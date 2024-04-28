import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> categories = [
    'All categories',
    'Hotels',
    'Restaurants',
    'Places',
    'Bars',
  ];
  final List<Map<String, String>> recentSearches = [];
  final List<Map<String, String>> trendingSearches = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Mise à jour de l'interface utilisateur à chaque changement de texte
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                labelText:
                    _searchController.text.isEmpty && !_focusNode.hasFocus
                        ? 'Search for hotels, places, bars...'
                        : '',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            // Widget pour les catégories avec SingleChildScrollView
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((category) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            child: Text(category),
                            onPressed: () {
                              // Ajoutez votre logique de filtre ici
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200], // background
                              foregroundColor: Colors.black, // foreground
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            // Vérifier si les listes de recherches récentes et tendances contiennent des éléments
            if (recentSearches.isNotEmpty)
              ...buildSearchList('Recent searches', recentSearches),
            if (trendingSearches.isNotEmpty)
              ...buildSearchList('Trending searches', trendingSearches),
          ],
        ),
      ),
    );
  }

  List<Widget> buildSearchList(
      String title, List<Map<String, String>> searches) {
    return [
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ...searches
          .map((search) => ListTile(
                leading: Icon(Icons.history),
                title: Text(search['title']!),
                subtitle: Text(search['subtitle']!),
              ))
          .toList(),
    ];
  }
}
