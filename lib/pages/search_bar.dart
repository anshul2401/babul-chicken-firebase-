import 'package:babul_chicken_firebase/main.dart';
import 'package:babul_chicken_firebase/pages/user_details.dart';
import 'package:babul_chicken_firebase/providers/user.dart';
import 'package:babul_chicken_firebase/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListSearch extends StatefulWidget {
  const ListSearch({Key key}) : super(key: key);

  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {
  final TextEditingController _textController = TextEditingController();

  static List<String> mainDataList = [
    'Bharhut nagar',
    'Mukhtiyar Ganj',
    'Civil Line',
    'Pannilal Chowk',
    'Jeevan Jyoti colony',
    'Mandakini Vihar Colony',
    'Rajendra Nagar',
    'Jawahar Nagar',
    'Umri',
    'Sangram Colony',
    'Jagat Dev Talab',
    'Raghuraj Nagar',
    'Gaushala Chowk',
    'Bhandavgarh colony',
    'Pateri',
    'Peptech city',
    'Sindhi camp',
    'Dhawari',
    'Dalibaba',
    'Kothwali',
    'Nazirabad',
    'Transport nagar',
    'Birla colony',
    'Bagha',
    'Krishna nagar',
    'Tikuriya tola',
  ];

  // Copy Main List into New List.
  List<String> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: getBoldText(
          'Select your area',
          18,
          Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.0),
              children: newDataList.map((data) {
                return ListTile(
                  title: Text(data),
                  onTap: () {
                    Provider.of<UserModel>(context, listen: false)
                        .setLandmark(data);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetails(),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// Search bar in app bar flutter
class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  Widget appBarTitle = new Text("AppBar Title");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("AppBar Title");
              }
            });
          },
        ),
      ]),
    );
  }
}
