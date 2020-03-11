import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:ifrauser/models/missing_person/missing_person.dart';

class MissingPersonService {
  static Future<MissingPerson> fetchMissingPersonDetails(
      int issueNumber) async {
    final CollectionReference ref =
        fb.firestore().collection('missing_persons');
    final DocumentSnapshot doc =
        await ref.doc(issueNumber ?? 'Z1QkAf77Fg5hskPzfg45').get();

    MissingPerson missingPerson = MissingPerson.fromJson(doc.data());
    return missingPerson;
  }
}
