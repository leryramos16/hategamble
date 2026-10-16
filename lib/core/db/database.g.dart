// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CheckInsTable extends CheckIns with TableInfo<$CheckInsTable, CheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urgeMeta = const VerificationMeta('urge');
  @override
  late final GeneratedColumn<int> urge = GeneratedColumn<int>(
    'urge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggersMeta = const VerificationMeta(
    'triggers',
  );
  @override
  late final GeneratedColumn<String> triggers = GeneratedColumn<String>(
    'triggers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    mood,
    urge,
    triggers,
    note,
    photo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('urge')) {
      context.handle(
        _urgeMeta,
        urge.isAcceptableOrUnknown(data['urge']!, _urgeMeta),
      );
    } else if (isInserting) {
      context.missing(_urgeMeta);
    }
    if (data.containsKey('triggers')) {
      context.handle(
        _triggersMeta,
        triggers.isAcceptableOrUnknown(data['triggers']!, _triggersMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckIn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      urge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urge'],
      )!,
      triggers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggers'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo'],
      )!,
    );
  }

  @override
  $CheckInsTable createAlias(String alias) {
    return $CheckInsTable(attachedDatabase, alias);
  }
}

class CheckIn extends DataClass implements Insertable<CheckIn> {
  final int id;
  final DateTime day;
  final int mood;
  final int urge;
  final String triggers;
  final String note;

  /// File name of an attached photo in the journal photos folder, or empty.
  final String photo;
  const CheckIn({
    required this.id,
    required this.day,
    required this.mood,
    required this.urge,
    required this.triggers,
    required this.note,
    required this.photo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<DateTime>(day);
    map['mood'] = Variable<int>(mood);
    map['urge'] = Variable<int>(urge);
    map['triggers'] = Variable<String>(triggers);
    map['note'] = Variable<String>(note);
    map['photo'] = Variable<String>(photo);
    return map;
  }

  CheckInsCompanion toCompanion(bool nullToAbsent) {
    return CheckInsCompanion(
      id: Value(id),
      day: Value(day),
      mood: Value(mood),
      urge: Value(urge),
      triggers: Value(triggers),
      note: Value(note),
      photo: Value(photo),
    );
  }

  factory CheckIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckIn(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<DateTime>(json['day']),
      mood: serializer.fromJson<int>(json['mood']),
      urge: serializer.fromJson<int>(json['urge']),
      triggers: serializer.fromJson<String>(json['triggers']),
      note: serializer.fromJson<String>(json['note']),
      photo: serializer.fromJson<String>(json['photo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<DateTime>(day),
      'mood': serializer.toJson<int>(mood),
      'urge': serializer.toJson<int>(urge),
      'triggers': serializer.toJson<String>(triggers),
      'note': serializer.toJson<String>(note),
      'photo': serializer.toJson<String>(photo),
    };
  }

  CheckIn copyWith({
    int? id,
    DateTime? day,
    int? mood,
    int? urge,
    String? triggers,
    String? note,
    String? photo,
  }) => CheckIn(
    id: id ?? this.id,
    day: day ?? this.day,
    mood: mood ?? this.mood,
    urge: urge ?? this.urge,
    triggers: triggers ?? this.triggers,
    note: note ?? this.note,
    photo: photo ?? this.photo,
  );
  CheckIn copyWithCompanion(CheckInsCompanion data) {
    return CheckIn(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      mood: data.mood.present ? data.mood.value : this.mood,
      urge: data.urge.present ? data.urge.value : this.urge,
      triggers: data.triggers.present ? data.triggers.value : this.triggers,
      note: data.note.present ? data.note.value : this.note,
      photo: data.photo.present ? data.photo.value : this.photo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckIn(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('mood: $mood, ')
          ..write('urge: $urge, ')
          ..write('triggers: $triggers, ')
          ..write('note: $note, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, mood, urge, triggers, note, photo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckIn &&
          other.id == this.id &&
          other.day == this.day &&
          other.mood == this.mood &&
          other.urge == this.urge &&
          other.triggers == this.triggers &&
          other.note == this.note &&
          other.photo == this.photo);
}

class CheckInsCompanion extends UpdateCompanion<CheckIn> {
  final Value<int> id;
  final Value<DateTime> day;
  final Value<int> mood;
  final Value<int> urge;
  final Value<String> triggers;
  final Value<String> note;
  final Value<String> photo;
  const CheckInsCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.mood = const Value.absent(),
    this.urge = const Value.absent(),
    this.triggers = const Value.absent(),
    this.note = const Value.absent(),
    this.photo = const Value.absent(),
  });
  CheckInsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime day,
    required int mood,
    required int urge,
    this.triggers = const Value.absent(),
    this.note = const Value.absent(),
    this.photo = const Value.absent(),
  }) : day = Value(day),
       mood = Value(mood),
       urge = Value(urge);
  static Insertable<CheckIn> custom({
    Expression<int>? id,
    Expression<DateTime>? day,
    Expression<int>? mood,
    Expression<int>? urge,
    Expression<String>? triggers,
    Expression<String>? note,
    Expression<String>? photo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (mood != null) 'mood': mood,
      if (urge != null) 'urge': urge,
      if (triggers != null) 'triggers': triggers,
      if (note != null) 'note': note,
      if (photo != null) 'photo': photo,
    });
  }

  CheckInsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? day,
    Value<int>? mood,
    Value<int>? urge,
    Value<String>? triggers,
    Value<String>? note,
    Value<String>? photo,
  }) {
    return CheckInsCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      mood: mood ?? this.mood,
      urge: urge ?? this.urge,
      triggers: triggers ?? this.triggers,
      note: note ?? this.note,
      photo: photo ?? this.photo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (urge.present) {
      map['urge'] = Variable<int>(urge.value);
    }
    if (triggers.present) {
      map['triggers'] = Variable<String>(triggers.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInsCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('mood: $mood, ')
          ..write('urge: $urge, ')
          ..write('triggers: $triggers, ')
          ..write('note: $note, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }
}

class $UrgesTable extends Urges with TableInfo<$UrgesTable, Urge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UrgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resistedMeta = const VerificationMeta(
    'resisted',
  );
  @override
  late final GeneratedColumn<bool> resisted = GeneratedColumn<bool>(
    'resisted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resisted" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _toolMeta = const VerificationMeta('tool');
  @override
  late final GeneratedColumn<String> tool = GeneratedColumn<String>(
    'tool',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _triggerMeta = const VerificationMeta(
    'trigger',
  );
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
    'trigger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    at,
    intensity,
    resisted,
    tool,
    trigger,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'urges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Urge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('resisted')) {
      context.handle(
        _resistedMeta,
        resisted.isAcceptableOrUnknown(data['resisted']!, _resistedMeta),
      );
    }
    if (data.containsKey('tool')) {
      context.handle(
        _toolMeta,
        tool.isAcceptableOrUnknown(data['tool']!, _toolMeta),
      );
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Urge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Urge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      resisted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resisted'],
      )!,
      tool: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tool'],
      )!,
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      )!,
    );
  }

  @override
  $UrgesTable createAlias(String alias) {
    return $UrgesTable(attachedDatabase, alias);
  }
}

