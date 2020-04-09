import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:fave_reads/model/Read.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_Read", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("tittle", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: true),
      SchemaColumn("author", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("year", ManagedPropertyType.integer,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("isReading", ManagedPropertyType.boolean,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final List<Map> reads = [
      {
        "tittle":"Head First Desing Patterns",
        "author": "Eric Freeman",
        "year":2004,
        "isReading":false
      },
      {
        "tittle":"Clean Code: A handbook of Agile",
        "author": "Uncle Bob",
        "year":2008,
        "isReading":true
      },
      {
        "tittle":"Code Complete: A Pratical Handbook",
        "author": "Stece McConnell",
        "year":2004,
        "isReading":false
      }
    ];

    for( final read in reads){
      await database.store.execute(
        "INSERT INTO _Read (tittle, author, year, isReading)"
            "VALUES (@tittle, @author, @year, @isReading)",
        substitutionValues: {
            "tittle"    :read["tittle"],
            "author"    :read["author"],
            "year"      :read["year"],
            "isReading" :read["isReading"]
        }
      );
    }

  }
}
