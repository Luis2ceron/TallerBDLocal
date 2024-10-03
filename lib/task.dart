class Task {
  int? id;          // Identificador único de la tarea
  String title;    // Título o descripción de la tarea
  bool isDone;     // Estado de la tarea (completada o no)

  Task({
    this.id,
    required this.title,
    this.isDone = false,
  });

  // Convierte una instancia de Task a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,                     // ID de la tarea, puede ser null si es nueva
      'title': title,               // Título de la tarea
      'isDone': isDone ? 1 : 0,     // Convertir booleano a entero (1 o 0)
    };
  }

  // Crea una instancia de Task a partir de un Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],                // Extraer ID del Map
      title: map['title'],          // Extraer título del Map
      isDone: map['isDone'] == 1,   // Convertir entero a booleano
    );
  }
}
