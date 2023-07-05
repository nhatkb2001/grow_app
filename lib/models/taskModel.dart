// import firebase
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String taskId;
  final String projectId;
  final String name;
  final String description;
  final String deadline;
  final String progress;
  final String status;
  final List assigned;
  final String owner;

  Task({
    required this.taskId,
    required this.projectId,
    required this.name,
    required this.description,
    required this.deadline,
    required this.progress,
    required this.status,
    required this.assigned,
    required this.owner,
  });

  factory Task.fromDocument(Map<String, dynamic> doc) {
    return Task(
        taskId: doc['taskId'],
        projectId: doc['projectId'],
        name: doc['name'],
        description: doc['description'],
        deadline: doc['deadline'],
        progress: doc['progress'],
        status: doc['status'],
        assigned: doc['assigned'],
        owner: doc["owner"]);
  }
}
