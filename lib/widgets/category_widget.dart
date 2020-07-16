import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shopeasy/helpers/app_localization.dart';
import 'package:shopeasy/screens/shops_category_page.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List categories = [];
  int size = 0;
  bool isSearching = false;
  TextEditingController searchCtrl = TextEditingController();
  String searchText = '';

  Future<void> getCategories() async {
    var test;
    databaseReference.child("categories").once().then((DataSnapshot snapshot) {
      setState(() {
        test = snapshot.value;
        categories = test.values.toList();
        size = test.length;
//        print(test.values);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.28),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: searchCtrl,
//              focusNode: searchFocusNode,
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.blueGrey.shade900,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.blueGrey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      if (!isSearching) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => searchCtrl.clear(),
                        );
                      }
                      searchText = '';
                      FocusScope.of(context).requestFocus(new FocusNode());
//                      searchFocusNode=
                    });
                  },
                ),
                hintText: AppLocalizations.of(context).translate('hp3'),
              ),
              onChanged: (value) {
                setState(() {
                  isSearching = true;
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          size == 0
              ? Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: size,
                  itemBuilder: (BuildContext ctxt, int index) {
                    String checkingText = categories[index].toLowerCase();
                    if (checkingText.contains(searchText)) {
                      return InkWell(
                        splashColor: Colors.grey,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                              child: Image.asset(
                                'assets/bulletCart.png',
                                width: 30,
                              ),
//                              Icon(
//                                Icons.radio_button_checked,
//                                color: Theme.of(context).primaryColor,
//                              ),
                            ),
                            title: Text(
                              categories[index].toUpperCase(),
                              style: TextStyle(
                                  color: Colors.blueGrey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Righteous'),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopCategory(
                                sCategory: categories[index],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
        ],
      ),
    );
  }
}
