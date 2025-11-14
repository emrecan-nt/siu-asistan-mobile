import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const SiUAsistanApp());
}

class SiUAsistanApp extends StatelessWidget {
  const SiUAsistanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SİÜ Asistan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF003D82), // Siirt Uni mavi
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003D82),
          primary: const Color(0xFF003D82),
          secondary: const Color(0xFF0066CC),
          tertiary: const Color(0xFF4A90E2),
          background: const Color(0xFFF5F7FA),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003D82),
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}