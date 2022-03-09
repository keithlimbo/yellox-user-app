class UserProfile {
  int? id;
  String? name;
  String? vatNo;
  String? email;
  String? companyName;
  String? phone;
  String? mobile;
  String? street;
  String? street2;
  String? city;
  List<int>? countryId;
  String? countryName;
  List<int>? stateId;
  int? messageAttachmentCount;
  bool? emailVerified;
  String? smileUserID;
  List<int>? smileUserRecord;
  bool? mobileVerified;
  String? accountStatus;
  String? employmentStatus;
  String? preferredPaymentDates;

  UserProfile(
      {this.id,
      this.name,
      this.vatNo,
      this.email,
      this.companyName,
      this.phone,
      this.mobile,
      this.street,
      this.street2,
      this.city,
      this.countryId,
      this.countryName,
      this.stateId,
      this.messageAttachmentCount,
      this.emailVerified,
      this.smileUserID,
      this.smileUserRecord,
      this.mobileVerified,
      this.accountStatus,
      this.employmentStatus,
      this.preferredPaymentDates});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vatNo = json['vat'].toString() == "false" || json['vat'] == null
        ? ""
        : json['vat'];
    email = json['email'].toString() == "false" ? "" : json['email'];
    companyName = json['company_name'].toString() == "false" ||
            json['company_name'] == null
        ? "No data provided"
        : json['company_name'];
    phone = json['phone'].toString() == "false" || json['phone'] == null
        ? ""
        : json['phone'];
    mobile = json['mobile'].toString() == "false"
        ? "No data available"
        : json['mobile'];
    street = json['street'].toString() == "false" ? "" : json['street'];
    street2 = json['street2'].toString() == "false" ? "" : json['street2'];
    city = json['city'].toString() == "false" ? "" : json['city'];

    countryId =
        json['country_id'].toString() == "false" || json['country_id'] == null
            ? []
            : json['country_id'].cast<int>();

    if (json['country_id'].toString() == "false" ||
        json['country_id'] == null) {
      countryName = "";
    } else {
      countryName = json['country_id'][1].toString();
    }

    stateId = json['state_id'].toString() == "false"
        ? []
        : json['state_id'].cast<int>();
    messageAttachmentCount = json['message_attachment_count'];
    emailVerified = json['email_verified'];
    // smileUserID = json['smile_user_id'].toString() == "false"
    //     ? "No data available"
    //     : json['smile_user_id'];
    // smileUserRecord = json['smile_user_record'].toString() == "false" ||
    //         json['smile_user_record'] == null
    //     ? 0
    //     : json['smile_user_record'].cast<int>();
    mobileVerified = json['mobile_verified'];
    accountStatus = json['account_status'].toString() == "false"
        ? "No data available"
        : json['account_status'];
    employmentStatus = json['employment_status'].toString() == "false"
        ? "No data available"
        : json['employment_status'];
    preferredPaymentDates = json['preferred_payment_dates'].toString() == "false"
        ? "No data available"
        : json['preferred_payment_dates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['vat'] = this.name;
    data['email'] = this.email;
    data['company_name'] = this.companyName;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['street'] = this.street;
    data['city'] = this.city;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['email_verified'] = this.emailVerified;
    // data['smile_user_id'] = this.smileUserID;
    data['mobile_verified'] = this.mobileVerified;
    data['account_status'] = this.accountStatus;
    data['employment_status'] = this.employmentStatus;
    data['preferred_payment_dates'] = this.preferredPaymentDates;
    return data;
  }
}