class Urge extends DataClass implements Insertable<Urge> {
  final int id;
  final DateTime at;
  final int intensity;
  final bool resisted;
  final String tool;
  final String trigger;
  const Urge({
    required this.id,
    required this.at,
    required this.intensity,
    required this.resisted,
    required this.tool,
    required this.trigger,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['intensity'] = Variable<int>(intensity);
    map['resisted'] = Variable<bool>(resisted);
    map['tool'] = Variable<String>(tool);
    map['trigger'] = Variable<String>(trigger);
    return map;
  }

  UrgesCompanion toCompanion(bool nullToAbsent) {
    return UrgesCompanion(
      id: Value(id),
      at: Value(at),
      intensity: Value(intensity),
      resisted: Value(resisted),
      tool: Value(tool),
      trigger: Value(trigger),
    );
  }

  factory Urge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Urge(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      intensity: serializer.fromJson<int>(json['intensity']),
      resisted: serializer.fromJson<bool>(json['resisted']),
      tool: serializer.fromJson<String>(json['tool']),
      trigger: serializer.fromJson<String>(json['trigger']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'intensity': serializer.toJson<int>(intensity),
      'resisted': serializer.toJson<bool>(resisted),
      'tool': serializer.toJson<String>(tool),
      'trigger': serializer.toJson<String>(trigger),
    };
  }

  Urge copyWith({
    int? id,
    DateTime? at,
    int? intensity,
    bool? resisted,
    String? tool,
    String? trigger,
  }) => Urge(
    id: id ?? this.id,
    at: at ?? this.at,
    intensity: intensity ?? this.intensity,
    resisted: resisted ?? this.resisted,
    tool: tool ?? this.tool,
    trigger: trigger ?? this.trigger,
  );
  Urge copyWithCompanion(UrgesCompanion data) {
    return Urge(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      resisted: data.resisted.present ? data.resisted.value : this.resisted,
      tool: data.tool.present ? data.tool.value : this.tool,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Urge(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('intensity: $intensity, ')
          ..write('resisted: $resisted, ')
          ..write('tool: $tool, ')
          ..write('trigger: $trigger')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, intensity, resisted, tool, trigger);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Urge &&
          other.id == this.id &&
          other.at == this.at &&
          other.intensity == this.intensity &&
          other.resisted == this.resisted &&
          other.tool == this.tool &&
          other.trigger == this.trigger);
}

class UrgesCompanion extends UpdateCompanion<Urge> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<int> intensity;
  final Value<bool> resisted;
  final Value<String> tool;
  final Value<String> trigger;
  const UrgesCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.intensity = const Value.absent(),
    this.resisted = const Value.absent(),
    this.tool = const Value.absent(),
    this.trigger = const Value.absent(),
  });
  UrgesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required int intensity,
    this.resisted = const Value.absent(),
    this.tool = const Value.absent(),
    this.trigger = const Value.absent(),
  }) : at = Value(at),
       intensity = Value(intensity);
  static Insertable<Urge> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<int>? intensity,
    Expression<bool>? resisted,
    Expression<String>? tool,
    Expression<String>? trigger,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (intensity != null) 'intensity': intensity,
      if (resisted != null) 'resisted': resisted,
      if (tool != null) 'tool': tool,
      if (trigger != null) 'trigger': trigger,
    });
  }

  UrgesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<int>? intensity,
    Value<bool>? resisted,
    Value<String>? tool,
    Value<String>? trigger,
  }) {
    return UrgesCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      intensity: intensity ?? this.intensity,
      resisted: resisted ?? this.resisted,
      tool: tool ?? this.tool,
      trigger: trigger ?? this.trigger,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (resisted.present) {
      map['resisted'] = Variable<bool>(resisted.value);
    }
    if (tool.present) {
      map['tool'] = Variable<String>(tool.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UrgesCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('intensity: $intensity, ')
          ..write('resisted: $resisted, ')
          ..write('tool: $tool, ')
          ..write('trigger: $trigger')
          ..write(')'))
        .toString();
  }
}

class $RelapsesTable extends Relapses with TableInfo<$RelapsesTable, Relapse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelapsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _triggerMeta = const VerificationMeta(
    'trigger',
  );
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
    'trigger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, amount, trigger, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relapses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Relapse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Relapse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Relapse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $RelapsesTable createAlias(String alias) {
    return $RelapsesTable(attachedDatabase, alias);
  }
}

