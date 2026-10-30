import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system/auth/cubit/auth_cubit.dart';
import 'package:student_system/auth/sign_in/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Sign Up", style: TextStyle(fontSize: 30,color: Colors.white)),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Sign Up success",
                    style: TextStyle(fontSize: 20),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            }
            if (state is SignUpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.msg, style: TextStyle(fontSize: 20)),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = BlocProvider.of<AuthCubit>(context);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          SizedBox(height: 50),
                          Text(
                            "Enter your email and password to create your account",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 50),
                          TextFormField(
                            controller: cubit.emailSignUpController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              hintText: "Email",
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: cubit.passwordSignUpController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              hintText: "Password",
                            ),
                          ),
                          SizedBox(height: 50),
                          state is SignUpLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    cubit.signUp();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(300, 50),
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.orange, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
