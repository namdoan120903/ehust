import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges; // Use prefix for badges package
import 'package:project/provider/NotificationProvider.dart';
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
        onTap: () {
          // Navigate based on the user's role
          if (authProvider.user.role == "STUDENT")
            Navigator.pushNamed(context, '/student');
          if (authProvider.user.role == "LECTURER")
            Navigator.pushNamed(context, '/lecturer');
        },
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      automaticallyImplyLeading: check,
      actions: [
        Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return badges.Badge(
              // Using the badge from the badges package explicitly
              showBadge: provider.unreadCount > 0,
              badgeContent: Text(
                provider.unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              child: IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                  provider
                      .getUnreadNotificationCount(); // Refresh count on open
                },
              ),
            );
          },
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
