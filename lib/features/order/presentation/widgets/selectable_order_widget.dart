import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/order_entity.dart';

class SelectableOrderWidget extends StatelessWidget {
  final OrderEntity order;
  final UserEntity user;
  final double height, width;
  final Function onPress, onLongPress;
  final bool isSelected;
  const SelectableOrderWidget(
      {super.key,
      required this.order,
      required this.height,
      required this.width,
      required this.onPress,
      required this.onLongPress,
      required this.isSelected,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.white.withAlpha(100) : Colors.transparent,
      child: InkWell(
        onTap: () => onPress(),
        onLongPress: () => onLongPress(),
        child: Container(
          margin: EdgeInsets.all(10),
          height: 0.8 * height,
          width: 0.9 * width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withAlpha(150)),
          child: Column(
            children: [
              Expanded(child: _buildProductDetails()),
              _buildOrderDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      order.product.productPictures.first,
                    ),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    Colors.transparent
                  ]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                user.locale == "en"
                    ? order.product.englishName
                    : order.product.arabicName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          color: Colors.black),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                order.quantity.toString(),
                style: TextStyle(color: Colors.amber, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Center(
                child: Text(
                  order.status,
                  style: TextStyle(color: Colors.purpleAccent, fontSize: 24),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${order.price}\$",
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 206, 7), fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
