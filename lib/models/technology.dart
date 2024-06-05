import 'package:my_portfolio/core/utils/constants.dart';

class TechnologyModel {
  final String name;
  final String logo;

  TechnologyModel(this.name, this.logo);
}

class TechnologyConstants {
  static TechnologyModel flutter =
      TechnologyModel("Flutter", AppConstants.flutterImage);

  static TechnologyModel firebase =
      TechnologyModel("Firebase", AppConstants.firebaseImage);
  static TechnologyModel razorPay =
      TechnologyModel("Razor Pay", AppConstants.razorPayImage);
  static TechnologyModel cPlus =
      TechnologyModel("Mysql", AppConstants.cPlusImage);

  static TechnologyModel swift =
      TechnologyModel("Figma", AppConstants.swiftImage);

  static List<TechnologyModel> technologyLearned = [
    flutter,
    firebase,
    swift,
    razorPay,
    cPlus,
  ];
}
