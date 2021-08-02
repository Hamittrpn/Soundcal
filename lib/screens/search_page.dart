import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:soundcal/constants/color_constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const historyLength = 5;
  List<String> _searchHistory = ['fushia', 'flutter', 'widgets', 'soundcal'];
  List<String> filteredSearchHistory;
  String selectedTerm;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: controller,
      body: FloatingSearchBarScrollNotifier(
        child: SearchResultsListView(
          searchTerm: selectedTerm,
        ),
      ),
      transition: CircularFloatingSearchBarTransition(),
      physics: BouncingScrollPhysics(),
      title: Text(
        selectedTerm ?? 'The Search App',
        style: TextStyle(fontSize: 14, color: Color(0xFFFD4C3CA)),
      ),
      hint: 'Search and find out...',
      backgroundColor: Color(0xFFFF2D9E4),
      elevation: 0,
      iconColor: Color(0xFFFD4C3CA),
      hintStyle: TextStyle(
        fontSize: 14,
      ),
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHistory = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          addSearchTerm(query);
          selectedTerm = query;
        });
        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Color(0xFFFF2D9E4),
            elevation: 4,
            child: Builder(
              builder: (context) {
                if (filteredSearchHistory.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Start searching",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                } else if (filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        addSearchTerm(controller.query);
                        selectedTerm = controller.query;
                      });
                      controller.close();
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHistory
                        .map(
                          (term) => ListTile(
                            title: Text(
                              term,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: const Icon(Icons.history),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  deleteSearchTerm(term);
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                putSearchTermFirst(term);
                                selectedTerm = term;
                              });
                              controller.close();
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  const SearchResultsListView({Key key, @required this.searchTerm})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    if (searchTerm == null) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: fsb.widget.height * 2, left: 10, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Featured Smart Scans",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'lib/assets/Images/hiphop1.jpeg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Hip Hop",
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'lib/assets/Images/jazz.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Jazz",
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'lib/assets/Images/rock3.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Rock",
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'lib/assets/Images/blues.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Blues",
                                style: TextStyle(
                                    color: kSecondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Radio Stations by Genre",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: ListTile.divideTiles(context: context, tiles: [
                      ListTile(
                        title: Text(
                          "Alternative",
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Rock",
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Blues",
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Jazz",
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ]).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (searchTerm == null || searchTerm.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
          ],
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: fsb.widget.height * 1.5),
      children: List.generate(
        50,
        (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
        ),
      ),
    );
  }
}
