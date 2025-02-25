import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String phone;
  final String sex;
  final String address;
  final bool agreement;
  final String role;

  SignUpParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.sex,
    required this.address,
    required this.agreement,
    this.role = 'customer',
  });
}

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signup(
      params.email,
      params.password,
      params.firstName,
      params.lastName,
      params.phone,
      params.sex,
      params.address,
    );
  }
}
