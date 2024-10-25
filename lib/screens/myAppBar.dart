import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool check;
  const MyAppBar({super.key, required this.check});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[700],
      title: GestureDetector(
        onTap:(){
          Navigator.pushNamed(context, '/studenthome');
        },
        child: Text(
          'EHUST-S',
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ) ,
      automaticallyImplyLeading: check,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white,),
          onPressed: () {
            // Handle notification button press
          },
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
