import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double _borderRadius = 24;

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  Future<List<PlaceInfo>> _getProducts() async {
    var data = await http.get(Uri.parse(
        'https://thefourshapes.azurewebsites.net/api/Shape/GetShapes'));

    var jsonData = json.decode(data.body);

    List<PlaceInfo> products = [];

    setState(() {
      for (var product in jsonData) {
        PlaceInfo newProduct = PlaceInfo(
          product['productName'],
          product['shapeName'],
          product[''],
          product[''],
          product[''],
          product['restockAmt'],
          product['currentAmt'],
          product[''],
        );

        newProduct.startColor = Color(0xff4db6ac);

        if (newProduct.currentAmt > 1) {
          newProduct.endColor = Color(0xff80cbc4);
          newProduct.status = 'Safe';
        } else {
          newProduct.startColor = Color(0xffff8a65);
          newProduct.endColor = Color(0xffffab91);
          newProduct.status = 'Urgent';
        }

        if (newProduct.productName == ('Box of Syringe')) {
          newProduct.pic = 'assets/box2.png';
        } else if (newProduct.productName == ('Panadol')) {
          newProduct.pic = 'assets/panadol2.png';
        } else if (newProduct.productName == ('Paracetemol')) {
          newProduct.pic = 'assets/para.png';
        } else {
          newProduct.pic = 'assets/syrup2.png';
        }
        if (newProduct.currentAmt > 1) {
          products.add(newProduct);
        } else {
          products.insert(0, newProduct);
        }
      }
    });
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: _getProducts(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: const Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _getProducts,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(_borderRadius),
                                    gradient: LinearGradient(
                                        colors: [
                                          snapshot.data[index].startColor,
                                          snapshot.data[index].endColor
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    boxShadow: [
                                      BoxShadow(
                                        color: snapshot.data[index].endColor,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Image.asset(
                                          snapshot.data[index].pic,
                                          height: 64,
                                          width: 64,
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].productName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              snapshot.data[index].productShape,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    'Restock Amount: ' +
                                                        snapshot.data[index]
                                                            .restockAmt
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Avenir',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    'Current Amount: ' +
                                                        snapshot.data[index]
                                                            .currentAmt
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Avenir',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].status,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceInfo {
  final String productName;
  final String productShape;
  final int restockAmt;
  final int currentAmt;
  String? status;
  String? pic;
  Color? startColor;
  Color? endColor;

  PlaceInfo(this.productName, this.productShape, this.startColor, this.endColor,
      this.pic, this.restockAmt, this.currentAmt, this.status);
}
