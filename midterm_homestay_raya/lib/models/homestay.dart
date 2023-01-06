class Homestay {
  String? homestayId;
  String? userId;
  String? homestayName;
  String? homestayDesc;
  String? homestayPrice;
  String? homestayRoom;
  String? homestayState;
  String? homestayLocality;
  String? homestayLat;
  String? homestayLng;
  String? homestayContact;
  String? homestayDate;

  Homestay(
      {this.homestayId,
      this.userId,
      this.homestayName,
      this.homestayDesc,
      this.homestayPrice,
      this.homestayRoom,
      this.homestayState,
      this.homestayLocality,
      this.homestayLat,
      this.homestayLng,
      this.homestayContact,
      this.homestayDate});

  Homestay.fromJson(Map<String, dynamic> json) {
    homestayId = json['homestay_id'];
    userId = json['user_id'];
    homestayName = json['homestay_name'];
    homestayDesc = json['homestay_desc'];
    homestayPrice = json['homestay_price'];
    homestayRoom = json['homestay_room'];
    homestayState = json['homestay_state'];
    homestayLocality = json['homestay_locality'];
    homestayLat = json['homestay_lat'];
    homestayLng = json['homestay_lng'];
    homestayContact = json['homestay_contact'];
    homestayDate = json['homestay_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['homestay_id'] = homestayId;
    data['user_id'] = userId;
    data['homestay_name'] = homestayName;
    data['homestay_desc'] = homestayDesc;
    data['homestay_price'] = homestayPrice;
    data['homestay_room'] = homestayRoom;
    data['homestay_state'] = homestayState;
    data['homestay_locality'] = homestayLocality;
    data['homestay_lat'] = homestayLat;
    data['homestay_lng'] = homestayLng;
    data['homestay_contact'] = homestayContact;
    data['homestay_date'] = homestayDate;
    return data;
  }
}