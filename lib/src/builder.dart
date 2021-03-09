library karee.screen.generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'screen_generator.dart';

///
///  @Author Champlain Marius Bakop
/// @email champlainmarius20@gmail.com
/// @github ChamplainLeCode
///
///
/// Builder for Karee core screens

Builder screenTracker(BuilderOptions options) {
  var builder = SharedPartBuilder([ScreenGenerator()], 'screen_tracker');
  return builder;
}
