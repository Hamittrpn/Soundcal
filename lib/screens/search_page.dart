import 'package:flutter/material.dart';
import 'package:soundcal/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SearchBar(),
        ),
        Text("Asdsdasdasdasd"),
      ],
    ));
  }
}
