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
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, trackingNumber, updatedAt, createdAt];
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
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
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
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
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
  final DateTime updatedAt;
  final DateTime createdAt;
  const TrackingNumber(
      {required this.id,
      required this.name,
      required this.trackingNumber,
      required this.updatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['tracking_number'] = Variable<String>(trackingNumber);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrackingNumbersCompanion toCompanion(bool nullToAbsent) {
    return TrackingNumbersCompanion(
      id: Value(id),
      name: Value(name),
      trackingNumber: Value(trackingNumber),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory TrackingNumber.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackingNumber(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      trackingNumber: serializer.fromJson<String>(json['trackingNumber']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'trackingNumber': serializer.toJson<String>(trackingNumber),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrackingNumber copyWith(
          {int? id,
          String? name,
          String? trackingNumber,
          DateTime? updatedAt,
          DateTime? createdAt}) =>
      TrackingNumber(
        id: id ?? this.id,
        name: name ?? this.name,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('TrackingNumber(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('trackingNumber: $trackingNumber, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, trackingNumber, updatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackingNumber &&
          other.id == this.id &&
          other.name == this.name &&
          other.trackingNumber == this.trackingNumber &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class TrackingNumbersCompanion extends UpdateCompanion<TrackingNumber> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> trackingNumber;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  const TrackingNumbersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.trackingNumber = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TrackingNumbersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String trackingNumber,
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        trackingNumber = Value(trackingNumber);
  static Insertable<TrackingNumber> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? trackingNumber,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (trackingNumber != null) 'tracking_number': trackingNumber,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TrackingNumbersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? trackingNumber,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt}) {
    return TrackingNumbersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
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
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackingNumbersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('trackingNumber: $trackingNumber, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
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
