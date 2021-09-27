class IdeasListModel {
  String message;
  int status;
  int success;
  List<Data2> data;

  IdeasListModel({this.message, this.status, this.success, this.data});

  IdeasListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data2>();
      json['data'].forEach((v) {
        data.add(new Data2.fromJson(v));
      });
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

class Data2 {
  String id;
  String userId;
  String insertType;
  String title;
  String coverImg;

  String description;
  String gallery;
  String notes;

  String interests;
  String priority;
  String createdAt;
  String modifiedAt;
  String percentage;
  String user_image;

  Data2(
      {this.id,
      this.userId,
      this.insertType,
      this.title,
      this.coverImg,

      this.description,
      this.gallery,
      this.notes,
      this.interests,
      this.priority,
      this.createdAt,
      this.modifiedAt,
      this.percentage,
      this.user_image});

  Data2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    insertType = json['insert_type'];
    title = json['title'];
    coverImg = json['cover_img'];

    description = json['description'];
    gallery = json['gallery'];
    notes = json['notes'];
    interests = json['interests'];
    priority = json['priority'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'].toString();
    percentage = json["percentage"];
    user_image = json["user_image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['insert_type'] = this.insertType;
    data['title'] = this.title;
    data['cover_img'] = this.coverImg;

    data['description'] = this.description;
    data['gallery'] = this.gallery;
    data['notes'] = this.notes;
    data['interests'] = this.interests;
    data['priority'] = this.priority;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data["percentage"] = this.percentage;
    data["user_image"] = this.user_image;
    return data;
  }
}
