class QuestionsModel {
  String message;
  int status;
  int success;
  List<Data> data;

  QuestionsModel({this.message, this.status, this.success, this.data});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
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
  String milestone;
  String question;
  List<String> options;
  String createdAt;

  Data({this.id, this.milestone, this.question, this.options, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    milestone = json['milestone'];
    question = json['question'];
    options = json['options'].cast<String>();
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['milestone'] = this.milestone;
    data['question'] = this.question;
    data['options'] = this.options;
    data['created_at'] = this.createdAt;
    return data;
  }
}