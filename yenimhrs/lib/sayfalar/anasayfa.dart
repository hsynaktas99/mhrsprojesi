import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yenimhrs/modeller/kullanici.dart';
import 'package:yenimhrs/sayfalar/hakkinda.dart';
import 'package:yenimhrs/sayfalar/randevu.dart';

import '../servisler/servis.dart';
import 'giris.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);
  static String yeni = "Yeni";

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int indexNo = 0;
  kullaniciServisi servis = kullaniciServisi();

  @override
  Widget build(BuildContext context) {
    User gelenKisi = ModalRoute.of(context)?.settings.arguments as User;
    String id = gelenKisi.uid;
    String ePosta = gelenKisi.email ?? "yok";
    int yaklasanRandevuSayisi = 0;

    TextStyle yaziStil = TextStyle(fontSize: 24, color: Color(0xFF4ea9a5));

    void degistir(int index) {
      setState(() {
        indexNo = index;
      });
    }

    List<Widget> sayfalar = [
      anaSayfa(
        ePosta: ePosta,
        yaziStil: yaziStil,
        yaklasanRandevuSayisi: yaklasanRandevuSayisi,
        id: id,
        kisi: gelenKisi,
      ),
      Randevularim(id: id),
      Menu()
    ];

    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: "Randevularim"),
          BottomNavigationBarItem(icon: Icon(Icons.ballot_rounded,),label: "Menu")
        ],
        currentIndex: indexNo,
        onTap: degistir,
      ),
      body: sayfalar[indexNo],
    ));
  }
}

//***************SAYFALAR**********************************
class Randevularim extends StatelessWidget {
  Randevularim({Key? key, required String this.id}) : super(key: key);

  final String id;

  kullaniciServisi servis = kullaniciServisi();
  TextStyle yaziStili = TextStyle(color: Color(0xFF4ea9a5), fontSize: 32);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
              child: Text(
            "Randevularim",
            style: yaziStili,
          )),
          flex: 2,
        ),
        Expanded(
          child: servis.randevuGetir(this.id),
          flex: 8,
        ),
      ],
    );
  }
}

class anaSayfa extends StatelessWidget {
  kullaniciServisi servis = kullaniciServisi();

  anaSayfa(
      {Key? key,
      required this.ePosta,
      required this.yaziStil,
      required this.yaklasanRandevuSayisi,
      required this.id,
      required this.kisi})
      : super(key: key);

  final String ePosta;
  final TextStyle yaziStil;
  final int yaklasanRandevuSayisi;
  final String id;
  final User kisi;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Hoş Geldiniz " + ePosta.split("@")[0],
                        style: yaziStil,
                      ),
                      Icon(
                        Icons.health_and_safety_outlined,
                        color: Color(0xFF4ea9a5),
                        size: 36,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.add_business, color: Colors.red, size: 54),
                    title: Text("Hastane Randevusu Al",
                        style: TextStyle(color: Colors.red, fontSize: 20)),
                    trailing:
                        Icon(Icons.chevron_right, color: Colors.red, size: 36),
                    onTap: () {
                      Navigator.pushNamed(context, Randevu.randevu,
                          arguments: kisi);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        "Yaklasan Randevularim",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(child: servis.randevuGetir(id))
          ],
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    kullaniciServisi servis = kullaniciServisi();

    return Container(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle,color: Colors.black),
            title: Text("Hakkinda",style:TextStyle(fontSize: 20) ,),
            trailing: Icon(Icons.arrow_circle_right_outlined,color: Colors.black),
            tileColor: Colors.amber,
            onTap: () {
              Navigator.pushNamed(context, Hakkinda.hakkinda);

            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.white),
            title: Text("Cikis Yap",style:TextStyle(fontSize: 20,color: Colors.white),),
            tileColor: Colors.red,
            onTap: () {
              servis.cikisYap();
              Navigator.pushNamedAndRemoveUntil(context, Giris.giris, (route) => false);
            },
          ),

        ],
      ),
    );
  }
}
