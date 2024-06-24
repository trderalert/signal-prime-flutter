import 'package:auto_route/auto_route.dart';
import 'package:base_setup/data/models/news.model.dart';
import 'package:base_setup/data/viewmodels/home.viewmodel.dart';
import 'package:base_setup/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'homeScreen')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeViewModel.buildWithProvider(
      builder: (_, __) {
        return _NewsBody();
      },
    );
  }
}

class _NewsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel model = Provider.of<HomeViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: TabAlignment.fill,
            isScrollable: false,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            labelColor: onSurface,
            indicatorColor: onSurface,
            unselectedLabelColor: onSurfaceVariant,
            onTap: (onTap) {
              print(onTap);
              model.getAlertsData(onTap);
            },
            tabs: const [
              Tab(
                child: Text(
                  'MT 4',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'MT 5',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          title: const Text(
            'Home',
            style: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  model.logout(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () async {
                  model.getAlertsData(0);
                },
                child: model.alertsLoader
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.2),
                        child: CircularProgressIndicator(),
                      ))
                    : Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Table(
                              border: const TableBorder(
                                  top: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  verticalInside: BorderSide(color: Colors.black)),
                              children: const [
                                TableRow(children: [
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'T.Price',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'SP',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'TP',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'Symbol',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'Tag',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'Time',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                ])
                              ],
                            ),
                            Table(
                              border: TableBorder.all(color: Colors.black),
                              children: List.generate(
                                  model.alertList.length,
                                  (index) => TableRow(children: [
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].entryprice}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].sp}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4.0),
                                          child: Text('${model.alertList[index].tp}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].symbol}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].tag}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.dateFormat(model.alertList[index].timestamp)}'),
                                        )),
                                      ])),
                            ),
                          ],
                        ),
                      ),
                /*Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ListView.builder(
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              itemBuilder: (context, index) {
                                final item = model.newsList[index];
                                debugPrint('title $index  : ${item.title}');
                                return NewsItem(
                                  item: item,
                                );
                              },
                              itemCount: model.newsList.length,
                            ),
                          ),
                          model.newsPaginationLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Visibility(
                                  visible: model.morePages == true,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        model.initLoadMore(context);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      const Color(0xff101F5A))),
                                      child: const Text(
                                        'Load More',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),*/
              ),
            ),
            SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () async {
                  model.getAlertsData(1);
                },
                child: model.alertsLoader
                    ? Center(
                        child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.2),
                        child: CircularProgressIndicator(),
                      ))
                    : Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Table(
                              border: const TableBorder(
                                  top: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  verticalInside: BorderSide(color: Colors.black)),
                              children: const [
                                TableRow(children: [
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'T.Price',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'SP',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'TP',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'Symbol',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'Tag',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Text(
                                      'Time',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                ])
                              ],
                            ),
                            Table(
                              border: TableBorder.all(color: Colors.black),
                              children: List.generate(
                                  model.alertList.length,
                                  (index) => TableRow(children: [
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].entryprice}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].sp}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4.0),
                                          child: Text('${model.alertList[index].tp}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].symbol}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.alertList[index].tag}'),
                                        )),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Text('${model.dateFormat(model.alertList[index].timestamp)}'),
                                        )),
                                      ])),
                            ),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  ///
  final News? item;

  ///
  const NewsItem({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    HomeViewModel model = Provider.of<HomeViewModel>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () {
          model.navigateToDetailWebView(item, context);
        },
        child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey.shade300,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.title ?? '',
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff101F5A),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  item?.subTitle ?? '',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  '${item?.time}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
                )
              ],
            )),
      ),
    );
  }
}
