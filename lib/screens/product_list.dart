import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/data/dbHelper.dart';
import 'package:sqflite_demo/models/product.dart';
import 'package:sqflite_demo/screens/product_add.dart';
import 'package:sqflite_demo/screens/product_detail.dart';

class ProductList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProductListState();
  }
}

class _ProductListState extends State{
  var dbHelper = DbHelper(); // DatabaseHelper ı açtım
  List<Product> products; // Product tan oluştuğunu belirttiğim bi liste yarattım

  var productCount = 0;

  @override
  void initState() { // Sayfa ilk açıldığında stateler buradan dolacak, veritabanından liste çekilecek
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
      ),
      body: buildProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToProductAdd();
        },
        child: Icon(Icons.add),
        tooltip: "Yeni Ürün Ekle",
      ),
    );
  }

  ListView buildProductList() {
    return ListView.builder(
        itemCount: productCount,
        itemBuilder: (BuildContext context, int position) {
          return Card( // Görünüm için bi Card widget ı oluşturdum
              color: Colors.redAccent,
              elevation: 2.0,
              child: ListTile( // ListTile içerisinde databaseden aldığımızı productların verilerini yazdırdık
                leading: CircleAvatar(backgroundColor: Colors.black12, child: Text("P")),
                title: Text(this.products[position].name),
                subtitle: Text(this.products[position].description),
                onTap: () {
                  goToDetail(this.products[position]);
                },
              ),
          );
        }
    );
  }

  void goToProductAdd() async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductAdd()));

    if(result != null) {
      if(result) {
        getProducts();
      }
    }
  }

  void getProducts() async {
    var productsFuture = dbHelper.getProducts();

    productsFuture.then((data) {
      setState(() {
        productCount = data.length;
        this.products = data;
      });

      print('PRODUCT COUNT');
      print(productCount);
    });
  }

  void goToDetail(Product product) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(product)));

    if(result != null) {
      if(result) {
        getProducts();
      }
    }

    getProducts();
  }
}