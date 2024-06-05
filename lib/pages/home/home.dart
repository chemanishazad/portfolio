import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_portfolio/core/utils/globals.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/pages/home/components/about.dart';
import 'package:my_portfolio/pages/home/components/carousel.dart';
import 'package:my_portfolio/pages/home/components/footer.dart';
import 'package:my_portfolio/pages/home/components/header.dart';
import 'package:my_portfolio/pages/home/components/portfolio_stats.dart';
import 'package:my_portfolio/pages/home/components/service.dart';
import 'package:my_portfolio/provider/amplitutde.dart';
import 'package:my_portfolio/provider/home.dart';
import 'package:my_portfolio/provider/theme.dart';
import 'package:my_portfolio/widgets/switch.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  late HomeProvider _homeProvider;
  late AmplitutdeProvider _amplitutdeProvider;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _homeProvider = ref.read(homeProvider);
    _amplitutdeProvider = ref.read(amplitudeProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(seconds: 2), () async {
        _amplitutdeProvider.logStartupEvent();
        await _amplitutdeProvider.logAScreen("home");
      });
    });
    super.initState();
  }

  Widget _buildPage() {
    return Stack(
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenHelper.isDesktop(context) ? 30 : 20,
                ),
                Carousel(
                  key: _homeProvider.homeKey,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AboutSection(
                  key: _homeProvider.aboutKey,
                ),
                ServiceSection(
                  key: _homeProvider.servicesKey,
                ),
                SizedBox(
                  key: _homeProvider.portfolioKey,
                  height: 100.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28.0),
                  child: PortfolioStats(),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Footer(
                  key: _homeProvider.contactKey,
                )
              ],
            ),
          ),
        ),
        Header(
          themeSwitch: ThemeSwitcher(
              clipper: const ThemeSwitcherBoxClipper(),
              builder: (context) {
                return CustomSwitch(
                  value: ref.watch(themeProvider).isDarkMode,
                  onChanged: (val) {
                    ref.read(themeProvider).changeTheme(val);
                    ThemeSwitcher.of(context).changeTheme(
                        theme: ref.read(themeProvider).getCurrentTheme,
                        isReversed: false // default: false
                        );
                  },
                );
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        key: Globals.scaffoldKey,
        endDrawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      if (Globals.scaffoldKey.currentState != null) {
                        if (Globals.scaffoldKey.currentState!.isEndDrawerOpen) {
                          Navigator.pop(context);
                          _homeProvider.scrollBasedOnHeader(
                              HeaderRow.headerItems[index]);
                        }
                      }
                    },
                    leading: Icon(
                      HeaderRow.headerItems[index].iconData,
                    ),
                    title: Text(
                      HeaderRow.headerItems[index].title,
                      style: const TextStyle(),
                    ),
                    trailing: HeaderRow.headerItems[index].isDarkTheme != null
                        ? HeaderRow.headerItems[index].isDarkTheme!
                            ? SizedBox(
                                width: 50,
                                child: CustomSwitch(
                                  value: ref.watch(themeProvider).isDarkMode,
                                  onChanged: (val) {
                                    ref.read(themeProvider).changeTheme(val);
                                    ThemeSwitcher.of(context).changeTheme(
                                        theme: ref
                                            .read(themeProvider)
                                            .getCurrentTheme,
                                        isReversed: false // default: false
                                        );
                                  },
                                ),
                              )
                            : null
                        : null,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10.0,
                  );
                },
                itemCount: HeaderRow.headerItems.length,
              ),
            ),
          ),
        ),
        body: _buildPage(),
      ),
    );
  }
}
