import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;

class ImageService {
  static Future<void> uploadImageFile(html.File image,List<String> _downloadUrlList,{String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref('images/$imageName');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
    await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    _downloadUrlList.add(imageUri.toString());
  }
}