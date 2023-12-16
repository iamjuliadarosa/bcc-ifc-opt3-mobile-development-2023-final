import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  String id;
  String title;
  String description;
  bool completed;

  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
        id: map['id'], title: map['title'], description: map['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor:
                completed == 1 ? Colors.green[200] : Colors.orange[200]),
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
