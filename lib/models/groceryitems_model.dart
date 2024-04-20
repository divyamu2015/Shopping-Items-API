import 'package:groceries_items/models/category_model.dart';

class GroceryItems{
 final String id;
final String name;
final int quantity;
final Category category ;

//GroceryItems(requi this.id,this.name,this.quantity,this.category);
GroceryItems({required this.id,required this.name,required this.quantity,required this.category });
}