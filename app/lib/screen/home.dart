import 'package:flutter/material.dart';
import '../widget/appbar.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

List channels = [];
List allChannels = [];
final player = AudioPlayer();
var select = 0;
final search = TextEditingController();
late List<String> mylist = [];
late bool selectFav = false;
late bool load = false;

class _HomeState extends State<Home> {
  Future getRadios() async {
    setState(() {
      load = true;
    });
    var response = await Dio().get("http://your-ip/api.php");
    setState(() {
      channels = response.data;
      allChannels = response.data;
      load = false;
    });
  }

  Future play(id, url) async {
    setState(() {
      select = id;
    });
    await player.setUrl(url);
    player.play();
  }

  Future stop() async {
    await player.stop();
    setState(() {
      select = 0;
    });
  }

  Future saveList(id) async {
    setState(() {
      if (mylist.contains(id)) {
        mylist.remove(id);
      } else {
        mylist.add(id);
      }
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('mylist', mylist);

    if (selectFav == true) {
      getFavList();
    }
  }

  Future getList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var stringList = prefs.getStringList('mylist') ?? [];
    mylist = stringList.toList().map((e) => e).toList();
  }

  Future getFavList({bool clear = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var stringList = prefs.getStringList('mylist') ?? [];
    final List result = stringList.toList().map((e) => int.parse(e)).toList();
    setState(() {
      if (clear == false) {
        selectFav = true;
        channels = allChannels.where((e) => result.contains(e['id'])).toList();
      } else {
        selectFav = false;
        channels = allChannels;
      }
    });
  }

  Future searchChannels(text) async {
    setState(() {
      if (text.isEmpty) {
        channels = allChannels;
      } else {
        channels = channels
            .where((elem) =>
                elem['name']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                elem['freq']
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()))
            .toList();
      }
    });
  }

  Future clearSearch() async {
    setState(() {
      search.clear();
      channels = allChannels;
    });
  }

  @override
  void initState() {
    super.initState();
    getRadios();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyBar(),
        backgroundColor: Color(0xFF130F40),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch(
              accentColor: Color(0xFF222D3B),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: load == false
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          onChanged: (text) {
                            searchChannels(text);
                          },
                          controller: search,
                          obscureText: false,
                          decoration: InputDecoration(
                            suffixIcon: search.text.isEmpty
                                ? SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      clearSearch();
                                    },
                                    icon:
                                        Icon(Icons.clear, color: Colors.white),
                                  ),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white54,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.all(14),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  getFavList(clear: true);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.window,
                                      color: selectFav == false
                                          ? Color(0xFFF2304D)
                                          : Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20,
                                        color: selectFav == false
                                            ? Color(0xFFF2304D)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  getFavList();
                                },
                                child: Row(
                                  children: [
                                    selectFav == true
                                        ? Icon(Icons.favorite,
                                            color: Color(0xFFF2304D))
                                        : Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Favorites",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20,
                                        color: selectFav == true
                                            ? Color(0xFFF2304D)
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      channels.length > 0
                          ? GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10),
                              itemCount: channels.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (channels[index]['id'] == select) {
                                      stop();
                                    } else {
                                      play(channels[index]['id'],
                                          channels[index]['url']);
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: channels[index]['id'] == select
                                          ? Color(0xFFF2304D)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment(0, -0.98),
                                          child: ListTile(
                                            title: Text(
                                              channels[index]['name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            subtitle: Text(
                                              channels[index]['freq']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Poppins',
                                                color: Colors.white70,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                saveList(channels[index]['id']
                                                    .toString());
                                              },
                                              icon: Icon(
                                                mylist.contains(channels[index]
                                                            ['id']
                                                        .toString())
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.white,
                                                size: 34,
                                              ),
                                            ),
                                            dense: false,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment(-0.59, 1.03),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: channels[index]['id'] ==
                                                    select
                                                ? Lottie.asset(
                                                    'assets/img/active.json',
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: Image.asset(
                                                      'assets/img/deactive.png',
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Column(
                              children: [
                                SizedBox(height: 50),
                                Center(
                                  child: Image.asset(
                                    'assets/img/empty.png',
                                    width: 290,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "-",
                                  style: TextStyle(
                                    color: Color(0xFFF2304D),
                                    fontSize: 25,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ],
                            ),
                    ],
                  )
                : Center(
                    child: Lottie.asset(
                      'assets/img/loading.json',
                      width: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
