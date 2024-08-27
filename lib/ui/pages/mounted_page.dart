import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecalls/domain/models/sleeping_items.dart';
import 'package:freecalls/ui/pages/select_language_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MountedPage extends StatelessWidget {
  const MountedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectLanguagePage(),
            ),
            (route) => false);
      },
      child: Scaffold(
        body: ChangeNotifierProvider<MountedProvider>(
          create: (context) => MountedProvider(),
          child: const MountedPageContent(),
        ),
      ),
    );
  }
}

class MountedPageContent extends StatefulWidget {
  const MountedPageContent({
    super.key,
  });

  @override
  State<MountedPageContent> createState() => _MountedPageContentState();
}

class _MountedPageContentState extends State<MountedPageContent> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MountedProvider>(context);
    return SizedBox.expand(
      child: FutureBuilder(
          future: model.getImages(),
          builder: (context, snapshot) {
            return MountedPageImage(
              imagesList: model.sleepingList,
            );
          }),
    );
  }
}

class MountedPageImage extends StatefulWidget {
  final List<SleepingItem> imagesList;
  const MountedPageImage({
    super.key,
    required this.imagesList,
  });

  @override
  State<MountedPageImage> createState() => _MountedPageImageState();
}

class _MountedPageImageState extends State<MountedPageImage> {
  int _currentIndex = 0;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imagesList.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.imagesList.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: widget.imagesList[_currentIndex].photo!,
            fit: BoxFit.fill,
          )
        : const SizedBox();
  }
}

final class MountedProvider extends ChangeNotifier {
  List<SleepingItem> sleepingList = [];

  Future<void> getImages() async {
    try {
      await http
          .get(
        Uri.parse('https://kioskapi.pythonanywhere.com/api/photos/'),
      )
          .then((response) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        sleepingList = SleepingItemsList.fromJson(data).items;
      });
    } catch (e) {
      e;
    }
  }
}
