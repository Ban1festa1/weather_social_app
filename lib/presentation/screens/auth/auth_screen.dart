import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoginMode = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите email и пароль'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пароль должен быть минимум 6 символов'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLoginMode) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (error) {
      String message = 'Ошибка авторизации';

      if (error.code == 'email-already-in-use') {
        message = 'Такой email уже зарегистрирован';
      } else if (error.code == 'user-not-found') {
        message = 'Пользователь не найден';
      } else if (error.code == 'wrong-password') {
        message = 'Неверный пароль';
      } else if (error.code == 'invalid-email') {
        message = 'Некорректный email';
      } else if (error.code == 'weak-password') {
        message = 'Слишком слабый пароль';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неизвестная ошибка'),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = isLoginMode ? 'Вход' : 'Регистрация';
    final buttonText = isLoginMode ? 'Войти' : 'Создать аккаунт';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Social'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud,
                    size: 72,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isLoading ? null : _submit,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: Text(isLoading ? 'Загрузка...' : buttonText),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              isLoginMode = !isLoginMode;
                            });
                          },
                    child: Text(
                      isLoginMode
                          ? 'Нет аккаунта? Зарегистрироваться'
                          : 'Уже есть аккаунт? Войти',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}