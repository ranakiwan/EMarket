import 'package:flutter/material.dart';
import 'dart:io';
import '../functions/homeFunctions.dart';
import '../widgets/homeWidgets.dart';
import 'service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isGridView = false;
  String name = "Guest";
  String mail = "";
  List<dynamic> internetData = [];
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetch(setState, (data) => internetData = data);
    loadData(setState, (n, m, img) {
      name = n;
      mail = m;
      _imageFile = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: buildAppDrawer(context, name, mail, _imageFile),
        body: buildHomeBody(
          context: context,
          scaffoldKey: _scaffoldKey,
          isGridView: isGridView,
          internetData: internetData,
          onToggleView: (grid) => setState(() => isGridView = grid),
        ),
      ),
    );
  }
}
