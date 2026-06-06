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
  }
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}