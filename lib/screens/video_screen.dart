import 'package:flutter/material.dart';
import 'package:sample_youtube_api_app/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final Video video;
  final String id;

  VideoScreen({this.video, this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState(video: video);
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;
  final Video video;

  _VideoScreenState({this.video});

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                print('Player is ready');
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          video.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${video.viewCount} views",
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {},
                        ),
                        Container(
                          child: Text("${int.parse(video.likeCount)}"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {},
                        ),
                        // Icon(),
                        Container(
                          child: Text("${int.parse(video.dislikeCount)}"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {},
                        ),
                        // Icon(),
                        Container(
                          child: Text("Share"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 25.0,
              color: Colors.black12,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(video.description),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
