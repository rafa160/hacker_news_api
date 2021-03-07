import 'dart:convert';

class StoriesModel {
   int id;
   bool deleted;
   String type;
   String by;
   int time;
   String text;
   bool dead;
   int parent;
   List<dynamic> kids;
   String url;
   int score;
   String title;
   int descendants;


   StoriesModel({
      this.id,
      this.deleted,
      this.type,
      this.by,
      this.time,
      this.text,
      this.dead,
      this.parent,
      this.kids,
      this.url,
      this.score,
      this.title,
      this.descendants});

   StoriesModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'] ?? false,
        type = parsedJson['type'],
        by = parsedJson['by'] ?? '',
        time = parsedJson['time'],
        text = parsedJson['text'] ?? '',
        dead = parsedJson['dead'] ?? false,
        parent = parsedJson['parent'],
        kids = parsedJson['kids'] ?? [],
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'] ?? 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'by': by,
      'time': time,
      'text': text,
      'parent': parent,
      'url': url,
      'score': score,
      'title': title,
      'descendants': descendants,
      'deleted': deleted ? 1 : 0,
      'dead': dead ? 1 : 0,
      'kids': jsonEncode(kids),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'by': by,
    };
  }
}