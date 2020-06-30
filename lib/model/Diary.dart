import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:intl/intl.dart'; //date

class Diary implements Comparable<Diary> {
  Diary({
    @required this.id,
    @required this.title,
    @required this.text,
    @required this.date,
    @required this.lastModified,
  });

  static final String emptyText =
      '[{"insert":"\\n"}]'; //be careful to use ' and not "

  final int id;
  String title;
  String text;
  final DateTime date;
  DateTime lastModified;

  // at last, can REMOVE IT
  // get all diary from json
  /* static List<Diary> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((obj) => Diary.fromMap(obj))
        .toList()
        .cast<Diary>();
  } */

  static Diary fromMap(Map map) {
    //var textJson = json.encode(map['text']);
    return new Diary(
        id: map['id'],
        title: map['title'],
        text: map['text'], //textJson,
        date: DateTime.parse(map['date']),
        lastModified: DateTime.parse(map['lastModified']));
  }

  static Diary fromJsonResponse(String response) {
    var decodedJson = json.decode(response);
    var casted = decodedJson.cast<String, dynamic>();
    return fromMap(casted);
  }

  String toJson() {
    return json.encode({
      "id": this.id,
      "text": this.text,
      "title": this.title,
      "date": DateFormat('yyyy-MM-dd hh:mm:ss').format(this.date),
      "lastModified":
          DateFormat('yyyy-MM-dd hh:mm:ss').format(this.lastModified),
    });
  }

  void changeDiaryText(String text) {
    this.lastModified = DateTime.now();
    this.text = text;
  }

  void changeDiaryTitle(String title) {
    this.lastModified = DateTime.now();
    this.title = title;
  }

  @override
  int compareTo(Diary other) {
    return other.lastModified.compareTo(lastModified);
  }
}
