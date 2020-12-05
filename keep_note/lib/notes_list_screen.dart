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
  
  _deleteNote(Task task){
    print('deleteTask called');
    DatabaseHelper.instance.deleteTask(task);
    _updateTaskList();
  }

  _updateTaskList(){
    print('updatetaskList called...');
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task) {
    print(' buildtask called...');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          ListTile(
            title: Text(task.title, style: TextStyle(color: Colors.white70, fontSize: 18.0),),
            subtitle: Text(task.content + '\n${_dateFormatter.format(task.date)}',style: TextStyle(color: Colors.white70, fontSize: 15.0),),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.white70,),
              onPressed: () { 
                _deleteNote(task);
              },),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen(
            updateTaskList: _updateTaskList,
            task: task,))),
          ),

          Divider(color: Colors.white70,),
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
