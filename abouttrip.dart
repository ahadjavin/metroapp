import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutTrip extends StatefulWidget {
  const AboutTrip({super.key});

  @override
  _AboutTripState createState() => _AboutTripState();
}

class _AboutTripState extends State<AboutTrip> {
  TextEditingController inputController1 = TextEditingController();
  TextEditingController inputController2 = TextEditingController();
  TextEditingController inputController3 = TextEditingController();

  Future<void> _submitForm() async {
    String trainService = inputController1.text;
    String location = inputController2.text;
    String problemDescription = inputController3.text;
    String date = DateTime.now().toString();

    // الرفع إلى Firestore
    await FirebaseFirestore.instance.collection('Support').add({
      'trainService': trainService,
      'location': location,
      'problemDescription': problemDescription,
      'date': date,
    });

    inputController1.clear();
    inputController2.clear();
    inputController3.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 248, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18315A),
        centerTitle: true,
        title: Text(
          'Technical Support',
          style: TextStyle(fontSize: ksize.width * 0.05, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            // Add your back logic here
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: ksize.width * 0.05),
              SizedBox(height: ksize.width * 0.02),
              SizedBox(
                width: ksize.width * 0.85,
                child: TextFormField(
                  controller: inputController1,
                  decoration: InputDecoration(
                    labelText: 'Train Service',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ksize.width * 0.02),
              SizedBox(
                width: ksize.width * 0.85,
                child: TextFormField(
                  controller: inputController2,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ksize.width * 0.02),
              SizedBox(
                width: ksize.width * 0.85,
                child: TextFormField(
                  controller: inputController3,
                  decoration: InputDecoration(
                    labelText: 'Description of problem',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ksize.width * 0.05),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF18315A), // لون الخلفية
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // حواف دائرية
                  ),
                ),
                child: SizedBox(
                  // لجعل الزر يأخذ عرض الشاشة بالكامل
                  width: ksize.width * 0.8,
                  height: ksize.height * 0.07,
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // لون النص
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
