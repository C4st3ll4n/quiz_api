import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/model/Read.dart';


class ReadsController extends ResourceController {
  /*@override
  FutureOr<RequestOrResponse> handle(Request request) {

      switch (request.method){
        case 'GET': return Response.ok("Getting all reads");
        case 'POST': return Response.ok("Posting a read");
        case 'PUT': return Response.ok("updated");
        case 'DELETE': return Response.ok("deleted");
        default: return Response.forbidden(headers: null, body: "Metodo nao autorizado");

    }

  }
*/

  ReadsController(this.context);

  ManagedContext context;

  @Operation.get("id")
  Future<Response> lookFor(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
    ..where((read) => read.id).equalTo(id);

    final read = await readQuery.fetchOne();

    if (read == null) {
      return Response.notFound(
          body: {"msg": "Item does not exists", "data": ""});
    } else {
      return Response.ok({"msg": "Founded a read", "data": read.asMap()});
    }
  }

  @Operation.get()
  Future<Response> listAll() async {
    final query = Query<Read>(context);
    final readQuery = await query.fetch();


    if(readQuery == null || readQuery.isEmpty)
      return Response.notFound(body: {"msg":"Does not exists any read","data":""});


    final List<Map<String, dynamic>> readings = List();
    for(Read r in readQuery){
      readings.add(r.asMap());
    }
    return Response.ok({"msg": "Got all reads", "data":readings});
  }

  @Operation.get("/details")
  Future<Response> listAllDetails() async {
    final query = Query<Read>(context);
    final readQuery = await query.fetch();

    if(readQuery == null || readQuery.isEmpty)
      return Response.notFound();

    final List<Map<String, dynamic>> readings = List();

    for(Read r in readQuery){
      readings.add(r.asMap());
    }

    return Response.ok({"msg": "Got all reads", "data":readings});
  }


  @Operation.post()
  Future<Response> addRead(@Bind.body(
      require: ["tittle","author","year","isReading"]) Read body) async
  {
    final query = Query<Read>(context)
    ..values = body;

    final insertRead = await query.insert();

    return Response.ok({"msg": "Added a read", "data":insertRead.asMap()});
  }

  @Operation.put("id")
  Future<Response> updateRead(@Bind.path("id")
  int id, @Bind.body(require: ["tittle","author","year","isReading"]) Read body) async
  {
    final query = Query<Read>(context)
      ..values = body
    ..where((read) => read.id).equalTo(id);

    final updateQuery = await query.updateOne();

    if (updateQuery == null) {
      return Response.notFound(
          body: {"msg": "Item does not exists", "data": ""});
    } else {
      return Response.ok({"msg": "Updated a read", "data":updateQuery.asMap()});
    }
  }

  @Operation.delete("id")
  Future<Response> deleteRead(@Bind.path("id") int id) async {
    final query = Query<Read>(context)
    ..where((read) => read.id).equalTo(id);

    final int deleteCount = await query.delete();

    if(deleteCount == null || deleteCount == 0){
      return Response.notFound(body:{"msg":"Read not found", "data":""});
    }else{
      return Response.ok({"msg":"Read deleted !", "data":"$deleteCount"});
    }
  }
}
