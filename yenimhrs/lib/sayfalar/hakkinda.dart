import 'package:flutter/material.dart';

class Hakkinda extends StatelessWidget {
   Hakkinda({Key? key}) : super(key: key);
  static String hakkinda = "Hakkinda";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Hakkinda")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Text("Hazirlayan",style: yaziStili(Colors.red,24),),
                  Text("Huseyin Aktas",style: yaziStili(Colors.black,36),),
                  SizedBox(height: 40,),
                  Text("E-posta",style: yaziStili(Colors.red, 24),),
                  SizedBox(height: 5,),
                  Text("hsynaktas2021@gmail.com",style: yaziStili(Colors.black, 24),),
                  SizedBox(height: 40,),
                  Text("Github",style: yaziStili(Colors.red, 24),),
                  Text("https://github.com/hsynaktas99",style: yaziStili(Colors.black, 24),)
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle yaziStili(Color renk,int yaziBoyutu){
  return TextStyle(
    color: renk,
    fontSize: yaziBoyutu*1.0
  );
}


