import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lone/fullscreen_img.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() => runApp(MyApp());

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['wallpapers', 'walls', 'amoled'],
    childDirected: true,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;

  final CollectionReference collectionReference =
      Firestore.instance.collection('tools');

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    subscription = collectionReference.snapshots().listen((data) {
      setState(() {
        wallpapersList = data.documents;
      });
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Lone"),
      ),
      body: wallpapersList != null
          ? new StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              itemCount: wallpapersList.length,
              itemBuilder: (c, i) {
                String img = wallpapersList[i].data['img'];
                return new Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: InkWell(
                    onTap: () {
                      createInterstitialAd()
                        ..load()
                        ..show();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new FullScreenImage(img)));
                    },
                    child: Hero(
                      tag: img,
                      child: FadeInImage(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                        placeholder: AssetImage("assets/wallfy.png"),
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (i) =>
                  StaggeredTile.count(2, i.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Lone",
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new WallScreen(),
    );
  }
}
