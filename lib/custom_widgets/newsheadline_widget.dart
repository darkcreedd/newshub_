import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:newshub_tabview/Models/newsmodel.dart';
import 'package:newshub_tabview/data/dataclass.dart';
import 'package:newshub_tabview/screens/webviewscreen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NewsHeadlineWidget extends StatefulWidget {
  NewsHeadlineWidget(
      {super.key,
      required this.articlesList,
      required this.id,
      required this.publishedAt,
      required this.headline,
      required this.description,
      required this.content,
      required this.imageUrl,
      required this.bookmarked,
      required this.newsUrl});
  String headline;
  int id;
  List<Article> articlesList;
  String? description;
  DateTime publishedAt;
  String? content;
  String? imageUrl;
  String newsUrl;
  String? source;
  String? author;
  bool bookmarked;
  @override
  State<NewsHeadlineWidget> createState() => _NewsHeadlineWidgetState();
}

class _NewsHeadlineWidgetState extends State<NewsHeadlineWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 4, 4).w,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(newsUrl: widget.newsUrl),
              ));
        },
        child: SizedBox(
          height: 180.h,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180.h,
                width: 150.w,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  errorWidget: (context, url, error) => Image.asset(
                      "assets/images/error_image.png",
                      fit: BoxFit.cover),
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      height: 50.h,
                      width: 50.w,
                      child: const CircularProgressIndicator(
                        color: Color.fromARGB(255, 231, 20, 5),
                      ),
                    ),
                  ),
                  imageUrl: widget.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 2, 0).w,
                  child: SizedBox(
                    child: ListView(
                      children: [
                        Text(
                          widget.headline,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 14.sp),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            widget.description ?? '',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0).w,
                          child: Text(
                            widget.content ?? '',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            DateFormat('E, d MMM yyyy HH:mm a')
                                .format(widget.publishedAt),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 30.w,
                color: Colors.transparent,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: -10,
                      right: -11,
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        splashRadius: 20,
                        onPressed: () {
                          var data =
                              Provider.of<DataClass>(context, listen: false);
                          setState(() {
                            for (var article in widget.articlesList) {
                              if (article.id == widget.id) {
                                article.bookmarked = !article.bookmarked;
                              }
                            }
                          });
                          data.addToBookmark(
                              widget.headline,
                              widget.description,
                              widget.content,
                              widget.imageUrl,
                              widget.newsUrl,
                              widget.source,
                              widget.author,
                              widget.publishedAt,
                              widget.bookmarked,
                              widget.id);
                        },
                        icon: (widget.bookmarked)
                            ? Icon(
                                Icons.bookmark,
                                color: const Color.fromARGB(255, 231, 20, 5),
                                size: 27.sp,
                              )
                            : Icon(
                                Icons.bookmark_outline,
                                color: Colors.red,
                                size: 27.sp,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
