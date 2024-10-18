import 'package:project_1/models/modal.dart';


abstract class DbApi
{
  Stream<List<Journal>> getJournalList(String uid);
  Future<Journal> getJournal(String doucmentID);
  Future<bool> addJournal(Journal journal);
  void updateJournal(Journal journal);
  void deleteJournal(Journal jouranl);
  // void updateJournalWithTransaction(Journal journal);
}