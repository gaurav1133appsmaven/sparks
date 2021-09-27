class RegisterModel {
  String message;
  int status;
  int success;
  Data data;

  RegisterModel({this.message, this.status, this.success, this.data});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  String email;
  String userName;

  Data({this.userId, this.email, this.userName});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['user_name'] = this.userName;
    return data;
  }
}