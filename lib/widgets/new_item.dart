import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import '../data/categories.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _isPosting = false;
  var _name = '';
  var _quantity = 1;
  var _initialCat = categories[Categories.values[0]];

  void _validateThenSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isPosting = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(
          'udemy-shopping-list-backend-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final status = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _name,
            'quantity': _quantity,
            'category': _initialCat!.title
          }));

      if (!context.mounted) {
        return;
      }

      final decodedRes = json.decode(status.body);
      Navigator.of(context).pop(GroceryItem(
          id: decodedRes['name'],
          name: _name,
          quantity: _quantity,
          category: _initialCat!));
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Name")),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length >= 50) {
                    return 'Must be 1-50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: '1',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be a positive number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _initialCat,
                      items: [
                        for (final cat in categories.entries)
                          DropdownMenuItem(
                            value: cat.value,
                            child: Row(
                              children: [
                                Container(
                                    width: 16,
                                    height: 16,
                                    decoration:
                                        BoxDecoration(color: cat.value.color)),
                                const SizedBox(width: 10),
                                Text(cat.value.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _initialCat = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isPosting ? null : _clearForm,
                      child: const Text('Clear')),
                  ElevatedButton(
                    onPressed: _isPosting ? null : _validateThenSave,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    child: _isPosting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator())
                        : const Text('Add'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
