import 'package:fitgame_app/Features/Daily/dailyScreen.dart';
import 'package:fitgame_app/Features/HabitTracker/HabitTrackerScreen.dart';
import 'package:fitgame_app/Features/Home/HomeScreen.dart';
import 'package:fitgame_app/Features/Profile/ProfileScreen.dart';
import 'package:fitgame_app/Features/ProgressTracker/ProgressScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitgame_app/Constant/GlobalVariable.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  final List<Widget> pages = [
    const HomeScreen(), //0
    // const DailyScreen(), //1
    const HabitTrackerScreen(),
    const ProgressScreen(), //2
    const ProfileScreen(), //3
  ];
  void updatedPage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        // backgroundColor: Color.fromARGB(
        //   255,
        //   56,
        //   23,
        //   23,
        // ), // Set your desired color
        iconSize: 25,
        onTap: updatedPage,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 0
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    // : Colors.red,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.home),
            ),
          ),

          BottomNavigationBarItem(
            label: "Daily",
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 1
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.calendar_month_outlined),
            ),
          ),

          BottomNavigationBarItem(
            label: "Progress",
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.bar_chart_outlined),
            ),
          ),

          BottomNavigationBarItem(
            label: "Profile",
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 3
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.account_circle_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
