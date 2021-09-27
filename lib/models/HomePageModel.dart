class HomePageModel {
  String message;
  int status;
  int success;
  List<HomeData> data;

  HomePageModel({this.message, this.status, this.success, this.data});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = new List<HomeData>();
      json['data'].forEach((v) {
        data.add(new HomeData.fromJson(v));
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

class HomeData {
  String id;
  String userId;
  String insertType;
  String voteStatus;
  String title;
  List<String> voiceMsg;
  String coverImg;
  String description;
  String gallery;
  String notes;
  String interests;
  String priority;
  String solutionType;
  String createdAt;
  String modifiedAt;
  int percentage;
  String userImage;

  HomeData(
      {this.id,
        this.userId,
        this.insertType,
        this.voteStatus,
        this.title,
        this.coverImg,
        this.voiceMsg,
        this.description,
        this.gallery,
        this.notes,
        this.interests,
        this.priority,
        this.solutionType,
        this.createdAt,
        this.modifiedAt,
        this.percentage,
        this.userImage});

  HomeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    insertType = json['insert_type'];
    voteStatus = json['vote_status'];
    title = json['title'];
    coverImg = json['cover_img'];
    voiceMsg = json['voice_msg'].cast<String>();
    description = json['description'];
    gallery = json['gallery'];
    notes = json['notes'];
    interests = json['interests'];
    priority = json['priority'];
    solutionType = json['solution_type'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    percentage = json['percentage'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['insert_type'] = this.insertType;
    data['vote_status'] = this.voteStatus;
    data['title'] = this.title;
    data['cover_img'] = this.coverImg;
    data['voice_msg'] = this.voiceMsg;
    data['description'] = this.description;
    data['gallery'] = this.gallery;
    data['notes'] = this.notes;
    data['interests'] = this.interests;
    data['priority'] = this.priority;
    data['solution_type'] = this.solutionType;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['percentage'] = this.percentage;
    data['user_image'] = this.userImage;
    return data;
  }
}