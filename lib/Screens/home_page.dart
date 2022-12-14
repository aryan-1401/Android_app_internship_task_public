import 'package:flutter/material.dart';
import 'package:newspaperapp/api/repository.dart';
import 'package:newspaperapp/model/catagory.dart';
import 'package:newspaperapp/model/news.dart';
import 'package:newspaperapp/screens/generelized_page.dart';
import 'package:newspaperapp/screens/view_news.dart';
import 'package:newspaperapp/widgets/collapsable_appbar.dart';
import 'package:newspaperapp/widgets/customized_indicator.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:newspaperapp/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  Future future;
  double margin;
  @override
  void initState() {
    tabController = TabController(length: 7, vsync: this);
    tabController.addListener(() {
      if (margin == 8) {
        if (tabController.index > 0) {
          setState(() {
            margin = 0;
          });
        }
      } else if (margin == 0 && tabController.index == 0) {
        setState(() {
          margin = 8;
        });
      }
    });
    future = Repository().getAllHeadLines();
    margin = 8;
    super.initState();
  }

  String getDay(int day) {
    final List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[day - 1];
  }

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            CollapsableAppBar(
                appBarHeight: 150,
                appBarChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: RichText(
                          text: TextSpan(
                              text: getDay(DateTime.now().toLocal().weekday) +
                                  ", ",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                color: kPrimaryLightColor,
                              ),
                              children: [
                                TextSpan(
                                    text: DateFormat.jm()
                                        .format(DateTime.now().toLocal())
                                        .toString(),
                                    style: TextStyle(fontSize: 16)),
                              ]),
                        ),
                      ),
                    ),
                    Flexible(
                      child: AnimatedContainer(
                        margin: EdgeInsets.only(
                          left: margin,
                        ),
                        child: TabBar(
                          indicator: CustomTabIndicator(),
                          labelColor: kPrimarySecondColor,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          indicatorSize: TabBarIndicatorSize.tab,
                          isScrollable: true,
                          unselectedLabelColor: kPrimaryLightColor,
                          unselectedLabelStyle:
                              TextStyle(fontWeight: FontWeight.w400),
                          controller: tabController,
                          tabs: <Widget>[
                            Container(
                              child: Tab(
                                text: "General",
                              ),
                            ),
                            Tab(
                              text: "Business",
                            ),
                            Tab(
                              text: "Entertainment",
                            ),
                            Tab(
                              text: "Health",
                            ),
                            Tab(
                              text: "Science",
                            ),
                            Tab(
                              text: "Sports",
                            ),
                            Tab(
                              text: "Technology",
                            ),
                          ],
                        ),
                        duration: Duration(milliseconds: 150),
                      ),
                    ),
                  ],
                ),
                child: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    FutureBuilder<List<Article>>(
                      future: future,
                      builder: (context, snapshotlist) {
                        if (snapshotlist.hasData) {
                          return EasyRefresh(
                            onRefresh: () async {
                              await new Future.delayed(
                                  const Duration(seconds: 1), () {
                                setState(() {
                                  future = Repository().getAllHeadLines();
                                });
                              });
                            },
                            refreshHeader: ClassicsHeader(
                              key: _headerKey,
                              bgColor: Colors.transparent,
                              textColor: Colors.black,
                            ),
                            child: ListView.builder(
                              key: PageStorageKey("allheadlines"),
                              shrinkWrap: true,
                              itemCount: snapshotlist.data.length,
                              itemBuilder: (context, index) {
//                          print(snapshotlist.data[index].urlToImage);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/view_news",
                                        arguments: ViewNews(
                                          newsUrl: snapshotlist.data[index].url,
                                          title: snapshotlist
                                                  .data[index].source.name ??
                                              "",
                                        ));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    color: kPrimaryLightColor,
                                    margin: EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8)),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshotlist
                                                    .data[index].urlToImage ??
                                                "https://dummyimage.com/300x200/000/fff",
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Text("Loading...")),
                                            errorWidget: (context, url,
                                                    error) =>
                                                new Center(
                                                    child: Icon(Icons.error)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "Headline",
                                                style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                snapshotlist
                                                        .data[index].author ??
                                                    "",
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshotlist.data[index].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                snapshotlist
                                                    .data[index].source.name,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              ),
                                              Text(
                                                (DateFormat.MMMMEEEEd().format(
                                                        snapshotlist.data[index]
                                                            .publishedAt
                                                            .toLocal()) +
                                                    " " +
                                                    DateFormat.jm().format(
                                                        snapshotlist.data[index]
                                                            .publishedAt
                                                            .toLocal())),
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Loading..."),
                          ));
                        }
                      },
                    ),
                    GeneralizedPage(
                      category: Categories.Business,
                    ),
                    GeneralizedPage(
                      category: Categories.Entertainment,
                    ),
                    GeneralizedPage(
                      category: Categories.Health,
                    ),
                    GeneralizedPage(
                      category: Categories.Science,
                    ),
                    GeneralizedPage(
                      category: Categories.Sports,
                    ),
                    GeneralizedPage(
                      category: Categories.Technology,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    updateKeepAlive();
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
}
