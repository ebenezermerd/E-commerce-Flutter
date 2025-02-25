import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/signup.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../data/datasources/auth_remote_data_source.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final SignUp signup;
  final AuthRemoteDataSource remoteDataSource;

  AuthBloc({
    required this.login,
    required this.signup,
    required this.remoteDataSource,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await login(LoginParams(
        email: event.email,
        password: event.password,
      ));

      result.fold(
        (failure) {
          if (failure is ValidationFailure) {
            emit(AuthError(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(AuthError(message: failure.message ?? 'Server Error'));
          } else if (failure is NetworkFailure) {
            emit(AuthError(message: 'Please check your internet connection'));
          } else if (failure is VerificationRequiredFailure) {
            emit(AuthVerificationRequired(
              email: failure.email,
              message: failure.message,
              accessToken: failure.accessToken,
            ));
          }
        },
        (user) => emit(AuthSuccess(user: user)),
      );
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await signup(SignUpParams(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phoneNumber,
        sex: event.sex,
        address: event.address,
        agreement: event.agreement,
      ));

      result.fold(
        (failure) {
          if (failure is ValidationFailure) {
            emit(AuthError(message: failure.message));
          } else if (failure is ServerFailure) {
            emit(AuthError(message: failure.message ?? 'Server Error'));
          } else if (failure is NetworkFailure) {
            emit(AuthError(message: 'Please check your internet connection'));
          } else if (failure is VerificationRequiredFailure) {
            emit(AuthVerificationRequired(
              email: failure.email,
              message: failure.message,
              accessToken: failure.accessToken,
            ));
          }
        },
        (user) => emit(SignUpSuccess(user: user)),
      );
    });

    on<VerifyEmailRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await remoteDataSource.verifyEmail(event.email, event.otp);
        emit(AuthSuccess(
            user: User(
          id: '',
          email: event.email,
          firstName: '',
          lastName: '',
          phoneNumber: '',
          sex: '',
          address: '',
          role: '',
          status: '',
          avatarUrl: '',
          country: '',
          city: '',
          zipCode: '',
          isVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ))); // Create a user object
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<ResendVerificationRequested>((event, emit) async {
      try {
        await remoteDataSource.resendVerification(event.email);
        emit(AuthSuccess(
            user: User(
          id: '',
          email: event.email,
          firstName: '',
          lastName: '',
          phoneNumber: '',
          sex: '',
          address: '',
          role: '',
          status: '',
          avatarUrl: '',
          country: '',
          city: '',
          zipCode: '',
          isVerified: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ))); // Keep current state
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }

  // String _mapFailureToMessage(Failure failure) {
  //   switch (failure.runtimeType) {
  //     case ServerFailure:
  //       return 'Server Error';
  //     case NetworkFailure:
  //       return 'Please check your internet connection';
  //     case ValidationFailure:
  //       return (failure as ValidationFailure).message;
  //     case VerificationRequiredFailure:
  //       final verificationFailure = failure as VerificationRequiredFailure;
  //       emit(AuthVerificationRequired(
  //         email: verificationFailure.email,
  //         message: verificationFailure.message,
  //         accessToken: verificationFailure.accessToken,
  //       ));
  //       return verificationFailure.message;
  //     default:
  //       return 'Unexpected Error';
  //   }
  // }
}
