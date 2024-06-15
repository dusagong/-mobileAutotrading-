import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
<<<<<<< HEAD
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
=======
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
>>>>>>> 30a07ccf35cdacc468cf7323d7fe3db2a749c9c0
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}
<<<<<<< HEAD

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
=======
class App extends StatefulWidget {
  const App({super.key});

>>>>>>> 30a07ccf35cdacc468cf7323d7fe3db2a749c9c0
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    SizedBox(),
    SizedBox(),
  ];

  void _onItemTapped(int index) { // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // bottom navigation 선언
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            label: 'KOR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'US',
          ),
        ],
        currentIndex: _selectedIndex, // 지정 인덱스로 이동
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped, // 선언했던 onItemTapped
      ),
    );
  }
}