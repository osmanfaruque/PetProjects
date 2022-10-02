// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;

  var lat;
  var lon;

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    lat = position!.latitude;
    lon = position!.longitude;
    fetchWeatherData();
  }

  fetchWeatherData() async {
    String weatherApi =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=fbfd8e8ee76618f1c54cd9a1e1c07711&units=metric";

    String forecastApi =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=fbfd8e8ee76618f1c54cd9a1e1c07711&units=metric";

    var weatherResponce = await http.get(Uri.parse(weatherApi));
    var forecastResponce = await http.get(Uri.parse(forecastApi));
    setState(() {
      weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
      forecastMap =
          Map<String, dynamic>.from(jsonDecode(forecastResponce.body));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Weather App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.location_on),
              )
            ],
          ),
          body: weatherMap == null
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(

                      //color: Color(0xffe9f3fb)
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 51, 143, 255),
                      Color.fromARGB(92, 255, 51, 173),
                      Color.fromARGB(74, 255, 153, 0),
                      Color.fromARGB(147, 194, 255, 153),
                    ],
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "${weatherMap!["name"]}",
                                      style: const TextStyle(
                                          color: Color(0xff14405c),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Jiffy(DateTime.now())
                                          .format("EEE, h:mm:ss"),
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Image.network(
                            'http://openweathermap.org/img/w/${weatherMap!['weather'][0]['icon']}.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${weatherMap!["main"]["temp"]}°",
                          style: TextStyle(
                              color: const Color(0xff14405c).withOpacity(1),
                              fontWeight: FontWeight.bold,
                              fontSize: 60),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/feels.png',
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              "Feels like ${weatherMap!["main"]["feels_like"]}°",
                              style: const TextStyle(
                                  color: Color(0xff14405c),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${weatherMap!["weather"][0]["main"]}",
                              style: const TextStyle(
                                  color: Color(0xff14405c),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'images/humidity.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Text(
                                  "Humidity: ${weatherMap!["main"]["humidity"]}",
                                  style: const TextStyle(
                                      color: Color(0xff14405c),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'images/presure.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Text(
                                  "Pressure :${weatherMap!["main"]["pressure"]}",
                                  style: const TextStyle(
                                      color: Color(0xff14405c),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'images/sunrise.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Text(
                                  "Sunrise :${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)).format("h:mm a")}",
                                  style: const TextStyle(
                                      color: Color(0xff14405c),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'images/sunset.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Text(
                                  "Sunset :${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)).format("h:mm a")}",
                                  style: const TextStyle(
                                      color: Color(0xff14405c),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Container(
                          height: 180,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: forecastMap!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 180,
                                    width: 170,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                255, 85, 119, 131)
                                            .withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: Column(
                                        children: [
                                          Text(Jiffy(
                                                  "${forecastMap!["list"][index]["dt_txt"]}")
                                              .format("EEE, h:mm")),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "${forecastMap!["list"][index]["main"]["temp"]}°"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Image.network(
                                            'http://openweathermap.org/img/w/${forecastMap!["list"][index]["weather"][0]['icon']}.png',
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "${forecastMap!["list"][index]["weather"][0]["main"]}"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "${forecastMap!["list"][index]["weather"][0]["description"]}")
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ))),
    );
  }
}
