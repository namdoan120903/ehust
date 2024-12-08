import 'package:flutter/material.dart';
import 'package:project/screens/myAppBar.dart';
import 'package:provider/provider.dart';

import '../../model/Class.dart';
import '../../provider/ClassProvider.dart';

class OpenClass extends StatefulWidget {
  const OpenClass({super.key});

  @override
  State<OpenClass> createState() => _OpenClassState();
}

class _OpenClassState extends State<OpenClass> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedStatus;
  String? _selectedType;
  int _currentPage = 0;
  final int _classesPerPage = 3;
  List<Class> filteredClasses = [];

  @override
  void initState() {
    super.initState();
    // Lấy instance của ClassProvider mà không lắng nghe các thay đổi
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    classProvider.getOpenClass(context, _idController.text, _selectedStatus, _nameController.text, _selectedType);
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    final totalPages = (filteredClasses.length / _classesPerPage).ceil();
    final currentPageClasses = filteredClasses
        .skip(_currentPage * _classesPerPage)
        .take(_classesPerPage)
        .toList();

    return Scaffold(
      appBar: MyAppBar(check: true, title: "EHUST-STUDENT"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Danh sách lớp mở kì này',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            SizedBox(height: 8),
            // Lọc theo ID và Tên (cùng 1 dòng)
            Row(
              children: [
                // TextField cho ID
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'ID lớp',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Khoảng cách giữa 2 TextField

                // TextField cho tên lớp
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên lớp',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Lọc theo trạng thái và loại lớp (cùng 1 dòng)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dropdown cho trạng thái
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: [
                      DropdownMenuItem(value: "ACTIVE", child: Text("ACTIVE")),
                      DropdownMenuItem(value: "COMPLETED", child: Text("COMPLETED")),
                      DropdownMenuItem(value: "UPCOMING", child: Text("UPCOMING")),
                      DropdownMenuItem(value: null, child: Text("No Select")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Trạng thái',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Khoảng cách giữa 2 dropdown

                // Dropdown cho loại lớp
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: [
                      DropdownMenuItem(value: "LT", child: Text("LT")),
                      DropdownMenuItem(value: "BT", child: Text("BT")),
                      DropdownMenuItem(value: "LT_BT", child: Text("LT_BT")),
                      DropdownMenuItem(value: null, child: Text("No Select")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Loại lớp',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                setState(() {
                String idFilter = _idController.text.trim();
                String nameFilter = _nameController.text.trim();
                // Lọc danh sách
                filteredClasses = classProvider.openClasss.where((classItem) {
                  // Kiểm tra từng điều kiện
                  final matchId = idFilter.isEmpty || (classItem.classId?.contains(idFilter) ?? false);
                  final matchName = nameFilter.isEmpty || (classItem.className?.contains(nameFilter)??false);
                  final matchStatus = _selectedStatus == null || classItem.status == _selectedStatus;
                  final matchType = _selectedType == null || classItem.classType == _selectedType;

                  // Trả về true nếu tất cả điều kiện đều khớp
                  return matchId && matchName && matchStatus && matchType;
                }).toList();
                print(filteredClasses);
                _currentPage = 0;
                });
              },
              child: Text('Tìm kiếm'),
            ),
            SizedBox(height: 8),

            classProvider.openClasss.isEmpty
                ? Text('Không tìm thấy lớp học nào.')
                : Expanded(
              child: ListView.builder(
                itemCount: currentPageClasses.length,
                itemBuilder: (context, index) {
                  final classItem = currentPageClasses[index];
                  return Card(
                    child: ListTile(
                      title: Text(classItem.className!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${classItem.classId} - Trạng thái: ${classItem.status} - Loại: ${classItem.classType}'),
                          Text('Giáo viên: ${classItem.lecturerName ?? ''} - SL: ${classItem.studentCount ?? 'N/A'}'),
                          Text('Thời gian bắt đầu: ${classItem.startDate ?? 'Chưa xác định'}'),
                          Text('Thời gian kết thúc: ${classItem.endDate ?? 'Chưa xác định'}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Previous
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _currentPage > 0
                      ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                      : null,
                ),
                // Hiển thị trang hiện tại
                Text('Trang ${_currentPage + 1} / $totalPages'),
                // Nút Next
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
