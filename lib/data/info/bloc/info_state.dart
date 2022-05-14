
import 'package:equatable/equatable.dart';

import '../info.dart';

abstract class InfoState extends Equatable{
  const InfoState();

  @override
  List<Object?> get props => [];
}

class InfoStateLoading extends InfoState{}

class InfoStateLoaded extends InfoState{
  final List<Info> data;

  const InfoStateLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}