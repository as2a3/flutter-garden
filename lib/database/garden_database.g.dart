// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorGardenDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$GardenDatabaseBuilder databaseBuilder(String name) =>
      _$GardenDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$GardenDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$GardenDatabaseBuilder(null);
}

class _$GardenDatabaseBuilder {
  _$GardenDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$GardenDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$GardenDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<GardenDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$GardenDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$GardenDatabase extends GardenDatabase {
  _$GardenDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PlantDAO? _plantsDAOInstance;

  TypeDAO? _typeDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `plant` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `planting_date` INTEGER NOT NULL, `type_id` INTEGER NOT NULL, FOREIGN KEY (`type_id`) REFERENCES `type` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `type` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PlantDAO get plantsDAO {
    return _plantsDAOInstance ??= _$PlantDAO(database, changeListener);
  }

  @override
  TypeDAO get typeDAO {
    return _typeDAOInstance ??= _$TypeDAO(database, changeListener);
  }
}

class _$PlantDAO extends PlantDAO {
  _$PlantDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _plantInsertionAdapter = InsertionAdapter(
            database,
            'plant',
            (Plant item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'planting_date': item.plantingDate,
                  'type_id': item.typeId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Plant> _plantInsertionAdapter;

  @override
  Future<Plant?> getPlantById(int id) async {
    return _queryAdapter.query('SELECT * FROM plant WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Plant(
            id: row['id'] as int?,
            name: row['name'] as String,
            plantingDate: row['planting_date'] as int,
            typeId: row['type_id'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Plant>> retrievePlants(int page) async {
    return _queryAdapter.queryList('SELECT * FROM plant LIMIT 10 OFFSET ?1',
        mapper: (Map<String, Object?> row) => Plant(
            id: row['id'] as int?,
            name: row['name'] as String,
            plantingDate: row['planting_date'] as int,
            typeId: row['type_id'] as int),
        arguments: [page]);
  }

  @override
  Future<Plant?> deletePlant(int id) async {
    return _queryAdapter.query('DELETE FROM plant WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Plant(
            id: row['id'] as int?,
            name: row['name'] as String,
            plantingDate: row['planting_date'] as int,
            typeId: row['type_id'] as int),
        arguments: [id]);
  }

  @override
  Future<List<int>> insertPlants(List<Plant> plants) {
    return _plantInsertionAdapter.insertListAndReturnIds(
        plants, OnConflictStrategy.abort);
  }

  @override
  Future<int> insertPlant(Plant plant) {
    return _plantInsertionAdapter.insertAndReturnId(
        plant, OnConflictStrategy.abort);
  }
}

class _$TypeDAO extends TypeDAO {
  _$TypeDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _plantTypeInsertionAdapter = InsertionAdapter(
            database,
            'type',
            (PlantType item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PlantType> _plantTypeInsertionAdapter;

  @override
  Future<List<PlantType>> retrieveAllTypes() async {
    return _queryAdapter.queryList('SELECT * FROM type',
        mapper: (Map<String, Object?> row) =>
            PlantType(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<PlantType?> getTypeById(int id) async {
    return _queryAdapter.query('SELECT * FROM type WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            PlantType(id: row['id'] as int?, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<List<PlantType>> retrieveTypesByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM type WHERE name = ?1',
        mapper: (Map<String, Object?> row) =>
            PlantType(id: row['id'] as int?, name: row['name'] as String),
        arguments: [name]);
  }

  @override
  Future<List<int>> insertType(List<PlantType> types) {
    return _plantTypeInsertionAdapter.insertListAndReturnIds(
        types, OnConflictStrategy.abort);
  }
}
