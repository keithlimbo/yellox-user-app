import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yellox_driver_app/models/user_profile.dart';

import '../models/user_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the patient table
  Future<Database?> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'yellox_db.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Patients
      await db.execute('CREATE TABLE IF NOT EXISTS userProfile('
          'id                   INTEGER PRIMARY KEY,'
          'name                 VARCHAR(255),'
          'email                VARCHAR(255),'
          'vat                  VARCHAR(255),'
          'company_name         VARCHAR(255),'
          'phone                VARCHAR(255),'
          'mobile               VARCHAR(255),'
          'street               TEXT,'
          'street2              TEXT,'
          'city                 VARCHAR(255),'
          'country_id           INTEGER,'
          'state_id             INTEGER,'
          'message_attachment_count INTEGER,'
          'email_verified       VARCHAR(255),'
          'smile_user_id        VARCHAR(255),'
          'smile_user_record    VARCHAR(255),'
          'mobile_verified      VARCHAR(255),'
          'account_status       VARCHAR(255),'
          'employment_status    VARCHAR(255),'
          'preferred_payment_dates VARCHAR(255)'
          ')');
    });
  }

  // Insert userProfile on database
  createUserProfile(UserProfile userProfile) async {
    await deleteAllUserProfile();
    final db = await database;
    try {
      final res = await db!.insert('userProfile', userProfile.toJson());
      return res;
    } catch (e) {}
  }

  // Delete all userProfile
  Future<int> deleteAllUserProfile() async {
    final db = await database;
    final res = await db!.rawDelete('DELETE FROM userProfile');

    return res;
  }

  Future<List<UserData>> getAllUserProfile() async {
    final db = await database;
    final res = await db!.rawQuery("SELECT * FROM userProfile");

    List<UserData> list =
        res.isNotEmpty ? res.map((c) => UserData.fromJson(c)).toList() : [];

    return list;
  }

  // Insert doctors on database
  // createDoctors(Doctors doctors) async {
  //   await deleteAllDoctors();
  //   final db = await database;
  //   try {
  //     final res = await db!.insert('doctors', doctors.toJson());
  //     return res;
  //   } catch (e) {}
  // }

  // // Delete all patients
  // Future<int> deleteAllDoctors() async {
  //   final db = await database;
  //   final res = await db!.rawDelete('DELETE FROM doctors');

  //   return res;
  // }

  // Future<List<Doctors>> getAllDoctors() async {
  //   final db = await database;
  //   final res = await db!.rawQuery("SELECT * FROM doctors");

  //   List<Doctors> list =
  //       res.isNotEmpty ? res.map((c) => Doctors.fromJson(c)).toList() : [];
  //   return list;
  // }
}
