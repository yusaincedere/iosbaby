import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  String parentId;
  String id;
  String ana_baslik;
  String baslik;
  String icerik;

  PostModel({
    this.parentId,
    this.id,
    this.ana_baslik,
    this.baslik,
    this.icerik,
  });

  factory PostModel.fromFirestore(DocumentSnapshot documentSnapshot){
    Map data = documentSnapshot.data();
    return PostModel(
      parentId: data["parentId"],
      id: data["id"],
      ana_baslik: data["ana_baslik"],
      baslik: data["baslik"],
      icerik: data["icerik"],
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'parentId': parentId,
      'id': id,
      'ana_baslik': ana_baslik,
      'baslik':baslik,
      'icerik':icerik,
    };
  }

  factory PostModel.fromMap(map){
    return PostModel(
      parentId: map['parentId'],
      id: map['id'],
      ana_baslik: map['ana_baslik'],
      baslik: map['baslik'],
      icerik: map['icerik'],
    );
  }
}