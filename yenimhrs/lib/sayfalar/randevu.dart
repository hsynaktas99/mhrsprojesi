import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yenimhrs/servisler/servis.dart';

class Randevu extends StatelessWidget {
  static String randevu ="Randevu";
  const Randevu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    kullaniciServisi servis = kullaniciServisi();
    User gelenKullanici = ModalRoute.of(context)?.settings.arguments as User;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Brans Seciniz"),
        ),
        body: Container(
          child: servis.bransYukle(gelenKullanici),
        ),
      ),
    );
  }
}
