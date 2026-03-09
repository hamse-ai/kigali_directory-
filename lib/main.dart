import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart'; // <--- MAKE SURE THIS LINE EXISTS
import 'firebase_options.dart';
import 'screens/main_navigation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      // Changed 'MyApp' to 'KigaliDirectoryApp' to match our logic
      child: const KigaliDirectoryApp(), 
    ),
  );
}

class KigaliDirectoryApp extends StatelessWidget {
  const KigaliDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: hides the debug banner
      title: 'Kigali Directory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}



class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // This StreamBuilder listens to the Firebase User state
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        

          // ... inside your AuthWrapper or StreamBuilder ...
          if (snapshot.hasData) {
            // Instead of returning a Scaffold with a Logout button, return the new shell
            return const MainNavigation(); 
          } else {
            return const AuthScreen();
          }
                  
      },
    );
  }
}