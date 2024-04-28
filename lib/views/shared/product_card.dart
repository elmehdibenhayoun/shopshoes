import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shopshoes/controllers/favorites_provider.dart';
import 'package:shopshoes/models/constant.dart';
import 'package:shopshoes/views/shared/appstyle.dart';
import 'package:shopshoes/views/ui/favorites.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {super.key,
      required this.price,
      required this.category,
      required this.id,
      required this.name,
      required this.image});
  final String price;
  final String category;
  final String id;
  final String name;
  final String image;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final _favBox = Hive.box('fav_box');

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: true);
    favoritesNotifier.getFavorites();
    bool selected = true;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 0.6,
                offset: Offset(1, 1))
          ]),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.23,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: NetworkImage(widget.image))),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () async {
                      if (favoritesNotifier.ids.contains(widget.id)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Favorites()));
                      } else {
                        favoritesNotifier.createFav({
                          "id": widget.id,
                          "name": widget.name,
                          "category": widget.category,
                          "price": widget.price,
                          "imageUrl": widget.image
                        });
                      }
                      setState(() {});
                    },
                    child: favoritesNotifier.ids.contains(widget.id)
                        ? const Icon(AntDesign.heart)
                        : const Icon(AntDesign.hearto),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style:
                        appStyleWithHt(25, Colors.black, FontWeight.bold, 1.1),
                  ),
                  Text(
                    widget.category,
                    style:
                        appStyleWithHt(15, Colors.grey, FontWeight.bold, 1.5),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.price,
                    style: appStyle(25, Colors.black, FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Text(
                        "Colors",
                        style: appStyle(12, Colors.grey, FontWeight.w500),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width:
                            20, // Ajustez la taille du cercle selon vos besoins
                        height:
                            20, // Ajustez la taille du cercle selon vos besoins
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? Colors.black : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
