// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetHistoryCollection on Isar {
  IsarCollection<History> get historys => getCollection();
}

const HistorySchema = CollectionSchema(
  name: 'History',
  schema:
      '{"name":"History","idName":"id","properties":[{"name":"isSynced","type":"Bool"},{"name":"scanName","type":"String"},{"name":"timestamp","type":"Long"},{"name":"totalAbiotic","type":"Long"},{"name":"totalConditionsCount","type":"Long"},{"name":"totalDiseased","type":"Long"},{"name":"totalPest","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'isSynced': 0,
    'scanName': 1,
    'timestamp': 2,
    'totalAbiotic': 3,
    'totalConditionsCount': 4,
    'totalDiseased': 5,
    'totalPest': 6
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _historyGetId,
  setId: _historySetId,
  getLinks: _historyGetLinks,
  attachLinks: _historyAttachLinks,
  serializeNative: _historySerializeNative,
  deserializeNative: _historyDeserializeNative,
  deserializePropNative: _historyDeserializePropNative,
  serializeWeb: _historySerializeWeb,
  deserializeWeb: _historyDeserializeWeb,
  deserializePropWeb: _historyDeserializePropWeb,
  version: 3,
);

int? _historyGetId(History object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _historySetId(History object, int id) {
  object.id = id;
}

List<IsarLinkBase> _historyGetLinks(History object) {
  return [];
}

void _historySerializeNative(
    IsarCollection<History> collection,
    IsarRawObject rawObj,
    History object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.isSynced;
  final _isSynced = value0;
  final value1 = object.scanName;
  final _scanName = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_scanName.length) as int;
  final value2 = object.timestamp;
  final _timestamp = value2;
  final value3 = object.totalAbiotic;
  final _totalAbiotic = value3;
  final value4 = object.totalConditionsCount;
  final _totalConditionsCount = value4;
  final value5 = object.totalDiseased;
  final _totalDiseased = value5;
  final value6 = object.totalPest;
  final _totalPest = value6;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _isSynced);
  writer.writeBytes(offsets[1], _scanName);
  writer.writeDateTime(offsets[2], _timestamp);
  writer.writeLong(offsets[3], _totalAbiotic);
  writer.writeLong(offsets[4], _totalConditionsCount);
  writer.writeLong(offsets[5], _totalDiseased);
  writer.writeLong(offsets[6], _totalPest);
}

History _historyDeserializeNative(IsarCollection<History> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = History(
    scanName: reader.readString(offsets[1]),
    totalAbiotic: reader.readLong(offsets[3]),
    totalConditionsCount: reader.readLong(offsets[4]),
    totalDiseased: reader.readLong(offsets[5]),
    totalPest: reader.readLong(offsets[6]),
  );
  object.id = id;
  object.isSynced = reader.readBool(offsets[0]);
  object.timestamp = reader.readDateTime(offsets[2]);
  return object;
}

P _historyDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _historySerializeWeb(
    IsarCollection<History> collection, History object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'isSynced', object.isSynced);
  IsarNative.jsObjectSet(jsObj, 'scanName', object.scanName);
  IsarNative.jsObjectSet(
      jsObj, 'timestamp', object.timestamp.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'totalAbiotic', object.totalAbiotic);
  IsarNative.jsObjectSet(
      jsObj, 'totalConditionsCount', object.totalConditionsCount);
  IsarNative.jsObjectSet(jsObj, 'totalDiseased', object.totalDiseased);
  IsarNative.jsObjectSet(jsObj, 'totalPest', object.totalPest);
  return jsObj;
}

