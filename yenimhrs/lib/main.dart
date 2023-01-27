import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yenimhrs/sayfalar/giris.dart';
import 'package:yenimhrs/sayfalar/anasayfa.dart';
import 'package:yenimhrs/sayfalar/hakkinda.dart';
import 'package:yenimhrs/sayfalar/kayit.dart';
import 'package:yenimhrs/sayfalar/randevu.dart';
import 'package:yenimhrs/sayfalar/randevu2.dart';
import 'package:yenimhrs/sayfalar/randevusaat.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {

  final Future<FirebaseApp> fbBaslat = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AnaSayfa.yeni: (context) =>AnaSayfa(),
        Randevu.randevu: (context) =>Randevu(),
        Randevu2.randevu2:(context) =>Randevu2(),
        RandevuSaat.randevuSaat:(context)=>RandevuSaat(),
        Kayit.kayit:(context) =>Kayit(),
        Hakkinda.hakkinda:(context) =>Hakkinda(),
        Giris.giris:(context) =>Giris()
      },
      theme: ThemeData(fontFamily: "SofiaSans"),
      home: FutureBuilder(future: fbBaslat,builder:((context, snapshot) {
        if(snapshot.hasError){
          return Center(child: Text("Yuklenirken bir hata olustu"),);
        }
        else if(snapshot.hasData){
          return Giris();
        }
        else {
          return CircularProgressIndicator();
        }
      })),

    );
  }
}



