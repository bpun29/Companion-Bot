import 'package:flutter/material.dart';

class SuggestModel {
  String name;
  String iconPath;
  String bio;
  Color boxColor;
  bool viewIsSelected;

  SuggestModel({
    required this.name,
    required this.iconPath,
    required this.bio,
    required this.boxColor,
    required this.viewIsSelected,
  });

  static List<SuggestModel> getSuggest() {
    List<SuggestModel> suggests = [];

    suggests.add(
      SuggestModel(
        name: 'Katy',
        iconPath: 'assets/icons/Katy.svg',
        bio: 'Dating Coach',
        viewIsSelected: true,
        boxColor: const Color.fromARGB(255, 230, 180, 255),
      ),
    );

    suggests.add(
      SuggestModel(
        name: 'Amy',
        iconPath: 'assets/icons/Amy.svg',
        bio: 'Cat Lover',
        viewIsSelected: true,
        boxColor: const Color.fromARGB(255, 255, 158, 198),
      ),
    );
    return suggests;
  }
}
