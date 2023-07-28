// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:exif/exif.dart';
import 'package:cadi_ai/entities/history.dart';

double getLatitude(int degrees, int minutes, double seconds, String reference) {
  var decimalDegrees = (degrees + (minutes / 60) + (seconds / 3600)).toDouble();
  return reference == 'S' ? -1 * decimalDegrees : decimalDegrees;
}

double getLongitude(int degrees, int minutes, double seconds, reference) {
  var decimalDegrees = (degrees + (minutes / 60) + (seconds / 3600)).toDouble();
  return reference == 'W' ? -1 * decimalDegrees : decimalDegrees;
}

Future<Map<String, double>> getCoordinatesOfImage(String path) async {
  final fileBytes = File(path).readAsBytesSync();
  final data = await readExifFromBytes(fileBytes, details: false);

  if (data.isEmpty) {
    return {};
  }

  IfdTag? latRef;
  IfdTag? longRef;
  IfdTag? lat;
  IfdTag? long;

  for (final entry in data.entries) {
    var latRefKey = "GPS GPSLatitudeRef";
    var longRefKey = "GPS GPSLongitudeRef";
    var latKey = "GPS GPSLatitude";
    var longKey = "GPS GPSLongitude";

    if (entry.key == latRefKey) {
      latRef = entry.value;
    } else if (entry.key == longRefKey) {
      longRef = entry.value;
    } else if (entry.key == latKey) {
      lat = entry.value;
    } else if (entry.key == longKey) {
      long = entry.value;
    }
  }

  if (latRef != null && longRef != null && lat != null && long != null) {
    var latValues = lat.values.toList();
    var longValues = long.values.toList();
    var latDecimalDegrees = getLatitude(latValues[0].toInt(),
        latValues[1].toInt(), latValues[2].toDouble(), latRef.toString());
    var longDecimalDegrees = getLongitude(longValues[0].toInt(),
        longValues[1].toInt(), longValues[2].toDouble(), longRef.toString());

    return {"lat": latDecimalDegrees, "long": longDecimalDegrees};
  }

  return {};
}

Future<Map<String, String>> getDateOfImage(String path) async {
  final fileBytes = File(path).readAsBytesSync();
  final data = await readExifFromBytes(fileBytes, details: false);

  if (data.isEmpty) {
    return {};
  }

  IfdTag? date;

  for (final entry in data.entries) {
    var dateKey = "Image DateTime";

    if (entry.key == dateKey) {
      date = entry.value;
    }
  }

  if (date != null) {
    return {"date": date.toString()};
  }

  return {};
}

getTotalConditionCounts(List<Map<String, int>> conditionCounters) {
  int totalAbioticCount = conditionCounters
      .map((counts) => counts[abioticCountKey])
      .fold(0, (prev, curr) => prev + curr!);

  int totalDiseasedCount = conditionCounters
      .map((counts) => counts[diseasedCountKey])
      .fold(0, (prev, curr) => prev + curr!);

  int totalPestCount = conditionCounters
      .map((counts) => counts[pestCountKey])
      .fold(0, (prev, curr) => prev + curr!);

  int totalConditionsCount = conditionCounters
      .map((counts) => counts[conditionsCountKey])
      .fold(0, (prev, curr) => prev + curr!);

  return {
    conditionsCountKey: totalConditionsCount,
    abioticCountKey: totalAbioticCount,
    diseasedCountKey: totalDiseasedCount,
    pestCountKey: totalPestCount
  };
}

Map<String, int> getConditionCounts(var decodedConditions) {
  var conditionsFound = 0;
  int abioticCount = 0;
  int diseasedCount = 0;
  int pestCount = 0;
  for (var condition in decodedConditions) {
    conditionsFound++;
    switch (condition['name']) {
      case 'abiotic':
        abioticCount += 1;
        break;
      case 'disease':
        diseasedCount += 1;
        break;
      case 'insect':
        pestCount += 1;
        break;
    }
  }
  return {
    conditionsCountKey: conditionsFound,
    abioticCountKey: abioticCount,
    diseasedCountKey: diseasedCount,
    pestCountKey: pestCount
  };
}

int getTotalCropStressFromHistory(List<History>? allHistory) {
  int? totalFoundCropStress = allHistory?.fold(
      0, (prev, currHistory) => prev! + currHistory.totalConditionsCount);
  return (totalFoundCropStress == null) ? 0 : totalFoundCropStress;
}

const DISEASED_FILTER = "isDiseased";
const ABIOTIC_FILTER = "isAbiotic";
const PEST_FILTER = "isPest";

const conditionsCountKey = 'conditionsCount';
const abioticCountKey = 'abioticCount';
const diseasedCountKey = 'diseasedCount';
const pestCountKey = 'pestCount';
