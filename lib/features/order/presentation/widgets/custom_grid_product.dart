import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_product_bloc/detailed_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_product_page.dart';

class CustomGridProduct extends StatelessWidget {
  final double height;
  final ProductEntity product;
  final UserEntity user;

  const CustomGridProduct(
      {super.key,
      required this.height,
      required this.product,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<DetailedProductBloc>(context)
            .add(GetDetailedProductEvent(product: product, token: user.token));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              DetailedProductPage(product: product, user: user),
        ));
      },
      child: Column(
        children: [
          Container(
            height: height,
            width: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.grey,
              image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(product.productPictures.first),
                  fit: BoxFit.cover),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    size: 30,
                    color: Colors.pink,
                  )),
            ),
          ),
          Container(
              height: 0.7 * height,
              width: height,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black.withAlpha(125),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.locale == "en"
                                ? product.englishName
                                : product.arabicName,
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'orders num'.tr(context),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Text(
                        "${product.ordersCount}",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 169, 236),
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: Text(
                        "quantity".tr(context),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Text(
                      "${product.quantity}",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 251, 4),
                          fontSize: 16),
                    ),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "price".tr(context),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Text(
                        "${product.price} \$",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 4, 255, 17),
                            fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
