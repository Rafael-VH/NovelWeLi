import 'package:flutter/material.dart';
import 'package:novel_we_li/features/presentation/screens/detail/novel_detail_screen.dart';
import 'package:novel_we_li/features/presentation/screens/home/home_screen.dart';
import 'package:novel_we_li/features/presentation/screens/library/library_screen.dart';
import 'package:novel_we_li/features/presentation/screens/reader/reader_screen.dart';
import 'package:novel_we_li/features/presentation/screens/search/search_screen.dart';
import 'package:novel_we_li/features/presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String library = '/library-screen';
  static const String splash = '/splash-screen';
  static const String search = '/search-screen';
  static const String novelDetail = '/novel-detail-screen';
  static const String home = '/home-screen';
  static const String reader = '/reader-screen';
  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    library: (context) => const LibraryScreen(),
    splash: (context) => const SplashScreen(),
    search: (context) => const SearchScreen(),
    novelDetail: (context) => const NovelDetailScreen(),
    home: (context) => const HomeScreen(),
    reader: (context) => const ReaderScreen(),
    };
  }
