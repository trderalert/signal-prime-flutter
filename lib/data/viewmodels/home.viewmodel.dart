import 'package:base_setup/data/models/alert.model.dart';
import 'package:base_setup/data/models/news.model.dart';
import 'package:base_setup/data/service/navigation_service.dart';
import 'package:base_setup/data/viewmodels/base_viewmodel.dart';
import 'package:base_setup/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel();

  /// News section
  List<News> newsList = <News>[];
  List<Alerts> alertList = <Alerts>[];
  String? csrfToken;
  bool newsGlobalLoading = false;
  bool alertsLoader = false;
  bool newsPaginationLoading = false;
  int? dataMore;
  bool? morePages;

  final fireStore = FirebaseFirestore.instance;

  ///
  static ChangeNotifierProvider<HomeViewModel> buildWithProvider({
    required Widget Function(BuildContext context, Widget? child)? builder,
    Widget? child,
  }) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => HomeViewModel()..init(context),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  init(BuildContext context) async {
    try {
      await getAlertsData(0);
      csrfToken = null;
      dataMore = null;
      morePages = null;

      newsGlobalLoading = true;
      notifyListeners();

      final response = await http.Client().get(
        Uri.parse('https://www.forexfactory.com/news'),
      );

      List<News> news = <News>[];

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        final newsElements = document.getElementsByClassName('flexBox news');
        for (var element in newsElements) {
          if (element.attributes.containsKey('data-more')) {
            dataMore = int.tryParse(element.attributes['data-more'] ?? "0");
            break;
          }
        }

        final moreElement = document.getElementsByClassName('foot').first;
        for (var element in moreElement.children) {
          final attributes = element.getElementsByClassName('more').first;
          for (var element in attributes.children) {
            if (element.text.toLowerCase() == 'more') {
              morePages = true;
            } else if (element.text.toLowerCase() == 'maximum allowed') {
              morePages = false;
            }
            break;
          }
          break;
        }

        final metaTags = document.getElementsByTagName('meta');
        for (var element in metaTags) {
          if (element.attributes.containsValue('csrf-token')) {
            csrfToken = element.attributes['content'];
            break;
          }
        }

        var temp = document.getElementsByClassName('body flexposts').first;
        for (var element in temp.children) {
          final titleElement = element.getElementsByClassName('flexposts__story-title').first;

          String? newsUrlLink;
          for (var element in titleElement.getElementsByTagName('a')) {
            if (element.attributes.containsKey('href')) {
              newsUrlLink = element.attributes['href'];
            }
          }

          final title = titleElement.text;
          final detailPageUrl =
              element.getElementsByClassName('flexposts__story-title').first.getElementsByTagName('a').first.text;
          print('--> url $detailPageUrl');
          final description =
              element.getElementsByClassName('flexposts__storydisplay-info').first.getElementsByTagName('a').first.text;

          final time = element
              .getElementsByClassName('flexposts__storydisplay-info')
              .first
              .getElementsByClassName('flexposts__nowrap flexposts__time nowrap')
              .first
              .text;

          String? id = '';
          String? timestamp = '';
          if (element.attributes.containsKey('id')) {
            id = element.attributes['id'];
          }
          if (element.attributes.containsKey('data-timestamp')) {
            timestamp = element.attributes['data-timestamp'];
          }

          news.add(News(
              newsId: id,
              newsUrl: 'https://www.forexfactory.com${newsUrlLink?.trim()}',
              title: title.trim(),
              subTitle: description.trim(),
              time: time.trim(),
              timestamp: timestamp));
        }
        newsList = news;
      }
    } catch (e) {
      debugPrint('$e');
    } finally {
      newsGlobalLoading = false;
      if (context.mounted) setBusy(false);
    }
  }

  Future<void> getAlertsData(int dataRef) async {
    alertsLoader = true;
    alertList.clear();
    var temp;
    if (dataRef == 1) {
      temp = await fireStore.collection('Mt5_Data').doc('Trade_Signals').get();
    } else {
      temp = await fireStore.collection('Mt4_Data').doc('Trade_Signals').get();
    }
    Map<String, dynamic>? temp2 = temp.data();

    await temp2?['data'].map((e) => alertList.add(Alerts.fromJson(e)));
    print(temp2?['data'].map((e) => alertList.add(Alerts.fromJson(e))));

    print(alertList);

    alertsLoader = false;
    notifyListeners();
  }

  String? dateFormat(Timestamp? tme) {
    int timestamp = tme?.millisecondsSinceEpoch ?? 0; // Example timestamp

    // Convert timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('dd-MM-yyyy HH:MM').format(dateTime);

    return formattedDate;

    print('Timestamp: $timestamp');
    print('DateTime: $dateTime');
  }

  initLoadMore(BuildContext context) async {
    try {
      newsPaginationLoading = true;
      notifyListeners();

      var requestBody = {
        "_csrf": "$csrfToken",
        "securitytoken": "guest",
        "do": "saveoptions",
        "setdefault": "no",
        "ignoreinput": "no",
        "flex[News_newsLeft1][idSuffix]": "",
        "flex[News_newsLeft1][_flexForm_]": "flexForm",
        "flex[News_newsLeft1][news]": "all",
        "flex[News_newsLeft1][format]": "headline",
        "flex[News_newsLeft1][sort]": "latest"
      };

      final response = await http.Client()
          .post(Uri.parse('https://www.forexfactory.com/flex.php?more=$dataMore'), body: requestBody);

      List<News> news = <News>[];

      if (response.statusCode == 200) {
        final XmlDocument xmlDocument = XmlDocument.parse(response.body);
        // Find the 'flex' element
        var flexElement = xmlDocument.findElements('flex').first;
        // Get the CDATA section inside 'flex' element
        var cdata = flexElement.children.first as XmlCDATA;

        var document = parser.parse(cdata.value);
        final newsElements = document.getElementsByClassName('flexBox news');
        for (var element in newsElements) {
          if (element.attributes.containsKey('data-more')) {
            dataMore = int.tryParse(element.attributes['data-more'] ?? "0");
            break;
          }
        }

        final moreElement = document.getElementsByClassName('foot').first;
        for (var element in moreElement.children) {
          final attributes = element.getElementsByClassName('more').first;
          for (var element in attributes.children) {
            if (element.text.toLowerCase() == 'more') {
              morePages = true;
            } else if (element.text.toLowerCase() == 'maximum allowed') {
              morePages = false;
            }
            break;
          }
          break;
        }

        var temp = document.getElementsByClassName('body flexposts').first;
        for (var element in temp.children) {
          final titleElement = element.getElementsByClassName('flexposts__story-title').first;

          String? newsUrlLink;
          for (var element in titleElement.getElementsByTagName('a')) {
            if (element.attributes.containsKey('href')) {
              newsUrlLink = element.attributes['href'];
            }
          }

          final title = titleElement.text;
          final detailPageUrl =
              element.getElementsByClassName('flexposts__story-title').first.getElementsByTagName('a').first.text;
          print('url $detailPageUrl');
          final description =
              element.getElementsByClassName('flexposts__storydisplay-info').first.getElementsByTagName('a').first.text;
          final time = element
              .getElementsByClassName('flexposts__storydisplay-info')
              .first
              .getElementsByClassName('flexposts__nowrap flexposts__time nowrap')
              .first
              .text;
          String? id = '';
          String? timestamp = '';
          if (element.attributes.containsKey('id')) {
            id = element.attributes['id'];
          }
          if (element.attributes.containsKey('data-timestamp')) {
            timestamp = element.attributes['data-timestamp'];
          }

          final newsItem = News(
              newsId: id,
              newsUrl: 'https://www.forexfactory.com${newsUrlLink?.trim()}',
              title: title.trim(),
              subTitle: description.trim(),
              time: time.trim(),
              timestamp: timestamp);

          try {
            newsList.firstWhere((element) => element.newsId == newsItem.newsId);
          } catch (_) {
            news.add(newsItem);
          }
        }
        newsList.addAll(news);
      }
    } catch (e) {
      print('$e');
    } finally {
      newsPaginationLoading = false;
      if (context.mounted) setBusy(false);
    }
  }

  void logout(BuildContext context) async {
    await auth.signOut();
    if (auth.currentUser == null && context.mounted) {
      NavigationService.navigateToLogin(context);
    }
  }

  void navigateToDetailWebView(News? item, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(item!.newsUrl!))) {
      await launchUrl(Uri.parse(item!.newsUrl!));
    }
  }
}
