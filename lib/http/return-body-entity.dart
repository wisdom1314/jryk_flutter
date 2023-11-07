class ReturnBodyEntity {
  Object? data;
  int? code;
  String? message;
  bool? succ;

  ReturnBodyEntity({this.data, this.code, this.message, this.succ}) ;

  ReturnBodyEntity.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    code = json['code'];
    message = json['message'];
    succ = json['succ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['code'] = this.code;
    data['message'] = this.message;
    data['succ'] = this.succ;
    return data;
  }
}
