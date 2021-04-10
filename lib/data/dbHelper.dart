import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/models/product.dart';

class DbHelper {

  Database _db;

  Future<Database> get db async { // Bu işlem bittikten sonrasını temsil eden metodları kullanmamız için Future kullandık (then vs)
    if (_db == null) { // db miz daha önce oluşturulmamışsa oluşturmamız lazım
      _db = await initializeDb(); // await: sonraki aşamalara geçilmesi için buranın bitmesini bekle
    }

    return _db;
  }

  Future<Database> initializeDb() async{
    String dbPath = join(await getDatabasesPath(), "etrade.db"); // path ayarları
    
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb); // bu yoldaki veritabanını aç, eğer yoksa onCreate metodunu çalıştır

    return eTradeDb;
  }

  void createDb(Database db, int version) async{
    await db.execute("Create table products(id integer primary key, name text, description text, unitPrice integer)");
  }

  // LİSTELEME
  Future<List<Product>> getProducts() async {
    Database db = await this.db;

    var result = await db.query("products");

    return List.generate(result.length, (i) {
      return Product.fromObject(result[i]);
    });
  }

  // EKLEME
  Future<int> insert(Product product) async{
    Database db = await this.db;

    var result = await db.insert("products", product.toMap());
    // Veriyi database e eklerken map şeklinde eklememiz gerekiyor.
    // Bu yüzden class ın içinde bu işi yapan toMap fonksiyonunu yazdık.

    return result;
  }

  // SİLME
  Future<int> delete(int id) async{
    Database db = await this.db;

    var result = await db.rawDelete("delete from products where id= $id");

    return result;
  }

  // GÜNCELLEME
  Future<int> update(Product product) async{
    Database db = await this.db;

    var result = await db.update("products", product.toMap(), where: "id=?", whereArgs: [product.id]);
    // ("hangi tablo", "hangi product gelicek", "değiştirilecek product ın neyine bakılcak", "bakılacak veri")

    return result;
  }
}