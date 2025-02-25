import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(
    String email,
    String password,
    String confirmPassword,
    String firstName,
    String lastName,
    String phone,
    String sex,
    String address,
    bool agreement,
  );
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> verifyEmail(String email, String otp);
  Future<void> resendVerification(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/sign-in'),
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 203) {
      // print(response.body);
      final data = json.decode(response.body);
      if (data['status'] == 'verification_required') {
        throw VerificationRequiredException(
          message: data['message'],
          email: email,
          accessToken: data['accessToken'],
        );
      }
      return UserModel.fromJson(data);
    } else {
      final data = json.decode(response.body);
      String message = data['message'] ?? 'Server error';
      throw ServerException(message);
    }
  }

  @override
  Future<UserModel> signup(
    String email,
    String password,
    String confirmPassword,
    String firstName,
    String lastName,
    String phone,
    String sex,
    String address,
    bool agreement,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/sign-up'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'role': 'customer',
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'sex': sex,
        'address': address,
        'password': password,
        'confirmPassword': confirmPassword,
        'agreement': agreement,
      }),
    );
    // print(response.body);

    if (response.statusCode == 201) {
      // print("201");
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      // print("422");
      final error = json.decode(response.body);
      throw ValidationException(
          error['message'] ?? 'Validation error occurred');
    } else {
      final data = json.decode(response.body);
      String message = data['message'] ?? 'Server error';
      throw ServerException(message);
    }
  }

  @override
  Future<void> logout() async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<void> verifyEmail(String email, String otp) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/email/verify'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'email': email,
        'otp': otp,
      }),
    );
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw ValidationException(error['error'] ?? 'Failed to verify email');
    }
  }

  @override
  Future<void> resendVerification(String email) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/email/verify/resend'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw ValidationException(
          error['message'] ?? 'Failed to resend verification');
    }
  }
}
