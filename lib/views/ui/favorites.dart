import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:shopshoes/models/constant.dart';
import 'package:shopshoes/views/shared/appstyle.dart';
import 'package:shopshoes/views/ui/mainscreen.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final _favBox = Hive.box('fav_box');

  _deleteFav(int key) async {
    await _favBox.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> fav = [];
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "name": item['name'],
        "category": item['category'],
        "price": item['price'],
        "imageUrl": item['imageUrl']
      };
    }).toList();
    fav = favData.reversed.toList();
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/top_image.png"),
                  fit: BoxFit.fill),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "My Favorites",
                style: appStyle(40, Colors.white, FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                itemCount: fav.length,
                padding: const EdgeInsets.only(top: 100),
                itemBuilder: (BuildContext context, int index) {
                  final shoe = fav[index];
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade100,
                                spreadRadius: 5,
                                blurRadius: 0.3,
                                offset: Offset(0, 1))
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CachedNetworkImage(
                                    imageUrl: shoe['imageUrl'],
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12, left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shoe['name'],
                                        style: appStyle(
                                            16, Colors.black, FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(shoe['category'],
                                          style: appStyle(14, Colors.grey,
                                              FontWeight.w600)),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${shoe['price']}',
                                              style: appStyle(18, Colors.black,
                                                  FontWeight.bold))
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  _deleteFav(shoe['key']);
                                  ids.removeWhere(
                                      (element) => element == shoe['id']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()));
                                },
                                child: const Icon(Ionicons.md_heart_dislike),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}
