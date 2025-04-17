// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failures.dart';
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
    on<GetTriviaFromConcreteNumber>(_onGetTriviaFromConcreteNumber);
    on<GetTriviaFromRandomNumber>(_onGetTriviaFromRandomNumber);
  }

  Future<void> _onGetTriviaFromConcreteNumber(
    GetTriviaFromConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Empty());
    final inputEither = converter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold(
      (failure) async {
        emit(Error(errorMessege: INVALID_INPUT_FAILURE_MESSAGE));
      },
      (integer) async {
        emit(Loading());
        final failureOrTrivia = await getConcreteNumberTrivia(
          Params(number: integer),
        );
        failureOrTrivia.fold(
          (failure) => emit(Error(errorMessege: _mapFailureToMessege(failure))),
          (trivia) => emit(Loaded(trivia)),
        );
      },
    );
  }

  Future<void> _onGetTriviaFromRandomNumber(
    GetTriviaFromRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Empty());
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    failureOrTrivia.fold(
      (failure) => emit(Error(errorMessege: _mapFailureToMessege(failure))),
      (trivia) => emit(Loaded(trivia)),
    );
  }

  String _mapFailureToMessege(Failures failure) {
    if (failure is ServerFailure) {
      return SERVER_FAILURE_MESSAGE;
    } else if (failure is CacheFailure) {
      return CACHE_FAILURE_MESSAGE;
    } else {
      return 'Unexpected error';
    }
  }
}
