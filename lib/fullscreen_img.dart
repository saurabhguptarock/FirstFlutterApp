import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  String img;

  FullScreenImage(this.img);
  final LinearGradient linearGradient = LinearGradient(
      colors: [Color(0x10000000), Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: linearGradient),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: img,
                  child: Image.network(img),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
