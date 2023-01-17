// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_it/screen/home.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController task = TextEditingController();
  TextEditingController desc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    addTaskToFirebase() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final userid = user!.uid;
      var time = DateTime.now();
      await FirebaseFirestore.instance.collection('tasks').doc(userid).collection('mytasks').doc(time.toString()).set({
        'title': task.text,
        'description': desc.text,
        'time': time.toString(),
        'timeStamp':time
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Task'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: task,
                  decoration: InputDecoration(
                      hintText: 'Enter Task', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: desc,
                  decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.grey; //<-- SEE HERE
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        addTaskToFirebase();
                        final snackBar = SnackBar(content: Text('Task Added'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text('Add Task')),
                )
              ],
            ),
          ),
        ));
  }
}
