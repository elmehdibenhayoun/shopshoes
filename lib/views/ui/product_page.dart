import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shopshoes/controllers/favorites_provider.dart';
import 'package:shopshoes/controllers/product_controller.dart';
import 'package:shopshoes/models/constant.dart';
import 'package:shopshoes/models/sneaker_model.dart';
import 'package:shopshoes/services/helper.dart';
import 'package:shopshoes/views/shared/appStyle.dart';
import 'package:shopshoes/views/shared/checkout_btn.dart';
import 'package:shopshoes/views/ui/favorites.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.id, required this.category});

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  final _favBox = Hive.box('fav_box');
  final _cartBox = Hive.box('cart_box');

  late Future<Sneakers> _sneaker;

  void getShoes() {
    if (widget.category == "Men's Running") {
      _sneaker = Helper().getMaleSneakersById(widget.id);
    } else if (widget.category == "Women's Running") {
      _sneaker = Helper().getFemaleSneakersById(widget.id);
    } else {
      _sneaker = Helper().getKidsSneakersById(widget.id);
    }
  }

  Future<void> _createCart(Map<String, dynamic> newCart) async {
    await _cartBox.add(newCart);
  }

  Future<void> _createFav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
  }

  @override
  void initState() {
    super.initState();
    getShoes();
  }

  @override
  Widget build(BuildContext context) {
    var favoritesNotifier =
        Provider.of<FavoritesNotifier>(context, listen: true);
    favoritesNotifier.getFavorites();
    return Scaffold(
        body: FutureBuilder<Sneakers>(
            future: _sneaker,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else {
                final sneaker = snapshot.data;
                return Consumer<ProductNotifier>(
                  builder: (context, productNotifier, child) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          leadingWidth: 0,
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    productNotifier.shoeSizes.clear();
                                  },
                                  child: const Icon(
                                    AntDesign.close,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: null,
                                  child: const Icon(
                                    Ionicons.ellipsis_horizontal,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          pinned: true,
                          snap: false,
                          floating: true,
                          backgroundColor: Colors.transparent,
                          expandedHeight: MediaQuery.of(context).size.height,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.37,
                                  width: MediaQuery.of(context).size.width,
                                  child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: sneaker!.imageUrl.length,
                                      controller: pageController,
                                      onPageChanged: (page) {
                                        productNotifier.activePage = page;
                                      },
                                      itemBuilder: (context, int index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.35,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: Colors.grey.shade300,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    sneaker.imageUrl[index],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                right: 20,
                                                child:
                                                    Consumer<FavoritesNotifier>(
                                                  builder: (context,
                                                      favoritesNotifier,
                                                      child) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (favoritesNotifier
                                                            .ids
                                                            .contains(
                                                                widget.id)) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const Favorites()));
                                                        } else {
                                                          favoritesNotifier
                                                              .createFav({
                                                            "id": sneaker.id,
                                                            "name":
                                                                sneaker.name,
                                                            "category": sneaker
                                                                .category,
                                                            "price":
                                                                sneaker.price,
                                                            "imageUrl": sneaker
                                                                .imageUrl[0]
                                                          });
                                                        }
                                                        setState(() {});
                                                      },
                                                      child: favoritesNotifier
                                                              .ids
                                                              .contains(
                                                                  sneaker.id)
                                                          ? const Icon(
                                                              AntDesign.heart,
                                                            )
                                                          : const Icon(
                                                              AntDesign.hearto,
                                                            ),
                                                    );
                                                  },
                                                )),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                left: 0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children:
                                                      List<Widget>.generate(
                                                          sneaker
                                                              .imageUrl.length,
                                                          (index) => Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        4),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 5,
                                                                  backgroundColor: productNotifier
                                                                              .activepage !=
                                                                          index
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              )),
                                                )),
                                          ],
                                        );
                                      }),
                                ),
                                Positioned(
                                    bottom: 18,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.700,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sneaker.name,
                                                style: appStyle(
                                                    25,
                                                    Colors.black,
                                                    FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    sneaker.category,
                                                    style: appStyle(
                                                        15,
                                                        Colors.grey,
                                                        FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  RatingBar.builder(
                                                    initialRating: 4,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 22,
                                                    itemPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 1),
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "\$${sneaker.price}",
                                                    style: appStyle(
                                                        15,
                                                        Colors.black,
                                                        FontWeight.w600),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Colors",
                                                        style: appStyle(
                                                            15,
                                                            Colors.black,
                                                            FontWeight.w500),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const CircleAvatar(
                                                        radius: 7,
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const CircleAvatar(
                                                        radius: 7,
                                                        backgroundColor:
                                                            Colors.red,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Select sizes",
                                                        style: appStyle(
                                                            15,
                                                            Colors.black,
                                                            FontWeight.w600),
                                                      ),
                                                      const SizedBox(
                                                        width: 25,
                                                      ),
                                                      Text("View size guide",
                                                          style: appStyle(
                                                              15,
                                                              Colors.grey,
                                                              FontWeight.w600)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    child: ListView.builder(
                                                        itemCount:
                                                            productNotifier
                                                                .shoeSizes
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final sizes =
                                                              productNotifier
                                                                      .shoeSizes[
                                                                  index];
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                            child: ChoiceChip(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              60),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid)),
                                                              disabledColor:
                                                                  Colors.white,
                                                              label: Text(
                                                                sizes['size'],
                                                                style: appStyle(
                                                                    10,
                                                                    sizes['isSelected']
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    FontWeight
                                                                        .w500),
                                                              ),
                                                              selectedColor:
                                                                  Colors.black,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8),
                                                              selected: sizes[
                                                                  'isSelected'],
                                                              onSelected:
                                                                  (newState) {
                                                                if (productNotifier
                                                                    .sizes
                                                                    .contains(sizes[
                                                                        'size'])) {
                                                                  productNotifier
                                                                      .sizes
                                                                      .remove(sizes[
                                                                          'size']);
                                                                } else {
                                                                  productNotifier
                                                                      .sizes
                                                                      .add(sizes[
                                                                          'size']);
                                                                }
                                                                print(
                                                                    productNotifier
                                                                        .sizes);
                                                                productNotifier
                                                                    .toggleCheck(
                                                                        index);
                                                              },
                                                            ),
                                                          );
                                                        }),
                                                  )
                                                ],
                                              ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                color: Colors.black,
                                              ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Text(
                                                  sneaker.title,
                                                  maxLines: 2,
                                                  style: appStyle(
                                                      20,
                                                      Colors.black,
                                                      FontWeight.w700),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                sneaker.description,
                                                textAlign: TextAlign.justify,
                                                maxLines: 4,
                                                style: appStyle(
                                                    12,
                                                    Colors.black,
                                                    FontWeight.normal),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: CheckoutButton(
                                                    onTap: () async {
                                                      _createCart({
                                                        "id": sneaker.id,
                                                        "name": sneaker.name,
                                                        "category":
                                                            sneaker.category,
                                                        "sizes": productNotifier
                                                            .sizes[0],
                                                        "imageUrl":
                                                            sneaker.imageUrl[0],
                                                        "price": sneaker.price,
                                                        "qty": 1
                                                      });
                                                      print(sneaker.name);
                                                      productNotifier.sizes
                                                          .clear();
                                                      Navigator.pop(context);
                                                    },
                                                    label: "Add to Cart",
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }
            }));
  }
}
