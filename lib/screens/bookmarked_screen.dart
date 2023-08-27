import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:newshub_tabview/data/dataclass.dart';
import 'package:newshub_tabview/screens/webviewscreen.dart';
import 'package:provider/provider.dart';

class BookmarkedScreen extends StatefulWidget {
  const BookmarkedScreen({super.key});

  @override
  State<BookmarkedScreen> createState() => _BookmarkedScreenState();
}

class _BookmarkedScreenState extends State<BookmarkedScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataClass>(
      builder: (context, value, child) => Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Visibility(
          //!Build more attractive UI here
          replacement: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
                child: Text(
              'No bookmarked articles',
              style: TextStyle(fontSize: 15.sp, fontStyle: FontStyle.italic),
            )),
          ),
          visible: value.bookmarkedArticles.isNotEmpty,
          child: ListView.builder(
            itemCount: value.bookmarkedArticles.length,
            itemBuilder: (context, index) {
              var bookmarkedArticles = value.bookmarkedArticles[index];
              return Padding(
                padding: const EdgeInsets.all(8.0).w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WebViewScreen(newsUrl: bookmarkedArticles.url),
                        ));
                  },
                  child: SizedBox(
                    height: 180.h,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0).w,
                          child: Container(
                            height: 170.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: CachedNetworkImage(
                              useOldImageOnUrlChange: true,
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/error_image.png",
                                  fit: BoxFit.cover),
                              placeholder: (context, url) => SizedBox(
                                height: 50.h,
                                width: 50.w,
                                child: const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 231, 20, 5),
                                ),
                              ),
                              imageUrl: bookmarkedArticles.imageLink ??
                                  'https://images.pexels.com/photos/1061634/pexels-photo-1061634.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 2, 0).w,
                            child: ListView(
                              children: [
                                Text(
                                  bookmarkedArticles.headline,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14.sp),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Text(
                                    bookmarkedArticles.description ?? '',
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0).w,
                                  child: Text(
                                    bookmarkedArticles.content ?? '',
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    DateFormat('E, d MMM yyyy HH:mm a')
                                        .format(bookmarkedArticles.publishedAt),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<DataClass>(context, listen: false)
                                .removeFromBookmarked(bookmarkedArticles.id);
                          },
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.bookmark,
                                color: const Color.fromARGB(255, 231, 20, 5),
                                size: 27.sp,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
