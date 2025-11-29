class GameModel {
  String? teamName1;
  String? teamName2;
  int? pass;
  int? time;
  int? point;

  GameModel({
    this.teamName1,
    this.teamName2,
    this.pass,
    this.time,
    this.point,
  });

  Map<String, dynamic> toJson() => {
        'teamName1': teamName1,
        'teamName2': teamName2,
        'pass': pass,
        'time': time,
        'point': point,
      };

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        teamName1: json['teamName1'] as String?,
        teamName2: json['teamName2'] as String?,
        pass: json['pass'] as int?,
        time: json['time'] as int?,
        point: json['point'] as int?,
      );
}
