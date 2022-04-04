import 'package:flutter/material.dart';

///AIzaSyCPZ5GeW1OfBbQBLYkFzyElLYHlYi250G8

class addpost extends StatefulWidget {
  const addpost({Key? key}) : super(key: key);

  @override
  State<addpost> createState() => _addpostState();
}

class _addpostState extends State<addpost> {
  @override
  TextEditingController TitleAnnonce = new TextEditingController();
  TextEditingController Type = new TextEditingController();
  // TextEditingController Willaya = new TextEditingController();
  TextEditingController Baladiya = new TextEditingController();
  TextEditingController Prix = new TextEditingController();
  TextEditingController Description = new TextEditingController();
  TextEditingController Surface = new TextEditingController();
  var selectedProperty = "Apartmets";
  var willaya = "";
  var allwillaya = ["Apartmets", "Plot", "Studio", "Villa"];

  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Add Property',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Title :'),
                      Container(
                        width: ScreenWidth * 0.75,
                        child: TextFormField(
                          decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenWidth * 0.080,
                      ),
                      Text('Type : '),
                      DropdownButton(
                        items: ["Apartmets", "Plot", "Studio", "Villa"]
                            .map((e) => DropdownMenuItem(
                                  child: Text("$e"),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedProperty = val.toString();
                            print(selectedProperty);
                          });
                        },
                        value: selectedProperty,
                      ),
                      SizedBox(
                        width: ScreenWidth * 0.05,
                      ),
                      Text('Surface :'),
                      Container(
                        width: ScreenWidth * 0.28,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            suffix: Text('m²'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenWidth * 0.080,
                      ),
                      Text('Description :'),
                    ],
                  ),
                ),
                Container(
                  width: ScreenWidth * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'write description',
                        border: OutlineInputBorder()),
                    maxLines: 10,
                  ),
                ),
                DropdownButton(
                  items: allwillaya
                      .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      willaya = val.toString();
                    });
                  },
                  value: selectedProperty,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ScreenWidth * 0.080,
                      ),
                      Text('Price :'),
                      Container(
                        width: ScreenWidth * 0.40,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            suffix: Text('DA'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
