import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GrocerySingleListItem extends StatelessWidget {
  const GrocerySingleListItem({super.key, required this.grosery});
  final GroceryItem grosery;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: grosery.category.categoryColor),
            ),
          ),
          const SizedBox(width: 30),
          Text(grosery.name),
          const Spacer(),
          Text(grosery.quantity.toString()),
        ],
      ),
    );
  }
}
