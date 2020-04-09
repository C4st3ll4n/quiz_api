import 'package:fave_reads/controller/ReadsController.dart';

import 'fave_reads.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class QuizApiChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  ///

  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
     final config = FavsReadConfig('config.yaml');
     final db = config.database;

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        db.username, db.password, db.host, db.port, db.databaseName);

    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router()
      ..route("/reads/[:id]").link(() => ReadsController(context))
      ..route("/docs").linkFunction((request) async {
        final docs = await File('client.html').readAsString();
        return Response.ok(docs)..contentType = ContentType.html;
      });

    return router;
  }

//1nv3st1g4tb
}

class FavsReadConfig extends Configuration {
  FavsReadConfig(String path) : super.fromFile(File(path));
  DatabaseConfiguration database;
}
