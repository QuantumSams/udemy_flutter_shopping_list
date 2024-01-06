import 'package:flutter/material.dart';
import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Name")),
                validator: (value) {
                  return 'Demo';
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: '1',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: DropdownButtonFormField(
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
                                    BoxDecoration(color: cat.value.color),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(cat.value.title),
                            ],
                          ),
                        )
                    ],
                    onChanged: (value) {},
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
