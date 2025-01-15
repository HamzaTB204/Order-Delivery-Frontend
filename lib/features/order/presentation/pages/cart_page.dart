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

class CartPage extends StatefulWidget {
  final UserEntity user;

  const CartPage({super.key, required this.user});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int? selectedIndex, editedQuantityNum;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProductBloc>(context)
        .add(GetCartProductsEvent(token: widget.user.token));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return _wrapWithUpdateListener(
      child: BlocBuilder<GetProductBloc, GetProductState>(
        builder: (context, state) {
          if (state is LoadingGetCartProductState) {
            return CustomLoadingWidget();
          } else if (state is FailedGetCartProductState) {
            return CustomErrorWidget(msg: state.failure.failureMessage);
          } else if (state is DoneGetCartProductState) {
            return SizedBox(
              height: 0.9 * height,
              child: state.products.isEmpty
                  ? SizedBox()
                  : Column(
                      children: [
                        _buildFirstSection(width, state.products),
                        _buildProducts(height, width, state.products),
                      ],
                    ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _wrapWithUpdateListener({required Widget child}) {
    return BlocListener<UpdateProductBloc, UpdateProductState>(
      listener: (context, state) {
        if (state is DoneOrderCartProductState) {
          showToastMsg(context, "Done Order Cart Products", true);
          BlocProvider.of<GetProductBloc>(context)
              .add(GetCartProductsEvent(token: widget.user.token));
        } else if (state is LoadingOrderCartProductState) {
          showToastMsgForProcess(context, "Ordering");
        } else if (state is FailedOrderCartProductState) {
          showToastMsg(
              context, "Order Error/n ${state.failure.failureMessage}");
        } else if (state is DoneDeleteCartState) {
          showToastMsg(context, "Done deleteing Cart Product", true);
          BlocProvider.of<GetProductBloc>(context)
              .add(GetCartProductsEvent(token: widget.user.token));
        } else if (state is LoadingDeleteCartState) {
          showToastMsgForProcess(context, "Deleting");
        } else if (state is FailedDeleteCartState) {
          showToastMsg(
              context, "Delete Error/n ${state.failure.failureMessage}");
        } else if (state is DoneUpdateCartState) {
          showToastMsg(context, "Done updating Cart Product", true);
          BlocProvider.of<GetProductBloc>(context)
              .add(GetCartProductsEvent(token: widget.user.token));
        } else if (state is LoadingUpdateCartState) {
          showToastMsgForProcess(context, "Updating");
        } else if (state is FailedUpdateCartState) {
          showToastMsg(
              context, "Update Error/n ${state.failure.failureMessage}");
        }
      },
      child: child,
    );
  }

  Widget _buildProducts(
      double height, double width, List<ProductEntity> products) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return SelectableProductWidget(
            isSelected: (selectedIndex != null && selectedIndex == index),
            onLongPress: () {
              setState(() {
                selectedIndex = selectedIndex == index ? null : index;
                editedQuantityNum = selectedIndex == null
                    ? null
                    : products[selectedIndex!].quantity;
              });
            },
            height: 0.2 * height,
            width: width,
            product: products[index],
            user: widget.user,
          );
        },
      ),
    );
  }

  Widget _buildFirstSection(double width, List<ProductEntity> products) {
    final bool isNull = selectedIndex == null;
    if (isNull) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPrice(true, products),
          _buildOrderBtn(),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrice(false, products),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: _buildDeleteBtn(products),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildEditQuantityBtns(), _buildEditBtn(products)],
            ),
          )
        ],
      );
    }
  }

  Widget _buildEditQuantityBtns() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              if (editedQuantityNum! > 1) {
                setState(() {
                  editedQuantityNum = editedQuantityNum! - 1;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Icon(Icons.remove)),
              ),
            ),
          ),
          Text(
            editedQuantityNum!.toString(),
            style: TextStyle(fontSize: 20),
          ),
          InkWell(
            onTap: () {
              setState(() {
                editedQuantityNum = editedQuantityNum! + 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Icon(Icons.add)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderBtn() {
    return InkWell(
      onTap: () {
        BlocProvider.of<UpdateProductBloc>(context)
            .add(OrderCartProductsEvent(token: widget.user.token));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(" Order ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildEditBtn(List<ProductEntity> products) {
    final bool active = editedQuantityNum! != products[selectedIndex!].quantity;
    return InkWell(
      onTap: active
          ? () {
              BlocProvider.of<UpdateProductBloc>(context).add(UpdateCartEvent(
                  token: widget.user.token,
                  productId: products[selectedIndex!].productId,
                  quantity: editedQuantityNum!));
              selectedIndex = null;
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 100,
        decoration: BoxDecoration(
            color: active ? Colors.amber : Colors.amber.withAlpha(100),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(" Edit ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildDeleteBtn(List<ProductEntity> products) {
    return InkWell(
      onTap: () {
        BlocProvider.of<UpdateProductBloc>(context).add(DeleteCartEvent(
          token: widget.user.token,
          productId: products[selectedIndex!].productId,
        ));
        selectedIndex = null;
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(
          " Delete ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPrice(bool total, List<ProductEntity> products) {
    final String text = "${total ? "total " : ""}price".tr(context);
    final price = total ? _getPrice(products) : products[selectedIndex!].price;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Text(text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("$price \$",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: const Color.fromARGB(255, 72, 255, 0))),
        ],
      ),
    );
  }

  String _getPrice(List<ProductEntity> products) {
    int price = 0;
    for (ProductEntity product in products) {
      price += product.price * product.quantity;
    }
    return price.toString();
  }
}
