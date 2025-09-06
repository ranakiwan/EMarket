import 'package:flutter/material.dart';
import 'dart:io';
import '../functions/homeFunctions.dart';
import '../widgets/homeWidgets.dart';
import '../functions/offlineFunctions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isGridView = false;
  bool hasInternet = true;
  String name = "Guest";
  String mail = "";
  List<dynamic> internetData = [];
  List<dynamic> localData = [];
  File? _imageFile;


  @override
  void initState() {
    super.initState();
    _initData();
    loadData(setState, (n, m, img) {
      name = n;
      mail = m;
      _imageFile = img;
    });
  }

  Future<void> _initData() async {
     hasInternet = await hasInternetConnection();
    if (hasInternet) {
      fetch(setState, (data) {
        internetData = data;
        saveFirstFiveProducts(data);
        //printFirstFiveProducts();
        setState(() {
          hasInternet = true;
        });
        
      });
    }
    else {
      setState(() {
        hasInternet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _initData();
    });
    return Builder(
      builder: (context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: buildAppDrawer(context, name, mail, _imageFile),
        body: buildHomeBody(
          context: context,
          scaffoldKey: _scaffoldKey,
          isGridView: isGridView,
          hasInternet: hasInternet,
          internetData: internetData,
          onToggleView: (grid) => setState(() => isGridView = grid),
        ),
      ),
    );
  }
}
