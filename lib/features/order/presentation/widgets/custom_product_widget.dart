import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_product_bloc/detailed_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_product_page.dart';

class CustomProductWidget extends StatelessWidget {
  final double height, width;
  final ProductEntity product;
  final UserEntity user;
  final Function? onLongPress;

  const CustomProductWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.product,
      required this.user,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        }
      },
      onTap: () {
        BlocProvider.of<DetailedProductBloc>(context)
            .add(GetDetailedProductEvent(token: user.token, product: product));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailedProductPage(
                  product: product,
                  user: user,
                )));
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProductPicture(),
                Expanded(child: _buildProductDetails(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3,
            ),
            Text(
              user.locale == "en" ? product.englishName : product.arabicName,
              style: TextStyle(color: Colors.white, fontSize: 18),
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
        ),
      ),
    );
  }

  Widget _buildProductPicture() {
    return Container(
      width: 0.4 * width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
        image: DecorationImage(
          image: CachedNetworkImageProvider(product.productPictures.first),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
