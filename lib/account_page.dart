import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import "home_page.dart";
import 'package:camera/camera.dart';
import "login_page.dart";
import "python_test.dart";

class AccountPage extends StatefulWidget {

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  void signout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false);
  }

  void deleteUser() async{
    await FirebaseAuth.instance.currentUser!.delete();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
  }

  void showDeleteDialogue() async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Delete your account?"),
            content: const Text("Deleting your account cannot be undone. Are you sure?"),
            actions: [
              ElevatedButton(
                  onPressed: (){Navigator.of(context).pop();},
                  child: const Text("Cancel")
              ),
              ElevatedButton(
                  onPressed: deleteUser,
                  child: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
              ),
            ]
          );
        }
    );
  }

  Widget navBar(){
    return                 Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:
      [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ElevatedButton(
            child: const Text("Home"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage())
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ElevatedButton(
            child: const Text("Discover"),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black45),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) =>
              //         python_test(title: "Discover", value: widget.value, camera: widget.camera))
              // );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ElevatedButton(
            child: const Text("Account"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      AccountPage())
              );
            },
          ),
        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Account"),
        ),
        body: Container(
            // alignment: Alignment.bottomCenter,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // padding: const EdgeInsets.fromLTRB(0,0,0,500),
                  child: Column(

                        children:[
                          Icon(
                            Icons.account_circle,
                            size: 250
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 25, right: 10, bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Text("Email: ", style: Theme.of(context).textTheme.bodyMedium),
                                Text(FirebaseAuth.instance.currentUser!.email!, style: Theme.of(context).textTheme.bodyMedium)
                              ],
                            ),
                          ),
                        ElevatedButton(
                        child: const Text("Log Out"),
                        onPressed: signout),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            child: const Text("Delete Account"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                ),
                                onPressed: showDeleteDialogue),
                        ),
                        ]
                  ),
            ),
        ]
    )
    ));
  }
}

