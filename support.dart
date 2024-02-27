import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 248, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18315A),
        centerTitle: true, // لوضع العنوان في المنتصف
        title: Text(
          'Technical support',
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
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: ksize.width * 0.1),
                  ElevatedButton(
                    onPressed: () {
                      // Add your booking logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // لون الخلفية
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // حواف دائرية
                      ),
                    ),
                    child: SizedBox(
                      width: ksize.width * 0.85,
                      height: ksize.height * 0.09,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'assets/technicalsupport.png', // مسار الصورة
                              width: 35, // تحديد العرض
                              height: 35, // تحديد الارتفاع
                            ),
                          ),
                          const SizedBox(width: 12),

                          const Text(
                            'About Trip',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF18315A), // لون النص
                            ),
                          ),
                          const SizedBox(width: 40), // مسافة بين النص والصورة
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ksize.width * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      // Add your booking logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // لون الخلفية
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // حواف دائرية
                      ),
                    ),
                    child: SizedBox(
                      width: ksize.width * 0.85,
                      height: ksize.height * 0.09,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'assets/technicalproplem.png', // مسار الصورة
                              width: 35, // تحديد العرض
                              height: 35, // تحديد الارتفاع
                            ),
                          ),
                          const SizedBox(width: 12),

                          const Text(
                            'Technical Proplem',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF18315A), // لون النص
                            ),
                          ),
                          const SizedBox(width: 40), // مسافة بين النص والصورة
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
