class CirclesListModel {
  String message;
  int status;
  int success;
  List<Data> data;

  CirclesListModel({this.message, this.status, this.success, this.data});

  CirclesListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String id;
  String userId;
  String name;
  String image;
  String isActive;
  String isDeleted;
  String createdAt;
  String modifiedAt;
  List<Users> users;
  List<Ideas> ideas;

  Data(
      {this.id,
        this.userId,
        this.name,
        this.image,
        this.isActive,
        this.isDeleted,
        this.createdAt,
        this.modifiedAt,
        this.users,
        this.ideas});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'].toString();
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    if (json['ideas'] != null) {
      ideas = new List<Ideas>();
      json['ideas'].forEach((v) {
        ideas.add(new Ideas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.ideas != null) {
      data['ideas'] = this.ideas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String userId;
  String name;

  Users({this.userId, this.name});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
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
  String isActive;
  String isDeleted;
  String createdAt;
  String modifiedAt;
  String userImage;
  String relationId;
  String isLiked;
  int unread_count;

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
        this.isActive,
        this.isDeleted,
        this.createdAt,
        this.modifiedAt,
        this.userImage,
        this.relationId,
        this.isLiked,this.unread_count});

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
    score = json['score'];
    rank = json['rank'];
    scoreUpdation = json['score_updation'];
    rankUpdation = json['rank_updation'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    userImage = json['user_image'];
    relationId = json['relation_id'];
    unread_count = json['unread_count'];
    isLiked = json['is_liked'].toString();
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
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['user_image'] = this.userImage;
    data['relation_id'] = this.relationId;
    data['unread_count'] = this.unread_count;
    data['is_liked'] = this.isLiked;
    return data;
  }
}