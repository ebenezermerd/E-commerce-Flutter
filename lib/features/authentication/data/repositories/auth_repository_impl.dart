import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        return Right(user);
      } on VerificationRequiredException catch (e) {
        return Left(VerificationRequiredFailure(
          message: e.message,
          email: e.email,
          accessToken: e.accessToken,
        ));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signup(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNumber,
    String sex,
    String address,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signup(
          email,
          password,
          password, // confirmPassword same as password
          firstName,
          lastName,
          phoneNumber,
          sex,
          address,
          true, // agreement
        );
        return Right(user);
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  // Implement other methods similarly...
}
