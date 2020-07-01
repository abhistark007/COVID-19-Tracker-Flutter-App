import 'dart:convert';

import 'package:covid_19_app/datasource.dart';
import 'package:covid_19_app/pages/countrypage.dart';
import 'package:covid_19_app/panels/infopanel.dart';
import 'package:covid_19_app/panels/mostaffectedcountries.dart';
import 'package:covid_19_app/panels/worldwidepanel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response =
        await http.get("https://disease.sh/v3/covid-19/all");
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get("https://disease.sh/v3/covid-19/countries?sort=cases");
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("COVID-19 TRACKER")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: 100,
              color: Colors.orange[100],
              child: Text(
                DataSource.quote,
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Worldwide",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CountryPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryBlack,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Regional",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            worldData == null
                ? LinearProgressIndicator(
                    backgroundColor: Colors.pink,
                  )
                : WorldWidePanel(
                    worldData: worldData,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Most Affected Countries",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            countryData == null
                ? LinearProgressIndicator(
                    backgroundColor: Colors.pink,
                  )
                : MostAffectedPanel(
                    countryData: countryData,
                  ),
            InfoPanel(),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "WE ARE TOGETHER IN THE FIGHT",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
