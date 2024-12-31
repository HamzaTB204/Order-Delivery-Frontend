import 'package:flutter/material.dart';
import 'package:order_delivery/features/auth/presentation/widgets/custom_text_form_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController searchTEC = TextEditingController();
  @override
  void dispose() {
    searchTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search Page"),
        ),
        body: SizedBox(
          height: 0.9 * height,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSearchTextField(),
                Container(
                    height: 0.7 * height,
                    padding: EdgeInsets.all(20),
                    child: _buildTabBars(height)),
                _buildSearchBtn()
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
              indicator: BoxDecoration(
                color: Colors.amber.withAlpha(50),
                borderRadius: BorderRadius.circular(10.0),
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.person_search_rounded,
                    color: Colors.blue,
                  ),
                  child: Text(
                    "Users",
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.content_paste_search_rounded,
                    color: Colors.purple,
                  ),
                  child: Text(
                    "Posts",
                  ),
                ),
              ]),
          Expanded(
            child: TabBarView(children: [
              _buildProductsTestWidgets(),
              _buildStoresTestWidgets()
            ]),
          )
        ]));
  }

  Widget _buildSearchBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () {
                //TODO:search
              },
              height: 50,
              color: Colors.green,
              child: const Text("search"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: CustomTextFormField(
            obsecure: false,
            textEditingController: searchTEC,
            hintText: "enter your search query",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "please fill enter your query to search";
              }
              return null;
            },
            prefixIcon: Icon(
              Icons.search,
              color: Colors.green,
              size: 40,
            )),
      ),
    );
  }

  Widget _buildProductsTestWidgets() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) => Container(
        height: 50,
        width: double.infinity,
        color: Colors.blue,
        child: Text("Product number $index"),
      ),
    );
  }

  Widget _buildStoresTestWidgets() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) => Container(
        height: 50,
        width: double.infinity,
        color: Colors.purple,
        child: Text("Store number $index"),
      ),
    );
  }
}
