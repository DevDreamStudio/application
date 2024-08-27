import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:freecalls/domain/models/home_items.dart';
import 'package:freecalls/domain/models/weather_data.dart';
import 'package:freecalls/ui/pages/select_language_page.dart';
import 'package:freecalls/ui/pages/settings_page.dart';
import 'package:freecalls/ui/pages/webview_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const inactivityDuration = Duration(seconds: 80);
    _timer = Timer(inactivityDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectLanguagePage()),
      );
    });
  }

  void _resetTimer() {
    _timer.cancel();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _resetTimer();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 84,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 48,
          ),
          actions: const <Widget>[
            ClockWidget(),
            SizedBox(width: 16),
          ],
          centerTitle: true,
        ),
        body: HomePageContent(
          action: _resetTimer,
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final Function action;
  const HomePageContent({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const FractionalOffset(0, .02),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ZoomTapAnimation(
              child: StreamBuilder(
                  stream: Stream.value(context.locale),
                  builder: (context, _) {
                    return Text(
                      'title'.tr(),
                      style: const TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                      ),
                    );
                  }),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(),
          child: const Align(
            alignment: FractionalOffset(.5, .1),
            child: HomePageWeatherWidget(),
          ),
        ),
        Align(
          alignment: const FractionalOffset(1, .04),
          child: HomePageSelectLanguageWidget(
            action: action,
          ),
        ),
        Align(
          alignment: const FractionalOffset(1, .7),
          child: ChangeNotifierProvider(
            create: (context) => HomeItemsProvider(),
            child: const HomePageLinks(),
          ),
        ),
      ],
    );
  }
}

class HomePageWeatherWidget extends StatelessWidget {
  const HomePageWeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WeatherProvider>(context);
    return Container(
      padding: const EdgeInsets.all(32),
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder(
            future: context.read<WeatherProvider>().getWeather(context),
            builder: (context, snapshot) {
              return SizedBox(
                child: snapshot.connectionState == ConnectionState.done
                    ? ZoomTapAnimation(
                        child: Center(
                          child: SizedBox(
                            width: 160,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.weatherData?.main?.temp != null
                                      ? '${model.weatherData?.main?.temp?.round()}'
                                      : 'E',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontSize: 92,
                                    color: Colors.white,
                                    height: 1,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                                Text(
                                  '°C',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.grey.shade100,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 130,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _currentTime = '';
  Timer? _timer;
  Timer? pressedTimer;

  // ignore: unused_field
  bool _isPressed = false;
  void _startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isPressed = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm').format(DateTime.now());
    });

    _timer = Timer(const Duration(seconds: 1), _updateTime);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _cancelTimer() {
    pressedTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
          _startTimer();
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          _cancelTimer();
        });
      },
      child: Text(
        _currentTime,
        style: const TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class WeatherProvider extends ChangeNotifier {
  WeatherData? weatherData;

  String? weatherIcon;

  Future<WeatherData?> getWeather(BuildContext context) async {
    try {
      await http
          .get(
        Uri(
            scheme: 'https',
            host: 'api.openweathermap.org',
            path: 'data/2.5/weather',
            queryParameters: {
              'q': 'Tashkent',
              'appid': '49cc8c821cd2aff9af04c9f98c36eb74',
              'lang': '${context.locale}',
              'units': 'metric',
            }),
      )
          .then((value) {
        final data = json.decode(utf8.decode(value.bodyBytes));
        weatherData = WeatherData.fromJson(data);
        weatherIcon = weatherData?.weather?[0].icon;

        return weatherData;
      });
    } catch (e) {
      e;
    }
    return null;
  }
}

class HomePageSelectLanguageWidget extends StatelessWidget {
  final Function action;
  const HomePageSelectLanguageWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> languagesItems = [
      {'flag': FlagsCode.UZ, "title": 'O\'zbek', "code": 'uz'},
      {'flag': FlagsCode.RU, "title": 'Русский', "code": 'ru'},
      {'flag': FlagsCode.US, "title": 'English', "code": 'en'},
    ];
    List<Widget> items = List.generate(languagesItems.length, (index) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: ZoomTapAnimation(
          onTap: () {
            action();
            context.setLocale(Locale(languagesItems[index]['code']));
          },
          child: SizedBox(
            width: 80,
            height: 65,
            child: Flag.fromCode(
              languagesItems[index]['flag'],
              fit: BoxFit.cover,
              borderRadius: 10,
            ),
          ),
        ),
      );
    });
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: 100,
      height: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    );
  }
}

class HomePageLinks extends StatelessWidget {
  const HomePageLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeItemsProvider>(context);
    return SizedBox(
      height: 600,
      child: FutureBuilder(
        future: model.getHomeItems(context),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 220,
                    mainAxisSpacing: 40,
                    crossAxisSpacing: 40,
                  ),
                  itemCount: model.items.length,
                  itemBuilder: (_, i) => ZoomTapAnimation(
                    onTap: () async {
                      try {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              url: model.items[i].link ?? '',
                            ),
                          ),
                        );
                      } catch (e) {
                        e;
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Image.network(
                              model.items[i].photo ?? "Error",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            model.items[i].title ?? 'Error',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
        },
      ),
    );
  }
}

final class HomeItemsProvider extends ChangeNotifier {
  List<HomeItem> items = [];

  Future<void> getHomeItems(BuildContext context) async {
    try {
      await http
          .get(Uri.parse('https://kioskapi.pythonanywhere.com/api/links/'))
          .then((value) {
        final data = json.decode(utf8.decode(value.bodyBytes));
        items = HomeItemsList.fromJson(data).items;
        items.add(
          HomeItem.fromJson(
            {
              "pk": 1,
              "title": "Yandex",
              "link": "https://yandex.com/maps/?lang=${context.locale}",
              "photo":
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Yandex_Maps_icon.svg/1200px-Yandex_Maps_icon.svg.png"
            },
          ),
        );
      });
    } catch (e) {
      items.add(
        HomeItem.fromJson(
          {
            "pk": 1,
            "title": "Yandex",
            "link": "https://yandex.com/maps/?lang=${context.locale}",
            "photo":
                "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Yandex_Maps_icon.svg/1200px-Yandex_Maps_icon.svg.png"
          },
        ),
      );
    }
  }
}
