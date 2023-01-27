import 'package:flutter/material.dart';
import 'package:yenimhrs/sayfalar/giris.dart';
import 'package:yenimhrs/servisler/servis.dart';

class Kayit extends StatelessWidget {
  static String kayit = "Kayit";

  Kayit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController kullaniciAdi = TextEditingController();
    TextEditingController ePosta = TextEditingController();
    TextEditingController parola = TextEditingController();

    kullaniciServisi servis = kullaniciServisi();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Kullanici Kayit Ekrani")),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      style: buildTextStyleGiris(24),
                      decoration: buildInputDecorationGiris("Kullanici Adiniz"),
                      controller: kullaniciAdi,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: buildTextStyleGiris(24),
                      decoration:
                          buildInputDecorationGiris("E-posta Adresiniz"),
                      controller: ePosta,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: buildTextStyleGiris(24),
                      decoration: buildInputDecorationGiris("Parolaniz"),
                      obscureText: true,
                      controller: parola,
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        servis
                            .kayitOl(
                                kullaniciAdi.text, ePosta.text, parola.text)
                            .then(
                          (value) {
                            showDialog(
                              context: context,
                              builder: (context) {
                               return  AlertDialog(
                                  title: Text("Kayit Olusturuldu"),
                                  content: Text(ePosta.text),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                    }, child: Text("Tamam"))
                                  ],
                                );
                              },
                            );
                          },
                        ).catchError((e) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Hata"),
                                content: Text("Hata olustu:" + e.toString()),
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
                        });
                      },
                      child: Text(
                        "Kayit Ol",
                        style: buildTextStyleGiris(20),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28))),
                          backgroundColor: Colors.green),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Iptal",
                        style: buildTextStyleGiris(20),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28))),
                          backgroundColor: Colors.red),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle buildTextStyleGiris(double fontSize) => TextStyle(fontSize: fontSize);

InputDecoration buildInputDecorationGiris(String icerik) {
  return InputDecoration(
    hintStyle: TextStyle(fontSize: 18),
    hintText: icerik,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
    ),
  );
}
