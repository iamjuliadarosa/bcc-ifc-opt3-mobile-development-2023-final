import 'package:flutter/material.dart';
import 'package:todo_app/TodoList.dart';
import 'TaskItem.dart';

void main() {
  runApp(MyApp());
}

List<TaskItem> ToDoTasks = [
  TaskItem("01", "Tarefa Pendente", "Descricao da Tarefa Pendente", false)
];
List<TaskItem> CompletedTasks = [
  TaskItem("02", "Tarefa Completa", "Descricao da Tarefa Completada.", true)
];
List<TaskItem> DeletedTasks = [
  TaskItem("02", "Tarefa Apagada", "Descricao da Tarefa Apagada.", false)
];
String ToDoWeatherContent = 'rgaghasryjasryjsrayjaryj';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To-Do-List', home: TodoList());
  }
}
