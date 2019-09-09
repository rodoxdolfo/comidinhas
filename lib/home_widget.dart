import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'news_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    News(),
    PlaceholderWidget(Colors.yellow),
    PlaceholderWidget(Colors.green)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comidinhas', style: TextStyle(color: Colors.white))
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Notícias'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.category),
            title: new Text('Menu'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.perm_device_information),
            title: new Text('Informações'),
          )
        ],
      ),
    );
  }
}