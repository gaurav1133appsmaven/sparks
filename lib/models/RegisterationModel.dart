class RegisterationModel {
  String message;
  int status;
  int success;
  Data data;

  RegisterationModel({this.message, this.status, this.success, this.data});

  RegisterationModel.fromJson(Map<String, dynamic> json) {
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
  String email;
  String password;
  String username;
  String firstName;
  String lastName;
  String image;
  String onboardingStatus;
  String phoneNo;
  String country;
  String state;
  String city;
  String birthDate;
  String ethnicity;
  String gender;
  String statusType;
  String occupation;
  String interests;
  String minFreeTime;
  String maxFreeTime;
  String ideasForMonths;
  String inviteStatus;
  String createdAt;
  String modifiedAt;

  Data(
      {this.id,
        this.email,
        this.password,
        this.username,
        this.firstName,
        this.lastName,
        this.image,
        this.onboardingStatus,
        this.phoneNo,
        this.country,
        this.state,
        this.city,
        this.birthDate,
        this.ethnicity,
        this.gender,
        this.statusType,
        this.occupation,
        this.interests,
        this.minFreeTime,
        this.maxFreeTime,
        this.ideasForMonths,
        this.inviteStatus,
        this.createdAt,
        this.modifiedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    onboardingStatus = json['onboarding_status'];
    phoneNo = json['phone_no'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    birthDate = json['birth_date'];
    ethnicity = json['ethnicity'];
    gender = json['gender'];
    statusType = json['status_type'];
    occupation = json['occupation'];
    interests = json['interests'];
    minFreeTime = json['min_free_time'];
    maxFreeTime = json['max_free_time'];
    ideasForMonths = json['ideas_for_months'];
    inviteStatus = json['invite_status'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    data['onboarding_status'] = this.onboardingStatus;
    data['phone_no'] = this.phoneNo;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['birth_date'] = this.birthDate;
    data['ethnicity'] = this.ethnicity;
    data['gender'] = this.gender;
    data['status_type'] = this.statusType;
    data['occupation'] = this.occupation;
    data['interests'] = this.interests;
    data['min_free_time'] = this.minFreeTime;
    data['max_free_time'] = this.maxFreeTime;
    data['ideas_for_months'] = this.ideasForMonths;
    data['invite_status'] = this.inviteStatus;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    return data;
  }
}