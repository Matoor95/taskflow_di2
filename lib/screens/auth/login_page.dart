import 'package:flutter/material.dart';
import 'package:taskflow_di2/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey=GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController=TextEditingController();
  final _authService=AuthService();
  bool _loading=false;
  @override
  // dispose permet de nettoyer les resource , il est essentiel a la gestioon de la memoire 
  void dispose (){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    
  }

  Future <void> _login() async {
    if(!_formKey.currentState!.validate()) return ;
    setState(()=>_loading=true);
    final error=await _authService.login(
      email:_emailController.text,
      password:_passwordController.text,
    );
    //si le widget n'est plus dansd l'arbre 
    if(!mounted) return ;
    setState(()=>_loading=false);
    if(error != null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(error), backgroundColor:const Color (0xFFEF4444)),
      );

    }

  }
 
  Future <void> _forgotPassword() async{
    if(_emailController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entrez votre email d\'abord"))
      );
      return;

    }
    final error= await _authService.sendPasswordReset(_emailController.text);
    if(!mounted) return ;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Email de renitialisation envoye'),
        backgroundColor: error != null ? const Color(0xFFEF4444) : const Color(0xFFfE444),
        )
    );
  }
  Widget build(BuildContext context) {
 const indigo = Color(0xFF4F46E5);
    const indigoLight = Color(0xFFEEF2FF);
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);
        return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // logo
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: indigoLight,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: const Icon(Icons.bolt_rounded, size: 36, color: indigo),
                  )
                ],
              )
              ),

          ),

        )
        )
        ,

    );
  }
}