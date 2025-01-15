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
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/cancel_order_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/delete_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/delete_fav_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_cart_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_detailed_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_driver_orders_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_fav_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_latest_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_ordered_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_random_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/get_top_demand_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_cart_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_fav_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/order_product_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/search_products_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/update_cart_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/update_driver_order_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/product_use_cases/update_order_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/get_detailed_store_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/get_random_stores_use_case.dart';
import 'package:order_delivery/features/order/domain/use-cases/store_use_cases/search_stores_use_case.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_product_bloc/detailed_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_store_pagination_bloc/detailed_store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/feed_products_bloc/feed_products_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/get_product_bloc/get_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/product_pagination_bloc/product_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/search_product_pagination_bloc/search_product_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/search_store_pagination_bloc/store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/store_bloc/store_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/update_product_bloc/update_product_bloc.dart';
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

  sl.registerFactory(() => GetProductBloc(
        getCartProducts: sl(),
        getFavProducts: sl(),
        getUserOrders: sl(),
        searchProducts: sl(),
        getDriverOrders: sl(),
      ));
  sl.registerFactory(() => StoreBloc(
        getDetailedStore: sl(),
        getRandomStores: sl(),
        searchStores: sl(),
      ));

  sl.registerFactory(() => ProductPaginationBloc(getRandomProducts: sl()));
  sl.registerFactory(() => DetailedStorePaginationBloc(getDetailedStore: sl()));
  sl.registerFactory(() => DetailedProductBloc(getDetailedProduct: sl()));
  sl.registerFactory(() => SearchProductPaginationBloc(searchProducts: sl()));

  sl.registerFactory(() =>
      FeedProductsBloc(getLatestProducts: sl(), getTopDemandProducts: sl()));
  sl.registerFactory(() => UpdateProductBloc(
        orderCartProducts: sl(),
        orderFavProducts: sl(),
        addProductToCart: sl(),
        addProductToFav: sl(),
        orderProduct: sl(),
        cancelOrder: sl(),
        deleteCart: sl(),
        deleteFav: sl(),
        updateCart: sl(),
        updateDriverOrder: sl(),
      ));

  sl.registerFactory(() => StorePaginationBloc(searchStores: sl()));

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
  sl.registerLazySingleton(
      () => OrderCartProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => OrderFavProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => GetCartProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => GetFavProductsUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => GetUserOrdersUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => DeleteCartUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => DeleteFavUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => UpdateCartUseCase(productRepository: sl()));
  sl.registerLazySingleton(() => UpdateOrderUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => GetDriverOrdersUseCase(productRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateDriverOrderUseCase(productRepository: sl()));

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
