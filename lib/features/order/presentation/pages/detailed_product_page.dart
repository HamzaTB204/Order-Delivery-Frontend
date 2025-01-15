import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/features/auth/presentation/pages/update_profile_page.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_product_bloc/detailed_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_store_pagination_bloc/detailed_store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/update_product_bloc/update_product_bloc.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/detailed_product.entity.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_store_page.dart';

import '../../../../core/util/functions/functions.dart';

class DetailedProductPage extends StatefulWidget {
  final ProductEntity product;
  final UserEntity user;
  const DetailedProductPage(
      {super.key, required this.product, required this.user});

  @override
  State<DetailedProductPage> createState() {
    return _DetailedProduct();
  }
}

class _DetailedProduct extends State<DetailedProductPage> {
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(context, "product details"),
      body: BlocListener<UpdateProductBloc, UpdateProductState>(
        listener: (context, state) {
          if (state is DoneOrderProductState) {
            showToastMsg(context, "Done Order", true);
            BlocProvider.of<DetailedProductBloc>(context).add(
                GetDetailedProductEvent(
                    token: widget.user.token, product: widget.product));
          } else if (state is LoadingOrderProductState) {
            showToastMsgForProcess(context, "adding");
          } else if (state is FailedOrderProductState) {
            showToastMsg(context, "Order Error");
          }
          if (state is DoneAddProductToCartState) {
            showToastMsg(context, "Done Add To Cart", true);
            BlocProvider.of<DetailedProductBloc>(context).add(
                GetDetailedProductEvent(
                    token: widget.user.token, product: widget.product));
          } else if (state is LoadingAddProductToCartState) {
            showToastMsgForProcess(context, "Adding");
          } else if (state is FailedAddProductToCartState) {
            showToastMsg(context, "add to cart err");
          }
          if (state is DoneAddProductToFavState) {
            showToastMsg(context, "Done Add To Favorite", true);
          } else if (state is LoadingAddProductToFavState) {
            showToastMsgForProcess(context, "adding");
          }
          if (state is FailedAddProductToFavState) {
            showToastMsg(context, "add to fav err");
          }
        },
        child: BlocBuilder<DetailedProductBloc, DetailedProductState>(
          builder: (context, state) {
            if (state is LoadedDetailedProductState) {
              return _buildBody(context, height, width, state.detailedProduct);
            } else if (state is FailedGetDetailedProductState) {
              showCustomAboutDialog(context, "detailed product err",
                  state.failure.failureMessage);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double height, double width,
      DetailedProductEntity detailedProduct) {
    String? appLang = widget.user.locale;
    ProductEntity product = detailedProduct.product;
    StoreEntity store = detailedProduct.store;
    UserEntity user = widget.user;
    return ListView(
      shrinkWrap: true,
      children: [
        _buildFirstSection(height, width, store),
        SizedBox(
            height: height * 0.4,
            child: _buildPageView(context, height, width, product)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "product description".tr(context),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(20),
            child: _buildText(
                context,
                appLang == "en"
                    ? product.englishDescription
                    : product.arabicDescription,
                Theme.of(context).textTheme.bodySmall!)),
        Container(
          height: 5,
          margin:
              const EdgeInsets.only(left: 100, right: 100, bottom: 30, top: 10),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAddToCartBtn(user.token, product.productId),
            _buildOrderBtn(user.token, product.productId),
            _buildAddToFavoriteButton(user.token, product.productId),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        _buildChangeAmountSection(),
      ],
    );
  }

  Widget _buildFirstSection(double height, double width, StoreEntity store) {
    return BlocBuilder<DetailedProductBloc, DetailedProductState>(
      builder: (context, state) {
        if (state is LoadedDetailedProductState) {
          return _buildProduct(
              height, width, store, state.detailedProduct.product);
        }
        return _buildProduct(height, width, store);
      },
    );
  }

  Widget _buildProduct(double height, double width, StoreEntity store,
      [ProductEntity? product]) {
    product = product ?? widget.product;
    return Container(
      decoration: BoxDecoration(color: Colors.black.withAlpha(75)),
      child: Row(
        spacing: 10,
        children: [
          Stack(
            children: [
              _buildStorePicture(height, width, store.logo),
              _buildFilter(context, height, width, store.storeName)
            ],
          ),
          SizedBox(
            height: height * 0.2,
            width: width - 0.2 * height - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.user.locale == "en"
                            ? product.englishName
                            : product.arabicName,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 3,
                  color: Colors.white.withAlpha(75),
                ),
                Column(
                  spacing: 5,
                  children: [
                    _buildRowText("orders num", product.ordersCount.toString(),
                        const Color.fromARGB(255, 0, 169, 236)),
                    _buildRowText("quantity", product.quantity.toString(),
                        const Color.fromARGB(255, 255, 251, 4)),
                    _buildRowText("price", "${product.price.toString()} \$",
                        const Color.fromARGB(255, 4, 255, 17)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowText(String first, String second, Color color) {
    return Row(children: [
      Expanded(
        child: Text(
          first.tr(context),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Text(
        second,
        style: TextStyle(color: color, fontSize: 18),
      ),
    ]);
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      title:
          Text(title.tr(context), style: Theme.of(context).textTheme.bodyLarge),
      foregroundColor: Colors.white,
    );
  }

  Widget _buildText(BuildContext context, String text, TextStyle textStyle) {
    return Text(
      text,
      style: textStyle,
    );
  }

  Widget _buildStorePicture(double height, double width, String storeLogo) {
    return Container(
      width: height * 0.2,
      height: height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        image: DecorationImage(
            image: CachedNetworkImageProvider(storeLogo), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildFilter(
      BuildContext context, double height, double width, String storeName) {
    return InkWell(
      onTap: () {
        BlocProvider.of<DetailedStorePaginationBloc>(context).add(
            GetDetailedStoreEvent(
                token: widget.user.token,
                storeId: widget.product.storeId,
                pageNum: 1));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailedStorePage(
              storeID: widget.product.storeId, user: widget.user),
        ));
      },
      child: Container(
        width: height * 0.2,
        height: height * 0.2,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Colors.black,
              Colors.transparent,
              Colors.transparent
            ])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildText(
                context, storeName, Theme.of(context).textTheme.bodySmall!),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView(BuildContext context, double height, double width,
      ProductEntity product) {
    List<String> productsPic = product.productPictures;
    return PageView.builder(
        itemCount: productsPic.length,
        itemBuilder: (context, index) {
          String pic = productsPic[index];
          return Center(
            child: Stack(
              children: [
                Container(
                  height: 0.3 * height,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(pic),
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        " ${index + 1} / ${productsPic.length} ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ))
              ],
            ),
          );
        });
  }

  Widget _buildAddToFavoriteButton(String token, String productID) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: Colors.pink, borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(onPressed: () {
        context
            .read<UpdateProductBloc>()
            .add(AddProductToFavEvent(token: token, productId: productID));
      }, child: BlocBuilder<UpdateProductBloc, UpdateProductState>(
        builder: (context, state) {
          if (state is DoneAddProductToFavState) {
            if (state.productId == widget.product.productId) {
              return Icon(
                Icons.favorite,
                color: Colors.white,
                size: 35,
              );
            }
          }
          return Icon(
            Icons.favorite_border_outlined,
            color: Colors.white,
            size: 35,
          );
        },
      )),
    );
  }

  Widget _buildAddToCartBtn(String token, String productID) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: amount == 0 ? Colors.amber.withAlpha(100) : Colors.amber,
          borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(onPressed: () {
        if (amount != 0) {
          context.read<UpdateProductBloc>().add(AddProductToCartEvent(
              token: token, productId: productID, quantity: amount));
        }
      }, child: BlocBuilder<UpdateProductBloc, UpdateProductState>(
        builder: (context, state) {
          if (state is DoneAddProductToCartState) {
            if (state.productId == widget.product.productId) {
              return Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 35,
              );
            }
          }
          return Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
            size: 35,
          );
        },
      )),
    );
  }

  Widget _buildOrderBtn(String token, String productID) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          color: amount == 0 ? Colors.blue.withAlpha(100) : Colors.blue,
          borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(onPressed: () {
        if (widget.user.firstName == null || widget.user.firstName == "") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UpdateProfilePage(),
          ));
        } else {
          if (amount != 0) {
            showConfirmDialog(
                context,
                () => context.read<UpdateProductBloc>().add(OrderProductEvent(
                    token: token, productId: productID, quantity: amount)));
          }
        }
      }, child: BlocBuilder<UpdateProductBloc, UpdateProductState>(
        builder: (context, state) {
          if (state is DoneOrderProductState) {
            if (state.productId == widget.product.productId) {
              return Icon(
                Icons.done,
                color: Colors.white,
                size: 35,
              );
            }
          }
          return Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          );
        },
      )),
    );
  }

  Widget _buildChangeAmountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              color: amount == 0 ? Colors.green.withAlpha(100) : Colors.green,
              borderRadius: BorderRadius.circular(50)),
          child: MaterialButton(
            onPressed: () {
              if (amount != 0) {
                setState(() {
                  amount--;
                });
              }
            },
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: Text(
              amount.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(50)),
          child: MaterialButton(
            onPressed: () {
              if (amount <= widget.product.quantity) {
                setState(() {
                  amount++;
                });
              }
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 50,
            ),
          ),
        )
      ],
    );
  }
}
