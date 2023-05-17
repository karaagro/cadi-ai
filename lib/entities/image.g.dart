// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetImageCollection on Isar {
  IsarCollection<Image> get images => getCollection();
}

const ImageSchema = CollectionSchema(
  name: 'Image',
  schema:
      '{"name":"Image","idName":"id","properties":[{"name":"conditionsCount","type":"Long"},{"name":"historyId","type":"Long"},{"name":"imageDate","type":"String"},{"name":"isAbiotic","type":"Bool"},{"name":"isDiseased","type":"Bool"},{"name":"isPest","type":"Bool"},{"name":"latCoordinates","type":"Double"},{"name":"longCoordinates","type":"Double"},{"name":"scanImage","type":"ByteList"},{"name":"timestamp","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'conditionsCount': 0,
    'historyId': 1,
    'imageDate': 2,
    'isAbiotic': 3,
    'isDiseased': 4,
    'isPest': 5,
    'latCoordinates': 6,
    'longCoordinates': 7,
    'scanImage': 8,
    'timestamp': 9
  },
  listProperties: {'scanImage'},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _imageGetId,
  setId: _imageSetId,
  getLinks: _imageGetLinks,
  attachLinks: _imageAttachLinks,
  serializeNative: _imageSerializeNative,
  deserializeNative: _imageDeserializeNative,
  deserializePropNative: _imageDeserializePropNative,
  serializeWeb: _imageSerializeWeb,
  deserializeWeb: _imageDeserializeWeb,
  deserializePropWeb: _imageDeserializePropWeb,
  version: 3,
);

int? _imageGetId(Image object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _imageSetId(Image object, int id) {
  object.id = id;
}

List<IsarLinkBase> _imageGetLinks(Image object) {
  return [];
}

void _imageSerializeNative(
    IsarCollection<Image> collection,
    IsarRawObject rawObj,
    Image object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.conditionsCount;
  final _conditionsCount = value0;
  final value1 = object.historyId;
  final _historyId = value1;
  final value2 = object.imageDate;
  final _imageDate = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_imageDate.length) as int;
  final value3 = object.isAbiotic;
  final _isAbiotic = value3;
  final value4 = object.isDiseased;
  final _isDiseased = value4;
  final value5 = object.isPest;
  final _isPest = value5;
  final value6 = object.latCoordinates;
  final _latCoordinates = value6;
  final value7 = object.longCoordinates;
  final _longCoordinates = value7;
  final value8 = object.scanImage;
  dynamicSize += (value8.length) * 1;
  final _scanImage = value8;
  final value9 = object.timestamp;
  final _timestamp = value9;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _conditionsCount);
  writer.writeLong(offsets[1], _historyId);
  writer.writeBytes(offsets[2], _imageDate);
  writer.writeBool(offsets[3], _isAbiotic);
  writer.writeBool(offsets[4], _isDiseased);
  writer.writeBool(offsets[5], _isPest);
  writer.writeDouble(offsets[6], _latCoordinates);
  writer.writeDouble(offsets[7], _longCoordinates);
  writer.writeBytes(offsets[8], _scanImage);
  writer.writeDateTime(offsets[9], _timestamp);
}

Image _imageDeserializeNative(IsarCollection<Image> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Image(
    conditionsCount: reader.readLong(offsets[0]),
    historyId: reader.readLong(offsets[1]),
    imageDate: reader.readString(offsets[2]),
    isAbiotic: reader.readBool(offsets[3]),
    isDiseased: reader.readBool(offsets[4]),
    isPest: reader.readBool(offsets[5]),
    latCoordinates: reader.readDouble(offsets[6]),
    longCoordinates: reader.readDouble(offsets[7]),
    scanImage: reader.readBytes(offsets[8]),
  );
  object.id = id;
  object.timestamp = reader.readDateTime(offsets[9]);
  return object;
}

P _imageDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readBytes(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _imageSerializeWeb(IsarCollection<Image> collection, Image object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'conditionsCount', object.conditionsCount);
  IsarNative.jsObjectSet(jsObj, 'historyId', object.historyId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'imageDate', object.imageDate);
  IsarNative.jsObjectSet(jsObj, 'isAbiotic', object.isAbiotic);
  IsarNative.jsObjectSet(jsObj, 'isDiseased', object.isDiseased);
  IsarNative.jsObjectSet(jsObj, 'isPest', object.isPest);
  IsarNative.jsObjectSet(jsObj, 'latCoordinates', object.latCoordinates);
  IsarNative.jsObjectSet(jsObj, 'longCoordinates', object.longCoordinates);
  IsarNative.jsObjectSet(jsObj, 'scanImage', object.scanImage);
  IsarNative.jsObjectSet(
      jsObj, 'timestamp', object.timestamp.toUtc().millisecondsSinceEpoch);
  return jsObj;
}

