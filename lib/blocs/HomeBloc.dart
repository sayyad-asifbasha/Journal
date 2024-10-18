import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_1/services/authentication_api.dart';
import 'package:project_1/services/db_firestore_api.dart';
import 'package:project_1/models/modal.dart';

class HomeBloc {
  late final DbApi dbApi;
  late final AuthenticationApi authenticationApi;
  final StreamController<List<Journal>> _journalController =
      StreamController<List<Journal>>();

  Sink<List<Journal>> get _addListJournal => _journalController.sink;

  Stream<List<Journal>> get listJournal => _journalController.stream;

  final StreamController<Journal> _journalDeleteController =
      StreamController<Journal>();

  Sink<Journal> get deleteJournal => _journalDeleteController.sink;

  HomeBloc(this.dbApi, this.authenticationApi) {
    _startListners();
  }

  void dispose() {
    _journalController.close();
    _journalDeleteController.close();
  }

  void _startListners() async {
    User? user = await authenticationApi.getFirebaseAuth().currentUser;
    if (user != null) {
      dbApi.getJournalList(user!.uid).listen((journalDocs) {
        _addListJournal.add(journalDocs);
      });
    } else {
      _addListJournal.add([]);
    }
    _journalDeleteController.stream.listen((journal) {
      dbApi.deleteJournal(journal);
    });
  }
}
