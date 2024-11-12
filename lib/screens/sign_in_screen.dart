import 'package:flutter/material.dart';
import 'package:project/provider/AuthProvider.dart';
import 'package:project/screens/student_home.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showPassword = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final TextEditingController _codeController = TextEditingController(text: authProvider.haveCode);
    return Scaffold(
      backgroundColor: Colors.red[700],
      body:SingleChildScrollView(
        child:
        Center(
        child: Padding(padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 150,),
            Text('HUST',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 40,),
            Text('Đăng nhập với tài khoản QLDT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),),
            SizedBox(height: 20,),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email hoặc mã số SV/CB",
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.3),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.white, width: 2)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: Colors.white, width: 2), // Set border color to white when focused
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: Colors.white, width: 2), // Set border color to white when disabled
                ),
                prefixIcon: Icon(Icons.person, color: Colors.white,)
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              style: TextStyle(color: Colors.white),
              obscureText: !_showPassword,
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "Mật Khẩu",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.white, width: 2)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                        color: Colors.white, width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                        color: Colors.white, width: 2),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white,),
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _showPassword = ! _showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility: Icons.visibility_off,
                        color: Colors.white,
                      ))
              ),
            ),
            SizedBox(height: 20,),
            if (authProvider.locked) TextField(
              style: TextStyle(color: Colors.white),
              controller: _codeController,
              decoration: InputDecoration(
                  labelText: "Mã xác thực",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: Colors.white, width: 2)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                        color: Colors.white, width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                        color: Colors.white, width: 2),
                  ),
              ),
            ),
            SizedBox(width: 20,),
            if (authProvider.isLoading) const CircularProgressIndicator()
            ,SizedBox(width: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      authProvider.login(context,_emailController.text, _passwordController.text);
                      if(authProvider.haveCode != null){authProvider.verifyCode(context, _emailController.text, _codeController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        )
                    ),
                    child: Text("Đăng nhập",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[700]
                      ),)),
                SizedBox(width: 10,),
                IconButton(onPressed: () {  },
                  icon: Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            TextButton(
                onPressed: (){
                },
                child: Text('Quên mật khẩu',
                style: TextStyle(
                  color: Colors.white,
                ),)),
            TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Đăng kí tài khoản',
                  style: TextStyle(
                    color: Colors.white,
                  ),))
          ],
        ),
        ),
      ),
    ));
  }
}
