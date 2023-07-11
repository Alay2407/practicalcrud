import 'package:flutter/material.dart';
import 'additemdialog.dart';
import 'dbhelper.dart';
import 'model_class.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshItemList();
  }

  Future<void> refreshItemList() async {
    List<Item> fetchedItems = await dbHelper!.getItems();
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite CRUD Example'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          Item item = items[index];
          return ListTile(
            title: Text(item.name!),
            subtitle: Text('Age: ${item.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await dbHelper!.deleteItem(item.id!);
                refreshItemList();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AddItemDialog(dbHelper: dbHelper!),
          );
          refreshItemList();
        },
      ),
    );
  }
}
