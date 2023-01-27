import 'package:flutter/material.dart';
import 'package:yenimhrs/sayfalar/anasayfa.dart';
import 'package:yenimhrs/sayfalar/kayit.dart';
import 'package:yenimhrs/servisler/servis.dart';

class Giris extends StatelessWidget {
  static String giris = "Giris";

  const Giris({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    kullaniciServisi kServis = kullaniciServisi();

    TextEditingController kullaniciAdi = TextEditingController();
    TextEditingController parola = TextEditingController();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset("assets/images/mhrslogo.png",
                  fit: BoxFit.contain),
            )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: kullaniciAdi,
                      style: buildTextStyleGiris(18),
                      decoration: buildInputDecorationGiris("E-posta"),
                    ),
                    TextField(
                        controller: parola,
                        style: buildTextStyleGiris(18),
                        decoration: buildInputDecorationGiris("Parola"),
                        obscureText: true,
                    ),

                  ],
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //0xFF4ea9a5U
                  ElevatedButton(
                    onPressed: () {
                      kServis
                          .girisYap(kullaniciAdi.text, parola.text)
                          .then((value) async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Bilgi"),
                              content: Text("Giris Basarili"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Tamam"))
                              ],
                            );
                          },
                        );
                        Navigator.pushNamed(context, AnaSayfa.yeni,arguments: value);

                      }).catchError((hata) async {
                        await showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: Text("Hata"),
                                content: Text(
                                    "Kullanici adi veya parola hatali olabilir"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Tamam"))
                                ],
                              );
                            }));
                      });
                    },
                    child: Text("Giris Yap",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(28))),
                        backgroundColor: Color(0xFF4ea9a5)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,Kayit.kayit);
                    },
                    child: Text("Kayit Ol",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(28))),
                        backgroundColor: Color(0xFFDC143C)),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  //****************************** WIDGET METHODLAR *************************

  TextStyle buildTextStyleGiris(double fontSize) =>
      TextStyle(fontSize: fontSize);

  InputDecoration buildInputDecorationGiris(String icerik) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 18),
      hintText: icerik,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}
