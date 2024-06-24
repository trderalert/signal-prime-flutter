import 'package:base_setup/data/models/news.model.dart';
import 'package:base_setup/data/viewmodels/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class NewsDetailViewModel extends BaseViewModel {
  NewsDetailViewModel({this.news});

  final News? news;

  InAppWebViewController? viewController;

  bool isLoad = false;
  int isLoadProgress = 0;

  final GlobalKey webViewKey = GlobalKey();

  String url = '';
  String title = '';
  double progress = 0;
  bool? isSecure;
  InAppWebViewController? webViewController;

  ///
  static ChangeNotifierProvider<NewsDetailViewModel> buildWithProvider({
    required Widget Function(BuildContext context, Widget? child)? builder,
    Widget? child,
    News? news,
  }) {
    return ChangeNotifierProvider<NewsDetailViewModel>(
      create: (BuildContext context) =>
          NewsDetailViewModel(news: news)..init(context),
      builder: builder,
      lazy: false,
      child: child,
    );
  }

  init(BuildContext context) {
    setBusy(false);
  }

  void updateProgress(int progress) {
    isLoadProgress = progress;
    notifyListeners();
  }

  void updateController(InAppWebViewController controller) {
    webViewController = controller;
    notifyListeners();
  }

  @override
  void dispose() {
    viewController?.dispose();
    super.dispose();
  }
}
