import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/features/product/domain/usecases/get_filtered_products.dart';
import 'package:shop/features/product/domain/usecases/get_product_by_id.dart';
import 'package:shop/features/product/presentation/state/details/bloc/details_bloc.dart';
import 'package:shop/features/product/presentation/state/home/bloc/home_bloc.dart';
import '../network/network_info.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/login.dart';
import '../../features/authentication/domain/usecases/signup.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/storage_service.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_products_by_category.dart';
import '../../features/product/presentation/state/product/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => StorageService(sharedPreferences));

  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      signup: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      baseUrl: baseUrl,
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Product Feature
  sl.registerFactory(
    () => ProductBloc(
      repository: sl(),
      getProductsByCategory: sl(),
    ),
  );
  sl.registerFactory(
    () => HomeBloc(
      repository: sl(),
      getFilteredProducts: sl(),
    ),
  );
  sl.registerFactory(
    () => DetailsBloc(
      repository: sl(),
      getProductById: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  sl.registerLazySingleton(() => GetFilteredProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      client: sl(),
      baseUrl: baseUrl,
    ),
  );
}
