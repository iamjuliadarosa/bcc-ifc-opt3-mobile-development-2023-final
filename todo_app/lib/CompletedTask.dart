import 'package:flutter/material.dart';
import 'TaskItem.dart';

class CompletedTask extends StatelessWidget {
  final List<TaskItem> CompletedTasks;

  CompletedTask({required this.CompletedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tarefas Completas'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: CompletedTasks.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                      duration: Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn,
                      child: TaskItem(
                          CompletedTasks[index].id,
                          CompletedTasks[index].title,
                          CompletedTasks[index].description,
                          CompletedTasks[index].completed));
                },
              ),
            ),
          ],
        ));
  }
}
