import 'package:auto_route/auto_route.dart';
import 'package:base_setup/data/models/news.model.dart';
import 'package:base_setup/data/viewmodels/news_detail.viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'newsDetailViewScreen')
class NewsDetailViewScreen extends StatelessWidget {
  const NewsDetailViewScreen({super.key, this.news});

  final News? news;

  @override
  Widget build(BuildContext context) {
    return NewsDetailViewModel.buildWithProvider(
        builder: (_, __) {
          return const NewsDetailWebView();
        },
        news: news);
  }
}

class NewsDetailWebView extends StatelessWidget {
  const NewsDetailWebView({super.key});

  @override
  Widget build(BuildContext context) {
    NewsDetailViewModel model = Provider.of<NewsDetailViewModel>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        final canGoBack = await model.viewController?.canGoBack();
        if (canGoBack == true) {
          model.viewController?.goBack();
        } else {
          if (context.mounted) Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            InAppWebView(
              key: model.webViewKey,
              initialUrlRequest:
                  URLRequest(url: WebUri(model.news?.newsUrl ?? '')),
              initialSettings: InAppWebViewSettings(
                allowContentAccess: true,
                allowFileAccess: true,
              ),
              onProgressChanged: (controller, progress) {
                model.updateProgress(progress);
              },
              onWebViewCreated: (controller) async {
                model.updateController(controller);
                if (!kIsWeb &&
                    defaultTargetPlatform == TargetPlatform.android) {
                  await controller.startSafeBrowsing();
                }
              },
              onReceivedServerTrustAuthRequest:
                  (controller, challenge) async {
                return ServerTrustAuthResponse(
                    action: ServerTrustAuthResponseAction.PROCEED);
              },
            ),
            Visibility(
              visible: model.isLoadProgress != 100,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
