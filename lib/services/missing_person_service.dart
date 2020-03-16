import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:ifrauser/models/missing_person/missing_person.dart';

class MissingPersonService {
  static Future<MissingPerson> fetchMissingPersonDetails(
      int issueNumber) async {
    MissingPerson missingPerson;
    final CollectionReference ref =
        fb.firestore().collection('missing_persons');
    final DocumentSnapshot doc =
        await ref.doc(issueNumber.toString() ?? 'Z1QkAf77Fg5hskPzfg45').get();

    if (doc.data() != null) missingPerson = MissingPerson.fromJson(doc.data());
    return missingPerson;
  }

  static Future<List<MissingPerson>> fetchAllMissingPersonDetails() async {
    List<MissingPerson> result = List<MissingPerson>();

    final CollectionReference ref =
        fb.firestore().collection('missing_persons');
    final QuerySnapshot response = await ref.get();

    final List<DocumentSnapshot> documents = response.docs;
    documents.forEach((doc) {
      MissingPerson missingPerson = MissingPerson.fromJson(doc.data());
      result.add(missingPerson);
    });
    return result;
  }
}
