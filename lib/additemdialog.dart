import 'package:flutter/material.dart';

import 'dbhelper.dart';
import 'model_class.dart';
class AddItemDialog extends StatefulWidget {
  final DBHelper? dbHelper;

  AddItemDialog({this.dbHelper});

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'age'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        GestureDetector(
          onTap: () async {
            String name = _nameController.text;
            int age = int.tryParse(_ageController.text) ?? 0;

            if (name.isNotEmpty && age > 0) {
              Item item = Item(name: name, quantity: age);
              await widget.dbHelper!.insertItem(item);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        )
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}