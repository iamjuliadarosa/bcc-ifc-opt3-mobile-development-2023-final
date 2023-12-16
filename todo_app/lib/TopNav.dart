import 'package:flutter/material.dart';
import 'package:todo_app/CompletedTask.dart';
import 'package:todo_app/DeletedTask.dart';
import 'package:todo_app/TemperatureWidget.dart';
import 'TaskItem.dart';

class TopNav extends StatelessWidget {
  final List<TaskItem> DeletedTasks;
  final List<TaskItem> CompletedTasks;
  String WeatherContent;

  TopNav(
      {required this.DeletedTasks,
      required this.CompletedTasks,
      required this.WeatherContent});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TemperatureWidget(content: WeatherContent),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CompletedTask(CompletedTasks: CompletedTasks);
                    },
                  ),
                );
              },
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CompletedTask(CompletedTasks: CompletedTasks);
                      },
                    ),
                  );
                },
              )),
          Text("Deslize para alterar"),
          ElevatedButton(
              onPressed: () {},
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DeletedTask(DeletedTasks: DeletedTasks);
                      },
                    ),
                  );
                },
              )),
        ],
      )
    ]));
  }
}
