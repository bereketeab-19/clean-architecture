import '../error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, params> {
  Future<Either<Failures, Type>> call(params params);
}
