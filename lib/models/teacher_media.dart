import 'package:equatable/equatable.dart';

class TeacherActivity extends Equatable {
  const TeacherActivity({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.image,
    required this.isGlobal,
    required this.scopeLabel,
  });

  factory TeacherActivity.fromJson(Map<String, dynamic> json) {
    return TeacherActivity(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      date: DateTime.parse((json['date'] ?? DateTime.now().toIso8601String()) as String),
      image: (json['image'] ?? '') as String,
      isGlobal: json['isGlobal'] == true || json['is_global'] == true,
      scopeLabel: (json['scopeLabel'] ?? json['scope_label'] ?? '') as String,
    );
  }

  final int id;
  final String title;
  final String content;
  final DateTime date;
  final String image;
  final bool isGlobal;
  final String scopeLabel;

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    date,
    image,
    isGlobal,
    scopeLabel,
  ];
}

class TeacherAlbumImage extends Equatable {
  const TeacherAlbumImage({
    required this.id,
    required this.imageLink,
    this.caption,
    required this.position,
  });

  factory TeacherAlbumImage.fromJson(Map<String, dynamic> json) {
    return TeacherAlbumImage(
      id: json['id'] as int,
      imageLink: (json['imageLink'] ?? json['image_link'] ?? '') as String,
      caption: json['caption'] as String?,
      position: (json['position'] ?? 0) as int,
    );
  }

  final int id;
  final String imageLink;
  final String? caption;
  final int position;

  @override
  List<Object?> get props => [id, imageLink, caption, position];
}

class TeacherAlbum extends Equatable {
  const TeacherAlbum({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.yearTitle,
    required this.photoCount,
    this.coverImage,
    this.images = const [],
  });

  factory TeacherAlbum.fromJson(Map<String, dynamic> json) {
    final images = ((json['images'] as List<dynamic>?) ?? [])
        .map(
          (item) => TeacherAlbumImage.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
    return TeacherAlbum(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      date: DateTime.parse(
        (json['date'] ?? DateTime.now().toIso8601String()) as String,
      ),
      yearTitle: (json['yearTitle'] ?? json['year_title'] ?? '') as String,
      photoCount: (json['photoCount'] ?? json['photo_count'] ?? images.length)
          as int,
      coverImage: (json['coverImage'] ?? json['cover_image']) as String? ??
          (images.isEmpty ? null : images.first.imageLink),
      images: images,
    );
  }

  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String yearTitle;
  final int photoCount;
  final String? coverImage;
  final List<TeacherAlbumImage> images;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    yearTitle,
    photoCount,
    coverImage,
    images,
  ];
}
