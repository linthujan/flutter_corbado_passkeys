class HttpResponseModel {
  HttpResponseModel({
    required this.status,
    required this.meta,
    required this.data,
  });
  HttpResponseModel.fromJSON(dynamic json) {
    status = json['status'] as bool;
    meta = Meta.fromJSON(json['meta'] as dynamic);
    data = json['data'] as dynamic;
    error = json['error'] as dynamic;
  }
  late bool status;
  late Meta meta;
  dynamic data;
  dynamic error;
}

class Meta {
  Meta({
    required this.message,
    required this.status,
  });

  Meta.fromJSON(dynamic meta) {
    message = meta['message'] as String;
    // status = meta['status'] as int;
  }
  late String message;
  late int? status;
}
