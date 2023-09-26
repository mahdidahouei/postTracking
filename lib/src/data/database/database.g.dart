// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TrackingNumbersTable extends TrackingNumbers
    with TableInfo<$TrackingNumbersTable, TrackingNumber> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackingNumbersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 99),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _trackingNumberMeta =
      const VerificationMeta('trackingNumber');
  @override
  late final GeneratedColumn<String> trackingNumber = GeneratedColumn<String>(
      'tracking_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 24, maxTextLength: 24),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name, trackingNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracking_numbers';
  @override
  VerificationContext validateIntegrity(Insertable<TrackingNumber> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tracking_number')) {
      context.handle(
          _trackingNumberMeta,
          trackingNumber.isAcceptableOrUnknown(
              data['tracking_number']!, _trackingNumberMeta));
    } else if (isInserting) {
      context.missing(_trackingNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackingNumber map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackingNumber(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      trackingNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}tracking_number'])!,
    );
  }

  @override
  $TrackingNumbersTable createAlias(String alias) {
    return $TrackingNumbersTable(attachedDatabase, alias);
  }
}

class TrackingNumber extends DataClass implements Insertable<TrackingNumber> {
  final int id;
  final String name;
  final String trackingNumber;
  const TrackingNumber(
      {required this.id, required this.name, required this.trackingNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['tracking_number'] = Variable<String>(trackingNumber);
    return map;
  }

  TrackingNumbersCompanion toCompanion(bool nullToAbsent) {
    return TrackingNumbersCompanion(
      id: Value(id),
      name: Value(name),
      trackingNumber: Value(trackingNumber),
    );
  }

  factory TrackingNumber.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackingNumber(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      trackingNumber: serializer.fromJson<String>(json['trackingNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'trackingNumber': serializer.toJson<String>(trackingNumber),
    };
  }

  TrackingNumber copyWith({int? id, String? name, String? trackingNumber}) =>
      TrackingNumber(
        id: id ?? this.id,
        name: name ?? this.name,
        trackingNumber: trackingNumber ?? this.trackingNumber,
      );
  @override
  String toString() {
    return (StringBuffer('TrackingNumber(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('trackingNumber: $trackingNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, trackingNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackingNumber &&
          other.id == this.id &&
          other.name == this.name &&
          other.trackingNumber == this.trackingNumber);
}

class TrackingNumbersCompanion extends UpdateCompanion<TrackingNumber> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> trackingNumber;
  const TrackingNumbersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.trackingNumber = const Value.absent(),
  });
  TrackingNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String trackingNumber,
  })  : name = Value(name),
        trackingNumber = Value(trackingNumber);
  static Insertable<TrackingNumber> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? trackingNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (trackingNumber != null) 'tracking_number': trackingNumber,
    });
  }

  TrackingNumbersCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? trackingNumber}) {
    return TrackingNumbersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (trackingNumber.present) {
      map['tracking_number'] = Variable<String>(trackingNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackingNumbersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('trackingNumber: $trackingNumber')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $TrackingNumbersTable trackingNumbers =
      $TrackingNumbersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [trackingNumbers];
}
