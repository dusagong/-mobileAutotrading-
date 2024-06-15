import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName,inputData){
    print("Task exe :" + taskName);
    return Future.value(true);
  });
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}
class App extends StatefulWidget {
  const App({super.key});

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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Workmanager().registerOneOffTask("taskOne", "backUp");
        print("ho");
      }),
    );
  }
}
