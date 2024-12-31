import 'package:flutter/material.dart';
import 'package:order_delivery/features/order/presentation/pages/search_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        spacing: 100,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomAppBar(context),
          Text("Top Demand Products"),
          Text("Latest Products"),
          Text("Products For you"),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Center(child: Text("App Title")),
          Positioned(
              right: 5,
              top: 2,
              child: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 40,
                    color: Colors.amber,
                  ),
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      )))
        ],
      ),
    );
  }
}
