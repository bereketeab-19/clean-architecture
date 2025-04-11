import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final List proprties;

  const Failures([this.proprties = const <dynamic>[]]);

  @override
  List<Object?> get props => proprties;
}

//General Failures
class ServerFailure extends Failures {}

class CacheFailure extends Failures {}
