import 'package:groceries_items/data/category_data.dart';
import 'package:groceries_items/models/groceryitems_model.dart';

import '../models/category_model.dart';

final groceryItems=[
 GroceryItems(
  id:'a', 
  name:'Milk',
   quantity:1,
    category:categories[Categories.diary]!),

    GroceryItems(
  id:'b', 
  name:'Bananas',
   quantity:5,
    category:categories[Categories.fruits]!),
    GroceryItems( 
  id:'c', 
  name:'Beaf Steak',
   quantity:1,
    category:categories[Categories.meats]!),

    GroceryItems(
      id: 'd',
      name: 'laddu',
      quantity: 5,
      category: categories[Categories.sweets]!)

    

];