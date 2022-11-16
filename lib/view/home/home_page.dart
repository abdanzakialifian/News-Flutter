import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/api/api_service.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/view/home/article_list_page.dart';
import 'package:news_app/view/setting/setting_page.dart';
import 'package:news_app/common/style.dart';
import 'package:news_app/widgets/platform_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    /* Check target platform */
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  /* UI for Android */
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: (value) {
          setState(() {
            bottomNavIndex = value;
          });
        },
      ),
    );
  }

  /* UI for iOS */
  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: secondaryColor,
        items: _bottomNavBarItems,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.news), label: "Headline"),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.settings), label: "Settings")
  ];

  final List<Widget> _listWidget = [
    ChangeNotifierProvider(
      create: (context) => NewsProvider(
        apiService: ApiService(),
      ),
      child: const ArticleListPage(),
    ),
    const SettingPage()
  ];
}
