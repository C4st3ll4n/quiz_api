import 'package:fave_reads/model/Read.dart';

import 'harness/app.dart';

Future main() async {
  final harness = Harness()
    ..install();

  setUp(() async {
    final readQuery = Query<Read>(harness.application.channel.context);

    readQuery.values = Read()
      ..tittle = "Scrum"
      ..author = "Henrique"
      ..year = 2020
      ..isReading = false;

    await readQuery.insert();

    readQuery.values = Read()
      ..tittle = "Percy Jackson"
      ..author = "Henrique Riordan"
      ..year = 2018
      ..isReading = true;

    await readQuery.insert();
  });

  group("Sucess 200 OK tests", (){

    test("GET /read returns 200 OK", () async {
      final response = await harness.agent.get("/reads");
      expectResponse(response, 200,
          body:
          {
            "msg": isString,
            "data": everyElement(
                {
                  "id": greaterThanOrEqualTo(0),
                  "tittle": isString,
                  "author": isString,
                  "year": isInteger,
                  "isReading": isBoolean,
                  "details": isString,
                }
            )
          }
      );
    });

    test("GET /reads/:id returns a single read 200 OK", () async {
      final response = await harness.agent.get("/reads/1");
      expectResponse(response, 200,
          body:
          {
            "msg": isString,
            "data":
            {
              "id": greaterThanOrEqualTo(0),
              "tittle": isString,
              "author": isString,
              "year": isInteger,
              "isReading": isBoolean,
              "details": isString,
            }
          }
      );
    });

    test("POST /reads updates a read 200 OK", () async {
      final response = await harness.agent.post("/reads",
          body: {
            "tittle":"PF: Autobiografia",
            "author":"Pedro Fabiano",
            "year":2020,
            "isReading":false,
          }
      );

      expectResponse(response, 200,
          body:
          {
            "msg": isString,
            "data":
            {
              "id": greaterThanOrEqualTo(0),
              "tittle":"PF: Autobiografia",
              "author":"Pedro Fabiano",
              "year":2020,
              "isReading":false,
              "details": isString,
            }
          }
      );
    });

    test("DELETE /reads/:id removes a read 200 OK", () async {
      final response = await harness.agent.delete("/reads/1",
          body: {
            "tittle":"PF: Autobiografia Atualizada",
            "author":"Pedro Fabiano",
            "year":2020,
            "isReading":false,
          }
      );

      expectResponse(response, 200,
          body:
          {
            "msg": isString,
            "data": isNotEmpty
          }
      );
    });

    test("PUT /reads/:id updates a read 200 OK", () async {
      final response = await harness.agent.put("/reads/1",
          body: {
            "tittle":"PF: Autobiografia Atualizada",
            "author":"Pedro Fabiano",
            "year":2020,
            "isReading":false,
          }
      );

      expectResponse(response, 200,
          body:
          {
            "msg": isString,
            "data":
            {
              "id": 1,
              "tittle":"PF: Autobiografia Atualizada",
              "author":"Pedro Fabiano",
              "year":2020,
              "isReading":false,
              "details": isString,
            }
          }
      );
    });


  });


  group("Not found 404 tests", (){

    setUp(harness.resetData);

    test("GET /read returns 404 Not Found", () async {
      final response = await harness.agent.get("/reads");
      expectResponse(response, 404,
          body:
          {
            "msg": isString,
            "data": isEmpty

          }
      );
    });

    test("GET /reads/:id returns a 404 Not Found", () async {
      final response = await harness.agent.get("/reads/10");
      expectResponse(response, 404,
          body:
          {
            "msg": isString,
            "data":isEmpty
          }
      );
    });

    test("POST /reads updates a 400 Bas Request", () async {
      final response = await harness.agent.post("/reads",
          body: {
            "tittle":"PF: Autobiografia",
            "author":"Pedro Fabiano",
            "year":2020,
          }
      );

      expectResponse(response, 400,
          body:
          {
            "error": isString,
            "reasons":isNotEmpty
          }
      );
    });

    test("DELETE /reads/:id removes a 404 Not Found", () async {
      final response = await harness.agent.delete("/reads/10",
          body: {
            "tittle":"PF: Autobiografia Atualizada",
            "author":"Pedro Fabiano",
            "year":2020,
            "isReading":false,
          }
      );

      expectResponse(response, 404,
          body:
          {
            "msg": isString,
            "data": isEmpty
          }
      );
    });

    test("PUT /reads/:id updates a 404 Not Found", () async {
      final response = await harness.agent.put("/reads/10",
          body: {
            "tittle":"PF: Autobiografia Atualizada",
            "author":"Pedro Fabiano",
            "year":2020,
            "isReading":false,
          }
      );

      expectResponse(response, 404,
          body:
          {
            "msg": isString,
            "data":isEmpty
          }
      );
    });

  });


}
