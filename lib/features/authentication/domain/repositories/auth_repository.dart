import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signup(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String sex,
    String address,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
} 