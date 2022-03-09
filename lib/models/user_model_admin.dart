class UserAdmin {
  int? uid;
  bool? isSystem;
  bool? isAdmin;
  UserAdminContext? userAdminContext;
  String? db;
  // String? serverVersion;
  // List<int>? serverVersionInfo;
  String? name;
  String? username;
  String? partnerDisplayName;
  int? companyId;
  int? partnerId;
  String? webBaseUrl;

  UserAdmin(
      {this.uid,
      this.isSystem,
      this.isAdmin,
      this.userAdminContext,
      this.db,
      // this.serverVersion,
      // this.serverVersionInfo,
      this.name,
      this.username,
      this.partnerDisplayName,
      this.companyId,
      this.partnerId,
      this.webBaseUrl});

  UserAdmin.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    isSystem = json['is_system'];
    isAdmin = json['is_admin'];
    userAdminContext = json['user_context'] != null
        ? new UserAdminContext.fromJson(json['user_context'])
        : null;
    db = json['db'];
    // serverVersion = json['server_version'];
    // serverVersionInfo = json['server_version_info'].cast<int>();
    name = json['name'];
    username = json['username'];
    partnerDisplayName = json['partner_display_name'];
    companyId = json['company_id'];
    partnerId = json['partner_id'];
    webBaseUrl = json['web.base.url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['is_system'] = this.isSystem;
    data['is_admin'] = this.isAdmin;
    if (this.userAdminContext != null) {
      data['user_context'] = this.userAdminContext!.toJson();
    }
    data['db'] = this.db;
    // data['server_version'] = this.serverVersion;
    // data['server_version_info'] = this.serverVersionInfo;
    data['name'] = this.name;
    data['username'] = this.username;
    data['partner_display_name'] = this.partnerDisplayName;
    data['company_id'] = this.companyId;
    data['partner_id'] = this.partnerId;
    data['web.base.url'] = this.webBaseUrl;
    return data;
  }
}

class UserAdminContext {
  String? lang;
  String? tz;
  int? uid;

  UserAdminContext({this.lang, this.tz, this.uid});

  UserAdminContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    tz = json['tz'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lang'] = this.lang;
    data['tz'] = this.tz;
    data['uid'] = this.uid;
    return data;
  }
}

class UserPwdAdmin {
  String? passwordAd;

  UserPwdAdmin({this.passwordAd});

  UserPwdAdmin.fromJson(Map<String, dynamic> json) {
    passwordAd = json['passwordAd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['passwordAd'] = this.passwordAd;
    return data;
  }
}
