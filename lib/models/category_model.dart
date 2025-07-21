import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    //create constructor of the class
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Max',
        iconPath: 'assets/icons/P-Max.svg',
        boxColor: const Color.fromARGB(255, 188, 255, 221),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Tom',
        iconPath: 'assets/icons/P-Tom.svg',
        boxColor: const Color.fromARGB(255, 158, 255, 249),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Penny',
        iconPath: 'assets/icons/Penny.svg',
        boxColor: const Color.fromARGB(255, 255, 183, 183),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Doja',
        iconPath: 'assets/icons/Doja.svg',
        boxColor: const Color.fromARGB(255, 221, 172, 255),
      ),
    );

    return categories;
  }
}
