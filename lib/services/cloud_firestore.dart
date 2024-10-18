import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_1/services/db_firestore_api.dart';
import 'package:project_1/models/modal.dart';

class DbFireStoreService implements DbApi
{
  final FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  String _collectionJournal='journals';
  DbFireStoreService()
  {
    _firebaseFirestore.settings;
  }
  Stream<List<Journal>> getJournalList(String? uid) {
    return _firebaseFirestore
        .collection(_collectionJournal)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      List<Journal> _journalDocs = snapshot.docs
          .map((doc) => Journal.fromDoc(doc.data(), doc.id))
          .toList();
      _journalDocs.sort((comp1, comp2) => comp2.date!.compareTo(comp1.date!));
      return _journalDocs;
    });
  }
  Future<Journal> getJournal(String documentID)async
  {
    DocumentReference _documentRef= _firebaseFirestore.collection(_collectionJournal).doc(documentID);
    return Journal.fromDoc(await _documentRef.get().then((doc)=>doc.data()), documentID);
  }
  Future<bool> addJournal(Journal journal)async
  {
  DocumentReference _documentRef=await _firebaseFirestore.collection(_collectionJournal).add({
    "date":journal.date,
    "mood":journal.mood,
    "note":journal.note,
    "uid":journal.uid
  });
  return _documentRef.id!=null;
  }
  void updateJournal(Journal journal)async{
    await _firebaseFirestore.collection(_collectionJournal).doc(journal.documentID).update(
      {
        "date":journal.date,
        "mood":journal.mood,
        "note":journal.note
      }
    ).catchError((error)=>print(error));
  }
  void deleteJournal(Journal jouranl) async
  {
    await _firebaseFirestore.collection(_collectionJournal).doc(jouranl.documentID).delete().catchError((error)=>print(error));
  }


}
