import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/errors/failures.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_error_widget.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/feed_products_bloc/feed_products_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/product_pagination_bloc/product_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/store_bloc/store_bloc.dart';
import 'package:order_delivery/features/order/presentation/widgets/carousel_product_slider_widget.dart';
import 'package:order_delivery/features/order/presentation/widgets/carousel_store_slider_widget.dart';
import 'package:order_delivery/features/order/presentation/widgets/custom_product_widget.dart';

class UserFeedPage extends StatefulWidget {
  final UserEntity user;

  const UserFeedPage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<UserFeedPage> {
  // final ScrollController _scrollC = ScrollController();
  int _pageNum = 1;
  final List<ProductEntity> randomProducts = [];
  @override
  void initState() {
    final String token = widget.user.token;

    BlocProvider.of<StoreBloc>(context).add(GetRandomStoresEvent(token: token));

    BlocProvider.of<FeedProductsBloc>(context)
        .add(GetFeedPageProductsEvent(token: token));

    BlocProvider.of<ProductPaginationBloc>(context)
        .add(GetRandomProductsEvent(pageNum: _pageNum, token: token));

    super.initState();
  }

  @override
  void dispose() {
    // _scrollC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubTitle("latest stores"),
          _buildStoresBloc(0.22 * height, width),
          _buildFeedPageBloc(height, width),
          _buildSubTitle("for you"),
          _buildForYouBloc(0.2 * height, width)
        ],
      ),
    );
  }

  Widget _buildFeedPageProducts(double height, double width,
      {bool loading = false,
      AppFailure? failure,
      List<ProductEntity> topDemand = const [],
      List<ProductEntity> latest = const []}) {
    if (failure == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubTitle("top demanded"),
          loading
              ? CustomLoadingWidget()
              : CarouselSliderProductWidget(
                  height: 0.2 * height,
                  width: width,
                  products: topDemand,
                  user: widget.user),
          _buildSubTitle("latest products"),
          loading
              ? CustomLoadingWidget()
              : CarouselSliderProductWidget(
                  height: 0.2 * height,
                  width: width,
                  products: latest,
                  user: widget.user),
        ],
      );
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubTitle("top demanded"),
            CustomErrorWidget(msg: failure.failureMessage),
            _buildSubTitle("latest products"),
            CustomErrorWidget(msg: failure.failureMessage)
          ]);
    }
  }

  Widget _buildFeedPageBloc(double height, double width) {
    return BlocBuilder<FeedProductsBloc, FeedProductsState>(
      builder: (context, state) {
        if (state is LoadingGetFeedPageProductsState) {
          return _buildFeedPageProducts(height, width, loading: true);
        } else if (state is FailedGetFeedPageProductsState) {
          return _buildFeedPageProducts(height, width, failure: state.failure);
        } else if (state is LoadedFeedPageProductsState) {
          return _buildFeedPageProducts(height, width,
              latest: state.latest, topDemand: state.topDemand);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStoresBloc(double height, double width) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state is LoadedRandomStoresState) {
          return CarouselSliderStoreWidget(
              height: height,
              width: width,
              stores: state.stores,
              user: widget.user);
        } else if (state is LoadingStoreState) {
          return CustomLoadingWidget();
        } else if (state is FailedStoreState) {
          return CustomErrorWidget(
            msg: state.failure.failureMessage,
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildForYouBloc(double height, double width) {
    return BlocConsumer<ProductPaginationBloc, ProductPaginationState>(
      listener: (context, state) {
        if (state is LoadedRandomProductsState) {
          // _scrollC.addListener(_onScroll(context));
        }
      },
      builder: (context, state) {
        if (state is LoadingGetRandomProductsState) {
          return randomProducts.isEmpty
              ? CustomLoadingWidget()
              : _buildRandomProducts(height, width, isLoading: true);
        } else if (state is FailedGetRandomProductsState) {
          return CustomErrorWidget(msg: state.failure.failureMessage);
        } else if (state is LoadedRandomProductsState) {
          randomProducts.addAll(state.products);
          return _buildRandomProducts(height, width);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSubTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Text(
        title.tr(context),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildRandomProducts(double height, double width,
      {bool isLoading = false}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // controller: _scrollC,
        itemCount:
            isLoading ? randomProducts.length + 1 : randomProducts.length,
        itemBuilder: (context, index) {
          if (isLoading && index == randomProducts.length) {
            return CustomLoadingWidget();
          }
          final product = randomProducts[index];
          return CustomProductWidget(
              height: height,
              width: width,
              product: product,
              user: widget.user);
        });
  }

  // _onScroll(BuildContext context) {
  //   // final max = _scrollC.position.maxScrollExtent;
  //   // final currentScroll = _scrollC.offset;
  //   BlocListener<ProductPaginationBloc, ProductPaginationState>(
  //     listener: (context, state) {
  //       if (state is LoadedRandomProductsState) {
  //         if (currentScroll >= max * 0.8) {
  //           context.read<ProductPaginationBloc>().add(GetRandomProductsEvent(
  //               pageNum: ++_pageNum, token: widget.user.token));
  //         }
  //       }
  //     },
  //   );

  //   return currentScroll;
  // }
}
