import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_delivery/features/auth/domain/enitities/user_entity.dart';
import 'package:order_delivery/features/order/presentation/bloc/detailed_store_pagination_bloc/detailed_store_pagination_bloc.dart';
import 'package:order_delivery/features/order/presentation/pages/detailed_store_page.dart';
import '../../domain/enitities/store_entity.dart';

class CarouselSliderStoreWidget extends StatelessWidget {
  final List<StoreEntity> stores;
  final double height, width;
  final UserEntity user;

  const CarouselSliderStoreWidget(
      {super.key,
      required this.stores,
      required this.height,
      required this.width,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CarouselSlider.builder(
          itemCount: stores.length,
          itemBuilder: (context, index, realIndex) {
            StoreEntity store = stores[index];
            return InkWell(
              onTap: () {
                BlocProvider.of<DetailedStorePaginationBloc>(context).add(
                    GetDetailedStoreEvent(
                        token: user.token, storeId: store.storeId, pageNum: 1));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailedStorePage(
                          storeID: store.storeId,
                          user: user,
                        )));
              },
              child: Stack(
                children: [
                  _buildStorePicture(index),
                  _buildFilter(index),
                  _buildProductCount(index)
                ],
              ),
            );
          },
          options: CarouselOptions(
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height)),
    );
  }

  Widget _buildProductCount(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              stores[index].productCount.toString(),
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilter(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withAlpha(200),
              Colors.transparent,
              Colors.transparent
            ]),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            stores[index].storeName,
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildStorePicture(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: CachedNetworkImageProvider(stores[index].logo),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
