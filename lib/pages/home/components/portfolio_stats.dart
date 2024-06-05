import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/core/utils/screen_helper.dart';
import 'package:my_portfolio/models/stat.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';

final List<Stat> stats = [
  Stat(count: "6+", text: "Projects"),
  Stat(
      count: (DateTime.now().year - 2021).toString(),
      text: "Years\nExperience"),
];

class PortfolioStats extends StatefulWidget {
  const PortfolioStats({super.key});

  @override
  _PortfolioStatsState createState() => _PortfolioStatsState();
}

class _PortfolioStatsState extends State<PortfolioStats>
    with TickerProviderStateMixin {
  late AnimationController _projectsController;
  late Animation<int> _projectsAnimation;
  late AnimationController _yearsController;
  late Animation<int> _yearsAnimation;

  @override
  void initState() {
    super.initState();
    _projectsController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _projectsAnimation = IntTween(begin: 0, end: 6).animate(_projectsController)
      ..addListener(() {
        setState(() {});
      });

    _yearsController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _yearsAnimation = IntTween(begin: 0, end: DateTime.now().year - 2021)
        .animate(_yearsController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _projectsController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  void _runAnimation() {
    if (!_projectsController.isAnimating &&
        _projectsController.status != AnimationStatus.completed) {
      _projectsController.forward();
    }
    if (!_yearsController.isAnimating &&
        _yearsController.status != AnimationStatus.completed) {
      _yearsController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return VisibilityDetector(
      key: Key('portfolio-stats-visibility-detector'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1) {
          _runAnimation();
        }
      },
      child: Container(
        child: ResponsiveWrapper(
          maxWidth: width,
          minWidth: width,
          defaultScale: false,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
              return Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: stats.map((stat) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    width: ScreenHelper.isMobile(context)
                        ? constraint.maxWidth / 2.0 - 20
                        : (constraint.maxWidth / 4.0 - 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // Check if the stat is for projects or years to animate it
                          stat.text.contains('Projects')
                              ? '${_projectsAnimation.value}+'
                              : stat.text.contains('Experience')
                                  ? '${_yearsAnimation.value}'
                                  : stat.count,
                          style: GoogleFonts.josefinSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 32.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          stat.text,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: kCaptionColor,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
