import 'package:fitgame_app/Common/Widgets/BottomBar.dart';
import 'package:fitgame_app/Constant/GlobalVariable.dart';
import 'package:fitgame_app/Features/HabitTracker/HabitProvider.dart';
import 'package:fitgame_app/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HabitProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitGame - new',
      onGenerateRoute: (settings) => generateRoute(settings),
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: BottomBar(),
      // Provider.of<UserProvider>(context).user.token.isEmpty
      //     ? const BottomBar()
      //     : const AuthScreen(),
    );
  }
}
