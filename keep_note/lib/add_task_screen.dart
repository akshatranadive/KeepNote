import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_note/helpers/database_helpers.dart';
import 'notes_list_screen.dart';

import 'models/task_model.dart';


class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;

   final Task task;

  // const AddTaskScreen({Key key, this.updateTaskList, this.task}) : super(key: key);
   AddTaskScreen({this.task, this.updateTaskList});

  // const AddTaskScreen({Key key, this.task, this.updateTaskList}) : super(key: key);


  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {



  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('dd MMM, yyyy');



  @override
  initState() {
    super.initState();

    if(widget.task != null){
      _title = widget.task.title;
      _date = widget.task.date;
      _content = widget.task.content;
    }
    // Add listeners to this class
    _dateController.text = _dateFormatter.format(_date);
  }

  _handleDatePicker() async{
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );

      if (date != null && date != _date) {
        setState(() {
          _date = date;
        });
        _dateController.text = _dateFormatter.format(_date);
      }


  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _submit(){
        if(_formKey.currentState.validate()){
          _formKey.currentState.save();

          print('$_title, $_date, $_content');

          Task task = Task(title: _title, date: _date, content: _content);
          // if(task==null){
          //   task.status = 0;
          // }
          // else{
          //   task.status = widget.task.status;
          //   DatabaseHelper.instance.updateTask(task);
          // }


          // print('$itemcount');
          // ignore: unnecessary_statements
          widget.updateTaskList;
          Navigator.pop(context);
        }


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(

            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),


            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, size: 30.0, color: Theme.of(context).primaryColor,),


                ),

                SizedBox(height: 20.0,),

                Text("Add Note",
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 30,),),
                  SizedBox(height: 10.0,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),

                        child: TextFormField(

                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(color: Colors.blue, width: 0.0),
                              ),
                            labelText: 'Title',
                            labelStyle: TextStyle(fontSize: 18.0, color: Colors.blue),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                          ),
                          validator: (input) =>
                          input.trim().isEmpty ? 'Please enter a note title' : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          readOnly: true,

                          controller: _dateController,
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(color: Colors.blue, width: 0.0),
                              ),
                              labelText: 'Date',
                              labelStyle: TextStyle(fontSize: 18.0, color: Colors.blue),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                // width: 0.0 produces a thin "hairline" border
                                borderSide: BorderSide(color: Colors.blue, width: 0.0),
                              ),
                              labelText: 'Content',
                              labelStyle: TextStyle(fontSize: 18.0, color: Colors.blue),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          validator: (input) =>
                          input.trim().isEmpty ? 'Please enter a note title' : null,
                          onSaved: (input) => _content = input,
                          initialValue: _content,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),

                        ),
                        child: FlatButton(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                            ),
                          ),

                          onPressed: _submit,

                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
