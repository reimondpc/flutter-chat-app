import 'package:chat_app_test/helpers/mostrar_alerta.dart';
import 'package:chat_app_test/services/auth_service.dart';
import 'package:chat_app_test/widgets/button_widget.dart';
import 'package:chat_app_test/widgets/input_widget.dart';
import 'package:chat_app_test/widgets/label_widget.dart';
import 'package:chat_app_test/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(title: 'Messenger'),
                  _Form(),
                  Labels(
                    ruta: 'register',
                    question: 'No tienes una cuenta?',
                    nav: 'Crea una ahora!',
                  ),
                  Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          InputWidget(
              icon: Icons.alternate_email_outlined,
              placeholder: 'Email',
              textController: emailController,
              keyboardType: TextInputType.emailAddress),
          InputWidget(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: passController,
            isPassword: true,
          ),
          ButtonWidget(
            text: 'Sign In',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                      emailController.text.trim(),
                      passController.text.trim(),
                    );
                    if (loginOk) {
                      //Navegar a otra pantalla
                      Navigator.pushReplacementNamed(context, 'user');
                    } else {
                      mostrarAlerta(context, 'Login incorrecto',
                          'Revise sus credenciales');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
