import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Fungsi untuk membuat tabel database
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE catatan (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT
      )
    ''');
  }

  // Fungsi untuk membuka atau membuat database
  static Future<sql.Database> db() async {
    return sql.openDatabase('catatan.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // Fungsi untuk menambahkan catatan ke database
  static Future<int> tambahCatatan(String judul, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {'judul': judul, 'deskripsi': deskripsi};
    return await db.insert('catatan', data);
  }

  // Fungsi untuk mengambil data catatan dari database
  static Future<List<Map<String, dynamic>>> getCatatan() async {
    final db = await SQLHelper.db();
    return db.query('catatan');
  }

  static Future<int> ubahCatatan(int id, String judul, String deskripsi) async {
    final db = await SQLHelper.db();
    final data = {'judul': judul, 'deskripsi': deskripsi};
    return await db.update("catatan", data, where: "id=$id");
  }

  // Fungsi untuk menghapus catatan dari database berdasarkan ID
  static Future<int> hapusCatatan(int id) async {
    final db = await SQLHelper.db();
    return await db.delete("catatan", where: "id = ?", whereArgs: [id]);
  }
}
