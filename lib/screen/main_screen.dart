import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

import 'game_player_screen.dart';
import '../domain/text_game.dart';
import 'widget/text_game_widget.dart';

class QuesterFlutter extends StatefulWidget {
  const QuesterFlutter({super.key});

  @override
  QuesterFlutterState createState() => QuesterFlutterState();
}

class QuesterFlutterState extends State<QuesterFlutter> {
  static const int _pageSize = 10;

  final List<TextGame> textGames = [];

  final PagingController<int, TextGame> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchTextGamesPage(pageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quester-Flutter',
        initialRoute: '/',
        routes: {
          '/home': (context) => const QuesterFlutter(),
          '/game-player': (context) {
            final gameNode =
                ModalRoute.of(context)!.settings.arguments as GameNode;

            return GamePlayerScreen(gameNode: gameNode);
          },
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Text("Quester-Flutter"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PagedMasonryGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const AlwaysScrollableScrollPhysics(),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                    itemBuilder: (context, item, index) => Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/game-player',
                                  arguments: item.rootNode);
                            },
                            child: TextGameWidget(textGame: item),
                          ),
                        )),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchTextGamesPage(int pageKey) async {
    try {
      final List<TextGame> newTextGames = await getTextGamesFromServer(pageKey);
      final bool isLastPage = newTextGames.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newTextGames);
      } else {
        final nextPageKey = ++pageKey;

        _pagingController.appendPage(newTextGames, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<TextGame>> getTextGamesFromServer(int pageKey) async {
    final Response serverResponse = await http
        .get(Uri.parse('http://localhost:8080/api/games?page=$pageKey'));

    if (serverResponse.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    final List<TextGame> textGamesList = jsonDecode(serverResponse.body)
        .map((jsonTextGame) => TextGame.fromJson(jsonTextGame))
        .whereType<TextGame>()
        .toList();

    return textGamesList;
  }
}
