import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yenimhrs/modeller/kullanici.dart';
import 'package:yenimhrs/sayfalar/anasayfa.dart';
import 'package:yenimhrs/sayfalar/randevu2.dart';
import 'package:yenimhrs/sayfalar/randevusaat.dart';

class kullaniciServisi {
  final FirebaseAuth fbAuth = FirebaseAuth.instance;
  final FirebaseFirestore fbFireStore = FirebaseFirestore.instance;

  Future<User?> girisYap(String eMail, String parola) async {
    var kullanici =
    await fbAuth.signInWithEmailAndPassword(email: eMail, password: parola);
    return kullanici.user;
  }

  cikisYap() async {
    return await fbAuth.signOut();
  }

  Future<User?> kayitOl(String kullaniciAdi, String eMail,
      String parola) async {
    var kullanici = await fbAuth.createUserWithEmailAndPassword(
        email: eMail, password: parola);
    Kullanici k =
    Kullanici(eMail: eMail, parola: parola, kullaniciAdi: kullaniciAdi);
    await fbFireStore
        .collection("uyeler")
        .doc(kullanici.user?.uid)
        .set(k.toJson());
    return kullanici.user;
  }

  Widget randevuGetir(String id) {
    CollectionReference koleksiyon =
    fbFireStore.collection("uyeler").doc(id).collection("randevular");
    return StreamBuilder<QuerySnapshot>(
      stream: koleksiyon.snapshots(),
      builder: (context, AsyncSnapshot as) {
        if (as.hasData) {
          List<DocumentSnapshot> liste = as.data.docs;

          if (liste.length < 1) {
            return Center(
              child: Text(
                "Randevunuz Bulunmamaktadir",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: liste.length,
              itemBuilder: (context, index) {
                Timestamp tarih = liste[index]["tarih"];
                DateTime gelenTarih = DateTime.fromMillisecondsSinceEpoch(
                    tarih.millisecondsSinceEpoch);
                return Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              gelenTarih.day.toString() +
                                  " / " +
                                  gelenTarih.month.toString() +
                                  " / " +
                                  gelenTarih.year.toString(),
                              style: yaziStili,
                            ),
                            Text(
                              "Saat " +
                                  (gelenTarih.hour + 3).toString() +
                                  ":" +
                                  gelenTarih.minute.toString(),
                              style: yaziStili,
                            )
                          ],
                        ),
                      ),
                      color: Color(0xFF4ea9a5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "NUMUNE HASTANESI",
                            style: yaziStili2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_business_sharp,
                            color: Colors.green,
                          ),
                          Text(
                            liste[index]["brans"].toString(),
                            style: yaziStili3,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.red,
                          ),
                          Text(
                            liste[index]["doktor"].toString().toUpperCase(),
                            style: yaziStili3,
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context, builder: (context) {
                                  return AlertDialog(
                                    title: Text("Uyari"),
                                    content:Text("Randevu Iptal Edilecek ?"),
                                    actions: [
                                      TextButton(onPressed: () async {
                                        await liste[index].reference.delete();
                                        Navigator.pop(context);
                                      }, child: Text("Onayla")),
                                      TextButton(onPressed: () {
                                        Navigator.pop(context);
                                      }, child: Text("Vazgec"))
                                    ],
                                  );
                                },);
                              },
                              child: Text(
                                "Iptal Et", style: buildTextStyleGiris(18),),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red
                              ),),
                          ],
                        )
                    ),
                  ],
                );
              },
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void randevuEkle(String id, int yil, int ay, int gun, int saat, int dk,
      String doktorId, String bransId) async {
    DateTime tarih = DateTime(yil, ay, gun, saat - 3, dk);
    Timestamp ts = Timestamp.fromDate(tarih);

    CollectionReference koleksiyon = fbFireStore.collection("branslar");
    var bransRef = koleksiyon.doc(bransId);
    var bransVeri = await bransRef.get();
    String bransAdi = bransVeri["ad"];

    CollectionReference koleksiyon2 =
    koleksiyon.doc(bransId).collection("doktoru");
    var doktorRef = koleksiyon2.doc(doktorId);
    var doktorVeri = await doktorRef.get();
    String doktorAdi = doktorVeri["ad"];

    Map<String, dynamic> randevu = {
      "doktor": doktorAdi,
      "brans": bransAdi,
      "tarih": ts
    };

    await fbFireStore
        .collection("uyeler")
        .doc(id)
        .collection("randevular")
        .add(randevu);
  }

  Widget bransYukle(User kullaniciId) {
    CollectionReference koleksiyon = fbFireStore.collection("branslar");

    return StreamBuilder<QuerySnapshot>(
      stream: koleksiyon.snapshots(),
      builder: (context, AsyncSnapshot as) {
        if (as.hasData) {
          List<DocumentSnapshot> liste = as.data.docs;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: liste.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: yaziStili2,
                      ),
                      title: Text(
                        liste[index]["ad"].toString(),
                        style: yaziStili2,
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.indigo,
                      ),
                      tileColor: Colors.amber,
                      onTap: () {
                        List<dynamic> veriler = [liste[index].id, kullaniciId];
                        Navigator.pushNamed(context, Randevu2.randevu2,
                            arguments: veriler);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget doktorYukle(List<dynamic> gelen) {
    CollectionReference koleksiyon =
    fbFireStore.collection("branslar").doc(gelen[0]).collection("doktoru");

    return StreamBuilder<QuerySnapshot>(
      stream: koleksiyon.snapshots(),
      builder: (context, AsyncSnapshot as) {
        if (as.hasData) {
          List<DocumentSnapshot> liste = as.data.docs;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: liste.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: yaziStili2,
                      ),
                      title: Text(
                        liste[index]["ad"].toString(),
                        style: yaziStili2,
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.indigo,
                      ),
                      tileColor: Colors.amber,
                      onTap: () {
                        /*
                        * 0 brans id
                        * 1 kullanici
                        * 2 doktor id
                        * */

                        gelen.add(liste[index].id);
                        Navigator.pushNamed(context, RandevuSaat.randevuSaat,
                            arguments: gelen);

                        //Navigator.pushNamedAndRemoveUntil(context, AnaSayfa.yeni, (route) => false,arguments: gelen[1]);
                        //Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  TextStyle yaziStili = TextStyle(color: Colors.white, fontSize: 24);
  TextStyle yaziStili2 = TextStyle(color: Colors.black, fontSize: 16);
  TextStyle yaziStili3 = TextStyle(color: Colors.black, fontSize: 14);
}
