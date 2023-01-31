import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wasurena/person_model.dart';

import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //登録済みリストを取得
  List<Person> People = [];
  String _imagePath = '';
  _setImagePath() async {
    _imagePath = (await getApplicationDocumentsDirectory()).path;
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      getPeopleList();
      _setImagePath();
    });
  }
  //人物リストを取得
  Future<void> getPeopleList() async {
    People = await DbHelper.instance.selectAllPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Container(
            child: ListView.builder(
              itemCount: 12, // 親しい人のみを表示
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 80,
                  color: colorList[index % colorList.length],
                );
              },
            ),

          ),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
