import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

import './new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addNewItem() async {
    final selectedCat = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (selectedCat == null) {
      return;
    }
    setState(() {
      _groceryItems.add(selectedCat);
    });
  }

  void _removeItem(GroceryItem itemToRemove) {
    setState(() {
      _groceryItems.remove(itemToRemove);
    });
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
        ],
      ),
      body: displayScreen,
    );
  }
}
