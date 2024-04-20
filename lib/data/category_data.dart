import 'package:flutter/material.dart';
import 'package:groceries_items/models/category_model.dart';

const categories={

Categories.vegetables:Category(
  'Vegetables', 
    Color.fromARGB(255, 28, 128, 31),
    ),

    Categories.fruits:Category(
      'Fruits', 
      Color.fromARGB(255, 115, 187, 117),
      ),

      Categories.meats:Category(
        'Meat', 
        Colors.red),
        
        Categories.diary:Category(
          'Dairy',
           Colors.blue),

            Categories.sweets:Category(
          'Sweets',
           Colors.orange)

};