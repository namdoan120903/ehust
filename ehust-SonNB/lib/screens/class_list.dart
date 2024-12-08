import 'package:flutter/material.dart';
import 'package:project/appBar/myAppBar.dart';
import 'package:project/appBar/bottomBar.dart';
class ClassList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Danh sách lớp học',
      home: ClassListScreen(),
    );
  }
}

class ClassListScreen extends StatelessWidget {
  //final List<String> classes = List.generate(20, (index) => 'Lớp học ${index + 1}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Danh sách lớp học',
                style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold,),
              ),
            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
            SizedBox(height: 20),
            // Khung chứa thông tin lớp
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(28),
              ),
              padding: EdgeInsets.only(left: 10.0,top: 20.0,right:136.0,bottom: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(
                    '154052 - Phát triển đa nền tảng',
                    style: TextStyle(fontSize: 16),
                    textAlign:TextAlign.start  ,
                  ),
                    Text('IT4788',style: TextStyle(fontSize: 16)),
                    Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 16)),
                  ]),

            ),
          ],
        ),
      ),
    );
  }
}
