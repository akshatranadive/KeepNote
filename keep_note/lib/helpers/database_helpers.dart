import 'dart:io';

import 'package:keep_note/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';


class DatabaseHelper{
    static final DatabaseHelper instance = DatabaseHelper._instance();
    static Database _db;

    //constructor call for initialising instance

    DatabaseHelper._instance();

    String tasksTable = 'task_table';
    String colId = 'id';
    String colTitle = 'title';
    String colDate = 'date';
    String colContent = 'content';
    // String colStatus = 'status';

    //Task Tables
    //Id | Title | Date | Content | Status
    // 0 |  ''   |  ''  |    ''   |   0
    // 1 |  ''   |  ''  |    ''   |   0
    // 2 |  ''   |  ''  |    ''   |   0

    Future<Database> get db async {
    if (_db == null){
    _db = await _initDb();

    }
    return _db;
    }

    Future<Database> _initDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'tasks_list.db';
    final tasksListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return tasksListDb;

    }

    //creating table in database
    void _createDb(Database db, int version) async{
    await db.execute('CREATE TABLE $tasksTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colContent TEXT)',
    );

    }


    //Querying to map rows in tables
    Future<List<Map<String, dynamic>>> getTaskMapList() async{
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
    //this returns all rows in task tables as map

    }

    //the above maps converted to task objects
    Future<List<Task>> getTaskList() async{
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap){
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
    }

    //inserting tasks/notes in database
    Future<int> insertTask(Task task) async{
        Database db = await this.db;
        final int result = await db.insert(tasksTable, task.toMap());
        return result;
    }

    //for updating task/notes
    Future<int> updateTask(Task task) async{
        Database db = await this.db;
        final int result = await db.update(
            tasksTable,
            task.toMap(),
        where: '$colId = ?',
        whereArgs: [task.id],
        );

        return result;
    }

    Future<int> deleteTask(Task task) async{
        Database db = await this.db;
        final int result = await db.delete(
            tasksTable,
            where: '$colId=?',
            whereArgs: [task.id],
        );

        return result;
    }


}


