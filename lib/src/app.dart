import 'package:flutter/material.dart';
import 'package:movie_app/src/repositories/home_page_repository.dart';
import 'package:movie_app/src/ui/video_player/video_player.dart';
import 'blocs/home/bloc.dart';
import 'tab_navigator.dart';
import 'bottom_navigation.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentTab = TabType.home;
  final navigatorKey = GlobalKey<NavigatorState>();
  HomeBloc _homeBloc;

  /// keys for each tab
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    TabType.home: GlobalKey<NavigatorState>(),
    TabType.browse: GlobalKey<NavigatorState>(),
    TabType.search: GlobalKey<NavigatorState>()
  };

  @override
  void initState() {
    super.initState();
    HomePageRepository repo = HomePageRepository();
    _homeBloc = HomeBloc(homeRepository: repo);
    _homeBloc.dispatch(FetchHomePage());
  }

  void _tabBarItemOnTap(int index) {
    setState(() {
      this._currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          fontFamily: 'Vaud',
          brightness: Brightness.dark,
          primaryColor: Color(0xff26262d),
          backgroundColor: Color(0xff26262d)),
      home: Scaffold(
          backgroundColor: Color(0xff26262d),
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(TabType.home),
              _buildOffstageNavigator(TabType.browse),
              _buildOffstageNavigator(TabType.search),
            ],
          ),
          bottomNavigationBar: BottomNavigation(
            currentTab: _currentTab,
            onSelectedTab: _tabBarItemOnTap,
          )),
      onGenerateRoute: (routeSettings) {
        final VideoPlayerPageArguments args = routeSettings.arguments;
        return MaterialPageRoute(
            fullscreenDialog: true,
            settings: routeSettings,
            builder: (context) {
              return VideoPlayerPage(movie: args.movie, url: args.url);
            });
      },
    );
  }

  Widget _buildOffstageNavigator(int tab) {
    return Offstage(
        offstage: _currentTab != tab,
        child: TabNavigator(
          homeBloc: _homeBloc,
          navigatorKey: navigatorKeys[tab],
          currentTab: tab,
        ));
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }
}
