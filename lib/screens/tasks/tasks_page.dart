import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskflow_di2/models/task_model.dart';
import 'package:taskflow_di2/services/tasks/task_service.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({ Key? key }) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _taskService=TaskService();
  final _controller = TextEditingController();
  final _user=FirebaseAuth.instance.currentUser;
  static const indigo = Color(0xFF4F46E5);
   static const indigoLight = Color(0xFFEEF2FF);
   static const textPrimary = Color(0xFF111827);
   static const textSecondary = Color(0xFF6B7280);
   static const borderColor = Color(0xFFE5E7EB);
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  // function ajouter task
  Future <void> _addTask() async{
    final title=_controller.text.trim();
    if(title.isEmpty) return;
    await _taskService.addTask(title, _user!.uid);
    _controller.clear();
  }
  Future <void> _showEditDialog( Task task ) async{
    final editController = TextEditingController(text: task.title);
    await showDialog(
      context: context,
       builder: (context)=>AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        title: const Text('Modifier la tache', 
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary
        ),
        ),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Titre de la tache',
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color:borderColor)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: indigo, width: 1.5)
            )
            )
          ),
          actions: [
            TextButton(
              onPressed: ()=> Navigator.pop(context) , 
              child: const Text('Annuler', style: TextStyle(color: textSecondary),)
              ),
              ElevatedButton(
                onPressed: () async{
                  final newTitle=editController.text.trim();
                  if(newTitle.isNotEmpty){
                    await _taskService.updateTitle(task.id, newTitle);

                  }
                  if(context.mounted) Navigator.pop(context);
                }, 
                child: const Text('Modifier')
                )
          ],
        ),


       
       );
       editController.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text
        ('Mes Taches',
         style:TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 18)
         ),
      ),
      body: Column(
        // champ a ajouter
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: borderColor))
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:_controller,
                    onSubmitted: (_)=> _addTask(),
                    style: const TextStyle(fontSize: 14, color: textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Nouvelle tache...',
                      hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
                      filled: true,
                      fillColor: const Color (0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: borderColor),

                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: borderColor)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:  BorderRadius.circular(10),
                        borderSide: const BorderSide(color: indigo, width: 1.5)
                      )
                    ),
                  )
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    height: 46,
                    width: 46,
                    child: ElevatedButton(onPressed: _addTask, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: indigo,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: const Icon(Icons.add, size:22)
                    ),
                  )

              ],
            ),
          ),
          // liste des tache en temps reel
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.getTasklsStream(_user!.uid),
               builder:(context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(color: indigo));
                }
                if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: indigoLight,
                            borderRadius: BorderRadius.circular(20),

                          ),
                          child: const Icon(Icons.check_circle_outline, size: 36, color: indigo),
                      
                        ),
                        const SizedBox(height: 16,),
                        const Text('Aucune Tache pour le moment',
                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary,)
                         ), 
                         const SizedBox(height: 4
                         ),
                         const Text('Ajouter votre premiere tache ci-dessus', style: TextStyle(fontSize: 13, color: textSecondary),)
                      ],
                    )
                  );
                }
                final tasks=snapshot.data!;
                final pending=tasks.where((t)=>!t.done).toList();
                final done= tasks.where((t)=>t.done).toList();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // en cours
                    if(pending.isNotEmpty) ...[
                      _sectionLabel('En cours', pending.length),
                      const SizedBox(height: 8,),
                       ...pending.map((task)=>_task)
                    ]
                  ],

                );

               }
               )
            )

        ],
      ),
      
    );
  }

Widget _sectionLabel(String label, int count){
  return Row(
    children: [
      Text(
        label, 
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600, color: textSecondary
        ) ,
        ),
        const SizedBox(width: 8,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 12, color: textSecondary),
          ),
        )
    ],
  );
}
Widget _taskCard(Task task){
  
}
}
