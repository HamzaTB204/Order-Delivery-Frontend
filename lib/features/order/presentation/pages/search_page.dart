import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/core/util/functions/functions.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/auth/presentation/widgets/costum_loading_widget.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:order_delivery/features/order/domain/enitities/product_entity.dart';
import 'package:order_delivery/features/order/domain/enitities/store_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_product_bloc/detailed_product_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_store_pagination_bloc/detailed_store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/bloc/search_store_pagination_bloc/store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_product_page.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_store_page.dart';
import '../bloc/search_product_pagination_bloc/search_product_pagination_bloc.dart';

class SearchPage extends StatefulWidget {
  final UserEntity user;
  const SearchPage({super.key, required this.user});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchTEC = TextEditingController();
  // final ScrollController scrollC = ScrollController();
  int productPageNUM = 1, storePageNUM = 1;
  int currentIndex = 0;
  //static String query = "" ;

  @override
  void initState() {
    // scrollC.addListener(_onScroll(context));
    super.initState();
  }

  @override
  void dispose() {
    searchTEC.dispose();
    // scrollC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserEntity user = widget.user;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search Page"),
        ),
        body: SizedBox(
          height: 0.9 * height,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildSearchTextField(),
                      ),
                      _buildSearchBtn(user.token)
                    ],
                  ),
                ),
                Container(
                    height: 0.9 * height,
                    padding: const EdgeInsets.all(20),
                    child: _buildTabBars(height)),
              ],
            ),
          ),
        ));
  }

  Widget _buildTabBars(double height) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(children: [
          TabBar(
              onTap: (value) {
                currentIndex = value;
              },
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(5.0),
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.production_quantity_limits_outlined,
                    color: Colors.amber,
                  ),
                  child: Text(
                    "products".tr(context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Tab(
                  icon: const Icon(
                    Icons.store,
                    color: Colors.lightGreen,
                  ),
                  child: Text(
                    "stores".tr(context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ]),
          Expanded(
            child: TabBarView(children: [
              _buildProductsBloc(height),
              _buildStoresBloc(height)
            ]),
          )
        ]));
  }

  Widget _buildSearchBtn(String token) {
    return MaterialButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          context.read<SearchProductPaginationBloc>().add(SearchProductsEvent(
              token: token, query: searchTEC.text, pageNum: 1));
          context.read<StorePaginationBloc>().add(SearchStoresEvent(
              token: token, query: searchTEC.text, pageNum: 1));
        }
      },
      height: 50,
      color: Colors.blue,
      child: const Text(
        "search",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Form(
        key: formKey,
        child: CustomTextFormField(
            obsecure: false,
            textEditingController: searchTEC,
            hintText: "enter your search query".tr(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "please enter your query to search".tr(context);
              }
              return null;
            },
            prefixIcon: const Icon(
              Icons.image_search,
              color: Colors.blue,
              size: 40,
            )),
      ),
    );
  }

  Widget _buildProductsBloc(double height) {
    return BlocBuilder<SearchProductPaginationBloc,
        SearchProductPaginationState>(
      builder: (context, state) {
        if (state is LoadedSearchProductsState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildProducts(context, state.products),
          );
        } else if (state is LoadingSearchProductsState && productPageNUM == 1) {
          return CustomLoadingWidget();
        } else if (state is FailedSearchProductsState && productPageNUM == 1) {
          showCustomAboutDialog(
              context, "failed product search", state.failure.failureMessage);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStoresBloc(double height) {
    return BlocConsumer<StorePaginationBloc, StorePaginationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadedSearchStoresState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildStores(context, state.stores),
          );
        } else if (state is LoadingStoreState && storePageNUM == 1) {
          return CustomLoadingWidget();
        } else if (state is FailedStoreState && storePageNUM == 1) {
          showCustomAboutDialog(
              context, "failed store search", state.failure.failureMessage);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildProducts(BuildContext context, List<ProductEntity> products) {
    String? appLang = widget.user.locale;
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () {
              BlocProvider.of<DetailedProductBloc>(context).add(
                  GetDetailedProductEvent(
                      token: widget.user.token, product: product));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailedProductPage(
                        product: product,
                        user: widget.user,
                      )));
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              product.productPictures.first),
                          fit: BoxFit.fill),
                    ),
                    child: Card(
                        color: Colors.grey.shade800,
                        margin: const EdgeInsets.only(top: 130),
                        child: ListTile(
                          leading: const Icon(
                            Icons.production_quantity_limits,
                            size: 15,
                            color: Colors.greenAccent,
                          ),
                          title: Text(
                            appLang == "en"
                                ? product.englishName
                                : product.arabicName,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ))),
              ],
            ),
          );
        });
  }

  Widget _buildStores(BuildContext context, List<StoreEntity> stores) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return InkWell(
            onTap: () {
              BlocProvider.of<DetailedStorePaginationBloc>(context).add(
                  GetDetailedStoreEvent(
                      token: widget.user.token,
                      storeId: store.storeId,
                      pageNum: 1));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailedStorePage(
                        storeID: store.storeId,
                        user: widget.user,
                      )));
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(store.logo),
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black38,
                  ),
                  child: Center(
                    child: Text(
                      store.storeName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  // _onScroll(BuildContext context) {
  // final double max = scrollC.position.maxScrollExtent;
  // final double currentScroll = scrollC.offset;
  //todo
  // must be another condition
  //   if (currentScroll >= max * 0.8) {
  //     if (currentIndex == 0) {
  //       productPageNUM++;
  //       context.read<SearchProductPaginationBloc>().add(SearchProductsEvent(
  //           pageNum: productPageNUM,
  //           token: widget.user.token,
  //           query: searchTEC.text));
  //     } else {
  //       storePageNUM++;
  //       context.read<SearchProductPaginationBloc>().add(SearchProductsEvent(
  //           pageNum: storePageNUM,
  //           token: widget.user.token,
  //           query: searchTEC.text));
  //     }
  //   }
  // }
}
