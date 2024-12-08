import 'package:flutter/material.dart';
import 'package:project/appBar/bottomBar.dart';
import 'package:project/appBar/myAppBar.dart';
class ClassInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: MyAppBar(),
        body: SingleChildScrollView(
          padding:  EdgeInsets.all(16.0),
          child: Column(

            children: [
              // Text "thông tin chi tiết lớp" màu đỏ, center
              Center(
                child: Text(
                  'Thông Tin Chi Tiết Lớp',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // 3 button: Bài tập, Tài liệu, Nghỉ phép
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors. red.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // Hành động cho nút Bài tập
                      },
                      child: Text('Bài tập',style: TextStyle(fontSize: 20,
                          color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors. red.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Hành động cho nút Tài liệu
                        },
                        child: Text('Tài liệu',style: TextStyle(fontSize: 20,
                            color: Colors.black),
                        )
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors. red.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Hành động cho nút Nghỉ phép
                        },
                        child: Text('Nghỉ phép',style: TextStyle(fontSize: 20,
                            color: Colors.black),
                        )
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Khung chứa thông tin lớp
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.only(left: 10.0,top: 30.0,right:76.0,bottom: 76.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(
                      '154052 - Phát Triển Đa Nền Tảng',
                      style: TextStyle(fontSize: 18),
                      textAlign:TextAlign.start  ,
                    ),
                      Text('IT4788',style: TextStyle(fontSize: 18)),
                      Text('Sáng t3, tiết 1-4, tc207',style: TextStyle(fontSize: 18)),
                      Text('Thông tin thêm',style: TextStyle(fontSize: 18))
                    ]),

              ),
              SizedBox(height: 20),
              // Khung màu đỏ nhạt chứa danh sách sinh viên
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.only(left: 20.0,top: 30.0,right:150.0,bottom: 46.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(
                      'Danh sách sinh viên',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign:TextAlign.start  ,
                    ),
                      Text('Nguyễn Văn A'),
                      Text('Trần Thị B'),
                      Text('Vũ Đức C'),
                    ]),

              ),
            ],
          ),
        ),
          bottomNavigationBar: MyBottomNavigationBar()
      ),
    );
  }
}
