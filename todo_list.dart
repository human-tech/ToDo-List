import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:hive/hive.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final formkey = GlobalKey<FormState>();
  String todo;
  final fieldText = TextEditingController();
  final todoBox = Hive.box('ToDo_List');

  void addToDo(ToDo todo) {
    todoBox.add(todo.todo);
  }

  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO-DO LIST"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: _buildList()),
          Form(
            key: formkey,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Enter a task",
                hintStyle: TextStyle(
                  fontSize: 20,
                ),
                contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 23),
              ),
              onSaved: (value) => todo = value,
              controller: fieldText,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formkey.currentState.save();
          final newtodo = ToDo(todo);
          addToDo(newtodo);
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            clearText();
          }
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
        itemCount: todoBox.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todoBox.getAt(index);

          return Card(
            child: ListTile(
              title: Text(
                todo,
                style: TextStyle(fontSize: 15),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        todoBox.deleteAt(index);
                      });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
