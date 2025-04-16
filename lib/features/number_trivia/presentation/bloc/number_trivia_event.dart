part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaFromConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaFromConcreteNumber({required this.numberString});
}

class GetTriviaFromRandomNumber extends NumberTriviaEvent {}
