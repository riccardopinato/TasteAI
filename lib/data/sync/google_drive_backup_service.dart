import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/account/google_account_controller.dart';
import '../../domain/backup/taste_backup_payload.dart';

class DriveBackupException implements Exception {
  const DriveBackupException(this.code);

  final String code;

  @override
  String toString() => 'DriveBackupException($code)';
}

class GoogleDriveBackupService {
  GoogleDriveBackupService({
    required GoogleAccountController accountController,
    http.Client? client,
  })  : _accountController = accountController,
        _client = client ?? http.Client();

  static const String backupFileName = 'tasteai_backup_v1.json';

  final GoogleAccountController _accountController;
  final http.Client _client;

  Future<void> upload(TasteBackupPayload payload) async {
    final Map<String, String> headers = await _authorizedHeaders();
    final String? existingId = await _latestBackupFileId(headers);

    if (existingId != null) {
      final http.Response response = await _client.patch(
        Uri.parse(
          'https://www.googleapis.com/upload/drive/v3/files/'
          '$existingId?uploadType=media',
        ),
        headers: <String, String>{
          ...headers,
          'content-type': 'application/json; charset=utf-8',
        },
        body: payload.encode(),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw DriveBackupException(
          'update_http_${response.statusCode}',
        );
      }
      return;
    }

    final String boundary =
        'tasteai_${DateTime.now().microsecondsSinceEpoch}';
    final String metadata = jsonEncode(
      <String, Object?>{
        'name': backupFileName,
        'parents': <String>['appDataFolder'],
        'mimeType': 'application/json',
      },
    );
    final String body = <String>[
      '--$boundary\r\n',
      'Content-Type: application/json; charset=UTF-8\r\n\r\n',
      metadata,
      '\r\n--$boundary\r\n',
      'Content-Type: application/json; charset=UTF-8\r\n\r\n',
      payload.encode(),
      '\r\n--$boundary--\r\n',
    ].join();

    final http.Response response = await _client.post(
      Uri.parse(
        'https://www.googleapis.com/upload/drive/v3/files'
        '?uploadType=multipart',
      ),
      headers: <String, String>{
        ...headers,
        'content-type': 'multipart/related; boundary=$boundary',
      },
      body: body,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw DriveBackupException(
        'create_http_${response.statusCode}',
      );
    }
  }

  Future<TasteBackupPayload?> downloadLatest() async {
    final Map<String, String> headers = await _authorizedHeaders();
    final String? fileId = await _latestBackupFileId(headers);
    if (fileId == null) return null;

    final http.Response response = await _client.get(
      Uri.parse(
        'https://www.googleapis.com/drive/v3/files/'
        '$fileId?alt=media',
      ),
      headers: headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw DriveBackupException(
        'download_http_${response.statusCode}',
      );
    }
    return TasteBackupPayload.decode(response.body);
  }

  Future<Map<String, String>> _authorizedHeaders() async {
    final Map<String, String>? headers =
        await _accountController.authorizeDriveHeaders();
    if (headers == null) {
      throw const DriveBackupException('drive_authorization_required');
    }
    return headers;
  }

  Future<String?> _latestBackupFileId(
    Map<String, String> headers,
  ) async {
    final Uri uri = Uri.https(
      'www.googleapis.com',
      '/drive/v3/files',
      <String, String>{
        'spaces': 'appDataFolder',
        'q': "name = '$backupFileName' and trashed = false",
        'fields': 'files(id,name,modifiedTime)',
        'orderBy': 'modifiedTime desc',
        'pageSize': '1',
      },
    );
    final http.Response response =
        await _client.get(uri, headers: headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw DriveBackupException(
        'list_http_${response.statusCode}',
      );
    }

    final Object? decoded = jsonDecode(response.body);
    if (decoded is! Map<Object?, Object?>) return null;
    final Object? rawFiles = decoded['files'];
    if (rawFiles is! List<Object?> || rawFiles.isEmpty) return null;
    final Object? first = rawFiles.first;
    if (first is! Map<Object?, Object?>) return null;
    return first['id']?.toString();
  }

  void dispose() {
    _client.close();
  }
}
