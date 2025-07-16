import 'package:botmobileapp/models/category_model.dart';
import 'package:botmobileapp/models/suggest_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = []; //defind to use the list
  List<SuggestModel> suggests = [];

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
    suggests = SuggestModel.getSuggest();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo(); //call at the begining -> the is fill first then widgets are display
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _serchField(),
          SizedBox(height: 40), //create distance from the top
          _categoriesSection(),
          SizedBox(height: 40),
          _suggestSection(),
        ],
      ),
    );
  }

  Column _suggestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //set text to the left
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Recommedation\nfor you',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 15), //create space between the text and the ListView
        Container(
          height: 240,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 210,
                decoration: BoxDecoration(
                  color: suggests[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      suggests[index].iconPath,
                      height: 110,
                      width: 110,
                    ),
                    Column(
                      children: [
                        Text(
                          suggests[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          suggests[index].bio,
                          style: TextStyle(
                            color: Color(0xff7B6F72),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      height: 40,
                      width: 120,
                      child: Center(
                        child: Text(
                          'Chat',
                          style: TextStyle(
                            color:
                                suggests[index].viewIsSelected
                                    ? Colors.white
                                    : Color(0xffC58BF2),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            suggests[index].viewIsSelected
                                ? Color(0xff9DCEFF)
                                : Colors.transparent,
                            suggests[index].viewIsSelected
                                ? Color(0xff92A3FD)
                                : Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemCount: suggests.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
          ),
        ),
      ],
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, //display the text on the left
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
          ), //create space from the left side
          child: Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 15), //create vertical distance
        Container(
          height: 120, //of List view
          child: ListView.separated(
            itemCount:
                categories
                    .length, //require parameter called item builder which used to display items
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              //add space from left to right
              left: 20,
              right: 20,
            ),
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemBuilder: (context, index) {
              //index -> actually the item number
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: SvgPicture.asset(categories[index].iconPath),
                      ),
                    ),
                    Text(
                      categories[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ); //must return in widget
            },
          ),
        ),
      ],
    );
  }

  Container _serchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        //create shadow of the container
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(
            15,
          ), //reduce the height of the text fill
          hintText: 'Search AI',
          hintStyle: TextStyle(color: Color(0xffDDDADA), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(
              12,
            ), //reduce the size of the search icon
            child: SvgPicture.asset('assets/icons/Search.svg'),
          ), //prefixIcon->widget type
          suffixIcon: Container(
            //make the hint text visible
            width: 100,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    //create vertical line
                    // color: Color(0xffDDDADA),
                    color: Colors.black,
                    indent: 10, //create space from the top
                    endIndent: 10, //create space from the buttom
                    thickness: 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Filter.svg'),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Companion AI',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0, // remove the shadow of the app bar
      centerTitle: true,
      // Left button
      leading: GestureDetector(
        onTap: () {
          // Add navigation or logic here
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center, // centers the icon
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
          decoration: BoxDecoration(
            color: Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Add options logic here
          },
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            child: SvgPicture.asset(
              'assets/icons/dots.svg',
              height: 18,
              width: 18,
            ),
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
