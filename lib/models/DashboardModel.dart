class DashboardModel {
  String message;
  int status;
  int success;
  DataDashBoard data;

  DashboardModel({this.message, this.status, this.success, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    data = json['data'] != null ? new DataDashBoard.fromJson(json['data']) : null;
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

class DataDashBoard {
  String topScore;
  String scoreUpdation;
  String rank;
  String rankUpdation;
  List<Circles> circles;

  DataDashBoard(
      {this.topScore,
        this.scoreUpdation,
        this.rank,
        this.rankUpdation,
        this.circles});

  DataDashBoard.fromJson(Map<String, dynamic> json) {
    topScore = json['top_score'];
    scoreUpdation = json['score_updation'];
    rank = json['rank'];
    rankUpdation = json['rank_updation'];
    if (json['circles'] != null) {
      circles = new List<Circles>();
      json['circles'].forEach((v) {
        circles.add(new Circles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['top_score'] = this.topScore;
    data['score_updation'] = this.scoreUpdation;
    data['rank'] = this.rank;
    data['rank_updation'] = this.rankUpdation;
    if (this.circles != null) {
      data['circles'] = this.circles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Circles {
  String circleId;
  String ideaId;
  String circleImage;
  String percentage;
  String totalUpvotes;
  String totalComments;

  Circles(
      {this.circleId,
        this.ideaId,
        this.circleImage,
        this.percentage,
        this.totalUpvotes,
        this.totalComments});

  Circles.fromJson(Map<String, dynamic> json) {
    circleId = json['circle_id'];
    ideaId = json['idea_id'];
    circleImage = json['circle_image'];
    percentage = json['percentage'].toString();
    totalUpvotes = json['total_upvotes'];
    totalComments = json['total_comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['circle_id'] = this.circleId;
    data['idea_id'] = this.ideaId;
    data['circle_image'] = this.circleImage;
    data['percentage'] = this.percentage;
    data['total_upvotes'] = this.totalUpvotes;
    data['total_comments'] = this.totalComments;
    return data;
  }
}