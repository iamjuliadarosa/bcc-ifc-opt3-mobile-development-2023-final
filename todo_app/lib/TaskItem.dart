import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  bool completed;

  TaskItem(this.id, this.title, this.description, this.completed);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                completed ? Colors.green[200] : Colors.orange[200]),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
