
import 'package:flutter/cupertino.dart';

class Kullanici {

  late String kullaniciAdi;
  late String parola;
  late String eMail;

  Kullanici({required this.eMail, required this.parola, required this.kullaniciAdi});

  Map<String,dynamic> toJson(){
    return {
      "kullaniciAdi":this.kullaniciAdi,
      "parola":this.parola,
      "eMail":this.eMail
    };
  }

}