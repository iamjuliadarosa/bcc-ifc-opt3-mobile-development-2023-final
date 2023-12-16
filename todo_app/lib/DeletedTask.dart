import 'package:flutter/material.dart';
import 'TaskItem.dart';

class DeletedTask extends StatelessWidget {
  final List<TaskItem> DeletedTasks;

  DeletedTask({required this.DeletedTasks});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tarefas Apagadas'),
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
                itemCount: DeletedTasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                      id: DeletedTasks[index].id,
                      title: DeletedTasks[index].title,
                      description: DeletedTasks[index].description,
                      completed: DeletedTasks[index].completed);
                },
              ),
            ),
          ],
        ));
  }
}
