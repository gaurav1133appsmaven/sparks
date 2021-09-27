class CommentsModel {
  String message;
  int status;
  int success;
  List<CommentsData> data;

  CommentsModel({this.message, this.status, this.success, this.data});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = new List<CommentsData>();
      json['data'].forEach((v) {
        data.add(new CommentsData.fromJson(v));
      });
      data = List.from(data.reversed);

    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentsData {
  String id;
  String userId;
  String circleId;
  String ideaId;
  String comment;
  String readBy;
  String createdAt;
  String modifiedAt;
  String userImage;
  String userReadBy;

  CommentsData(
      {this.id,
        this.userId,
        this.circleId,
        this.ideaId,
        this.comment,
        this.readBy,
        this.createdAt,
        this.modifiedAt,
        this.userImage,
        this.userReadBy});

  CommentsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    circleId = json['circle_id'];
    ideaId = json['idea_id'];
    comment = json['comment'];
    readBy = json['read_by'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    userImage = json['user_image'];
    userReadBy = json['user_read_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['circle_id'] = this.circleId;
    data['idea_id'] = this.ideaId;
    data['comment'] = this.comment;
    data['read_by'] = this.readBy;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['user_image'] = this.userImage;
    data['user_read_by'] = this.userReadBy;
    return data;
  }
}