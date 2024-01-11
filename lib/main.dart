import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChnageNotifier-Model.dart'; // Importiere dein TaskListModel

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskListModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List App'),
      ),
      body: Consumer<TaskListModel>(
        builder: (context, taskListModel, child) {
          return ListView.builder(
            itemCount: taskListModel.tasks.length,
            itemBuilder: (context, index) {
              Task task = taskListModel.tasks[index];
              return ListTile(
                title: Text(task.title),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    taskListModel.toggleTaskCompletion(index);
                  },
                ),
                onLongPress: () {
                  taskListModel.removeTask(index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Öffne einen Dialog, um eine neue Aufgabe hinzuzufügen
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newTaskTitle = ''; // Lokale Variable, um den neuen Aufgabentitel zu speichern

              return AlertDialog(
                title: Text('Neue Aufgabe hinzufügen'),
                content: TextField(
                  onChanged: (value) {
                    newTaskTitle = value; // Aktualisiere den neuen Aufgabentitel bei Eingabeänderungen
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (newTaskTitle.isNotEmpty) {
                        Task newTask = Task(title: newTaskTitle);
                        Provider.of<TaskListModel>(context, listen: false).addTask(newTask);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Hinzufügen'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Neue Aufgabe hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }
}
