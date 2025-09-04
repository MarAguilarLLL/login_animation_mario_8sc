import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Cerebro de la logica de animaciones
  StateMachineController? controller;

  // State Machine Input
  SMIBool? isCheckIn; // Activa Oso chismoso
  SMIBool? isHandsUP; // Se tapa los ojos
  SMITrigger? trigSuccess; // Se emociona
  SMITrigger? trigFail; // Se pone triste
  SMINumber? numLook; // Controla la mirada del oso (nueva variable)

  // Estado para ocultar/mostrar contraseña
  bool _obscurePassword = true;

  // Controlador para el campo de email
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateBearLook);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _updateBearLook() {
    if (numLook != null) {
      // Calculamos un valor entre 0 y 1 basado en la longitud del email
      // Puedes ajustar el divisor (15) según lo que consideres una longitud "normal"
      double lookValue = (_emailController.text.length/1);
      numLook!.change(lookValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    // Verifica si hay un controlador
                    if (controller == null) return;
                    // Agregar el controlador al tablero
                    artboard.addController(controller!);
                    // "Enlaza" la animacion con la app
                    isCheckIn = controller!.findSMI("isChecking");
                    isHandsUP = controller!.findSMI("isHandsUp");
                    trigSuccess = controller!.findSMI("trigSuccess");
                    trigFail = controller!.findSMI("trigFail");
                    numLook = controller!.findSMI("numLook"); // Nueva variable
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController, // Usar el controlador
                onChanged: (value) {
                  if (isHandsUP != null) {
                    // No subir las manos al escribir email
                    isHandsUP!.change(false);
                  }
                  // Verifica que ese SMI no sea nulo
                  if (isCheckIn == null) return;
                  isCheckIn!.change(true);
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  if (isCheckIn != null) {
                    // No mover los ojos al escribir la contraseña
                    isCheckIn!.change(false);
                  }
                  // Verifica que ese SMI no sea nulo
                  if (isHandsUP == null) return;
                  isHandsUP!.change(true);
                },
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              // Boton de login
              const SizedBox(height: 10),
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}