Image _imageDeserializeWeb(IsarCollection<Image> collection, dynamic jsObj) {
  final object = Image(
    conditionsCount: IsarNative.jsObjectGet(jsObj, 'conditionsCount') ??
        double.negativeInfinity,
    historyId:
        IsarNative.jsObjectGet(jsObj, 'historyId') ?? double.negativeInfinity,
    imageDate: IsarNative.jsObjectGet(jsObj, 'imageDate') ?? '',
    isAbiotic: IsarNative.jsObjectGet(jsObj, 'isAbiotic') ?? false,
    isDiseased: IsarNative.jsObjectGet(jsObj, 'isDiseased') ?? false,
    isPest: IsarNative.jsObjectGet(jsObj, 'isPest') ?? false,
    latCoordinates: IsarNative.jsObjectGet(jsObj, 'latCoordinates') ??
        double.negativeInfinity,
    longCoordinates: IsarNative.jsObjectGet(jsObj, 'longCoordinates') ??
        double.negativeInfinity,
    scanImage: IsarNative.jsObjectGet(jsObj, 'scanImage') ?? Uint8List(0),
  );
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.timestamp = IsarNative.jsObjectGet(jsObj, 'timestamp') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'timestamp'),
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  return object;
}

P _imageDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'conditionsCount':
      return (IsarNative.jsObjectGet(jsObj, 'conditionsCount') ??
          double.negativeInfinity) as P;
    case 'historyId':
      return (IsarNative.jsObjectGet(jsObj, 'historyId') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'imageDate':
      return (IsarNative.jsObjectGet(jsObj, 'imageDate') ?? '') as P;
    case 'isAbiotic':
      return (IsarNative.jsObjectGet(jsObj, 'isAbiotic') ?? false) as P;
    case 'isDiseased':
      return (IsarNative.jsObjectGet(jsObj, 'isDiseased') ?? false) as P;
    case 'isPest':
      return (IsarNative.jsObjectGet(jsObj, 'isPest') ?? false) as P;
    case 'latCoordinates':
      return (IsarNative.jsObjectGet(jsObj, 'latCoordinates') ??
          double.negativeInfinity) as P;
    case 'longCoordinates':
      return (IsarNative.jsObjectGet(jsObj, 'longCoordinates') ??
          double.negativeInfinity) as P;
    case 'scanImage':
      return (IsarNative.jsObjectGet(jsObj, 'scanImage') ?? Uint8List(0)) as P;
    case 'timestamp':
      return (IsarNative.jsObjectGet(jsObj, 'timestamp') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'timestamp'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _imageAttachLinks(IsarCollection col, int id, Image object) {}

extension ImageQueryWhereSort on QueryBuilder<Image, Image, QWhere> {
  QueryBuilder<Image, Image, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension ImageQueryWhere on QueryBuilder<Image, Image, QWhereClause> {
  QueryBuilder<Image, Image, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Image, Image, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Image, Image, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Image, Image, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Image, Image, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension ImageQueryFilter on QueryBuilder<Image, Image, QFilterCondition> {
  QueryBuilder<Image, Image, QAfterFilterCondition> conditionsCountEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'conditionsCount',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> conditionsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'conditionsCount',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> conditionsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'conditionsCount',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> conditionsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'conditionsCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> historyIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'historyId',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> historyIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'historyId',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> historyIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'historyId',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> historyIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'historyId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'imageDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'imageDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'imageDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'imageDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'imageDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'imageDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'imageDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> imageDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'imageDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> isAbioticEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isAbiotic',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> isDiseasedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isDiseased',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> isPestEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isPest',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> latCoordinatesGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'latCoordinates',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> latCoordinatesLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'latCoordinates',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> latCoordinatesBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'latCoordinates',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> longCoordinatesGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'longCoordinates',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> longCoordinatesLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'longCoordinates',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> longCoordinatesBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'longCoordinates',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'timestamp',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'timestamp',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'timestamp',
      value: value,
    ));
  }

  QueryBuilder<Image, Image, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'timestamp',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension ImageQueryLinks on QueryBuilder<Image, Image, QFilterCondition> {}

extension ImageQueryWhereSortBy on QueryBuilder<Image, Image, QSortBy> {
  QueryBuilder<Image, Image, QAfterSortBy> sortByConditionsCount() {
    return addSortByInternal('conditionsCount', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByConditionsCountDesc() {
    return addSortByInternal('conditionsCount', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByHistoryId() {
    return addSortByInternal('historyId', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByHistoryIdDesc() {
    return addSortByInternal('historyId', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByImageDate() {
    return addSortByInternal('imageDate', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByImageDateDesc() {
    return addSortByInternal('imageDate', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIsAbiotic() {
    return addSortByInternal('isAbiotic', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIsAbioticDesc() {
    return addSortByInternal('isAbiotic', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIsDiseased() {
    return addSortByInternal('isDiseased', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIsDiseasedDesc() {
    return addSortByInternal('isDiseased', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIsPest() {
    return addSortByInternal('isPest', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByIsPestDesc() {
    return addSortByInternal('isPest', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByLatCoordinates() {
    return addSortByInternal('latCoordinates', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByLatCoordinatesDesc() {
    return addSortByInternal('latCoordinates', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByLongCoordinates() {
    return addSortByInternal('longCoordinates', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByLongCoordinatesDesc() {
    return addSortByInternal('longCoordinates', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByTimestamp() {
    return addSortByInternal('timestamp', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> sortByTimestampDesc() {
    return addSortByInternal('timestamp', Sort.desc);
  }
}

extension ImageQueryWhereSortThenBy on QueryBuilder<Image, Image, QSortThenBy> {
  QueryBuilder<Image, Image, QAfterSortBy> thenByConditionsCount() {
    return addSortByInternal('conditionsCount', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByConditionsCountDesc() {
    return addSortByInternal('conditionsCount', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByHistoryId() {
    return addSortByInternal('historyId', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByHistoryIdDesc() {
    return addSortByInternal('historyId', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByImageDate() {
    return addSortByInternal('imageDate', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByImageDateDesc() {
    return addSortByInternal('imageDate', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIsAbiotic() {
    return addSortByInternal('isAbiotic', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIsAbioticDesc() {
    return addSortByInternal('isAbiotic', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIsDiseased() {
    return addSortByInternal('isDiseased', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIsDiseasedDesc() {
    return addSortByInternal('isDiseased', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIsPest() {
    return addSortByInternal('isPest', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByIsPestDesc() {
    return addSortByInternal('isPest', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByLatCoordinates() {
    return addSortByInternal('latCoordinates', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByLatCoordinatesDesc() {
    return addSortByInternal('latCoordinates', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByLongCoordinates() {
    return addSortByInternal('longCoordinates', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByLongCoordinatesDesc() {
    return addSortByInternal('longCoordinates', Sort.desc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByTimestamp() {
    return addSortByInternal('timestamp', Sort.asc);
  }

  QueryBuilder<Image, Image, QAfterSortBy> thenByTimestampDesc() {
    return addSortByInternal('timestamp', Sort.desc);
  }
}

extension ImageQueryWhereDistinct on QueryBuilder<Image, Image, QDistinct> {
  QueryBuilder<Image, Image, QDistinct> distinctByConditionsCount() {
    return addDistinctByInternal('conditionsCount');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByHistoryId() {
    return addDistinctByInternal('historyId');
  }

  QueryBuilder<Image, Image, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByImageDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('imageDate', caseSensitive: caseSensitive);
  }

  QueryBuilder<Image, Image, QDistinct> distinctByIsAbiotic() {
    return addDistinctByInternal('isAbiotic');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByIsDiseased() {
    return addDistinctByInternal('isDiseased');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByIsPest() {
    return addDistinctByInternal('isPest');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByLatCoordinates() {
    return addDistinctByInternal('latCoordinates');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByLongCoordinates() {
    return addDistinctByInternal('longCoordinates');
  }

  QueryBuilder<Image, Image, QDistinct> distinctByTimestamp() {
    return addDistinctByInternal('timestamp');
  }
}

extension ImageQueryProperty on QueryBuilder<Image, Image, QQueryProperty> {
  QueryBuilder<Image, int, QQueryOperations> conditionsCountProperty() {
    return addPropertyNameInternal('conditionsCount');
  }

  QueryBuilder<Image, int, QQueryOperations> historyIdProperty() {
    return addPropertyNameInternal('historyId');
  }

  QueryBuilder<Image, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Image, String, QQueryOperations> imageDateProperty() {
    return addPropertyNameInternal('imageDate');
  }

  QueryBuilder<Image, bool, QQueryOperations> isAbioticProperty() {
    return addPropertyNameInternal('isAbiotic');
  }

  QueryBuilder<Image, bool, QQueryOperations> isDiseasedProperty() {
    return addPropertyNameInternal('isDiseased');
  }

  QueryBuilder<Image, bool, QQueryOperations> isPestProperty() {
    return addPropertyNameInternal('isPest');
  }

  QueryBuilder<Image, double, QQueryOperations> latCoordinatesProperty() {
    return addPropertyNameInternal('latCoordinates');
  }

  QueryBuilder<Image, double, QQueryOperations> longCoordinatesProperty() {
    return addPropertyNameInternal('longCoordinates');
  }

  QueryBuilder<Image, Uint8List, QQueryOperations> scanImageProperty() {
    return addPropertyNameInternal('scanImage');
  }

  QueryBuilder<Image, DateTime, QQueryOperations> timestampProperty() {
    return addPropertyNameInternal('timestamp');
  }
}
