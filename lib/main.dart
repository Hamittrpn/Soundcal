import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soundcal/constants/color_constants.dart';
import 'package:soundcal/screens/listen_page.dart';
import 'package:soundcal/screens/profile_page.dart';
import 'package:soundcal/screens/search_page.dart';
import 'package:soundcal/widgets/search_bar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  final _tabs = [
    ListenPage(),
    SearchBar(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoundCal',
      theme: new ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(backgroundColor: kPrimaryColor, elevation: 0),
      ),
      home: Scaffold(
        body: _tabs[currentIndex],
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(() => currentIndex = index),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white24,
            backgroundColor: kSecondaryColor,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Icon(Icons.play_arrow ,size: 26,),
                ),
                label: 'Listen Now',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Icon(CupertinoIcons.search,size: 26,),
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Icon(CupertinoIcons.person_crop_circle, size: 26,),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
