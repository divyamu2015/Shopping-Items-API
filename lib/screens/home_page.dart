import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/category_data.dart';
import '../models/groceryitems_model.dart';
import 'grocery_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   List<GroceryItems> _groceryItems = [];
   var _isLoading =true;
   String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https('grocery-items-2838f-default-rtdb.firebaseio.com',
        'shopping-list.json');
    
    try{
      final response = await http.get(url);
       if(response.statusCode >=400){
      setState(() {
          _error='Failed to fetch data.Please try again later';

      });
    

    }

   
    if(response.body == 'null'){
      setState(() {
        _isLoading =false;
      });
      return ;
    }

    final Map<String,dynamic> listData=json.decode(response.body);
    final List<GroceryItems> loadItems=[];
    for (final item in listData.entries){
      final category=categories.entries.firstWhere(
        (catItem) => catItem.value.title == item.value['category']).value;
      loadItems.add(GroceryItems(
      id: item.key, 
      name: item.value['name'],
       quantity: item.value['quantity'], 
       category: category,
       ));
 
    }
    setState(() {
      _groceryItems=loadItems;
     });
     } catch(error){
       setState(() {
          _error='Something went wrong.Please try again later';

      });
     }

   
    
  }

  void _addItem() async {
   final newItem= await Navigator.of(context).push<GroceryItems>(MaterialPageRoute(
      builder: (context) {
        return const GroceryPage();
      },
    ));

   // _loadItems();

   if(newItem ==null){
    return;
   }

   setState(() {
     _groceryItems.add(newItem);
   });
  }


  void _removeItem(GroceryItems items) async {

    final index =_groceryItems.indexOf(items);
  setState(() {
      _groceryItems.remove(items);
    });

     final url = Uri.https('grocery-items-2838f-default-rtdb.firebaseio.com',
        'shopping-list/${items.id}.json');

       final response =await http.delete(url);
         
         //undo
       if(response.statusCode>=400){
        //optional show the error
        setState(() {
      _groceryItems.insert(index,items);
    });
       }

    
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet..'),
    );

    if(_isLoading){
      content =const Center(
        child: CircularProgressIndicator(),
      );

    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            key: ValueKey(_groceryItems[index].id),
            child: ListTile(
              leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.colors),
              title: Text(_groceryItems[index].name),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }

    if(_error !=null){
      content =  Center(
      child: Text(_error!),
    );
    }


    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        centerTitle: true,
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem();
        },
        child: const Icon(Icons.add),
      ),
    ));
  }
}
