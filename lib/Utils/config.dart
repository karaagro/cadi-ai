import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  static Map? _pubspecYamlMap;

  static Future<Map> _getPubspecYamlMap() async {
    if (_pubspecYamlMap == null) {
      final String yamlString =
          await rootBundle.loadString('pubspec.yaml', cache: false);
      _pubspecYamlMap = loadYaml(yamlString);
    }
    return _pubspecYamlMap!;
  }

  static Future<String> getVersion() async {
    final pubspecYamlMap = await _getPubspecYamlMap();
    return pubspecYamlMap['version'].toString().split('+').first;
  }
}
