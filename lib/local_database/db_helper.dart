import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:visiting_card/models/contact_model.dart';

class DbHelper {
  final String _createcontactTable = """create table $contactTable(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColEmail text,
  $tblContactColMobile text,
  $tblContactColAddress text,
  $tblContactColCompanyName text,
  $tblContactColDesignation text,
  $tblContactColWebsite text,
  $tblContactColImage text,
  $tblContactColFavorite integer)""";
  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = p.join(root, "contact.db");
    return openDatabase(dbPath,version: 1 , onCreate: (db, version){
      db.execute(_createcontactTable);
    },);
  }


  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(contactTable, contactModel.toMap());
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await _open();
    final mapList = await db.query(contactTable);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<List<ContactModel>> getAllFavoriteContacts() async {
    final db = await _open();
    final mapList = await db.query(contactTable, where: '$tblContactColFavorite = ?', whereArgs: [1]);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<ContactModel> getContactById(int id) async {
    final db = await _open();
    final mapList = await db.query(contactTable, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    return db.delete(contactTable, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  Future<int> updateContactField(int id, Map<String, dynamic> map) async {
    final db = await _open();
    return db.update(contactTable, map, where: '$tblContactColId = ?', whereArgs: [id]);
  }
  
}
