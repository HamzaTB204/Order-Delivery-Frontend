import 'package:flutter/material.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/widgets/custom_product_widget.dart';

class SelectableProductWidget extends StatelessWidget {
  final Function onLongPress;
  final bool isSelected;
  final double height, width;
  final ProductEntity product;
  final UserEntity user;

  const SelectableProductWidget(
      {super.key,
      required this.isSelected,
      required this.onLongPress,
      required this.height,
      required this.width,
      required this.product,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: isSelected ? Colors.white.withAlpha(100) : Colors.transparent,
        child: CustomProductWidget(
          height: height,
          width: width,
          product: product,
          user: user,
          onLongPress: onLongPress,
        ));
  }
}
