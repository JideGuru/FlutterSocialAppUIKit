import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop/rails_page.dart';
import 'mobile/tabs_page.dart';

class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: TabsPage(),
      desktop: RailsPage(),
      tablet: RailsPage(),
    );
  }
}
