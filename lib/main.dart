import 'package:flutter/material.dart';
import 'package:trade_app/API/Kor/api.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // String accessToken = await getAccessToken() ?? '';
  String accessToken = 'hi';
  getCollection();
  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String accessToken;

  const MyApp({super.key,required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:FutureBuilder(
        future: algorithm(accessToken),  // Call your asynchronous function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Once the future completes successfully, navigate to home screen
            return const App();
          }
        },
      )
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
    print(index);
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