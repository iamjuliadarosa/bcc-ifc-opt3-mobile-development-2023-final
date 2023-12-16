import 'package:flutter/material.dart';
import 'package:todo_app/TopNav.dart';
import 'package:uuid/uuid.dart';
import 'TaskItem.dart';

final uuid = Uuid();
List<TaskItem> Tasks = [];
List<TaskItem> CompletedTasks = [];
List<TaskItem> DeletedTasks = [];
String ToDoWeatherContent = '';
String generateUniqueId() {
  return uuid.v4();
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldControllerTitle =
      TextEditingController();
  final TextEditingController _textFieldControllerDescription =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To-Do List'),
        ),
        body: TaskList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add),
        ));
  }

  void _addTodoItem(String title, String description) {
    setState(() {
      final uniqueId = generateUniqueId();
      Tasks.add(TaskItem(uniqueId, title, description, false));
      _showSnackbar('Tarefa adicionada: $title');
    });
    _textFieldControllerTitle.clear();
    _textFieldControllerDescription.clear();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duração da mensagem em segundos
      ),
    );
  }

  //Generate list of item widgets
  Widget _buildTodoItem(String title) {
    return ListTile(
      title: Text(title),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicione uma tarefa à sua lista'),
          content: Column(children: [
            TextField(
              controller: _textFieldControllerTitle,
              decoration: const InputDecoration(
                  hintText: 'Digite o título da tarefa aqui'),
            ),
            TextField(
                controller: _textFieldControllerDescription,
                decoration: const InputDecoration(
                    hintText: 'Digite a descrição da tarefa aqui'))
          ]),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('ADICIONAR'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldControllerTitle.text,
                    _textFieldControllerDescription.text);
              },
            ),
            ElevatedButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duração da mensagem em segundos
      ),
    );
  }

  void _addNewTask(String title, String description) {
    if (description.isNotEmpty && title.isNotEmpty) {
      setState(() {
        final uniqueId = generateUniqueId();
        Tasks.add(TaskItem(uniqueId, title, description, false));
        _showSnackbar('Tarefa adicionada: $title');
      });
    } else {
      if (title.isEmpty) {
        _showSnackbar('O título não pode estar vazio.');
      }
      if (description.isEmpty) {
        _showSnackbar('A descrição não pode estar vazia.');
      }
    }
  }

  void _completeTask(int index) {
    setState(() {
      _showSnackbar('Tarefa completa: ${Tasks[index].title}');
      Tasks[index].completed = !Tasks[index].completed;
      CompletedTasks.add(Tasks[index]);
      Tasks.removeAt(index);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _showSnackbar('Tarefa removida: ${Tasks[index].title}');
      DeletedTasks.add(Tasks[index]);
      Tasks.removeAt(index);
    });
  }

  int _findTaskbyID(String ID) {
    int foundTask = Tasks.indexWhere((task) => task.id == ID);
    return foundTask;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopNav(
          DeletedTasks: DeletedTasks,
          CompletedTasks: CompletedTasks,
          WeatherContent: ToDoWeatherContent,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: Tasks.length,
            itemBuilder: (context, index) {
              final uniqueId = generateUniqueId();
              return Dismissible(
                key: Key(uniqueId),
                child: TaskItem(Tasks[index].id, Tasks[index].title,
                    Tasks[index].description, Tasks[index].completed),
                onDismissed: (direction) => {
                  if (direction == DismissDirection.endToStart)
                    {
                      // Left-to-right swipe
                      // Marca tarefa como completa
                      _completeTask(index)
                    }
                  else if (direction == DismissDirection.startToEnd)
                    {
                      // Right-to-left swipe
                      // Remove tarefa da lista
                      _deleteTask(index)
                    }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
