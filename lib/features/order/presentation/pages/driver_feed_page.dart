import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/constants/strings.dart';
import 'package:order_delivery/core/util/functions/functions.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_error_widget.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/get_product_bloc/get_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/update_product_bloc/update_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/widgets/selectable_order_widget.dart';

class DriverFeedPage extends StatefulWidget {
  final UserEntity user;

  const DriverFeedPage({super.key, required this.user});

  @override
  State<DriverFeedPage> createState() => _DriverFeedPageState();
}

class _DriverFeedPageState extends State<DriverFeedPage> {
  int? selectedPendingIndex, selectedDeliveringIndex;
  int currentIndex = 0;
  bool? isPending = true;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProductBloc>(context)
        .add(GetDriverOrdersEvent(token: widget.user.token));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return _wrapWithUpdateListener(
      child: BlocBuilder<GetProductBloc, GetProductState>(
        builder: (context, state) {
          if (state is LoadingGetDriverOrdersState) {
            return CustomLoadingWidget();
          } else if (state is FailedGetDriverOrdersState) {
            return CustomErrorWidget(msg: state.failure.failureMessage);
          } else if (state is DoneGetDriverOrdersState) {
            return SizedBox(
              height: 0.9 * height,
              child: state.orders.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                          height: 0.778 * height,
                          child: _buildTabBars(height, width, state.orders)),
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
          TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (value) {
                if (value == 0) {
                  isPending = true;
                } else if (value == 1) {
                  isPending = false;
                } else {
                  isPending = null;
                }
                currentIndex = value;
                selectedPendingIndex = null;
                selectedDeliveringIndex = null;
              },
              indicator: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(10.0),
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.alarm,
                    color: Colors.lightBlue,
                    size: 30,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.fire_truck,
                    color: Colors.amber,
                    size: 30,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.done_all,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.pink,
                    size: 30,
                  ),
                ),
              ]),
          Expanded(
            child: TabBarView(children: [
              _buildOrders(height, width, _mapOrders(orders, pending),
                  onLongPress: true),
              _buildOrders(height, width, _mapOrders(orders, delivering),
                  onLongPress: true),
              _buildOrders(height, width, _mapOrders(orders, delivered)),
              _buildOrders(height, width, _mapOrders(orders, canceled)),
            ]),
          )
        ]));
  }

  Widget _buildOrders(
    double height,
    double width,
    List<OrderEntity> orders, {
    bool onLongPress = false,
  }) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return SelectableOrderWidget(
                onPress: () {},
                isSelected: !onLongPress
                    ? false
                    : (isPending!
                        ? (selectedPendingIndex != null &&
                            selectedPendingIndex == index)
                        : (selectedDeliveringIndex != null &&
                            selectedDeliveringIndex == index)),
                onLongPress: !onLongPress
                    ? () {}
                    : () {
                        setState(() {
                          if (isPending!) {
                            selectedPendingIndex =
                                selectedPendingIndex == index ? null : index;
                          } else {
                            selectedDeliveringIndex =
                                selectedDeliveringIndex == index ? null : index;
                          }
                        });
                      },
                height: 0.4 * height,
                width: width,
                order: orders[index],
                user: widget.user,
              );
            },
          ),
        ),
        if (selectedPendingIndex != null || selectedDeliveringIndex != null)
          _buildFirstSection(width, orders),
      ],
    );
  }

  Widget _wrapWithUpdateListener({required Widget child}) {
    return BlocListener<UpdateProductBloc, UpdateProductState>(
      listener: (context, state) {
        if (state is DoneUpdateDriverOrderState) {
          showToastMsg(context, "Done Updating Order", true);
          BlocProvider.of<GetProductBloc>(context)
              .add(GetDriverOrdersEvent(token: widget.user.token));
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
    if (isPending != null) {
      if (isPending!) {
        if (selectedPendingIndex != null) {
          return _buildUpdateSection(orders);
        }
      } else {
        if (selectedDeliveringIndex != null) {
          return _buildUpdateSection(orders);
        }
      }
    }
    return SizedBox();
  }

  Widget _buildUpdateSection(List<OrderEntity> orders) {
    if (isPending != null) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrice(orders),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: isPending!
                    ? _buildDeliveringBtn(orders)
                    : _buildDeliveredBtn(orders),
              )
            ],
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _buildDeliveringBtn(List<OrderEntity> orders) {
    return InkWell(
      onTap: () {
        BlocProvider.of<UpdateProductBloc>(context).add(UpdateOrderStatusEvent(
            token: widget.user.token,
            orderId: orders[selectedPendingIndex!].id,
            newState: delivering));
        selectedPendingIndex = null;
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(
          " Add to Delivering ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDeliveredBtn(List<OrderEntity> orders) {
    return InkWell(
      onTap: () {
        BlocProvider.of<UpdateProductBloc>(context).add(UpdateOrderStatusEvent(
            token: widget.user.token,
            orderId: orders[selectedDeliveringIndex!].id,
            newState: delivered));
        selectedDeliveringIndex = null;
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(
          " Add to Delivered ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPrice(List<OrderEntity> orders) {
    if (orders.isNotEmpty) {
      if (!isPending!) {
        if (orders.first.status == delivering) {
          final String text = "price".tr(context);
          final price = orders[selectedDeliveringIndex!].price *
              orders[selectedDeliveringIndex!].quantity;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(text,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("$price \$",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color.fromARGB(255, 72, 255, 0))),
              ],
            ),
          );
        }
      } else {
        if (orders.first.status == pending) {
          final String text = "price".tr(context);
          final price = orders[selectedPendingIndex!].price *
              orders[selectedPendingIndex!].quantity;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(text,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("$price \$",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color.fromARGB(255, 72, 255, 0))),
              ],
            ),
          );
        }
      }
    }
    return SizedBox();
  }

  String _getPrice(List<OrderEntity> orders) {
    int price = 0;
    for (var i = 0; i < orders.length; i++) {
      price += orders[i].price;
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
