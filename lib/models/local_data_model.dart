final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String byColumn = "byColumn";


class LocalData {

  int id;
  String title;
  String by;


  LocalData();

  LocalData.fromMap(Map map){
    id = map[idColumn];
    title = map[titleColumn];
    by = map[byColumn];

  }

  Map toMap() {
    Map<String, dynamic> map = {
      titleColumn: title,
      byColumn: by,
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $title, email: $by)";
  }

}