History _historyDeserializeWeb(
    IsarCollection<History> collection, dynamic jsObj) {
  final object = History(
    scanName: IsarNative.jsObjectGet(jsObj, 'scanName') ?? '',
    totalAbiotic: IsarNative.jsObjectGet(jsObj, 'totalAbiotic') ??
        double.negativeInfinity,
    totalConditionsCount:
        IsarNative.jsObjectGet(jsObj, 'totalConditionsCount') ??
            double.negativeInfinity,
    totalDiseased: IsarNative.jsObjectGet(jsObj, 'totalDiseased') ??
        double.negativeInfinity,
    totalPest:
        IsarNative.jsObjectGet(jsObj, 'totalPest') ?? double.negativeInfinity,
  );
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  object.isSynced = IsarNative.jsObjectGet(jsObj, 'isSynced') ?? false;
  object.timestamp = IsarNative.jsObjectGet(jsObj, 'timestamp') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, 'timestamp'),
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  return object;
}

P _historyDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'isSynced':
      return (IsarNative.jsObjectGet(jsObj, 'isSynced') ?? false) as P;
    case 'scanName':
      return (IsarNative.jsObjectGet(jsObj, 'scanName') ?? '') as P;
    case 'timestamp':
      return (IsarNative.jsObjectGet(jsObj, 'timestamp') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'timestamp'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'totalAbiotic':
      return (IsarNative.jsObjectGet(jsObj, 'totalAbiotic') ??
          double.negativeInfinity) as P;
    case 'totalConditionsCount':
      return (IsarNative.jsObjectGet(jsObj, 'totalConditionsCount') ??
          double.negativeInfinity) as P;
    case 'totalDiseased':
      return (IsarNative.jsObjectGet(jsObj, 'totalDiseased') ??
          double.negativeInfinity) as P;
    case 'totalPest':
      return (IsarNative.jsObjectGet(jsObj, 'totalPest') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _historyAttachLinks(IsarCollection col, int id, History object) {}

extension HistoryQueryWhereSort on QueryBuilder<History, History, QWhere> {
  QueryBuilder<History, History, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension HistoryQueryWhere on QueryBuilder<History, History, QWhereClause> {
  QueryBuilder<History, History, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<History, History, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<History, History, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<History, History, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<History, History, QAfterWhereClause> idBetween(
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

extension HistoryQueryFilter
    on QueryBuilder<History, History, QFilterCondition> {
  QueryBuilder<History, History, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> idBetween(
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

  QueryBuilder<History, History, QAfterFilterCondition> isSyncedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isSynced',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'scanName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'scanName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'scanName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'scanName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'scanName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'scanName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'scanName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> scanNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'scanName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'timestamp',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> timestampGreaterThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> timestampLessThan(
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

  QueryBuilder<History, History, QAfterFilterCondition> timestampBetween(
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

  QueryBuilder<History, History, QAfterFilterCondition> totalAbioticEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'totalAbiotic',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalAbioticGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'totalAbiotic',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalAbioticLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'totalAbiotic',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalAbioticBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totalAbiotic',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition>
      totalConditionsCountEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'totalConditionsCount',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition>
      totalConditionsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'totalConditionsCount',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition>
      totalConditionsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'totalConditionsCount',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition>
      totalConditionsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totalConditionsCount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalDiseasedEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'totalDiseased',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition>
      totalDiseasedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'totalDiseased',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalDiseasedLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'totalDiseased',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalDiseasedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totalDiseased',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalPestEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'totalPest',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalPestGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'totalPest',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalPestLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'totalPest',
      value: value,
    ));
  }

  QueryBuilder<History, History, QAfterFilterCondition> totalPestBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'totalPest',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension HistoryQueryLinks
    on QueryBuilder<History, History, QFilterCondition> {}

extension HistoryQueryWhereSortBy on QueryBuilder<History, History, QSortBy> {
  QueryBuilder<History, History, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByIsSynced() {
    return addSortByInternal('isSynced', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByIsSyncedDesc() {
    return addSortByInternal('isSynced', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByScanName() {
    return addSortByInternal('scanName', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByScanNameDesc() {
    return addSortByInternal('scanName', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTimestamp() {
    return addSortByInternal('timestamp', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTimestampDesc() {
    return addSortByInternal('timestamp', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalAbiotic() {
    return addSortByInternal('totalAbiotic', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalAbioticDesc() {
    return addSortByInternal('totalAbiotic', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalConditionsCount() {
    return addSortByInternal('totalConditionsCount', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy>
      sortByTotalConditionsCountDesc() {
    return addSortByInternal('totalConditionsCount', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalDiseased() {
    return addSortByInternal('totalDiseased', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalDiseasedDesc() {
    return addSortByInternal('totalDiseased', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalPest() {
    return addSortByInternal('totalPest', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> sortByTotalPestDesc() {
    return addSortByInternal('totalPest', Sort.desc);
  }
}

extension HistoryQueryWhereSortThenBy
    on QueryBuilder<History, History, QSortThenBy> {
  QueryBuilder<History, History, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByIsSynced() {
    return addSortByInternal('isSynced', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByIsSyncedDesc() {
    return addSortByInternal('isSynced', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByScanName() {
    return addSortByInternal('scanName', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByScanNameDesc() {
    return addSortByInternal('scanName', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTimestamp() {
    return addSortByInternal('timestamp', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTimestampDesc() {
    return addSortByInternal('timestamp', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalAbiotic() {
    return addSortByInternal('totalAbiotic', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalAbioticDesc() {
    return addSortByInternal('totalAbiotic', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalConditionsCount() {
    return addSortByInternal('totalConditionsCount', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy>
      thenByTotalConditionsCountDesc() {
    return addSortByInternal('totalConditionsCount', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalDiseased() {
    return addSortByInternal('totalDiseased', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalDiseasedDesc() {
    return addSortByInternal('totalDiseased', Sort.desc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalPest() {
    return addSortByInternal('totalPest', Sort.asc);
  }

  QueryBuilder<History, History, QAfterSortBy> thenByTotalPestDesc() {
    return addSortByInternal('totalPest', Sort.desc);
  }
}

extension HistoryQueryWhereDistinct
    on QueryBuilder<History, History, QDistinct> {
  QueryBuilder<History, History, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<History, History, QDistinct> distinctByIsSynced() {
    return addDistinctByInternal('isSynced');
  }

  QueryBuilder<History, History, QDistinct> distinctByScanName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('scanName', caseSensitive: caseSensitive);
  }

  QueryBuilder<History, History, QDistinct> distinctByTimestamp() {
    return addDistinctByInternal('timestamp');
  }

  QueryBuilder<History, History, QDistinct> distinctByTotalAbiotic() {
    return addDistinctByInternal('totalAbiotic');
  }

  QueryBuilder<History, History, QDistinct> distinctByTotalConditionsCount() {
    return addDistinctByInternal('totalConditionsCount');
  }

  QueryBuilder<History, History, QDistinct> distinctByTotalDiseased() {
    return addDistinctByInternal('totalDiseased');
  }

  QueryBuilder<History, History, QDistinct> distinctByTotalPest() {
    return addDistinctByInternal('totalPest');
  }
}

extension HistoryQueryProperty
    on QueryBuilder<History, History, QQueryProperty> {
  QueryBuilder<History, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<History, bool, QQueryOperations> isSyncedProperty() {
    return addPropertyNameInternal('isSynced');
  }

  QueryBuilder<History, String, QQueryOperations> scanNameProperty() {
    return addPropertyNameInternal('scanName');
  }

  QueryBuilder<History, DateTime, QQueryOperations> timestampProperty() {
    return addPropertyNameInternal('timestamp');
  }

  QueryBuilder<History, int, QQueryOperations> totalAbioticProperty() {
    return addPropertyNameInternal('totalAbiotic');
  }

  QueryBuilder<History, int, QQueryOperations> totalConditionsCountProperty() {
    return addPropertyNameInternal('totalConditionsCount');
  }

  QueryBuilder<History, int, QQueryOperations> totalDiseasedProperty() {
    return addPropertyNameInternal('totalDiseased');
  }

  QueryBuilder<History, int, QQueryOperations> totalPestProperty() {
    return addPropertyNameInternal('totalPest');
  }
}
