import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newshub_tabview/screens/bookmarked_screen.dart';
import 'package:newshub_tabview/screens/business_screen.dart';
import 'package:newshub_tabview/screens/entertainment_screen.dart';
import 'package:newshub_tabview/screens/general_screen.dart';
import 'package:newshub_tabview/screens/health_screen.dart';
import 'package:newshub_tabview/screens/science_screen.dart';
import 'package:newshub_tabview/screens/sportsscreen.dart';
import 'package:newshub_tabview/screens/technology.dart';
import 'package:newshub_tabview/data/dataclass.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  String string = '';

  String fcountry = 'us';

  final List<String> tabs = [
    'General',
    'Business',
    'Sports',
    'Entertainment',
    'Science',
    'Health',
    'Technology'
        'Bookmarked'
  ];
  var countryList = [
    'US',
    'UK',
    'Canada',
    'China',
    'Germany',
    'Japan',
    'South Africa',
    'Ukraine',
  ];
  String selectedCountry = 'US';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0).w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Icon(Icons.list, size: 16.sp, color: Colors.yellow),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: countryList
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: selectedCountry,
                  onChanged: (value) {
                    setState(() {
                      var data = Provider.of<DataClass>(context, listen: false);
                      selectedCountry = value as String;
                      fcountry = data.matchcountry(selectedCountry);
                      data.reload(fcountry);
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  iconSize: 16.sp,
                  buttonHeight: 45.h,
                  buttonWidth: 100.w,
                  selectedItemHighlightColor: Colors.black,
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14).w,
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20).r,
                    border: Border.all(color: Colors.white, width: 2.w),
                    color: const Color.fromARGB(255, 231, 20, 5),
                  ),
                  itemHeight: 35.h,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14).w,
                  dropdownWidth: 120.h,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14).r,
                    color: const Color.fromARGB(255, 231, 20, 5),
                  ),
                  dropdownElevation: 4,
                  scrollbarRadius: const Radius.circular(40).r,
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(-20, 0),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<DataClass>(context, listen: false)
                      .reload(fcountry);
                },
                icon: const Icon(Icons.refresh))
          ],
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 231, 20, 5),
          title: Text(
            'News Hub',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16.sp),
            indicatorWeight: 4.w,
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: 'General',
              ),
              Tab(
                text: 'Business',
              ),
              Tab(
                text: 'Entertainment',
              ),
              Tab(
                text: 'Sports',
              ),
              Tab(
                text: 'Health',
              ),
              Tab(
                text: 'Science',
              ),
              Tab(
                text: 'Technology',
              ),
              Tab(
                text: 'Bookmarked',
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GeneralScreen(),
            BusinessScreen(),
            EntertainmentScreen(),
            SportsScreen(),
            HealthScreen(),
            ScienceScreen(),
            TechnologyScreen(),
            BookmarkedScreen()
          ],
        ),
      ),
    );
  }
}
