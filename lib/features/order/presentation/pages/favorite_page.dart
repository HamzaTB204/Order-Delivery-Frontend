import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/functions/functions.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_error_widget.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/get_product_bloc/get_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/update_product_bloc/update_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/widgets/selectable_product_widget.dart';

class FavoritePage extends StatefulWidget {
  final UserEntity user;

  const FavoritePage({super.key, required this.user});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int? selectedIndex;
  @override
  void initState() {
    BlocProvider.of<GetProductBloc>(context)
        .add(GetFavProductsEvent(token: widget.user.token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<UpdateProductBloc, UpdateProductState>(
        listener: (context, state) {
          if (state is DoneOrderFavProductState) {
            showToastMsg(context, "Done Order Favorite products", true);
            BlocProvider.of<GetProductBloc>(context)
                .add(GetFavProductsEvent(token: widget.user.token));
          } else if (state is LoadingOrderFavProductState) {
            showToastMsgForProcess(context, "Ordering");
          } else if (state is FailedOrderFavProductState) {
            showToastMsg(
                context, "Order Error/n ${state.failure.failureMessage}");
          } else if (state is DoneDeleteFavState) {
            showToastMsg(context, "Done Delete From Favorite", true);
            BlocProvider.of<GetProductBloc>(context)
                .add(GetFavProductsEvent(token: widget.user.token));
          } else if (state is LoadingAddProductToCartState) {
            showToastMsgForProcess(context, "Deleting");
          } else if (state is FailedAddProductToCartState) {
            showToastMsg(context, "Delete From Favorite Error");
          }
        },
        child: BlocBuilder<GetProductBloc, GetProductState>(
          builder: (context, state) {
            if (state is LoadingGetFavProductState) {
              return CustomLoadingWidget();
            } else if (state is FailedGetFavProductState) {
              return CustomErrorWidget(msg: state.failure.failureMessage);
            } else if (state is DoneGetFavProductState) {
              return SizedBox(
                height: 0.9 * height,
                child: Stack(
                  children: [
                    _buildProducts(height, width, state.products),
                    if (state.products.isNotEmpty)
                      _buildBtn(height, width, state.products),
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProducts(
      double height, double width, List<ProductEntity> products) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return SelectableProductWidget(
            isSelected: (selectedIndex != null && selectedIndex == index),
            onLongPress: () {
              setState(() {
                selectedIndex = selectedIndex == index ? null : index;
              });
            },
            height: 0.2 * height,
            width: width,
            product: products[index],
            user: widget.user);
      },
    );
  }

  Widget _buildBtn(double height, double width, List<ProductEntity> products) {
    final bool isNull = selectedIndex == null;
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          if (selectedIndex == null) {
            BlocProvider.of<UpdateProductBloc>(context)
                .add(OrderFavProductsEvent(token: widget.user.token));
          } else {
            BlocProvider.of<UpdateProductBloc>(context).add(DeleteFavEvent(
                token: widget.user.token,
                productId: products[selectedIndex!].productId));
            selectedIndex = null;
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 0.1 * height,
          width: 0.9 * width,
          decoration: BoxDecoration(
              color: isNull ? Colors.blue : Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
              isNull ? "Order Favorite Products" : "Delete Selected Product"),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'fav page'.tr(context),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      backgroundColor: Colors.pink,
    );
  }
}
