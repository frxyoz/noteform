import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/home_page.dart';

class SignupPage extends StatefulWidget{
  @override
  State createState() => _SignupPageState();
}



class _SignupPageState extends State<SignupPage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String eulaText = "";

  bool submitLock = false;

  void onPressSubmitButton() async{
    if(submitLock) {return;}
    submitLock = true;

    if (_formKey.currentState!.validate()){
      await loadEULAtext();
      await showEulaDialog();
    }
    submitLock = false;
  }

  void navigateToHomePage(){
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (builder) => HomePage()),
            (route) => false
    );
  }

  void signupToFirebase() async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      navigateToHomePage();

    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') { showSnackBar("The provided password is too weak."); }
      else if (e.code == 'email-already-in-use') { showSnackBar("That email is already in use."); }
      else if (e.code == 'invalidEmail') { showSnackBar("The provided email is invalid"); }
      else{
        print(e.code);
        showSnackBar("Error. Please try again later,");
      }
    }
  }

  Future<void> showEulaDialog() async{
    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
          title: const Text("End-User License Agreement (EULA)"),
          content: SingleChildScrollView(
            child: ListBody(
          children: [
            Text(eulaText),
        ],
      )
    ),
        actions: [
          ElevatedButton(
            onPressed: (){ Navigator.of(context).pop(); },
            child: const Text('Back'),
          ),
          ElevatedButton(
          onPressed: signupToFirebase,
          child: const Text('Agree'),
          ),

        ],
    );
        }
    );
  }

  Future<void> loadEULAtext() async{
    eulaText = await rootBundle.loadString('assets/eula.txt');
  }



  String? validateEmail(String? value){
    String pattern = r'.+@.+\..+';

    if(value == null || value.isEmpty){
      return "Please enter your Email";
    }
    else if ( ! RegExp(pattern).hasMatch(value) ){
      return "Please enter a valid Email";
    }
    return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty){
      return "Please enter your Password";
    }
    return null;
  }

  String? validateConfirmPassword(String? value){
    if(value != passwordController.text){
      return "Make sure your passwords match.";
    }
    return null;
  }

  void showSnackBar(String message){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.yellow,
            onPressed: (){ ScaffoldMessenger.of(context).hideCurrentSnackBar(); } ,
          ),
        )
    );
  }

  Form signUpForm(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              validator: validateEmail,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'user@example.com'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passwordController,
              validator: validatePassword,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Password'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: confirmPasswordController,
              validator: validateConfirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password'
              ),
            ),
          ),


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: onPressSubmitButton,
              child: const Text('Sign Up')
          ),
        ),

        ],
      ),
    );
  }

  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up')
      ),
      body: signUpForm(),
    );
  }
}