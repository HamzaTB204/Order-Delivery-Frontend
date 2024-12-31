import 'package:get_it/get_it.dart';
import 'package:order_delivery/features/auth/data/data-sources/auth_remote_data_source.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_local_data_source.dart';
import 'package:order_delivery/features/auth/data/data-sources/user_remote_data_source.dart';
import 'package:order_delivery/features/auth/data/repository/auth_repository.dart';
import 'package:order_delivery/features/auth/data/repository/user_repository.dart';
import 'package:order_delivery/features/auth/domain/repository/auth_repository.dart';
import 'package:order_delivery/features/auth/domain/repository/user_repository.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/login_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/logout_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/auth_repo/signup_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/change_user_lang_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/get_local_user_use_case.dart';
import 'package:order_delivery/features/auth/domain/use-cases/user_repo/update_profile_use_case.dart';
import 'package:order_delivery/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:order_delivery/features/auth/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:order_delivery/features/order/data/data-sources/product_remote_data_source.dart';
import 'package:order_delivery/features/order/data/data-sources/store_remote_data_source.dart';
import 'package:order_delivery/features/order/data/repository/product_repository_impl.dart';
import 'package:order_delivery/features/order/data/repository/store_repository_impl.dart';
import 'package:order_delivery/features/order/domain/repository/product_repository.dart';
import 'package:order_delivery/features/order/domain/repository/store_repository.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/add_product_to_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/add_product_to_fav_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_detailed_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_latest_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_random_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_top_demand_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/search_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/get_detailed_store_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/get_random_stores_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/search_stores_use_case.dart';
import 'package:order_delivery/features/order/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/store_bloc/store_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! features - auth

  //* bloc

  sl.registerFactory(() =>
      AuthBloc(getLocalUser: sl(), login: sl(), logout: sl(), signup: sl()));
  sl.registerFactory(() => UserBloc(updateProfile: sl(), changeUserLang: sl()));

  //* use_cases

  sl.registerLazySingleton(() => GetLocalUserUseCase(userRepository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignupUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(userRepository: sl()));
  sl.registerLazySingleton(() => ChangeUserLangUseCase(userRepository: sl()));

  //* repository

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(userLDS: sl(), authRDS: sl()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userLDS: sl(), userRDS: sl()));

  //* data_sources

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(sharedPreferences: sl()));

  // ! faetures - order

  //* bloc

  sl.registerFactory(() => ProductBloc(
        getTopDemandProducts: sl(),
        getLatestProducts: sl(),
        getRandomProducts: sl(),
        getDetailedProduct: sl(),
        searchProducts: sl(),
        addProductToCart: sl(),
        addProductToFav: sl(),
        orderProduct: sl(),
      ));
  sl.registerFactory(() => StoreBloc(
        getDetailedStore: sl(),
        getRandomStores: sl(),
        searchStores: sl(),
      ));

  //* use_cases

  // product

  sl.registerLazySingleton(
      () => GetTopDemandProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => GetLatestProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => GetRandomProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => GetDetailedProductUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => SearchProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => AddProductToFavUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => AddProductToCartUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => OrderProductUseCase(productRepository: sl()));

  // store
  sl.registerLazySingleton(
      () => GetDetailedStoreUseCase(storeRepository: sl()));
  sl.registerLazySingleton(() => GetRandomStoresUseCase(storeRepository: sl()));
  sl.registerLazySingleton(() => SearchStoresUseCase(storeRepository: sl()));

  //* repository

  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(productRDS: sl()));

  sl.registerLazySingleton<StoreRepository>(
      () => StoreRepositoryImpl(storeRDS: sl()));

  //* data_sources

  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<StoreRemoteDataSource>(
      () => StoreRemoteDataSourceImpl(client: sl()));

  //! core

  //!extra
  final sharedPreferences = await SharedPreferences.getInstance();
  final client = http.Client();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => client);
}
