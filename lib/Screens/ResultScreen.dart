import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:near_me/Screens/testing.dart';
import 'package:http/http.dart' as http;
import 'package:near_me/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResultScreen extends StatefulWidget {
  final place, name;
  ResultScreen({this.place, this.name});
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultScreen> {
  var data;
  int length = 0;
  int radius = 1500;
  List _icon = [
    FontAwesomeIcons.hospitalUser,
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.hotel,
    Icons.fastfood,
    FontAwesomeIcons.gasPump,
    FontAwesomeIcons.medkit,
    FontAwesomeIcons.theaterMasks
  ];
  List _title = [
    "hospital",
    "bank",
    "gym",
    "lodging",
    "restaurant",
    "gas_station",
    "pharmacy",
    "movie_theater",
  ];
  List _colors = [
    Colors.red,
    Colors.pink.shade300,
    Colors.black54,
    Colors.teal,
    Colors.yellow.shade900,
    Colors.blue.shade600,
    Colors.red,
    Colors.blueGrey
  ];
  String currentAddress;
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      currentAddress = first.addressLine;
    });
    while (length < 10) {
      String url =
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=$radius&type=${_title[widget.place]}&key=${Secrets.API_KEY}";
      print(url);
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        setState(() {
          data = result["results"];
          length = data.length;
          radius += 500;
        });
        print(data);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Center(
            child: SpinKitRipple(
            color: Colors.tealAccent,
            size: 100.0,
          ))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.indigo,
              title: Text(
                widget.name,
                style: TextStyle(
                    fontFamily: 'Economica',
                    fontSize: 25,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Card(
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 8,
                            //decoration: BoxDecoration,
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 10, bottom: 10, right: 4),
                                child: FaIcon(
                                  _icon[widget.place],
                                  color: _colors[widget.place],
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                data[index]["name"].length > 70
                                    ? data[index]['name']
                                        .toString()
                                        .substring(0, 70)
                                    : data[index]['name'],
                                style: TextStyle(
                                  fontFamily: 'Economica',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10.0, bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Status:  ",
                                    ),
                                    if (data[index]["opening_hours"] == null)
                                      Text("--")
                                    else
                                      Text(
                                        data[index]["opening_hours"]["open_now"]
                                            ? 'Open'
                                            : 'Closed',
                                        style: TextStyle(
                                            color: data[index]["opening_hours"]
                                                    ["open_now"]
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    Expanded(
                                      child: Text(" "),
                                    ),
                                    if (data[index]['rating'] != null)
                                      Text(
                                        '★' * data[index]['rating'].toInt(),
                                      )
                                    else
                                      Text("☆"),
                                  ],
                                ),
                              ),
                              onTap: () {
                                onClick(currentAddress, data[index], context);
                              },
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
  }

  void onClick(String currentAddress, var data, BuildContext context) {
    print(currentAddress);
    print(data["vicinity"]);
    Alert(
      context: context,
      title: data["name"],
      image: Image.network(
        data["icon"],
      ),
      desc: data["vicinity"],
      buttons: [
        DialogButton(
          child: Text(
            "Back",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Navigate",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapView(
                        start: currentAddress, stop: data["vicinity"])));
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}
