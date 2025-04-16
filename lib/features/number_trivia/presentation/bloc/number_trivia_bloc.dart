// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or Zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter converter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.converter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      emit(Empty());
      if (event is GetTriviaFromConcreteNumber) {
        final inputEither = converter.stringToUnsignedInteger(
          event.numberString,
        );
        inputEither.fold(
          (failure) {
            emit(Error(errorMessege: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async {
            getConcreteNumberTrivia(Params(number: integer));
          },
        );
      }
    });
  }
}
