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

  SingleProtein({this.date, this.number, this.text});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'number': number,
      'text': text,
    };
  }
}