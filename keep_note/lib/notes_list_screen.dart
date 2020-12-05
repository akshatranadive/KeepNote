import 'package:flutter/material.dart';
import 'package:keep_note/add_task_screen.dart';
import 'package:intl/intl.dart';
import 'helpers/database_helpers.dart';
import 'models/task_model.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('dd MMM, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList(){
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          ListTile(
            title: Text(task.title, style: TextStyle(color: Colors.white70, fontSize: 18.0),),
            subtitle: Text('${_dateFormatter.format(task.date)}'+ task.content,style: TextStyle(color: Colors.white70, fontSize: 15.0),),
            trailing: Icon(Icons.delete_outline_outlined, color: Colors.white70,),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(
            updateTaskList: _updateTaskList,
            task: task,))),
          ),

          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(updateTaskList: _updateTaskList,))),
      ),

      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {

          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(

              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40.0, horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Notes",
                          style: TextStyle(color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 40,),),

                      ],

                    ),
                  );
                }
                return _buildTask(snapshot.data[index - 1]);
              },);
        },
      ),
    );
  }
}
