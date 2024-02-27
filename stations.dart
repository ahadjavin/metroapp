import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class MyStations extends StatefulWidget {
  const MyStations({super.key});

  @override
  _MyStationsState createState() => _MyStationsState();
}

class _MyStationsState extends State<MyStations> {
  late GoogleMapController mapController;
  String _selectedItem1 = 'Ministry of Interior Station';
  String _selectedItem2 = 'King Fahd Stadium station';
  late int _selectedPersonCount = 0;
  static String? Useruid;
  DateTime? _selectedDate;
  int ticketPrice = 0;
  int ticketId = 0;
  final List<int> _personCounts = List.generate(7, (index) => index + 0); // قائمة بالأعداد من 1 إلى 5
  bool deletionCompleted = false;

  final String apiKey = 'AIzaSyDQXEcMiMO2T8zKLkOvQUexisCioFa-mSs';
  int? distance;
  String startLatitude = '';
  String startLongitude = '';
  String endLatitude = '';
  String endLongitude = '';
  String nameuser = "";

  double? startLatitudeValue;
  double? endLatitudeValue;

  double? startLongitudeValue;
  double? endLongitudeValue;

  String? selectedStationName; // يمكنك تعريف متغير لتخزين القيمة المحددة
  String? selectedStation2Name; // يمكنك تعريف متغير لتخزين القيمة المحددة
  String? selectedStation1Latitude;

  double carSpeed = 40; // سرعة السيارة بالكيلومترات في الساعة
  double trainSpeed = 100; // سرعة القطار بالكيلومترات في الساعة
  String carTime = ''; // متغير يحمل الوقت بالسيارة بالدقائق
  String trainTime = ''; // متغير يحمل الوقت بالقطار بالدقائق
  String generateRandomNumber() {
    Random random = Random();
    String randomNumber = '';

    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(10).toString();
    }

