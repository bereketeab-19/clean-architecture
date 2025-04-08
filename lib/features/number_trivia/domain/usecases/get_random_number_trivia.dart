import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failures, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
