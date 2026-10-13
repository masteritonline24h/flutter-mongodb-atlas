import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/about_screen.dart';
import 'views/screens/contact_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter MVC Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: authController.checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final AuthController _authController = AuthController();

  final List<Widget> _pages = const [
    HomeScreen(),
    AboutScreen(),
    ContactScreen(),
  ];

  void _onLogout() async {
    await _authController.handleLogout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication with MongoDB'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'ចាកចេញ',
            onPressed: _onLogout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ទំព័រដើម'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'អំពីយើង'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: 'ទំនាក់ទំនង'),
        ],
      ),
    );
  }
}