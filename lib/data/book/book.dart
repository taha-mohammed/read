import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Book extends Equatable{
  final int? id;
  final String title;
  final String author;

  const Book({
    this.id,
    required this.title,
    required this.author
  });

  Book.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        author = res["author"];

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "title":title,
      "author":author
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  List<Object?> get props => [title, author];
}