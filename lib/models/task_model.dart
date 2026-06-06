class Task {
  final String id;
  final String title;
  final String userId;
  final bool done;
  final DateTime? createdAt;
  Task(
      {required this.id,
      this.createdAt,
      required this.done,
      required this.title,
      required this.userId});

      // Firestore -> Task
      factory Task.fromFirestore(String id, Map<String , dynamic> data){
        return Task(id: 
        id,
         done: data['done'] ?? false, 
        title: data['title'] ?? '',
         userId: data['userId'] ?? '',
         createdAt: data['createdAt']?.toDate()

         );
      }
    // Task ->firestore
    Map<String, dynamic> toMap(){
      return{
        'title': title,
        'done': false,
        'userId': userId
      };
    }
}
