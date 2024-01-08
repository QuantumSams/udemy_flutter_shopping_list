import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

import './new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    final url = Uri.https(
        'udemy-shopping-list-backend-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final respone = await http.get(url);
    if (respone.statusCode >= 400) {
      setState(() {
        _error = "An error has occured. Please try again.";
      });
      return;
    }
    final List<GroceryItem> _groceryItemsTmp = [];
    final Map<String, dynamic> decodedJson = json.decode(respone.body);

    for (final item in decodedJson.entries) {
      final cat = categories.entries
          .firstWhere((inCat) => inCat.value.title == item.value['category'])
          .value;
      _groceryItemsTmp.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: cat),
      );
    }
    setState(() {
      _isLoading = false;
      _groceryItems = _groceryItemsTmp;
    });
  }

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem itemToRemove) async {
    final index = _groceryItems.indexOf(itemToRemove);

    setState(() {
      _groceryItems.remove(itemToRemove);
    });
    final url = Uri.https(
        'demy-shopping-list-backend-default-rtdb.firebaseio.com',
        'shopping-list/${itemToRemove.id}.json');
    final respone = await http.delete(url);

    if (respone.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, itemToRemove);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("'${itemToRemove.name}' can't be removed.")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget displayScreen = const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Nothing here",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text("Click 'Add' button to enter new grocery")
          ]),
    );

    if (_isLoading) {
      displayScreen = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      displayScreen = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      displayScreen = Center(
        child: Text(_error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _loadItems, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: displayScreen,
    );
  }
}
