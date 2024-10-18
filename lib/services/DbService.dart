import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_1/models/modal.dart';

class DbService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionJournal = 'journals';

  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournal)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Journal> _journalDocs = snapshot.docs
          .map((doc) => Journal.fromDoc(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      return _journalDocs; // Return the list of Journal objects
    });
  }
}
