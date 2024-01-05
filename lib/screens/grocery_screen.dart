import 'package:flutter/material.dart';
import '../widget/grocery_single_list_item.dart';
import '../data/dummy_items.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: groceryItems.length,
          itemBuilder: (BuildContext context, int index) =>
              GrocerySingleListItem(grosery: groceryItems[index])),
    );
  }
}
