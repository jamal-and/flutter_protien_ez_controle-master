class Protein {
  final String date;
  final int weight;
  final int protein;
  final int isDone;

  Protein({this.date, this.weight, this.protein,this.isDone});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'weight': weight,
      'protein': protein,
      'done':isDone,
    };
  }
}
class SingleProtein {
  final String date;
  final int number;
  final String text;
  final String hour;

  SingleProtein({this.date, this.number, this.text,this.hour});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'number': number,
      'text': text,
      'hour':hour
    };
  }
}

class Meal {
  final String name;
  final int protein;
  final String description;
  final String color;
  final int id;

  Meal({this.name, this.protein, this.description,this.color,this.id});


  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'protein': protein,
      'description': description,
      'color':color
    };
  }
}