import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_store_enitity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_store_pagination_bloc/detailed_store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/widgets/custom_grid_product.dart';
import '../../../../core/util/functions/functions.dart';

class DetailedStorePage extends StatefulWidget {
  final String storeID;
  final UserEntity user;
  const DetailedStorePage(
      {super.key, required this.storeID, required this.user});

  @override
  State<DetailedStorePage> createState() {
    return _DetailedStore();
  }
}

class _DetailedStore extends State<DetailedStorePage> {
  // final ScrollController _scrollC = ScrollController();
  static int pageNUM = 2;
  final List<ProductEntity> storeProducts = [];

  @override
  void initState() {
    // _scrollC.addListener(_onScroll(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(context, "store details"),
      body: BlocBuilder<DetailedStorePaginationBloc,
          DetailedStorePaginationState>(
        builder: (context, state) {
          if (state is LoadedDetailedStoreState) {
            return _buildBody(context, height, width, state.detailedStore);
          } else if (state is LoadingDetailedStoreState && pageNUM == 1) {
            return const CustomLoadingWidget();
          } else if (state is FailedDetailedStoreState) {
            showCustomAboutDialog(
                context, "Error", state.failure.failureMessage);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, double height, double width,
      DetailedStoreEntity storeDetails) {
    final StoreEntity store = storeDetails.store;
    storeProducts.addAll(storeDetails.products);

    return ListView(
      shrinkWrap: true,
      children: [
        Stack(
          children: [
            _buildPicture(height, width, store.logo),
            _buildFilter(context, height, width, store.storeName)
          ],
        ),
        _buildSubTitle("products count", store.productCount.toString()),
        _buildSubTitle("store's product"),
        _buildStoreProducts(context, 0.2 * height, width)
      ],
    );
  }

  Widget _buildSubTitle(String subtitle, [String? value]) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10, right: 50),
      child: Row(
        children: [
          Text(
            subtitle.tr(context),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (value != null)
            Text(
              " $value",
              style: TextStyle(
                  color: Colors.yellowAccent.withAlpha(225),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      title:
          Text(title.tr(context), style: Theme.of(context).textTheme.bodyLarge),
      backgroundColor: Colors.black45,
      foregroundColor: Colors.white,
    );
  }

  Widget _buildText(BuildContext context, String text, TextStyle textStyle) {
    return Text(
      text,
      style: textStyle,
    );
  }

  Widget _buildPicture(double height, double width, String storeLogo) {
    return Container(
      width: width,
      height: height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(storeLogo), fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildFilter(
      BuildContext context, double height, double width, String storeName) {
    return Container(
      width: width,
      height: height * 0.3,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.black,
        Colors.transparent,
        Colors.transparent,
      ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _buildText(
              context, storeName, Theme.of(context).textTheme.bodyLarge!),
        ),
      ),
    );
  }

  Widget _buildStoreProducts(
      BuildContext context, double height, double width) {
    final productsCount = storeProducts.length;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.separated(
          // controller: _scrollC,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: productsCount.isEven
              ? (productsCount / 2).toInt()
              : (productsCount / 2).toInt() + 1,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (context, index) {
            if (index == productsCount - index - 1) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: CustomGridProduct(
                      height: height,
                      product: storeProducts[index],
                      user: widget.user,
                    ),
                  ),
                ],
              );
            }
            final firstProduct = storeProducts[index];
            final secondProduct = storeProducts[productsCount - index - 1];
            return SizedBox(
                height: 1.7 * height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomGridProduct(
                      height: height,
                      product: firstProduct,
                      user: widget.user,
                    ),
                    CustomGridProduct(
                      height: height,
                      product: secondProduct,
                      user: widget.user,
                    ),
                  ],
                ));
          }),
    );
  }

/*
  _onScroll(BuildContext context) {
    final max = _scrollC.position.maxScrollExtent;
    final currentScroll = _scrollC.offset;

    BlocListener<DetailedStorePaginationBloc, DetailedStorePaginationState>(
      listener: (context, state) {
        if (state is LoadedDetailedStoreState) {
          if (currentScroll >= max * 0.8) {
            context.read<DetailedStorePaginationBloc>().add(
                GetDetailedStoreEvent(
                    token: widget.user.token,
                    storeId: widget.storeID,
                    pageNum: pageNUM++));
          }
        }
      },
      child: Container(),
    );
    return currentScroll;
  }
*/
  @override
  void dispose() {
    // _scrollC.dispose();
    super.dispose();
  }
}
