
class CalculatorHistory {
  final int? id;
  final String expression;
  final String result;
  final String createdAt;

  const CalculatorHistory({
    this.id,
    required this.expression,
    required this.result,
    required this.createdAt,
  });

  factory CalculatorHistory.fromMap(Map<String, dynamic> map) {
    return CalculatorHistory(
      id: map['id'] as int?,
      expression: map['expression'] as String,
      result: map['result'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'expression': expression,
      'result': result,
      'created_at': createdAt,
    };
  }
}


class Password {
  final int? id;
  final String encryptedPassword;
  final String createdAt;
  final String? updatedAt;

  const Password({
    this.id,
    required this.encryptedPassword,
    required this.createdAt,
    this.updatedAt,
  });

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id'] as int?,
      encryptedPassword: map['encrypted_password'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'encrypted_password': encryptedPassword,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}


class Album {
  final int? id;
  final String name;
  final int itemCount;
  final String createdAt;

  const Album({
    this.id,
    required this.name,
    required this.itemCount,
    required this.createdAt,
  });

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as int?,
      name: map['name'] as String,
      itemCount: map['item_count'] as int,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'item_count': itemCount,
      'created_at': createdAt,
    };
  }
}


class Media {
  final int? id;
  final int albumId;
  final String type;
  final String encryptedPath;
  final String thumbnailPath;
  final String originalName;
  final int fileSize;
  final String createdAt;

  const Media({
    this.id,
    required this.albumId,
    required this.type,
    required this.encryptedPath,
    required this.thumbnailPath,
    required this.originalName,
    required this.fileSize,
    required this.createdAt,
  });

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      id: map['id'] as int?,
      albumId: map['album_id'] as int,
      type: map['type'] as String,
      encryptedPath: map['encrypted_path'] as String,
      thumbnailPath: map['thumbnail_path'] as String,
      originalName: map['original_name'] as String,
      fileSize: map['file_size'] as int,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'album_id': albumId,
      'type': type,
      'encrypted_path': encryptedPath,
      'thumbnail_path': thumbnailPath,
      'original_name': originalName,
      'file_size': fileSize,
      'created_at': createdAt,
    };
  }
}


class Note {
  final int? id;
  final String title;
  final String encryptedContent;
  final String createdAt;
  final String updatedAt;

  const Note({
    this.id,
    required this.title,
    required this.encryptedContent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      encryptedContent: map['encrypted_content'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'encrypted_content': encryptedContent,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}


class SecurityQuestion {
  final int? id;
  final String question;
  final String encryptedAnswer;
  final String createdAt;

  const SecurityQuestion({
    this.id,
    required this.question,
    required this.encryptedAnswer,
    required this.createdAt,
  });

  factory SecurityQuestion.fromMap(Map<String, dynamic> map) {
    return SecurityQuestion(
      id: map['id'] as int?,
      question: map['question'] as String,
      encryptedAnswer: map['encrypted_answer'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'question': question,
      'encrypted_answer': encryptedAnswer,
      'created_at': createdAt,
    };
  }
}
