import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/routes.dart';
import 'package:gecoory_web_panel/constants/theme_data.dart';
import 'package:gecoory_web_panel/controllers/menu_controller.dart';
import 'package:gecoory_web_panel/screens/main/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/dark_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDstXN1cL6t99jFawjQOOL8OzKCVUg_R_Q",
      appId: "1:750800242395:web:18dd21bb39725e64386efe",
      messagingSenderId: "750800242395",
      projectId: "flutter-grocery-app-fg",
      storageBucket: "flutter-grocery-app-fg.appspot.com"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('App is being initialized'),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('An error has been occured ${snapshot.error}'),
                ),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MenuControllerClass(),
            ),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Grocery',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                initialRoute: HomeScreen.routeName,
                routes: routes,
              );
            },
          ),
        );
      },
    );
  }
}
