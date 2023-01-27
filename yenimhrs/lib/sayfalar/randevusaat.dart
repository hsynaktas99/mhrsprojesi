import 'package:flutter/material.dart';

import '../servisler/servis.dart';
import 'anasayfa.dart';

class RandevuSaat extends StatelessWidget {
  RandevuSaat({Key? key}) : super(key: key);
  static String randevuSaat = "RandevuSaat";

  @override
  Widget build(BuildContext context) {
    TextEditingController gunC = TextEditingController();
    TextEditingController ayC = TextEditingController();
    TextEditingController yilC = TextEditingController();
    TextEditingController saatC = TextEditingController();
    TextEditingController dkC = TextEditingController();

    kullaniciServisi servis = kullaniciServisi();
    List<dynamic> gelen =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String doktorId = gelen[2].toString();
    String bransId = gelen[0].toString();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Randevu Saati ve Tarihi"),
        ),
        body: Container(
          child: Container(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Ornek: 2.09.2023",
                style: buildTextStyleGiris(24),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: gunC,
                            decoration: buildInputDecorationGiris("Gun"),
                            style: buildTextStyleGiris(18))),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                            controller: ayC,
                            decoration: buildInputDecorationGiris("Ay"),
                            style: buildTextStyleGiris(18))),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                            controller: yilC,
                            decoration: buildInputDecorationGiris("Yil"),
                            style: buildTextStyleGiris(18))),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Ornek: 13:59",
                style: buildTextStyleGiris(24),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                        child: TextField(
                      controller: saatC,
                      decoration: buildInputDecorationGiris("Saat"),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextField(
                      controller: dkC,
                      decoration: buildInputDecorationGiris("Dakika"),
                    )),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    servis.randevuEkle(
                        gelen[1].uid,
                        int.parse(yilC.text),
                        int.parse(ayC.text),
                        int.parse(gunC.text),
                        int.parse(saatC.text),
                        int.parse(dkC.text),
                        gelen[2].toString(),
                        gelen[0].toString());

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("BASARILI"),
                          content: Text("Randevu Alinmistir"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, AnaSayfa.yeni, (route) => false,
                                      arguments: gelen[1]);
                                },
                                child: Text("Tamam"))
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Hata"),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: Text("Tamam"))
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  "Randevuyu Onayla",
                  style: buildTextStyleGiris(20),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    backgroundColor: Colors.green),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AnaSayfa.yeni, (route) => false,
                      arguments: gelen[1]);
                },
                child: Text(
                  "Vazgec",
                  style: buildTextStyleGiris(20),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(28))),
                    backgroundColor: Colors.red),
              )
            ]),
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
