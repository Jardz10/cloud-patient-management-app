import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPatientScreen extends StatefulWidget {
  static const routeName = '/EditPatientScreen';
  final patientId;
  EditPatientScreen({this.patientId});
  @override
  _EditPatientScreenState createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  @override
  void initState() {
    super.initState();
    _getPatientData();
  }

  bool _isLoading = false;
  TextEditingController patientAge = new TextEditingController();
  TextEditingController patientcomorbidities = new TextEditingController();
  TextEditingController patientTreatment = new TextEditingController();
  List<String> patientcomorbiditiesList = [];
  List<String> patientTreatmentList = [];
  var url = '';
  Future<void> _getPatientData() async {
    var firebase = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(widget.patientId)
        .get();
    List<dynamic> comorbidities = firebase['Comorbidities'];
    List<dynamic> treatment = firebase['Treatment'];
    List<dynamic> _url = firebase['Url'];

    setState(() {
      patientAge.text = firebase['Age'];
      patientcomorbidities.text = comorbidities.join(',');
      patientTreatment.text = treatment.join(',');
      url = _url.join("");
    });
  }

  final _formData = GlobalKey<FormState>();
  /* File _userImageFile = File('path');
  void _pickedIMage(File image) {
    setState(() {
      _userImageFile = image;
    });
  } */

  Future<void> _saveForm() async {
    setState(() {
      patientcomorbiditiesList = patientcomorbidities.text.split(',').toList();
      patientTreatmentList = patientTreatment.text.split(',').toList();

      _isLoading = true;
    });
    try {
      /* final ref = FirebaseStorage.instance
          .ref()
          .child('patients')
          .child(patientName.text + 'jpg');

      await ref.putFile(_userImageFile);
      url = await ref.getDownloadURL(); */

      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(widget.patientId)
          .update({
        'Age': patientAge.text.toString(),
        'Comorbidities': patientcomorbiditiesList,
        'Treatment': patientTreatmentList,
      });
    } catch (err) {}
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? SingleChildScrollView(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30),
                  ),
                  Center(
                    child: Text(
                      'Edit Patient',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 280,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  /* ImagePickerClass(_pickedIMage,), */
                  Form(
                    key: _formData,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter valid Name';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: patientAge,
                            decoration: InputDecoration(labelText: 'Age'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter valid Name';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: patientcomorbidities,
                            decoration: InputDecoration(
                              labelText: 'Comorbidities',
                              hintText: 'Please seperate using commas',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter valid Name';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: patientTreatment,
                            decoration: InputDecoration(
                              labelText: 'Treatments',
                              hintText: 'Please seperate using commas',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 8),
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    onPressed: () => _saveForm(),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
