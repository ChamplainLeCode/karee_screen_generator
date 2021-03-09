///
///  @Author Champlain Marius Bakop
/// @email champlainmarius20@gmail.com
/// @github ChamplainLeCode
///
///Libirary for the Screen Generator in Karee core
///
library karee.screen.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/screen_generator.dart';

/// Builder for Karee core screens

Builder screenTracker(BuilderOptions options) {
  var builder = SharedPartBuilder([ScreenGenerator()], 'screen_tracker');
  return builder;
}
