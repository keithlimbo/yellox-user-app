class UserModel {
  String? jsonrpc;
  Null id;
  UserData? result;

  UserModel({this.jsonrpc, this.id, this.result});

  UserModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
        json['result'] != null ? new UserData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class UserData {
  int? uid;
  // bool? isSystem;
  // bool? isAdmin;
  UserContext? userContext;
  String? db;
  String? serverVersion;
  List<int>? serverVersionInfo;
  String? name;
  String? username;
  String? partnerDisplayName;
  int? companyId;
  int? partnerId;
  String? webBaseUrl;

  UserData(
      {this.uid,
      // this.isSystem,
      // this.isAdmin,
      this.userContext,
      this.db,
      this.serverVersion,
      this.serverVersionInfo,
      this.name,
      this.username,
      this.partnerDisplayName,
      this.companyId,
      this.partnerId,
      this.webBaseUrl});

  UserData.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    // isSystem = json['is_system'];
    // isAdmin = json['is_admin'];
    userContext = json['user_context'] != null
        ? new UserContext.fromJson(json['user_context'])
        : null;
    db = json['db'];
    serverVersion = json['server_version'];
    serverVersionInfo = json['server_version_info'].cast<int>();
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
    // data['is_system'] = this.isSystem;
    // data['is_admin'] = this.isAdmin;
    if (this.userContext != null) {
      data['user_context'] = this.userContext!.toJson();
    }
    data['db'] = this.db;
    data['server_version'] = this.serverVersion;
    data['server_version_info'] = this.serverVersionInfo;
    data['name'] = this.name;
    data['username'] = this.username;
    data['partner_display_name'] = this.partnerDisplayName;
    data['company_id'] = this.companyId;
    data['partner_id'] = this.partnerId;
    data['web.base.url'] = this.webBaseUrl;
    return data;
  }
}

class UserContext {
  String? lang;
  String? tz;
  int? uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    tz = json['tz'].toString() == "false" ? "" : json['tz'];
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

class UserPwd {
  String? password;

  UserPwd({this.password});

  UserPwd.fromJson(Map<String, dynamic> json) {
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    return data;
  }
}

class UserSession {
  String? sessionID;

  UserSession({this.sessionID});

  UserSession.fromJson(Map<String, dynamic> json) {
    sessionID = json['sessionID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionID'] = this.sessionID;
    return data;
  }
}

