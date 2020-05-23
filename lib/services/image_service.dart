import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;

class ImageService {
  static Future<void> uploadMultipleImageFile(
      html.File image, List<String> _downloadUrlList,
      {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref('sightings/$imageName');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    _downloadUrlList.add(imageUri.toString());
  }

  static Future<String> uploadImage(html.File image, {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref('face_search/$imageName');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri.toString();
  }
}
