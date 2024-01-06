import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _quantity = 1;
  var _initialCat = categories[Categories.values[0]];

  void _validateThenSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
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
                  TextButton(onPressed: _clearForm, child: const Text('Clear')),
                  ElevatedButton(
                    onPressed: _validateThenSave,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    child: const Text('Add'),
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
