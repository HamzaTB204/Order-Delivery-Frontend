import 'package:order_delivery/features/auth/presentation/pages/update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/update_product_bloc/update_product_bloc.dart';
import '../../../../core/util/functions/functions.dart' as fun;

class CustomButtonWidget extends StatefulWidget {
  final ProductEntity product;
  //final ProductEvent event ;
  final String title;
  final UserEntity user;
  const CustomButtonWidget(
      {super.key,
      required this.title,
      required this.user,
      required this.product});
  @override
  State<CustomButtonWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButtonWidget> {
  static int quantity = 0;

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    //ProductEvent event = widget.event ;
    ProductEntity product = widget.product;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 45, 133, 90)),
              foregroundColor: const WidgetStatePropertyAll(Colors.black),
              elevation: const WidgetStatePropertyAll(7),
              shadowColor: WidgetStatePropertyAll(Colors.greenAccent.shade200),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(15))),
          onPressed: () {
            if (widget.user.firstName == null) {
              fun.showCustomAboutDialog(context, "war", 'you cannot do this');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UpdateProfilePage()));
            } else {
              showCustomAboutDialog(context, title, widget.user.token,
                  widget.product.productId, product.quantity);
            }
          },
          child: Text(
            title.tr(context),
            style: Theme.of(context).textTheme.displayMedium,
          )),
    );
  }

  void showCustomAboutDialog(BuildContext context, String title, String token,
      String productID, int productQuantity,
      [List<Widget>? actions, bool barrierDismissible = true]) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Column(
            children: [
              Text(
                title.tr(context),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 0) {
                            quantity--;
                          }
                        });
                      },
                      color: Theme.of(context).colorScheme.tertiary,
                      icon: const Icon(
                        Icons.minimize,
                        size: 10,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "$quantity",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity < productQuantity) {
                            quantity++;
                          }
                        });
                      },
                      color: Theme.of(context).colorScheme.tertiary,
                      icon: const Icon(
                        Icons.add,
                        size: 10,
                        color: Colors.white,
                      )),
                ],
              )
            ],
          ),
          actions: actions ??
              [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "cancel".tr(context),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<UpdateProductBloc>().add(
                        title.toLowerCase() == "order"
                            ? OrderProductEvent(
                                token: token,
                                productId: productID,
                                quantity: quantity)
                            : AddProductToCartEvent(
                                token: token,
                                productId: productID,
                                quantity: quantity));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    title.toLowerCase().tr(context),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
        );
      },
    );
  }
}