class Relapse extends DataClass implements Insertable<Relapse> {
  final int id;
  final DateTime at;
  final double amount;
  final String trigger;
  final String note;
  const Relapse({
    required this.id,
    required this.at,
    required this.amount,
    required this.trigger,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['amount'] = Variable<double>(amount);
    map['trigger'] = Variable<String>(trigger);
    map['note'] = Variable<String>(note);
    return map;
  }

  RelapsesCompanion toCompanion(bool nullToAbsent) {
    return RelapsesCompanion(
      id: Value(id),
      at: Value(at),
      amount: Value(amount),
      trigger: Value(trigger),
      note: Value(note),
    );
  }

  factory Relapse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Relapse(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      amount: serializer.fromJson<double>(json['amount']),
      trigger: serializer.fromJson<String>(json['trigger']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'amount': serializer.toJson<double>(amount),
      'trigger': serializer.toJson<String>(trigger),
      'note': serializer.toJson<String>(note),
    };
  }

  Relapse copyWith({
    int? id,
    DateTime? at,
    double? amount,
    String? trigger,
    String? note,
  }) => Relapse(
    id: id ?? this.id,
    at: at ?? this.at,
    amount: amount ?? this.amount,
    trigger: trigger ?? this.trigger,
    note: note ?? this.note,
  );
  Relapse copyWithCompanion(RelapsesCompanion data) {
    return Relapse(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      amount: data.amount.present ? data.amount.value : this.amount,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Relapse(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('amount: $amount, ')
          ..write('trigger: $trigger, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, amount, trigger, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Relapse &&
          other.id == this.id &&
          other.at == this.at &&
          other.amount == this.amount &&
          other.trigger == this.trigger &&
          other.note == this.note);
}

class RelapsesCompanion extends UpdateCompanion<Relapse> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<double> amount;
  final Value<String> trigger;
  final Value<String> note;
  const RelapsesCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.amount = const Value.absent(),
    this.trigger = const Value.absent(),
    this.note = const Value.absent(),
  });
  RelapsesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    this.amount = const Value.absent(),
    this.trigger = const Value.absent(),
    this.note = const Value.absent(),
  }) : at = Value(at);
  static Insertable<Relapse> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<double>? amount,
    Expression<String>? trigger,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (amount != null) 'amount': amount,
      if (trigger != null) 'trigger': trigger,
      if (note != null) 'note': note,
    });
  }

  RelapsesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<double>? amount,
    Value<String>? trigger,
    Value<String>? note,
  }) {
    return RelapsesCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      amount: amount ?? this.amount,
      trigger: trigger ?? this.trigger,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelapsesCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('amount: $amount, ')
          ..write('trigger: $trigger, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messengerMeta = const VerificationMeta(
    'messenger',
  );
  @override
  late final GeneratedColumn<String> messenger = GeneratedColumn<String>(
    'messenger',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isHotlineMeta = const VerificationMeta(
    'isHotline',
  );
  @override
  late final GeneratedColumn<bool> isHotline = GeneratedColumn<bool>(
    'is_hotline',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hotline" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, messenger, isHotline];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('messenger')) {
      context.handle(
        _messengerMeta,
        messenger.isAcceptableOrUnknown(data['messenger']!, _messengerMeta),
      );
    }
    if (data.containsKey('is_hotline')) {
      context.handle(
        _isHotlineMeta,
        isHotline.isAcceptableOrUnknown(data['is_hotline']!, _isHotlineMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      messenger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}messenger'],
      )!,
      isHotline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hotline'],
      )!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final int id;
  final String name;
  final String phone;

  /// Facebook username or numeric ID, opened as `m.me/<messenger>`. Empty if none.
  final String messenger;
  final bool isHotline;
  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.messenger,
    required this.isHotline,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['messenger'] = Variable<String>(messenger);
    map['is_hotline'] = Variable<bool>(isHotline);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      messenger: Value(messenger),
      isHotline: Value(isHotline),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      messenger: serializer.fromJson<String>(json['messenger']),
      isHotline: serializer.fromJson<bool>(json['isHotline']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'messenger': serializer.toJson<String>(messenger),
      'isHotline': serializer.toJson<bool>(isHotline),
    };
  }

  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? messenger,
    bool? isHotline,
  }) => Contact(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    messenger: messenger ?? this.messenger,
    isHotline: isHotline ?? this.isHotline,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      messenger: data.messenger.present ? data.messenger.value : this.messenger,
      isHotline: data.isHotline.present ? data.isHotline.value : this.isHotline,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('messenger: $messenger, ')
          ..write('isHotline: $isHotline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, messenger, isHotline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.messenger == this.messenger &&
          other.isHotline == this.isHotline);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> messenger;
  final Value<bool> isHotline;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.messenger = const Value.absent(),
    this.isHotline = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    this.messenger = const Value.absent(),
    this.isHotline = const Value.absent(),
  }) : name = Value(name),
       phone = Value(phone);
  static Insertable<Contact> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? messenger,
    Expression<bool>? isHotline,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (messenger != null) 'messenger': messenger,
      if (isHotline != null) 'is_hotline': isHotline,
    });
  }

  ContactsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? messenger,
    Value<bool>? isHotline,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      messenger: messenger ?? this.messenger,
      isHotline: isHotline ?? this.isHotline,
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
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (messenger.present) {
      map['messenger'] = Variable<String>(messenger.value);
    }
    if (isHotline.present) {
      map['is_hotline'] = Variable<bool>(isHotline.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('messenger: $messenger, ')
          ..write('isHotline: $isHotline')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, note, photo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final DateTime at;
  final String note;

  /// File name of an attached photo in the journal photos folder, or empty.
  final String photo;
  const JournalEntry({
    required this.id,
    required this.at,
    required this.note,
    required this.photo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['note'] = Variable<String>(note);
    map['photo'] = Variable<String>(photo);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      at: Value(at),
      note: Value(note),
      photo: Value(photo),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      note: serializer.fromJson<String>(json['note']),
      photo: serializer.fromJson<String>(json['photo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'note': serializer.toJson<String>(note),
      'photo': serializer.toJson<String>(photo),
    };
  }

  JournalEntry copyWith({int? id, DateTime? at, String? note, String? photo}) =>
      JournalEntry(
        id: id ?? this.id,
        at: at ?? this.at,
        note: note ?? this.note,
        photo: photo ?? this.photo,
      );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      note: data.note.present ? data.note.value : this.note,
      photo: data.photo.present ? data.photo.value : this.photo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('note: $note, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, note, photo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.at == this.at &&
          other.note == this.note &&
          other.photo == this.photo);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<String> note;
  final Value<String> photo;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.note = const Value.absent(),
    this.photo = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    this.note = const Value.absent(),
    this.photo = const Value.absent(),
  }) : at = Value(at);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<String>? note,
    Expression<String>? photo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (note != null) 'note': note,
      if (photo != null) 'photo': photo,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<String>? note,
    Value<String>? photo,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      note: note ?? this.note,
      photo: photo ?? this.photo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('note: $note, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CheckInsTable checkIns = $CheckInsTable(this);
  late final $UrgesTable urges = $UrgesTable(this);
  late final $RelapsesTable relapses = $RelapsesTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    checkIns,
    urges,
    relapses,
    contacts,
    journalEntries,
  ];
}

typedef $$CheckInsTableCreateCompanionBuilder =
    CheckInsCompanion Function({
      Value<int> id,
      required DateTime day,
      required int mood,
      required int urge,
      Value<String> triggers,
      Value<String> note,
      Value<String> photo,
    });
typedef $$CheckInsTableUpdateCompanionBuilder =
    CheckInsCompanion Function({
      Value<int> id,
      Value<DateTime> day,
      Value<int> mood,
      Value<int> urge,
      Value<String> triggers,
      Value<String> note,
      Value<String> photo,
    });

class $$CheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urge => $composableBuilder(
    column: $table.urge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urge => $composableBuilder(
    column: $table.urge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggers => $composableBuilder(
    column: $table.triggers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get urge =>
      $composableBuilder(column: $table.urge, builder: (column) => column);

  GeneratedColumn<String> get triggers =>
      $composableBuilder(column: $table.triggers, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);
}

class $$CheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInsTable,
          CheckIn,
          $$CheckInsTableFilterComposer,
          $$CheckInsTableOrderingComposer,
          $$CheckInsTableAnnotationComposer,
          $$CheckInsTableCreateCompanionBuilder,
          $$CheckInsTableUpdateCompanionBuilder,
          (CheckIn, BaseReferences<_$AppDatabase, $CheckInsTable, CheckIn>),
          CheckIn,
          PrefetchHooks Function()
        > {
  $$CheckInsTableTableManager(_$AppDatabase db, $CheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<int> urge = const Value.absent(),
                Value<String> triggers = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> photo = const Value.absent(),
              }) => CheckInsCompanion(
                id: id,
                day: day,
                mood: mood,
                urge: urge,
                triggers: triggers,
                note: note,
                photo: photo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime day,
                required int mood,
                required int urge,
                Value<String> triggers = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> photo = const Value.absent(),
              }) => CheckInsCompanion.insert(
                id: id,
                day: day,
                mood: mood,
                urge: urge,
                triggers: triggers,
                note: note,
                photo: photo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CheckInsTable, CheckIn>(table),
                  BaseReferences<_$AppDatabase, $CheckInsTable, CheckIn>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInsTable,
      CheckIn,
      $$CheckInsTableFilterComposer,
      $$CheckInsTableOrderingComposer,
      $$CheckInsTableAnnotationComposer,
      $$CheckInsTableCreateCompanionBuilder,
      $$CheckInsTableUpdateCompanionBuilder,
      (CheckIn, BaseReferences<_$AppDatabase, $CheckInsTable, CheckIn>),
      CheckIn,
      PrefetchHooks Function()
    >;
typedef $$UrgesTableCreateCompanionBuilder =
    UrgesCompanion Function({
      Value<int> id,
      required DateTime at,
      required int intensity,
      Value<bool> resisted,
      Value<String> tool,
      Value<String> trigger,
    });
typedef $$UrgesTableUpdateCompanionBuilder =
    UrgesCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<int> intensity,
      Value<bool> resisted,
      Value<String> tool,
      Value<String> trigger,
    });

class $$UrgesTableFilterComposer extends Composer<_$AppDatabase, $UrgesTable> {
  $$UrgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resisted => $composableBuilder(
    column: $table.resisted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tool => $composableBuilder(
    column: $table.tool,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UrgesTableOrderingComposer
    extends Composer<_$AppDatabase, $UrgesTable> {
  $$UrgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resisted => $composableBuilder(
    column: $table.resisted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tool => $composableBuilder(
    column: $table.tool,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UrgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UrgesTable> {
  $$UrgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<bool> get resisted =>
      $composableBuilder(column: $table.resisted, builder: (column) => column);

  GeneratedColumn<String> get tool =>
      $composableBuilder(column: $table.tool, builder: (column) => column);

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);
}

class $$UrgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UrgesTable,
          Urge,
          $$UrgesTableFilterComposer,
          $$UrgesTableOrderingComposer,
          $$UrgesTableAnnotationComposer,
          $$UrgesTableCreateCompanionBuilder,
          $$UrgesTableUpdateCompanionBuilder,
          (Urge, BaseReferences<_$AppDatabase, $UrgesTable, Urge>),
          Urge,
          PrefetchHooks Function()
        > {
  $$UrgesTableTableManager(_$AppDatabase db, $UrgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UrgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UrgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UrgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<bool> resisted = const Value.absent(),
                Value<String> tool = const Value.absent(),
                Value<String> trigger = const Value.absent(),
              }) => UrgesCompanion(
                id: id,
                at: at,
                intensity: intensity,
                resisted: resisted,
                tool: tool,
                trigger: trigger,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required int intensity,
                Value<bool> resisted = const Value.absent(),
                Value<String> tool = const Value.absent(),
                Value<String> trigger = const Value.absent(),
              }) => UrgesCompanion.insert(
                id: id,
                at: at,
                intensity: intensity,
                resisted: resisted,
                tool: tool,
                trigger: trigger,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UrgesTable, Urge>(table),
                  BaseReferences<_$AppDatabase, $UrgesTable, Urge>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UrgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UrgesTable,
      Urge,
      $$UrgesTableFilterComposer,
      $$UrgesTableOrderingComposer,
      $$UrgesTableAnnotationComposer,
      $$UrgesTableCreateCompanionBuilder,
      $$UrgesTableUpdateCompanionBuilder,
      (Urge, BaseReferences<_$AppDatabase, $UrgesTable, Urge>),
      Urge,
      PrefetchHooks Function()
    >;
typedef $$RelapsesTableCreateCompanionBuilder =
    RelapsesCompanion Function({
      Value<int> id,
      required DateTime at,
      Value<double> amount,
      Value<String> trigger,
      Value<String> note,
    });
typedef $$RelapsesTableUpdateCompanionBuilder =
    RelapsesCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<double> amount,
      Value<String> trigger,
      Value<String> note,
    });

class $$RelapsesTableFilterComposer
    extends Composer<_$AppDatabase, $RelapsesTable> {
  $$RelapsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RelapsesTableOrderingComposer
    extends Composer<_$AppDatabase, $RelapsesTable> {
  $$RelapsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RelapsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelapsesTable> {
  $$RelapsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$RelapsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RelapsesTable,
          Relapse,
          $$RelapsesTableFilterComposer,
          $$RelapsesTableOrderingComposer,
          $$RelapsesTableAnnotationComposer,
          $$RelapsesTableCreateCompanionBuilder,
          $$RelapsesTableUpdateCompanionBuilder,
          (Relapse, BaseReferences<_$AppDatabase, $RelapsesTable, Relapse>),
          Relapse,
          PrefetchHooks Function()
        > {
  $$RelapsesTableTableManager(_$AppDatabase db, $RelapsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelapsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelapsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelapsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => RelapsesCompanion(
                id: id,
                at: at,
                amount: amount,
                trigger: trigger,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                Value<double> amount = const Value.absent(),
                Value<String> trigger = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => RelapsesCompanion.insert(
                id: id,
                at: at,
                amount: amount,
                trigger: trigger,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RelapsesTable, Relapse>(table),
                  BaseReferences<_$AppDatabase, $RelapsesTable, Relapse>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RelapsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RelapsesTable,
      Relapse,
      $$RelapsesTableFilterComposer,
      $$RelapsesTableOrderingComposer,
      $$RelapsesTableAnnotationComposer,
      $$RelapsesTableCreateCompanionBuilder,
      $$RelapsesTableUpdateCompanionBuilder,
      (Relapse, BaseReferences<_$AppDatabase, $RelapsesTable, Relapse>),
      Relapse,
      PrefetchHooks Function()
    >;
typedef $$ContactsTableCreateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
      Value<String> messenger,
      Value<bool> isHotline,
    });
typedef $$ContactsTableUpdateCompanionBuilder =
    ContactsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String> messenger,
      Value<bool> isHotline,
    });

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messenger => $composableBuilder(
    column: $table.messenger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHotline => $composableBuilder(
    column: $table.isHotline,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messenger => $composableBuilder(
    column: $table.messenger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHotline => $composableBuilder(
    column: $table.isHotline,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get messenger =>
      $composableBuilder(column: $table.messenger, builder: (column) => column);

  GeneratedColumn<bool> get isHotline =>
      $composableBuilder(column: $table.isHotline, builder: (column) => column);
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
          Contact,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> messenger = const Value.absent(),
                Value<bool> isHotline = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                name: name,
                phone: phone,
                messenger: messenger,
                isHotline: isHotline,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
                Value<String> messenger = const Value.absent(),
                Value<bool> isHotline = const Value.absent(),
              }) => ContactsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                messenger: messenger,
                isHotline: isHotline,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContactsTable, Contact>(table),
                  BaseReferences<_$AppDatabase, $ContactsTable, Contact>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
      Contact,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      required DateTime at,
      Value<String> note,
      Value<String> photo,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<String> note,
      Value<String> photo,
    });

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> photo = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                at: at,
                note: note,
                photo: photo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                Value<String> note = const Value.absent(),
                Value<String> photo = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                at: at,
                note: note,
                photo: photo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalEntriesTable, JournalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $JournalEntriesTable,
                    JournalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db, _db.checkIns);
  $$UrgesTableTableManager get urges =>
      $$UrgesTableTableManager(_db, _db.urges);
  $$RelapsesTableTableManager get relapses =>
      $$RelapsesTableTableManager(_db, _db.relapses);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
}
