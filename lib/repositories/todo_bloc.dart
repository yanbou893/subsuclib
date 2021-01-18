import 'dart:async';
import 'dart:core';
import 'package:subsuclib/models/todo.dart';
import 'package:subsuclib/repositories/db_provider.dart';

class TodoBloc {

  final _subsucController = StreamController<List<Subsuc>>();
  Stream<List<Subsuc>> get todoStream => _subsucController.stream;

  getSubsucs() async {
    _subsucController.sink.add(await DBProvider.db.getAllSubsuc());
  }

  TodoBloc() {
    getSubsucs();
  }

  dispose() {
    _subsucController.close();
  }

  create(Subsuc subsuc) {
    subsuc.assignUUID();
    DBProvider.db.createSubsuc(subsuc);
    getSubsucs();
  }

  update(Subsuc subsuc) {
    DBProvider.db.updateSubsuc(subsuc);
    getSubsucs();
  }

  delete(String id) {
    DBProvider.db.deleteSubsuc(id);
    getSubsucs();
  }
}