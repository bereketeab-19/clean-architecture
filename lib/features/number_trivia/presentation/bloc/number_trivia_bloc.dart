// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failures.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
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
    on<NumberTriviaEvent>((event, emit) async {
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
            emit(Loading());
            final failureOrTrivia = await getConcreteNumberTrivia(
              Params(number: integer),
            );
            _eitherLoadedOrError(failureOrTrivia, emit);
          },
        );
      }
      if (event is GetTriviaFromRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrError(failureOrTrivia, emit);
      }
    });
  }

  void _eitherLoadedOrError(
    Either<Failures, NumberTrivia> failureOrTrivia,
    Emitter<NumberTriviaState> emit,
  ) {
    return failureOrTrivia.fold(
      (failure) {
        emit(Error(errorMessege: _mapFailureToMessege(failure)));
      },
      (trivai) {
        emit(Loaded(trivai));
      },
    );
  }

  String _mapFailureToMessege(Failures failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure _:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
