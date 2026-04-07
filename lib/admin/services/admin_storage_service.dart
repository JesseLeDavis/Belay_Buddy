import 'dart:typed_data';

import 'package:belay_buddy/src/features/venues/domain/header_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Handles uploading header SVGs to Firebase Storage and persisting
/// the HeaderConfig to Firestore.
class AdminStorageService {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;

  AdminStorageService({
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Uploads an SVG file for a specific panel and returns the download URL.
  Future<String> uploadPanelSvg({
    required String venueId,
    required int panelIndex,
    required Uint8List bytes,
    required String fileName,
  }) async {
    final ref = _storage.ref('headers/$venueId/panel_$panelIndex.svg');
    final metadata = SettableMetadata(contentType: 'image/svg+xml');
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  /// Saves the full HeaderConfig to Firestore.
  Future<void> saveHeaderConfig(HeaderConfig config) async {
    await _firestore
        .collection('headerConfigs')
        .doc(config.cragId)
        .set(config.toJson());
  }

  /// Deletes a panel's custom SVG from Storage and clears its URL.
  Future<void> deletePanelSvg({
    required String venueId,
    required int panelIndex,
  }) async {
    try {
      final ref = _storage.ref('headers/$venueId/panel_$panelIndex.svg');
      await ref.delete();
    } on FirebaseException {
      // File may not exist — that's fine
    }
  }
}
