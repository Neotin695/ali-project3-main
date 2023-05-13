import 'package:flutter/material.dart';
import 'package:project2/tawari_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  List tawari = [
    {"name": "اسعاف", "screen": "images/iseaf.png"},
    {"name": "شرطة", "screen": "images/polic2.png"},
    {"name": "مطافى", "screen": "images/fire.png"},
    {"name": "غاز", "screen": "images/gas.png"},
    {"name": "كهرباء", "screen": "images/electricity.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: tawari.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TawariScreen(title: tawari[i]['name']);
                    }),
                  );
                },
                child: Container(
                  height: 260,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(tawari[i]['screen']),
                        radius: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${tawari[i]['name']}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
