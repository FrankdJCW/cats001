import 'package:cats001/pages/activity_feed.dart';
import 'package:cats001/pages/create_account.dart';
import 'package:cats001/pages/profile.dart';
import 'package:cats001/pages/search.dart';
import 'package:cats001/pages/timeline.dart';
import 'package:cats001/pages/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Required for google sign in
final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final DateTime timestamp = DateTime.now();

//Creates home page
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false; //If its true, then the account its logged in
  late PageController pageController; //used to go from page to page on home
  int pageIndex = 0; //current page

  @override
  void initState() {
    super.initState();
    pageController = PageController(); //creates the page controller
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    //This checks if the user is already logged in from a previous session,
    //if they are, then it auto-logs in
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

//This method checks if the account is logged in (currently only google accounts)
  handleSignIn(GoogleSignInAccount? account) {
    if (account != null) {
      createUser();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUser() async {
    //Get current user's data
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    final DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    //If user does not exist
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      //create their account
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
    }
  }

  //This disposes of the page controller
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //login (currently only google)
  login() {
    googleSignIn.signIn();
  }

  //logoug (currently only google)
  logout() {
    googleSignIn.signOut();
  }

  //changes page index
  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  //jumps to pages based on the page index
  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

//This is the main Home Screen
  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          //This button is for testing only, it will be replaced
          //by the Search button eventually
          ElevatedButton(onPressed: logout, child: Text('logout')),
          //Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 45.0,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

//This is the screen when the user isn't logged in
  Scaffold buildUnAuthScreen() {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'FIU Animals',
                  style: TextStyle(
                    fontFamily: "Signatra",
                    fontSize: 90.0,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: login,
                  child: Container(
                    width: 260.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/google_signin_button.png'),
                            fit: BoxFit.cover)),
                  ),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    //if ithe user is logged in sends them to the home page, else to the login page
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
