import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_sv_entity.dart';

class DatabaseService extends GetxService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<DatabaseService> init() async {
    await database;
    return this;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'secret_vault.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {

      await db.execute('''
        CREATE TABLE security_question (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          question TEXT NOT NULL,
          encrypted_answer TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> _onCreate(Database db, int version) async {

    await db.execute('''
      CREATE TABLE calculator_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expression TEXT NOT NULL,
        result TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE password (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        encrypted_password TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');


    await db.execute('''
      CREATE TABLE album (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        item_count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        album_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        encrypted_path TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL,
        original_name TEXT NOT NULL,
        file_size INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (album_id) REFERENCES album (id) ON DELETE CASCADE
      )
    ''');


    await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        encrypted_content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE security_question (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        encrypted_answer TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');


    await db.execute(
        'CREATE INDEX idx_media_album_id ON media (album_id)');
    await db.execute(
        'CREATE INDEX idx_calculator_history_created_at ON calculator_history (created_at DESC)');
    await db.execute(
        'CREATE INDEX idx_note_updated_at ON note (updated_at DESC)');
  }



  Future<int> insertCalculatorHistory(CalculatorHistory history) async {
    try {
      final db = await database;
      return await db.insert('calculator_history', history.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CalculatorHistory>> getCalculatorHistories() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'calculator_history',
        orderBy: 'created_at DESC, id DESC',
      );
      return List.generate(maps.length, (i) {
        return CalculatorHistory.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<int> deleteCalculatorHistory(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'calculator_history',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> clearCalculatorHistories() async {
    try {
      final db = await database;
      return await db.delete('calculator_history');
    } catch (e) {
      rethrow;
    }
  }



  Future<int> insertPassword(Password password) async {
    try {
      final db = await database;
      return await db.insert('password', password.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<Password?> getPassword() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'password',
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return Password.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updatePassword(Password password) async {
    try {
      final db = await database;
      return await db.update(
        'password',
        password.toMap(),
        where: 'id = ?',
        whereArgs: [password.id],
      );
    } catch (e) {
      rethrow;
    }
  }



  Future<int> insertAlbum(Album album) async {
    try {
      final db = await database;
      return await db.insert('album', album.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Album>> getAlbums() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'album',
        orderBy: 'created_at DESC, id DESC',
      );
      return List.generate(maps.length, (i) {
        return Album.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<Album?> getAlbumById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'album',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return Album.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateAlbum(Album album) async {
    try {
      final db = await database;
      return await db.update(
        'album',
        album.toMap(),
        where: 'id = ?',
        whereArgs: [album.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteAlbum(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'album',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateAlbumItemCount(int albumId, int count) async {
    try {
      final db = await database;
      return await db.update(
        'album',
        {'item_count': count},
        where: 'id = ?',
        whereArgs: [albumId],
      );
    } catch (e) {
      rethrow;
    }
  }



  Future<int> insertMedia(Media media) async {
    try {
      final db = await database;
      return await db.insert('media', media.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Media>> getMediaByAlbumId(int albumId, {String? type}) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'media',
        where: type != null ? 'album_id = ? AND type = ?' : 'album_id = ?',
        whereArgs: type != null ? [albumId, type] : [albumId],
        orderBy: 'created_at DESC, id DESC',
      );
      return List.generate(maps.length, (i) {
        return Media.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<Media?> getMediaById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'media',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return Media.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> deleteMedia(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'media',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteMediaByAlbumId(int albumId) async {
    try {
      final db = await database;
      return await db.delete(
        'media',
        where: 'album_id = ?',
        whereArgs: [albumId],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getMediaCountByAlbumId(int albumId) async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM media WHERE album_id = ?',
        [albumId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      return 0;
    }
  }



  Future<int> insertNote(Note note) async {
    try {
      final db = await database;
      return await db.insert('note', note.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Note>> getNotes() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'note',
        orderBy: 'updated_at DESC, id DESC',
      );
      return List.generate(maps.length, (i) {
        return Note.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<Note?> getNoteById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'note',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return Note.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateNote(Note note) async {
    try {
      final db = await database;
      return await db.update(
        'note',
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'note',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }



  Future<int> insertSecurityQuestion(SecurityQuestion question) async {
    try {
      final db = await database;
      return await db.insert('security_question', question.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SecurityQuestion>> getSecurityQuestions() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'security_question',
        orderBy: 'id ASC',
      );
      return List.generate(maps.length, (i) {
        return SecurityQuestion.fromMap(maps[i]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<int> deleteAllSecurityQuestions() async {
    try {
      final db = await database;
      return await db.delete('security_question');
    } catch (e) {
      rethrow;
    }
  }



  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
