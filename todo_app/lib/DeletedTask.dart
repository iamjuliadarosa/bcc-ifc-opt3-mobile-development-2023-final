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
                      DeletedTasks[index].id,
                      DeletedTasks[index].title,
                      DeletedTasks[index].description,
                      DeletedTasks[index].completed);
                },
              ),
            ),
          ],
        ));
  }
}
