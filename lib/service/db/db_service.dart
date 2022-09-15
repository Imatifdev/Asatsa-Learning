import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:qixer/model/save_item_model.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static Database? _database;

  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'service_db');
    var database = await openDatabase(path, version: 1, onCreate: _dbOnCreate);
    return database;
  }

  _dbOnCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE savedItem_table(id INTEGER PRIMARY KEY AUTOINCREMENT, serviceId INTEGER, sellerId INTEGER, title TEXT, image TEXT, price INTEGER, sellerName TEXT, rating REAL)");
  }

  Future<Database> get getdatabase async {
    if (_database != null) {
      //if the database already exists
      return _database!;
    } else {
      //else create the database and return it
      _database = await setDatabase();
      return _database!;
    }
  }

  checkIfSaved(serviceId, title, sellerName) async {
    var connection = await getdatabase;
    var result = await connection.rawQuery(
        "SELECT * FROM savedItem_table WHERE serviceId=? and title =? and sellerName=?",
        [serviceId, title, sellerName]);

    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  saveOrUnsave(
      int serviceId,
      String title,
      String image,
      int price,
      String sellerName,
      double rating,
      BuildContext context,
      int sellerId) async {
    var connection = await getdatabase;
    var result = await connection.rawQuery(
        "SELECT * FROM savedItem_table WHERE serviceId=? and title =? and sellerName=?",
        [serviceId, title, sellerName]);
    if (result.isEmpty) {
      //if not already added to cart
      var itemObj = SaveItemModel();
      itemObj.serviceId = serviceId;
      itemObj.title = title;
      itemObj.image = image;
      itemObj.price = price;
      itemObj.sellerName = sellerName;
      itemObj.rating = rating;
      itemObj.sellerId = sellerId;

      await connection.insert('savedItem_table', itemObj.itemMap());
      print('data inserted');

      return true;
    } else {
      //else, already saved, so remove it
      await connection.rawDelete(
          "DELETE FROM savedItem_table WHERE serviceId=? and title =? and sellerName=?",
          [serviceId, title, sellerName]);

      print('data removed');
      return false;
    }
  }

//get all saved item ======>
  getAllSaveditem() async {
    var connection = await getdatabase;
    return await connection.query('savedItem_table');
  }
}
