import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piano/signup_page.dart';
import "home_page.dart";
import 'package:camera/camera.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void navigateToSignUpPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage())
    );
  }

  void navigateToHomePage(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route)=> false
    );
  }

  void login() async {
    try{
      String email = emailController.text;
      String password = passwordController.text;
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      navigateToHomePage();
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        showSnackBar('That Email is not registered');
      }
      else if(e.code == 'wrong-password'){
        showSnackBar("Wrong password.");
      }
      else{
        print(e.code);
        showSnackBar("Can't connect, please try again later.");
      }
    }
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

  void onPressedLoginButton() async {
    if (_formKey.currentState!.validate()) {
      login();
    }
  }

  Form loginForm(){
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Email Form Field
          TextFormField(
          controller: emailController,
          validator: validateEmail,
          decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'user@example.com'
          ),
          ),

            // Password Form Field
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom:8),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Login Button
                ElevatedButton(
                    onPressed: onPressedLoginButton,
                    child: const Text('Login')
                ),

                // Sign Up Button
                ElevatedButton(
                    onPressed: navigateToSignUpPage,
                    child: const Text('SignUp')
                ),

              ],
            )

          ],
        ),
      )
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: loginForm()
  );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text("Login"),
  //       ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           TextField(
  //             decoration: const InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 labelText: 'Input Username'
  //             ),
  //             onSubmitted: (String name) {
  //               username = name;
  //             },
  //           ),
  //           const SizedBox(height: 30),
  //           TextField(
  //             obscureText: true,
  //             decoration: const InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 labelText: 'Enter your password'
  //             ),
  //             onSubmitted: (String pass) {
  //               print("Password set!");
  //             },
  //           ),
  //         ElevatedButton(
  //           child: const Text("Submit"),
  //             onPressed: (){
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) =>  HomePage(title:"Home Page", value : username, camera: widget.camera))
  //               );
  //             }
  //         ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

