

class Task{
  int id;
  String title;
  DateTime date;
  String content;
  // int status; //0 - incomplete, 1 - incomplete

  Task({this.title, this.date, this.content});
  Task.withId({this.id, this.title, this.date, this.content});

  //To map Task object to Map
  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();

    if(id != null){
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['content'] = content;
    // map['status'] = status;


    return map;
}

  //To get Task object back from database which is mapped

  factory Task.fromMap(Map<String, dynamic> map){
    return Task.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      content: map['content'],
      // status: map['status'],
    );
  }
}