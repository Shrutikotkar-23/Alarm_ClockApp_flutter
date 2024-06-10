// class AlarmInfo{
//   final DateTime alarmDateTime;
//   final String? decsription;
//   final bool?  isActive;

//    AlarmInfo(this.alarmDateTime ,{this.decsription   ,this.isActive});

  

// }
class AlarmInfo {
  int ?id;
  String? title;
  DateTime? alarmDateTime;
  bool? isPending;


  AlarmInfo(  
      {
        this.alarmDateTime,
      this.id,
      this.title,
      this.isPending,
      });

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        isPending: json["isPending"],
        
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "isPending": isPending,
        
      };
}