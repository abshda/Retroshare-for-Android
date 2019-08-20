import 'package:flutter/material.dart';

import 'package:retroshare/ui/splash_screen.dart';
import 'package:retroshare/ui/home/home_screen.dart';
import 'package:retroshare/ui/signin_screen.dart';
import 'package:retroshare/ui/signup_screen.dart';
import 'package:retroshare/ui/room/room_screen.dart';
import 'package:retroshare/ui/create_room_screen.dart';
import 'package:retroshare/ui/create_identity_screen.dart';
import 'package:retroshare/ui/launch_transition_screen.dart';
import 'package:retroshare/ui/change_identity_screen.dart';
import 'package:retroshare/ui/add_friend_screen.dart';
import 'package:retroshare/ui/discover_chats_screen.dart';
import 'package:retroshare/ui/search_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        if (args is bool)
          return MaterialPageRoute(
              builder: (_) => SplashScreen(isLoading: args));

        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/signin':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/launch_transition':
        return MaterialPageRoute(builder: (_) => LaunchTransitionScreen());
      case '/room':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => RoomScreen(
              isRoom: args['isRoom'],
              chat: args['chatData'],
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => RoomScreen());
      case '/create_room':
        return MaterialPageRoute(builder: (_) => CreateRoomScreen());
      case '/create_identity':
        if (args is bool)
          return MaterialPageRoute(
              builder: (_) => CreateIdentityScreen(isFirstId: args));

        return MaterialPageRoute(builder: (_) => CreateIdentityScreen());
      case '/change_identity':
        return MaterialPageRoute(builder: (_) => ChangeIdentityScreen());
      case '/add_friend':
        return MaterialPageRoute(builder: (_) => AddFriendScreen());
      case '/discover_chats':
        return MaterialPageRoute(builder: (_) => DiscoverChatsScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('Error'),
          ),
        );
      },
    );
  }
}