    return randomNumber;
  }

  Future<void> calculateDistance() async {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitudeValue!,
      startLongitudeValue!,
      endLatitudeValue!,
      endLongitudeValue!,
    );

    // تحويل المسافة من الأمتار إلى الكيلومترات
    double distanceInKilometers = distanceInMeters / 1000;

    // حساب الوقت بالسيارة بالساعات
    double carTimeInHours = distanceInKilometers / carSpeed;

    // تقريب الوقت بالسيارة إلى أقرب رقم صحيح
    int carTimeInMinutes = (carTimeInHours * 60).ceil();

    // حساب الوقت بالقطار بالساعات
    double trainTimeInHours = distanceInKilometers / trainSpeed;

    // تقريب الوقت بالقطار إلى أقرب رقم صحيح
    int trainTimeInMinutes = (trainTimeInHours * 60).ceil();

    // تقريب المسافة إلى أقرب رقم صحيح
    int roundedDistance = distanceInKilometers.ceil();

    setState(() {
      distance = roundedDistance;
      carTime = carTimeInMinutes.toString();
      trainTime = trainTimeInMinutes.toString();
    });

    int ticketCost = calculateTicketCost(distance!, _selectedPersonCount);

    // تحديث الحالة لعرض التكلفة في واجهة المستخدم
    setState(() {
      // تحديث الحالة لعرض التكلفة
      ticketPrice = ticketCost;
    });
    print("ticketPrice : $ticketPrice");
  }

  int calculateTicketCost(int distance, int numberOfPersons) {
    int ticketPricePerKm = 1; // سعر التذكرة لكل كيلومتر
    int ticketPrice = distance * ticketPricePerKm * numberOfPersons; // حساب التكلفة
    return ticketPrice;
  }

  @override
  void initState() {
    super.initState();

    // getCurrentUseData().then((name) {
    //   setState(() {
    //     nameuser = name;
    //   });
    // });

    // setState(() {
    //   Useruid = currentUser.uid;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 248, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18315A),
        centerTitle: true, // لوضع العنوان في المنتصف
        title: Text(
          'Trip',
          style: TextStyle(fontSize: ksize.width * 0.05, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            // Add your back logic here
          },
          icon: const Icon(Icons.arrow_back), // أيقونة الرجوع
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: ksize.height * 0.33,
                    child: Image.network(
                      'https://api.aqarsas.sa/mstatic/909764',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Form',
                              style: TextStyle(fontSize: ksize.width * 0.05, color: const Color(0xFF18315A)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(width: 1, color: const Color(0xFF18315A)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('stations')
                                    .snapshots(), // تغيير 'your_collection' إلى اسم مجموعتك
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // يمكنك استبداله بمؤشر تحميل آخر حسب تصميم تطبيقك
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData || snapshot.data == null) {
                                    return const Text('No data found!');
                                  }

                                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                                  List<String> items = documents.map((doc) => doc['stationName'].toString()).toList();
                                  List<String> latitudes = documents.map((doc) => doc['Latitude'].toString()).toList();
                                  List<String> longitudes =
                                      documents.map((doc) => doc['Longitude'].toString()).toList();
                                  return DropdownButton<String>(
                                    value: _selectedItem1,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedItem1 = newValue!;
                                        selectedStationName = newValue;
                                        int index = items.indexOf(
                                            selectedStationName!); // العثور على الفهرس المطابق لاسم المحطة المحددة

                                        startLatitudeValue = double.parse(latitudes[index]);
                                        startLongitudeValue = double.parse(longitudes[index]);
                                      });
                                    },
                                    items: items.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            value,
                                            style:
                                                const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF18315A)),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    icon: const Icon(Icons.arrow_drop_down_sharp),
                                    iconSize: 40,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'To',
                              style: TextStyle(fontSize: ksize.width * 0.05, color: const Color(0xFF18315A)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(width: 1, color: const Color(0xFF18315A)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('stations')
                                    .snapshots(), // تغيير 'your_collection' إلى اسم مجموعتك
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // يمكنك استبداله بمؤشر تحميل آخر حسب تصميم تطبيقك
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData || snapshot.data == null) {
                                    return const Text('No data found!');
                                  }

                                  List<DocumentSnapshot> documents = snapshot.data!.docs;

                                  List<String> stationitems =
                                      documents.map((doc) => doc['stationName'].toString()).toList();
                                  List<String> endlatitudes =
                                      documents.map((doc) => doc['Latitude'].toString()).toList();
                                  List<String> endlongitudes =
                                      documents.map((doc) => doc['Longitude'].toString()).toList();

                                  return DropdownButton<String>(
                                    value: _selectedItem2,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedItem2 = newValue!;
                                        selectedStation2Name = newValue;
                                        int endindex = stationitems.indexOf(
                                            selectedStation2Name!); // العثور على الفهرس المطابق لاسم المحطة المحددة

                                        endLatitudeValue = double.parse(endlatitudes[endindex]);
                                        endLongitudeValue = double.parse(endlongitudes[endindex]);
                                      });
                                      calculateDistance();
                                    },
                                    items: stationitems.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            value,
                                            style:
                                                const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF18315A)),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    icon: const Icon(Icons.arrow_drop_down_sharp),
                                    iconSize: 40,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: ksize.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (selectedDate != null && selectedTime != null) {
                                    // Combine selectedDate and selectedTime into a single DateTime object
                                    DateTime selectedDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );

                                    setState(() {
                                      _selectedDate = selectedDateTime;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF18315A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _selectedDate != null
                                          ? DateFormat('dd MMM yyyy HH:mm')
                                              .format(_selectedDate!) // تنسيق التاريخ والوقت
                                          : '27 jan 2024',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              DropdownButton<int>(
                                value: _selectedPersonCount,
                                onChanged: (int? newValue) {
                                  if (_personCounts.contains(newValue)) {
                                    // التحقق مما إذا كانت القيمة المحددة موجودة في قائمة العناصر
                                    setState(() {
                                      _selectedPersonCount = newValue!;
                                      calculateDistance();
                                    });
                                  }
                                },
                                items: _personCounts.map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Color(0xFF18315A), // لون الأيقونة
                                        ),
                                        const SizedBox(width: 10), // تباعد بين الأيقونة والنص
                                        Text(
                                          '$value',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF18315A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                icon: const Icon(
                                  Icons.person, // أيقونة المستخدم
                                  color: Color(0xFF18315A), // لون الأيقونة
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              'Ticket Price: $ticketPrice  SAR', // عرض ثمن التذكرة
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF18315A),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/car.png', // مسار الصورة
                                width: 27, // تحديد العرض
                                height: 27, // تحديد الارتفاع
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$carTime minutes',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25,
                                  color: Color(0xFF18315A), // لون النص
                                ),
                              ),
                              SizedBox(width: ksize.width * 0.1),
                              Image.asset(
                                'assets/car2.png', // مسار الصورة
                                width: 27, // تحديد العرض
                                height: 27, // تحديد الارتفاع
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$trainTime minutes',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25,
                                  color: Color(0xFF18315A), // لون النص
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              CollectionReference ticketsRef = FirebaseFirestore.instance.collection('tickets');

              Future<void> updateTicketsNumbers() async {
                try {
                  if (!deletionCompleted) {
                    // استرجاع المستند الأول في ticketsRef
                    QuerySnapshot querySnapshot = await ticketsRef.limit(1).get();
                    // استرجاع البيانات من المستند الأول
                    Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
                    // القيمة الحالية لـ ticketsNumbers
                    int currentTicketsNumbers = data['ticketsNumbers'] ?? 0;
                    // التحديث: قلل القيمة بواحد
                    int newTicketsNumbers = currentTicketsNumbers - 1;
                    if (newTicketsNumbers >= 0) {
                      // تحديث المستند الأول في ticketsRef بالقيمة الجديدة لـ ticketsNumbers
                      await ticketsRef.doc(querySnapshot.docs.first.id).update({'ticketsNumbers': newTicketsNumbers});
                      deletionCompleted = true; // تحديث العلامة للإشارة إلى أن الحذف تم مرة واحدة
                      return;
                    }
                  }
                } catch (e) {
                  print('Error updating tickets numbers: $e');
                }
              }

              void showTicketDetailsDialog(BuildContext context, String ticketId) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ticket Details'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${DateFormat('dd MMM yyyy HH:mm').format(_selectedDate!)}'),

                            Text('Distance: $distance K'),
                            Text('Person Count: $_selectedPersonCount'),
                            Text('Ticket Price: $ticketPrice'),
                            Text('ticketId $ticketId'),
                            // قد تحتاج إلى إضافة المزيد من التفاصيل حسب احتياجات التطبيق الخاصة بك
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }

              Future<String> buyTicket() async {
                String ticketId = generateRandomNumber(); // Generate the ticket ID
                try {
                  // Update ticket numbers
                  await updateTicketsNumbers();

                  // Add user ticket details
                  CollectionReference userTicketsRef = FirebaseFirestore.instance.collection('UserTickets');
                  await userTicketsRef.add({
                    'acceptedDate': true,
                    'date': _selectedDate,
                    'distance': distance,
                    'presonid': "YYz6LNY6UYPemISOw7JqNmZ3Kfx1",
                    'ticketPrice': ticketPrice,
                    '_personCounts': _selectedPersonCount,
                    'ticketId': ticketId,
                  });

                  return ticketId; // Return the ticket ID
                } catch (e) {
                  print('Error adding appointment chat: $e');
                  return ''; // Return an empty string if there's an error
                }
              }

              () async {
                try {
                  // Buy ticket and get the generated ticket ID
                  String generatedTicketId = await buyTicket();

                  // Show ticket details dialog
                  showTicketDetailsDialog(context, generatedTicketId);
                } catch (e) {
                  print('Error buying ticket: $e');
                }
              };

              // Update the selected date
              String generatedTicketId = await buyTicket(); // انتظر القيمة المرجعية
              showTicketDetailsDialog(context, generatedTicketId);
            },
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
                  'Buy Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // لون النص
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: ksize.width * 0.01),
        ],
      ),
    );
  }
}
