import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async';

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
  SMINumber? numLook; // Controla la mirada del oso

  // Estado para ocultar/mostrar contraseña
  bool _obscurePassword = true;

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes para detectar qué campo está activo
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Timer para el debounce
  Timer? _debounceTimer;

  // Estado para mostrar carga durante el login
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    
    // Agregar listeners a los focus nodes
    _emailFocusNode.addListener(_handleEmailFocusChange);
    _passwordFocusNode.addListener(_handlePasswordFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onEmailChanged() {
    // Cancelar el timer anterior si existe
    _debounceTimer?.cancel();
    
    // Asegurarse de que isCheckIn esté activo cuando se escribe en el email
    if (_emailFocusNode.hasFocus && isCheckIn != null) {
      isCheckIn!.change(true);
    }
    
    // Actualizar la mirada del oso según la longitud del texto
    if (numLook != null && _emailFocusNode.hasFocus) {
      double lookValue = (_emailController.text.length / 1);
      numLook!.change(lookValue);
    }
    
    // Iniciar un nuevo timer para resetear después de 1 segundo de inactividad
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      // Solo resetear si el email aún tiene el foco
      if (_emailFocusNode.hasFocus) {
        if (isCheckIn != null) {
          isCheckIn!.change(false); // Deja de mirar el email (vuelve a base)
        }
      }
    });
  }

  void _handleEmailFocusChange() {
    if (_emailFocusNode.hasFocus) {
      // Cuando el email field está enfocado
      if (isHandsUP != null) {
        isHandsUP!.change(false); // Baja las manos si estaban arriba
      }
      // Nota: No activamos isCheckIn aquí, se activará al escribir
    } else {
      // Cuando el email field pierde el foco
      _debounceTimer?.cancel(); // Cancelar el timer si existe
      _resetEmailAnimation();
    }
  }

  void _handlePasswordFocusChange() {
    if (_passwordFocusNode.hasFocus) {
      // Cuando el password field está enfocado
      // Cancelar el timer del email si existe
      _debounceTimer?.cancel();
      if (isCheckIn != null) {
        isCheckIn!.change(false); // Deja de mirar el email
      }
      if (isHandsUP != null) {
        isHandsUP!.change(true); // Se tapa los ojos
      }
    } else {
      // Cuando el password field pierde el foco
      if (isHandsUP != null) {
        isHandsUP!.change(false); // Baja las manos
      }
    }
  }

  void _resetEmailAnimation() {
    if (isCheckIn != null) {
      isCheckIn!.change(false); // Deja de mirar el email
    }
    //if (numLook != null) {
      //numLook!.change(0.0); // Resetea la mirada a cero
    //}
  }

  // Función para simular el proceso de login
  void _simulateLogin() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Ocultar teclado
    FocusScope.of(context).unfocus();
    
    // Simular proceso de autenticación
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar credenciales (esto es solo un ejemplo)
    final email = _emailController.text;
    final password = _passwordController.text;
    
    final isValid = email.contains('@') && password.length >= 6;
    
    // Activar la animación correspondiente
    if (isValid && trigSuccess != null) {
      trigSuccess!.fire();
      // Aquí podrías navegar a la siguiente pantalla después de un delay
    } else if (!isValid && trigFail != null) {
      trigFail!.fire();
    }
    
    setState(() {
      _isLoading = false;
    });
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
                    numLook = controller!.findSMI("numLook");
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
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
                controller: _passwordController,
                focusNode: _passwordFocusNode,
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
                onPressed: _simulateLogin,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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