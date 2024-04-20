import 'package:flutter/material.dart';

enum Categories{
  vegetables,
  fruits,
  meats,
  diary,
  sweets,
 

}
class Category{
  final String title;
  final Color colors;

  const Category(this.title,this.colors);
  
}