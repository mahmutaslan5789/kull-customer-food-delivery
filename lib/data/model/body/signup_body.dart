class SignUpBody {
  String fName;
  String lName;
  String phone;
  String email;
  String social_id;
  String password;

  SignUpBody({this.fName, this.lName, this.phone, this.email='', this.password,this.social_id});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    social_id = json['social_id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['social_id'] = this.social_id;
    data['password'] = this.password;
    return data;
  }
}
