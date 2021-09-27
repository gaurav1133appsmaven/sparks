class QuickIdeaModel {
  String message;
  int status;
  int success;
  String limit;

  QuickIdeaModel({this.message, this.status, this.success, this.limit});

  QuickIdeaModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    data['limit'] = this.limit;
    return data;
  }
}