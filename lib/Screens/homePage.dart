import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:near_me/Screens/ResultScreen.dart';
import 'package:near_me/Screens/testing.dart';
import 'package:near_me/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _title = [
    "Hospitals",
    "Banks",
    "Gyms",
    "Hotels",
    "Restaurants",
    "Gas Stations",
    "Pharmacies",
    "Movie Theaters"
  ];
  List _tileimages = [
    "assets/tileImage/hospital.jpg",
    "assets/tileImage/bank.jpg",
    "assets/tileImage/gym.jpg",
    "assets/tileImage/hotel.jpg",
    "assets/tileImage/restaurent.jpg",
    "assets/tileImage/gas.jpg",
    "assets/tileImage/pharmacy.jpg",
    "assets/tileImage/movie.jpg"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getLocation();
  }

  double back_op = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.place),
          backgroundColor: Colors.indigo,
          title: Row(
            children: [
              Text(
                'Near Me',
                style: TextStyle(
                    fontFamily: 'Economica',
                    fontSize: 25,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(_title.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  sendData(index, _title[index], context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      //background color of box
                      BoxShadow(
                        color: Colors.grey.shade600,
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                        offset: Offset(
                          10.0, // Move to right 10  horizontally
                          10.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(_tileimages[index])),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        _title[index],
                        style: TextStyle(
                          fontFamily: "Rajdhani",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ));
  }

  sendData(int index, String name, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  place: index,
                  name: name,
                )));
  }
}
