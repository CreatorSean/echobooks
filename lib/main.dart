import 'package:echobooks/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: const Color(0xFFE3DACD),
        textTheme: const TextTheme(
          headline1: TextStyle(color: Color(0xFF3D705A)),
          headline2: TextStyle(color: Color(0xFF825E4C)),
        ),
        cardColor: const Color(0xFFFFFDFC),
      ),
      home: const HomeScreen(),
      // home: const DbTestScreen(),
    );
  }
}
