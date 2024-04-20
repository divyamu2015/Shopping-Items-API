import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:groceries_items/models/category_model.dart';
import 'package:groceries_items/models/groceryitems_model.dart';

import '../data/category_data.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  final _formkey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQunatity =1;
  var _selectedCategory =categories[Categories.vegetables]!;
  var _isSending = false;


  void _saveItem() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        _isSending=true;
      });
      final url=Uri.https(
        'grocery-items-2838f-default-rtdb.firebaseio.com','shopping-list.json');
    final response= await http.post(
      url,
      headers: {
        'Content-Type' :'application/json',
      },
      body: json.encode(
        {
          'name': _enteredName, 
        'quantity': _enteredQunatity, 
        'category': _selectedCategory.title,
        }
      )
      );

      final Map<String,dynamic> resData= json.decode(response.body);
      if(!context.mounted){
        return;
      }
      Navigator.of(context).pop(GroceryItems(
        id: resData['name'], 
        name: _enteredName,
         quantity: _enteredQunatity,
          category: _selectedCategory));
    }
  }

  @override 
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                // controller: _namecontroller,
                decoration: const InputDecoration(
                    label: Text(
                  'Name',
                  style: TextStyle(fontSize: 20),
                )),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      // controller: _categorycontroller,
                      decoration: const InputDecoration(label: Text('Quality')),
                       initialValue: _enteredQunatity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be valid positive number.';
                        }
                        return null;
                      },

                      onSaved: (value){
                        _enteredQunatity=int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        decoration:
                            const InputDecoration(hintText: 'Select Category'),
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.colors,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(category.value.title)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                             _selectedCategory =value!;
                          });
                         
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 54, 3, 63))),
                      onPressed:_isSending ? null : () {
                        _formkey.currentState!.reset();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 54, 3, 63))),
                      onPressed:_isSending? null : _saveItem,
                      child:_isSending ? const SizedBox(
                        height: 16,
                        width: 16,
                        child:CircularProgressIndicator() ,
                      ) :
                      const Text(
                        'Add item',
                        style: TextStyle(
                          color: Colors.white,
                           fontSize: 15),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
