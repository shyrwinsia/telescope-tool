import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(TelescopeTool());
}

class TelescopeTool extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _TelescopeToolState createState() => _TelescopeToolState();
}

class _TelescopeToolState extends State<TelescopeTool> {
  List<String> types = ['Refractor', 'Reflector'];
  List<String> units = ['Metric', 'English'];
  Map<String, List<String>> subtypes = {
    'Refractor': ['Galilean', 'Keplerian', 'Achromatic', 'Apochromatic'],
    'Reflector': ['Newtonian', 'Cassegrain', 'Gregorian']
  };
  String type, subtype, unitTelescope, unitEyepiece;
  bool hasData = false;

  final telescopeApertureController = TextEditingController();
  final telescopeFocalLengthController = TextEditingController();
  final eyepieceFocalLengthController = TextEditingController();
  final barlowController = TextEditingController();

  String magnification, fnum, maxmag, maxeyepiece;

  @override
  void initState() {
    super.initState();
    type = types.first;
    subtype = subtypes[types.first].first;
    unitTelescope = units.first;
    unitEyepiece = units.first;
  }

  calculate() {
    // convert fls to mm
    // magnification = (scope focal length / eyepiece focal length) * barlow
    // f number = round (scope focal length / scope aperture)
    // max useful mag = 2 * aperture (in mm)
    // max useful eyepiece = scope fl / max useful mag
    num tfl = double.tryParse(telescopeFocalLengthController.value.text) ?? 0;
    num efl = double.tryParse(eyepieceFocalLengthController.value.text) ?? 0;
    num tap = double.tryParse(telescopeApertureController.text) ?? 0;
    num bar = double.tryParse(barlowController.value.text) ?? 0;

    if (unitTelescope == "English") {
      tfl *= 25.4;
      tap *= 25.4;
    }

    if (unitEyepiece == "English") {
      efl *= 25.4;
    }

    setState(() {
      if (efl != 0 && tfl != 0 && tap != 0) {
        this.magnification = ((tfl / efl) * bar).toStringAsFixed(0);
        this.fnum = (tfl / tap).roundToDouble().toStringAsFixed(0);
        this.maxmag = (2 * tap).toStringAsFixed(0);
        this.maxeyepiece = (tfl / ((2 * tap))).toStringAsFixed(0);
        this.hasData = true;
      } else {
        this.hasData = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telescope Tool',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Telescope Magnification and Eyepiece Chooser'),
          ),
          body: telescope()),
    );
  }

  Widget telescopeSettings() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              telescopeType(),
              SizedBox(height: 40),
              telescopeParams(),
              SizedBox(height: 40),
              eyepieceParams(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget telescopeType() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Telescope Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        DropdownButton<String>(
          value: this.type,
          items: this.types.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (choice) {
            setState(() {
              this.type = choice;
              this.subtype = subtypes[choice].first;
            });
          },
          isExpanded: true,
        ),
        DropdownButton<String>(
          value: this.subtype,
          items: this.subtypes[this.type].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (choice) {
            setState(() {
              this.subtype = choice;
            });
          },
          isExpanded: true,
        ),
      ],
    );
  }

  Widget telescopeParams() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Telescope Parameters',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        DropdownButton<String>(
          value: this.unitTelescope,
          items: this.units.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (choice) {
            setState(() {
              this.unitTelescope = choice;
            });
            calculate();
          },
          isExpanded: true,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: telescopeApertureController,
                onChanged: (change) => calculate(),
                decoration: InputDecoration(labelText: 'Aperture'),
                inputFormatters: <TextInputFormatter>[
                  DecimalTextInputFormatter()
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            this.unitTelescope == 'Metric'
                ? Text('mm',
                    style: TextStyle(fontSize: 16, color: Colors.black54))
                : Text('in',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: telescopeFocalLengthController,
                onChanged: (change) => calculate(),
                decoration: new InputDecoration(labelText: 'Focal Length'),
                inputFormatters: <TextInputFormatter>[
                  DecimalTextInputFormatter()
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            this.unitTelescope == 'Metric'
                ? Text('mm',
                    style: TextStyle(fontSize: 16, color: Colors.black54))
                : Text('in',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ],
    );
  }

  Widget eyepieceParams() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eyepiece Parameters',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        DropdownButton<String>(
          value: this.unitEyepiece,
          items: this.units.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (choice) {
            setState(() {
              this.unitEyepiece = choice;
            });
            calculate();
          },
          isExpanded: true,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: eyepieceFocalLengthController,
                onChanged: (change) => calculate(),
                decoration: InputDecoration(labelText: 'Focal Length'),
                inputFormatters: <TextInputFormatter>[
                  DecimalTextInputFormatter()
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            this.unitEyepiece == 'Metric'
                ? Text('mm',
                    style: TextStyle(fontSize: 16, color: Colors.black54))
                : Text('in',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: barlowController,
                onChanged: (change) => calculate(),
                decoration: InputDecoration(labelText: 'Barlow / Reducer'),
                inputFormatters: <TextInputFormatter>[
                  DecimalTextInputFormatter()
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12),
            this.unitEyepiece == 'Metric'
                ? Text('mm',
                    style: TextStyle(fontSize: 16, color: Colors.black54))
                : Text('in',
                    style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ),
      ],
    );
  }

  Widget telescope() {
    return Row(
      children: [
        telescopeSettings(),
        telescopeVisualization(),
      ],
    );
  }

  Widget telescopeVisualization() {
    return Expanded(
      flex: 7,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${this.subtype} Telescope',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text(
                'Telescope diagram goes here',
              ),
              SizedBox(height: 40),
              Text(
                'Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              dataGenerated(),
              SizedBox(height: 40),
              Text(
                'Visualization',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              hasData
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image(
                                width: 30,
                                height: 30,
                                image: AssetImage('assets/moon.png'),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Apparent size',
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                          SizedBox(width: 64),
                          Column(
                            children: [
                              Image(
                                width: 400,
                                height: 400,
                                image: AssetImage('assets/moon.png'),
                              ),
                              Text(
                                'Magnified size',
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Text('No valid inputs')
            ],
          ),
        ),
      ),
    );
  }

  dataGenerated() {
    return hasData
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Magnification: ${this.magnification}x'),
              SizedBox(height: 12),
              Text('F-num: ${this.fnum}'),
              SizedBox(height: 12),
              Text('Maximum Useful Mag: ${this.maxmag}x'),
              SizedBox(height: 12),
              Text('Max useful eyepiece: ${this.maxeyepiece}mm'),
            ],
          )
        : Text('No valid inputs');
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^\d*\.?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
