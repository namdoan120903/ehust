import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/AuthProvider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool check;
  final String title;
  const MyAppBar({super.key, required this.check, required this.title});
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return AppBar(
      backgroundColor: Colors.red[700],
      title: GestureDetector(
        onTap:(){
          if(authProvider.user.role == "STUDENT") Navigator.pushNamed(context, '/student');
          if(authProvider.user.role == "LECTURER") Navigator.pushNamed(context, '/lecturer');
        },
        child: Text(
          title,
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
