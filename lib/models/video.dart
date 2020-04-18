class Video {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String viewCount;
  final String likeCount;
  final String dislikeCount;
  final String commentCount;

  Video({
    this.id,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.channelTitle,
    this.viewCount,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['snippet']['title'],
      description: map['snippet']['description'],
      thumbnailUrl: map['snippet']['thumbnails']['high']['url'],
      channelTitle: map['snippet']['channelTitle'],
      viewCount: map['statistics']['viewCount'],
      likeCount: map['statistics']['likeCount'],
      dislikeCount: map['statistics']['dislikeCount'],
      commentCount: map['statistics']['commentCount'],
    );
  }
}
