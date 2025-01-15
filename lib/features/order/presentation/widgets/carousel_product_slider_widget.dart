import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/widgets/custom_product_widget.dart';
import '../../../auth/domain/enitities/user_entity.dart';

class CarouselSliderProductWidget extends StatelessWidget {
  final double height, width;
  final List<ProductEntity> products;
  final UserEntity user;

  const CarouselSliderProductWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.products,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CarouselSlider.builder(
          itemCount: products.length,
          itemBuilder: (context, index, realIndex) {
            ProductEntity product = products[index];
            return CustomProductWidget(
              height: height,
              width: width,
              product: product,
              user: user,
            );
          },
          options: CarouselOptions(
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height)),
    );
  }
}
