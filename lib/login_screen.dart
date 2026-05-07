import 'package:flutter/material.dart';
import 'package:project_flutter/api_service.dart';
import 'package:project_flutter/signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

@override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handlelogic ()async{

    String email = emailController.text;
    String password = passwordController.text;
    if(email.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(" please Enter the Email"),),
    );

    return;

    }

    if(password.length<6){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(" please enter the password"),),
    );

    return;
  }
try{
  final token = await ApiService.login(email, password);
  await ApiService.saveToken(token);
  print("Token saved");
  print("Token: $token");
  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> HomeScreen())
      );
}catch(e){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Login Failed - wrong email or password")),
  );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _handlelogic,
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text("Don't have an account? Sign up"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}