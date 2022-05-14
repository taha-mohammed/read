

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read/data/info/bloc/info_bloc.dart';
import 'package:read/data/info/bloc/info_event.dart';
import 'package:read/data/info/bloc/info_state.dart';
import 'package:read/data/info/info.dart';
import 'package:read/data/info/mock_info_repository.dart';

void main() {
  late InfoBloc infoBloc;
  const bookTitle = "BOOK_TITLE_TEST";
  const info = Info(id: 17,bookTitle: bookTitle, infoText: "INFO_TEXT_TESt");
  const updatedInfo = Info(id: 17,bookTitle: bookTitle, infoText: "UPDATED_INFO_TEXT_TESt");

  group("test info bloc", () {

    setUp(() {
      EquatableConfig.stringify;
      infoBloc = InfoBloc(MockInfoRepo());
    });

    blocTest(
        "Test Create new Info",
        build: () => infoBloc,
        act: (InfoBloc bloc) => bloc..add(const InfoEventAdd(info: info))..add(const InfoEventGetAll(bookTitle: bookTitle)),
        expect: () => [const InfoStateLoaded(data: [info])]
    );

    blocTest(
        "Test search for Infos",
        build: () => infoBloc,
        act: (InfoBloc bloc) => bloc.add(const InfoEventGet("te", bookTitle: bookTitle)),
        expect: () => [const InfoStateLoaded(data: [info])]
    );

    blocTest(
        "Test update Info",
        build: () => infoBloc,
        act: (InfoBloc bloc) => bloc..add(const InfoEventUpdate(info: updatedInfo))..add(const InfoEventGetAll(bookTitle: bookTitle)),
        expect: () => [const InfoStateLoaded(data: [updatedInfo])]
    );

    blocTest(
        "Test delete Info",
        build: () => infoBloc,
        act: (InfoBloc bloc) => bloc..add(const InfoEventDelete(id: 17))..add(const InfoEventGetAll(bookTitle: bookTitle)),
        expect: () => [const InfoStateLoaded(data: [])]
    );

    tearDown(() {
      infoBloc.close();
    });
  });
}