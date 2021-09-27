class MyProfileModel {
  String message;
  int status;
  int success;
  Data data;

  MyProfileModel({this.message, this.status, this.success, this.data});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String userId;
  String firstName;
  String lastName;
  String image;
  String ideasLimit;
  String createdIdeasCount;
  String createdCirclesCount;
  String monthlyAvgIdeas;
  String userStatus;
  List<Ideas> ideas;

  Data(
      {this.userId,
        this.firstName,
        this.lastName,
        this.image,
        this.ideasLimit,
        this.createdIdeasCount,
        this.createdCirclesCount,
        this.monthlyAvgIdeas,
        this.userStatus,
        this.ideas});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    ideasLimit = json['ideas_limit'];
    createdIdeasCount = json['created_ideas_count'];
    createdCirclesCount = json['created_circles_count'];
    monthlyAvgIdeas = json['monthly_avg_ideas'];
    userStatus = json['user_status'];
    if (json['ideas'] != null) {
      ideas = new List<Ideas>();
      json['ideas'].forEach((v) {
        ideas.add(new Ideas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['ideas_limit'] = this.ideasLimit;
    data['created_ideas_count'] = this.createdIdeasCount;
    data['created_circles_count'] = this.createdCirclesCount;
    data['monthly_avg_ideas'] = this.monthlyAvgIdeas;
    data['user_status'] = this.userStatus;
    if (this.ideas != null) {
      data['ideas'] = this.ideas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ideas {
  String id;
  String userId;
  String insertType;
  String voteStatus;
  String title;
  String coverImg;
  String voiceMsg;
  String description;
  String gallery;
  String notes;
  String interests;
  String priority;
  String solutionType;
  String score;
  String rank;
  String scoreUpdation;
  String rankUpdation;
  String createdAt;
  String modifiedAt;

  Ideas(
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
        this.score,
        this.rank,
        this.scoreUpdation,
        this.rankUpdation,
        this.createdAt,
        this.modifiedAt});

  Ideas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    insertType = json['insert_type'];
    voteStatus = json['vote_status'];
    title = json['title'];
    coverImg = json['cover_img'];
    voiceMsg = json['voice_msg'];
    description = json['description'];
    gallery = json['gallery'];
    notes = json['notes'];
    interests = json['interests'];
    priority = json['priority'];
    solutionType = json['solution_type'];
    score = json['score'].toString();
    rank = json['rank'].toString();
    scoreUpdation = json['score_updation'].toString();
    rankUpdation = json['rank_updation'].toString();
    createdAt = json['created_at'].toString();
    modifiedAt = json['modified_at'].toString();
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
    data['score'] = this.score;
    data['rank'] = this.rank;
    data['score_updation'] = this.scoreUpdation;
    data['rank_updation'] = this.rankUpdation;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    return data;
  }
}