import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/data/dbHelper.dart';
import 'package:sqflite_demo/models/product.dart';

class ProductDetail extends StatefulWidget{
  Product product;
  ProductDetail(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState(product);
  }

}

enum Options{delete, update}

class _ProductDetailState extends State{
  Product product;
  _ProductDetailState(this.product);

  var dbHelper = DbHelper();

  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtUnitPrice = TextEditingController();

  @override
  void initState() {
    txtName.text = product.name;
    txtDescription.text = product.description;
    txtUnitPrice.text = product.unitPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürün Detayı: ${product.name}"),
        actions: [
          PopupMenuButton<Options>(
            onSelected: selectProcess,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              PopupMenuItem<Options>(
                value: Options.delete,
                child: Text("Sil"),
              ),
              PopupMenuItem<Options>(
                value: Options.update,
                child: Text("Güncelle"),
              )
            ],
          )
        ],
      ),
      body: buildProductDetail(),

    );
  }

  buildProductDetail() {
    return Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            buildNameField(),
            buildDescriptionField(),
            buildUnitPriceField(),
          ],
        )
    );
  }


  void selectProcess(Options options) async{
    print(options);
    // Seçilen işlemi temsil eder

    switch(options) {
      case Options.delete:
        await dbHelper.delete(product.id);

        Navigator.pop(context, true);
        break;

      case Options.update:
        await dbHelper.update(Product.withId(product.id, txtName.text, txtDescription.text, double.tryParse(txtUnitPrice.text)));

        Navigator.pop(context, true);
        break;
      default:
    }
  }

  buildNameField() {
    return TextField(
      decoration: InputDecoration(labelText: "Ürün Adı"),
      controller: txtName,
    );
  }

  buildDescriptionField() {
    return TextField(
      decoration: InputDecoration(labelText: "Ürün Açıklaması"),
      controller: txtDescription,
    );
  }

  buildUnitPriceField() {
    return TextField(
      decoration: InputDecoration(labelText: "Birim Fiyatı"),
      controller: txtUnitPrice,
    );
  }
}