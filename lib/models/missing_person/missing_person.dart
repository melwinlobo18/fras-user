// To parse this JSON data, do
//
//     final missingPerson = missingPersonFromJson(jsonString);

import 'dart:convert';

class MissingPerson {
  String name;
  int issueNumber;
  DateTime missingDate;
  String missingFrom;
  int age;
  String sex;
  String race;
  String hairColor;
  String eyeColor;
  double height;
  int weight;
  String imageUrl;

  MissingPerson(
      {this.name,
      this.issueNumber,
      this.missingDate,
      this.missingFrom,
      this.age,
      this.sex,
      this.race,
      this.hairColor,
      this.eyeColor,
      this.height,
      this.weight,
      this.imageUrl});

  factory MissingPerson.fromRawJson(String str) =>
      MissingPerson.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MissingPerson.fromJson(Map<String, dynamic> json) => MissingPerson(
        name: json["name"] == null ? null : json["name"],
        issueNumber: json["issueNumber"] == null ? null : json["issueNumber"],
        missingDate: json["missingDate"] == null
            ? null
            : DateTime.parse(json["missingDate"].toString()),
        missingFrom: json["missingFrom"] == null ? null : json["missingFrom"],
        age: json["age"] == null ? null : json["age"],
        sex: json["sex"] == null ? null : json["sex"],
        race: json["race"] == null ? null : json["race"],
        hairColor: json["hairColor"] == null ? null : json["hairColor"],
        eyeColor: json["eyeColor"] == null ? null : json["eyeColor"],
        height: json["height"] == null ? null : json["height"].toDouble(),
        weight: json["weight"] == null ? null : json["weight"],
        imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "issueNumber": issueNumber == null ? null : issueNumber,
        "missingDate":
            missingDate == null ? null : missingDate.toIso8601String(),
        "missingFrom": missingFrom == null ? null : missingFrom,
        "age": age == null ? null : age,
        "sex": sex == null ? null : sex,
        "race": race == null ? null : race,
        "hairColor": hairColor == null ? null : hairColor,
        "eyeColor": eyeColor == null ? null : eyeColor,
        "height": height == null ? null : height,
        "weight": weight == null ? null : weight,
        "imageUrl": imageUrl == null ? null : imageUrl,
      };
}
