import 'package:flutter/services.dart' as the_bundle;
import 'package:shopshoes/models/sneaker_model.dart';

class Helper {
  Future<List<Sneakers>> getMaleSneakers() async {
    final data =
        await the_bundle.rootBundle.loadString("assets/json/men_shoes.json");
    final maleList = sneakersFromJson(data);
    return maleList;
  }

  Future<List<Sneakers>> getFemaleSneakers() async {
    final data =
        await the_bundle.rootBundle.loadString("assets/json/women_shoes.json");
    final womenList = sneakersFromJson(data);
    return womenList;
  }

  Future<List<Sneakers>> getKidsSneakers() async {
    final data =
        await the_bundle.rootBundle.loadString("assets/json/kids_shoes.json");
    final kidsList = sneakersFromJson(data);
    return kidsList;
  }

  Future<Sneakers> getMaleSneakersById(String id) async {
    final data = await the_bundle.rootBundle.loadString("assets/json/men_shoes.json");
    final maleList = sneakersFromJson(data);
    final sneaker = maleList.firstWhere((sneaker) => sneaker.id == id);
    return sneaker;
  }

  Future<Sneakers> getFemaleSneakersById(String id) async {
    final data =
        await the_bundle.rootBundle.loadString("assets/json/women_shoes.json");
    final womenList = sneakersFromJson(data);
    final sneaker = womenList.firstWhere((sneaker) => sneaker.id == id);
    return sneaker;
  }

  Future<Sneakers> getKidsSneakersById(String id) async {
    final data =
        await the_bundle.rootBundle.loadString("assets/json/kids_shoes.json");
    final kidsList = sneakersFromJson(data);
    final sneaker = kidsList.firstWhere((sneaker) => sneaker.id == id);
    return sneaker;
  }
}
