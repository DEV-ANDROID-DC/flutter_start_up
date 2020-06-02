import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Flutter",
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordState extends State<RandomWords> {
  final List<WordPair> _suggections = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StartUp Name Generator'),
        actions : <Widget> [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ]
      ),

      body: _buildSuggections(),
    );
  }

  Widget _buildSuggections() {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemBuilder: (BuildContext, int iterator) {
          if (iterator.isOdd) {
            return Divider();
          }
          final int index = iterator ~/ 2;
          if (index >= _suggections.length) {
            _suggections.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggections[index]);
        });
  }

  Widget _buildRow(WordPair wordPair) {
    final bool alreadySaved = _saved.contains(wordPair);
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon (
        alreadySaved ?  Icons.favorite : Icons.favorite_border,
        color: alreadySaved ?  Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }


  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                  (WordPair wordPair) {
                return ListTile(
                  title: Text(
                    wordPair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          final List<Widget> list = ListTile.divideTiles(
              context: context, tiles: tiles).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Favourate Suggections"),
            ),
            body: ListView(children: list),
          );
        },
      ),
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordState();
}
