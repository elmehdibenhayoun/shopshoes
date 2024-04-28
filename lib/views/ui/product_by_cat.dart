import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shopshoes/models/sneaker_model.dart';
import 'package:shopshoes/services/helper.dart';
import 'package:shopshoes/views/shared/appstyle.dart';
import 'package:shopshoes/views/shared/category_btn.dart';
import 'package:shopshoes/views/shared/custom_spacer.dart';
import 'package:shopshoes/views/shared/stagger_tile.dart';

import '../shared/latest_shoes.dart';

class ProductByCat extends StatefulWidget {
  const ProductByCat({super.key, required this.tabIndex});
  final int tabIndex;

  @override
  State<ProductByCat> createState() => _ProductByCatState();
}

class _ProductByCatState extends State<ProductByCat>
    with TickerProviderStateMixin {
  late final TabController _tabcontroller =
      TabController(length: 3, vsync: this);

  late Future<List<Sneakers>> _male;
  late Future<List<Sneakers>> _female;
  late Future<List<Sneakers>> _kids;

  void getMale() {
    _male = Helper().getMaleSneakers();
  }

  void getFemale() {
    _female = Helper().getFemaleSneakers();
  }

  void getKids() {
    _kids = Helper().getKidsSneakers();
  }

  @override
  void initState() {
    super.initState();
    _tabcontroller.animateTo(widget.tabIndex, curve: Curves.easeIn);
    getMale();
    getFemale();
    getKids();
  }

  List<String> brand = [
    "assets/images/adidas.png",
    "assets/images/gucci.png",
    "assets/images/jordan.png",
    "assets/images/nike.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/top_image.png"),
                    fit: BoxFit.fill),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            AntDesign.close,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            filter();
                          },
                          child: const Icon(
                            FontAwesome.sliders,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    controller: _tabcontroller,
                    isScrollable: true,
                    labelColor: Colors.white,
                    labelStyle: appStyle(24, Colors.white, FontWeight.bold),
                    unselectedLabelColor: Colors.grey.withOpacity(0.3),
                    tabs: const [
                      Tab(
                        text: "Men Shoes",
                      ),
                      Tab(
                        text: "Women Shoes",
                      ),
                      Tab(
                        text: "Kids Shoes",
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.165,
                  left: 16,
                  right: 12),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: TabBarView(controller: _tabcontroller, children: [
                  LatestShoes(
                    male: _male,
                  ),
                  LatestShoes(
                    male: _female,
                  ),
                  LatestShoes(
                    male: _kids,
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> filter() {
    double _value = 100;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white54,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.86,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: 40,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black38),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                const CustomSpacer(),
                Text(
                  "Filter",
                  style: appStyle(28, Colors.black, FontWeight.bold),
                ),
                const CustomSpacer(),
                Text(
                  "Gender",
                  style: appStyle(18, Colors.black, FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(
                  children: [
                    CategoryBtn(buttonClr: Colors.black, label: "Men"),
                    CategoryBtn(buttonClr: Colors.grey, label: "Women"),
                    CategoryBtn(buttonClr: Colors.grey, label: "Kids"),
                  ],
                ),
                const CustomSpacer(),
                Text(
                  "Category",
                  style: appStyle(18, Colors.black, FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(
                  children: [
                    CategoryBtn(buttonClr: Colors.black, label: "Shoes"),
                    CategoryBtn(buttonClr: Colors.grey, label: "Appareils"),
                    CategoryBtn(buttonClr: Colors.grey, label: "Accessories"),
                  ],
                ),
                const CustomSpacer(),
                Text(
                  "Price",
                  style: appStyle(20, Colors.black, FontWeight.bold),
                ),
                const CustomSpacer(),
                Slider(
                    value: _value,
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                    thumbColor: Colors.black,
                    max: 500,
                    divisions: 50,
                    label: _value.toString(),
                    secondaryTrackValue: 200,
                    onChanged: (double value) {}),
                CustomSpacer(),
                Text(
                  "Brand",
                  style: appStyle(20, Colors.black, FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  height: 80,
                  child: ListView.builder(
                      itemCount: brand.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Image.asset(
                              brand[index],
                              height: 60,
                              width: 80,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
