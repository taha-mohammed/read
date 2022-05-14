import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Info extends Equatable{
  final int? id;
  final String bookTitle;
  final String infoText;

  const Info({
    this.id,
    required this.bookTitle,
    required this.infoText
  });

  Info.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        bookTitle = res["book_title"],
        infoText = res["info_text"];

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "book_title":bookTitle,
      "info_text":infoText
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  List<Object?> get props => [bookTitle, infoText];
}