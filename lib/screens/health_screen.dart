import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newshub_tabview/Models/newsmodel.dart';
import 'package:newshub_tabview/services/check_internet_connectivity.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/newsheadline_widget.dart';
import '../data/dataclass.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  Future<List<Article>?>? healthArticles;
  CheckInternet? _checkInternet;

  @override
  void initState() {
    var data = Provider.of<DataClass>(context, listen: false);
    _checkInternet = Provider.of<CheckInternet>(context, listen: false);
    _checkInternet?.checkRealtimeConnection();

    healthArticles = data.healthArticles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var mediaQ = MediaQuery.of(context).size;
    return Consumer<DataClass>(
      builder: (context, value, child) => (_checkInternet!.status != "Offline")
          ? FutureBuilder(
              future: healthArticles,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: SizedBox(
                        height: 50.h,
                        width: 50.h,
                        child: SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: const CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );

                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return NewsHeadlineWidget(
                              articlesList: snapshot.data!,
                              id: snapshot.data![index].id,
                              bookmarked: snapshot.data![index].bookmarked,
                              imageUrl: snapshot.data![index].urlToImage ??
                                  'https://images.unsplash.com/photo-1572949645841-094f3a9c4c94?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80',
                              headline: snapshot.data![index].title,
                              publishedAt: snapshot.data![index].publishedAt,
                              description:
                                  ((snapshot.data![index].description) ?? ' '),
                              content: snapshot.data![index].content ?? '',
                              newsUrl: snapshot.data![index].url);
                        },
                      );
                    }
                }

                return const Center(child: Text('Snapshot received no data'));
              })
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Internet",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    "Check your internet connection and refresh",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(45.w, 45.w),
                      backgroundColor: const Color.fromARGB(255, 231, 20, 5),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      var data = Provider.of<DataClass>(context, listen: false);
                      setState(() {
                        data.healthArticles = data.fetchHNews('us');
                      });
                    },
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
