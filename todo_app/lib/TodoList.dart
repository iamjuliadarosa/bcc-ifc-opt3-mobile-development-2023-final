import 'package:flutter/material.dart';
import 'package:todo_app/DatabaseHelper.dart';
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
  final DatabaseHelper dbHelper;
  TodoList({required this.dbHelper});
  @override
  _TodoListState createState() => _TodoListState(dbHelper: dbHelper);
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldControllerTitle =
      TextEditingController();
  final TextEditingController _textFieldControllerDescription =
      TextEditingController();
  final DatabaseHelper dbHelper;
  _TodoListState({required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To-Do List'),
        ),
        body: TaskList(dbHelper: dbHelper),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add),
        ));
  }

  void _addTodoItem(String title, String description) async {
    final uniqueId = generateUniqueId();
    final newTask = TaskItem(
        id: uniqueId, title: title, description: description, completed: false);

    // Inserir a nova tarefa no banco de dados
    await dbHelper.insertTask(newTask);

    // Atualizar a lista local
    setState(() {
      Tasks.add(newTask);
    });

    _showSnackbar('Tarefa adicionada: $title');
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
  final DatabaseHelper dbHelper;

  TaskList({required this.dbHelper});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    print("Em _loadTasks");
    Tasks = await widget.dbHelper.getAllTasks();
    setState(() {});
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Duração da mensagem em segundos
      ),
    );
  }

  void _addNewTask(String title, String description) async {
    if (description.isNotEmpty && title.isNotEmpty) {
      final uniqueId = generateUniqueId();
      final newTask = TaskItem(
          id: uniqueId,
          title: title,
          description: description,
          completed: false);

      // Inserir a nova tarefa no banco de dados
      await widget.dbHelper.insertTask(newTask);

      // Atualizar a lista local
      setState(() {
        Tasks.add(newTask);
      });

      _showSnackbar('Tarefa adicionada: $title');
    } else {
      if (title.isEmpty) {
        _showSnackbar('O título não pode estar vazio.');
      }
      if (description.isEmpty) {
        _showSnackbar('A descrição não pode estar vazia.');
      }
    }
  }

  void _completeTask(int index) async {
    final completedTask = Tasks[index];

    // Remover a tarefa do banco de dados
    await widget.dbHelper.deleteTask(completedTask.id!);

    // Atualizar a lista local
    setState(() {
      Tasks[index].completed = Tasks[index].completed;
      CompletedTasks.add(Tasks[index]);
      Tasks.removeAt(index);
    });

    _showSnackbar('Tarefa completa: ${completedTask.title}');
  }

  void _deleteTask(int index) async {
    final deletedTask = Tasks[index];

    // Remover a tarefa do banco de dados
    await widget.dbHelper.deleteTask(deletedTask.id!);

    // Atualizar a lista local
    setState(() {
      DeletedTasks.add(deletedTask);
      Tasks.removeAt(index);
    });

    _showSnackbar('Tarefa removida: ${deletedTask.title}');
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
                child: TaskItem(
                    id: Tasks[index].id,
                    title: Tasks[index].title,
                    description: Tasks[index].description,
                    completed: Tasks[index].completed),
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
