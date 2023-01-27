import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yenimhrs/servisler/servis.dart';


class Randevu2 extends StatelessWidget {
  const Randevu2({Key? key}) : super(key: key);
  static String randevu2 ="Randevu2";

  @override
  Widget build(BuildContext context) {
    kullaniciServisi servis = kullaniciServisi();
    List<dynamic> gelenVeriler = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Doktor Seciniz"),
        ),
        body: Container(
          child: servis.doktorYukle(gelenVeriler),
        ),
      ),
    );
  }
}
