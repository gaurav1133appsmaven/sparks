class TopSuggestionModel {
  String message;
  int status;
  int success;
  Data data;

  TopSuggestionModel({this.message, this.status, this.success, this.data});

  TopSuggestionModel.fromJson(Map<String, dynamic> json) {
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
  int score;
  String rank;
  String scoreUpdation;
  String rankUpdation;
  String createdAt;
  String modifiedAt;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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