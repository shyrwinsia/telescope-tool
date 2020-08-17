import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telescopetool/dataformatter.dart';

class TelescopeTool extends StatefulWidget {
  @override
  _TelescopeToolState createState() => _TelescopeToolState();
}

class _TelescopeToolState extends State<TelescopeTool> {
  List<String> units = ['Metric', 'English'];
  String type, subtype, unitTelescope, unitEyepiece;
  bool hasData = false, warn = false;

  final telescopeApertureController = TextEditingController();
  final telescopeFocalLengthController = TextEditingController();
  final eyepieceFocalLengthController = TextEditingController();
  final barlowController = TextEditingController();

  String magnification, fnum, maxmag, maxeyepiece;

  @override
  void initState() {
    super.initState();
    unitTelescope = units.first;
    unitEyepiece = units.first;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                telescopeParams(),
                SizedBox(height: 80),
                eyepieceParams(),
              ],
            ),
          ),
          SizedBox(width: 100),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OUTPUT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                dataGenerated(),
                SizedBox(height: 80),
                Text(
                  'VISUALIZATION',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                hasData
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image(
                                  width: 10,
                                  height: 10,
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
                                  width: 120,
                                  height: 120,
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
        ],
      ),
    );
  }

  Widget telescopeParams() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TELESCOPE',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
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
          'EYEPIECE',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
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
            Text('x', style: TextStyle(fontSize: 16, color: Colors.black54))
          ],
        ),
      ],
    );
  }

  dataGenerated() {
    return hasData
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              this.warn
                  ? Text('Magnification: ${this.magnification}x',
                      style: TextStyle(fontSize: 16, color: Colors.red))
                  : Text(
                      'Magnification: ${this.magnification}x',
                      style: TextStyle(fontSize: 16),
                    ),
              SizedBox(height: 12),
              Text(
                'F-num: ${this.fnum}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Maximum Useful Mag: ${this.maxmag}x',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'Max useful eyepiece: ${this.maxeyepiece}mm',
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        : Text('No valid inputs');
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
    num bar = double.tryParse(barlowController.value.text) ?? 1;

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
        this.warn = ((tfl / efl) * bar) > (2 * tap);
        this.hasData = true;
      } else {
        this.hasData = false;
      }
    });
  }
}
