// import firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String projectId;
  final String name;
  final String description;
  final String deadline;
  final String background;
  final String owner;
  final String progress;
  final String quantityTask;
  final String status;
  final List assigned;

  Project(
      {required this.projectId,
      required this.name,
      required this.description,
      required this.deadline,
      required this.background,
      required this.owner,
      required this.progress,
      required this.quantityTask,
      required this.status,
      required this.assigned});

  factory Project.fromDocument(Map<String, dynamic> doc) {
    return Project(
      projectId: doc['projectId'],
      name: doc['name'],
      description: doc['description'],
      deadline: doc['deadline'],
      background: doc['background'],
      owner: doc['owner'],
      progress: doc['progress'],
      quantityTask: doc['quantityTask'],
      status: doc['status'],
      assigned: doc['assigned'],
    );
  }
}
