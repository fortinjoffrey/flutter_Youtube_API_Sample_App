import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sample_youtube_api_app/models/channel.dart';
import 'package:sample_youtube_api_app/models/video.dart';
import 'package:sample_youtube_api_app/utilities/keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, 'youtube/v3/channels', parameters);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get channel
    var response = await http.get(uri, headers: headers);
    if (200 == response.statusCode) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch  first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<Video> _fetchVideoInfoFromId({String videoId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, statistics',
      'id': videoId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, 'youtube/v3/videos', parameters);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);

    if (200 == response.statusCode) {
      var data = json.decode(response.body);

      dynamic videoJson = data['items'][0];

      return Video.fromMap(videoJson);
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, status, contentDetails, status',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(_baseUrl, 'youtube/v3/playlistItems', parameters);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get playlist videos
    var response = await http.get(uri, headers: headers);

    if (200 == response.statusCode) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from upload playlist
      List<Video> videos = [];

      await Future.forEach(videosJson, (json) async {
        String videoId = json['snippet']['resourceId']['videoId'];
        Video video = await _fetchVideoInfoFromId(videoId: videoId);
        videos.add(video);
      });

      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
