library karee.screen.generator;

import 'dart:io';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:screen_tracker/screen_tracker.dart' show Screen;

///
/// @Author Champlain Marius Bakop
/// @email champlainmarius20@gmail.com
/// @github ChamplainLeCode
///
///
///ScreenGenerator for Karee core Screen
class ScreenGenerator extends GeneratorForAnnotation<Screen> {
  @override
  dynamic generateForAnnotatedElement(
      var element, ConstantReader annotation, BuildStep buildStep) {
    String source = element.metadata[0].toSource();
    var sourceElement = element.source;
    if(sourceElement != null){

      String sh = sourceElement.shortName, ex = buildStep.inputId.extension;

      print("\n\n########################META FIRST\n\n####################");
      var annotation = element.metadata.first.computeConstantValue();

      print(source);
      print("\n\n########################\n#${annotation?.getField('name')??'No_name'}\n################");
      generatedScreens.putIfAbsent(
          annotation?.getField('name')?.toStringValue() ?? 'NO_NAME',
          // source.substring(source.indexOf("'") + 1, source.lastIndexOf("'")),
          () => {
                #uri: sourceElement.uri.toString(),
                #className: "${underscoreToCambel(sh.replaceAll(ex, ''))}()",
                #initial: annotation?.getField('isInitial')?.toBoolValue() ?? false
              });
      writeMap();
    }
  }

  String cambelToUnderscore([String name = '']) {
    var response = '';
    for (var index = 0; index < name.length; index++) {
      var char = name[index];
      if (isUpper(char)) {
        response = response + (index == 0 ? '' : '_') + char.toLowerCase();
      } else {
        response = response + char;
      }
    }
    return response;
  }

  String underscoreToCambel([String name = '']) {
    var response = '';
    for (var index = 0; index < name.length; index++) {
      var char = name[index];
      char = index == 0 && !isUpper(char) ? char.toUpperCase() : char;
      if (char == '_') {
        response = response +
            (index + 1 < name.length ? name[index + 1].toUpperCase() : '');
        index++;
      } else {
        response = response + char;
      }
    }
    return response;
  }

  bool isUpper([String char = '']) {
    if (char.isEmpty) return false;
    return char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90;
  }
}

Map<String, Map<Symbol, dynamic>> generatedScreens = {};

writeMap() async {
  File f = File("lib/app/screens.dart");
  String content =
      """\n/*\n *\t\n@Author Champlain Marius Bakop\n@Email champlainmarius20@gmail.com\n@github ChamplainLeCode */\n\n\nList<Map<Symbol, dynamic>> screens = [\n""";
  generatedScreens.forEach((String annotation, Map<Symbol, dynamic> data) {
    if (data[#initial])
      content =
          """import '${data[#uri]}';\n$content\n\t{#name: '$annotation', #screen: () => ${data[#className]}, #initial: ${data[#initial]}},""";
    else
      content =
          """import '${data[#uri]}';\n$content\n\t{#name: '$annotation', #screen: () => ${data[#className]}},""";
  });
  content = "$content\n\n];";
  await f.writeAsString(content, mode: FileMode.write);
}
