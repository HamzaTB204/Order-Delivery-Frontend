import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/util/functions/functions.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_error_widget.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_product_bloc/detailed_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/get_product_bloc/get_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/update_product_bloc/update_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_product_page.dart';
import 'package:order_delivery/features/order/presentation/widgets/selectable_order_widget.dart';

class OrderPage extends StatefulWidget {
  final UserEntity user;

  const OrderPage({super.key, required this.user});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int? selectedIndex, editedQuantityNum;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProductBloc>(context)
        .add(GetUserOrdersEvent(token: widget.user.token));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return _wrapWithUpdateListener(
      child: BlocBuilder<GetProductBloc, GetProductState>(
        builder: (context, state) {
          if (state is LoadingGetUserOrdersState) {
            return CustomLoadingWidget();
          } else if (state is FailedGetUserOrdersState) {
            return CustomErrorWidget(msg: state.failure.failureMessage);
          } else if (state is DoneGetUserOrdersState) {
            return SizedBox(
              height: 0.9 * height,
              child: state.orders.isEmpty
                  ? SizedBox()
                  : Column(
                      children: [
                        Expanded(
                            child: _buildTabBars(height, width, state.orders)),
                        _buildFirstSection(
                            width, _mapOrders(state.orders, pending)),
                      ],
                    ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _buildTabBars(double height, double width, List<OrderEntity> orders) {
    return DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (value) {
                  currentIndex = value;
                },
                indicator: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                dividerHeight: 0,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.alarm,
                      color: Colors.lightBlue,
                      size: 40,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.fire_truck,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.done_all,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.pink,
                      size: 40,
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: TabBarView(children: [
              _buildOrders(height, width, _mapOrders(orders, pending), true),
              _buildOrders(height, width, _mapOrders(orders, delivering)),
              _buildOrders(height, width, _mapOrders(orders, delivered)),
              _buildOrders(height, width, _mapOrders(orders, canceled)),
            ]),
          )
        ]));
  }

  Widget _buildOrders(double height, double width, List<OrderEntity> orders,
      [bool onLongPress = false]) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return SelectableOrderWidget(
          onPress: () {
            BlocProvider.of<DetailedProductBloc>(context).add(
                GetDetailedProductEvent(
                    token: widget.user.token, product: orders[index].product));
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailedProductPage(
                  product: orders[index].product, user: widget.user),
            ));
          },
          isSelected: !onLongPress
              ? false
              : (selectedIndex != null && selectedIndex == index),
          onLongPress: !onLongPress
              ? () {}
              : () {
                  setState(() {
                    selectedIndex = selectedIndex == index ? null : index;
                    editedQuantityNum = selectedIndex == null
                        ? null
                        : orders[selectedIndex!].quantity;
                  });
                },
          height: 0.4 * height,
          width: width,
          order: orders[index],
          user: widget.user,
        );
      },
    );
  }

  Widget _wrapWithUpdateListener({required Widget child}) {
    return BlocListener<UpdateProductBloc, UpdateProductState>(
      listener: (context, state) {
        if (state is DoneCancelOrderState) {
          showToastMsg(context, "Done Cancel Order", true);
          BlocProvider.of<GetProductBloc>(context)
              .add(GetUserOrdersEvent(token: widget.user.token));
        } else if (state is LoadingCancelOrderState) {
          showToastMsgForProcess(context, "Canceling");
        } else if (state is FailedCancelOrderState) {
          showToastMsg(
              context, "Cancel Error/n ${state.failure.failureMessage}");
        } else if (state is DoneUpdateDriverOrderState) {
          showToastMsg(context, "Done Updating Order", true);
          BlocProvider.of<GetProductBloc>(context)
              .add(GetUserOrdersEvent(token: widget.user.token));
        } else if (state is LoadingUpdateOrderState) {
          showToastMsgForProcess(context, "Updating");
        } else if (state is FailedUpdateDriverOrderState) {
          showToastMsg(
              context, "Update Error/n ${state.failure.failureMessage}");
        }
      },
      child: child,
    );
  }

  Widget _buildFirstSection(double width, List<OrderEntity> orders) {
    final bool isNull = selectedIndex == null;
    if (isNull) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
        child: Align(
            alignment: Alignment.centerLeft, child: _buildPrice(true, orders)),
      );
    } else {
      return orders[selectedIndex!].status == pending
          ? orders[selectedIndex!].status != pending
              ? _buildPrice(false, orders)
              : _buildUpdateSection(orders)
          : Align(
              alignment: Alignment.centerLeft,
              child: _buildPrice(false, orders),
            );
    }
  }

  Widget _buildUpdateSection(List<OrderEntity> orders) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPrice(false, orders),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: _buildCancelBtn(orders),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildCancelBtn(List<OrderEntity> orders) {
    return InkWell(
      onTap: () {
        BlocProvider.of<UpdateProductBloc>(context).add(CancelOrderEvent(
          token: widget.user.token,
          orderId: orders[selectedIndex!].id,
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
          " Cancel ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPrice(bool total, List<OrderEntity> orders) {
    final String text = "${total ? "total " : ""}price".tr(context);
    final price = total
        ? _getPrice(orders)
        : orders[selectedIndex!].price * orders[selectedIndex!].quantity;
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

  String _getPrice(List<OrderEntity> orders) {
    int price = 0;
    for (var i = 0; i < orders.length; i++) {
      final order = orders[i];
      if (order.status == pending) {
        price += order.price;
      }
    }
    return price.toString();
  }

  List<OrderEntity> _mapOrders(List<OrderEntity> orders, String query) {
    List<OrderEntity> mappedOrders = [];
    for (OrderEntity order in orders) {
      if (query == order.status) {
        mappedOrders.add(order);
      }
    }
    return mappedOrders;
  }
}
