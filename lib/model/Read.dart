import 'package:fave_reads/fave_reads.dart';

class _Read{
  @primaryKey
  int id;

  @Column(unique: true)
  String tittle;

  @Column()
  String author;

  @Column()
  int year;

  @Column()
  bool isReading;
}

class Read extends ManagedObject<_Read> implements _Read{

  @Serialize()
  String get details => "$tittle by $author";

  /*@override
  Map<String, dynamic> asMap() => {
        "tittle": tittle,
        "author": author,
        "year": year,
        "isReading": isReading
      };

  @override
  void readFromMap(Map<String, dynamic> requestBody) {
    author = requestBody["author"].toString();
    year = int.parse(requestBody["year"].toString());
    tittle = requestBody["tittle"].toString();
    isReading = requestBody["isReading"] as bool;
  }*/

  @override
  String toString() {
    return 'Read{tittle: $tittle, author: $author, year: $year, isReading: $isReading}';
  }
}
