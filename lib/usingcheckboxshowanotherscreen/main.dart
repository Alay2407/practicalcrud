import 'package:flutter/material.dart';

import '../using_list_crud_operation/main.dart';



class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> todos = [];
  List<Todo> selectedTodos = [];

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _editTextEditingController = TextEditingController();

  void addTodo() {
    String title = _textEditingController.text;
    if (title.isNotEmpty) {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      Todo todo = Todo(id: id, title: title);
      setState(() {
        todos.add(todo);
      });
      _textEditingController.clear();
    }
  }

  void updateTodoStatus(int index, bool completed) {
    setState(() {
      todos[index].completed = completed;
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void updateTodoTitle(int index, String newTitle) {
    setState(() {
      todos[index].title = newTitle;
    });
  }

  void openEditDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: _editTextEditingController,
            decoration: InputDecoration(hintText: 'Enter new title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String newTitle = _editTextEditingController.text;
                if (newTitle.isNotEmpty) {
                  updateTodoTitle(index, newTitle);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void selectTodoItem(bool value, Todo todo) {
    setState(() {
      if (value) {
        selectedTodos.add(todo);
      } else {
        selectedTodos.remove(todo);
      }
    });
  }

  void clearSelectedTodos() {
    setState(() {
      selectedTodos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter a todo',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTodo,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                Todo todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      updateTodoStatus(index, value!);
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          openEditDialog(index);
                        },
                      ),
                      Checkbox(
                        value: selectedTodos.contains(todo),
                        onChanged: (bool? value) {
                          selectTodoItem(value!, todo);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todo List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Selected Todos',
          ),
        ],
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectedTodosScreen(selectedTodos: selectedTodos),
              ),
            );
          }
        },
      ),
    );
  }
}



//selected checkbox
class SelectedTodosScreen extends StatelessWidget {
  final List<Todo> selectedTodos;

  const SelectedTodosScreen({required this.selectedTodos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Todos'),
      ),
      body: ListView.builder(
        itemCount: selectedTodos.length,
        itemBuilder: (BuildContext context, int index) {
          Todo todo = selectedTodos[index];
          return ListTile(
            title: Text(todo.title),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TodoApp(),
  ));
}
