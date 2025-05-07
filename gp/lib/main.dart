import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/loading_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Screens/login_page.dart';
import 'Screens/verification_code_page.dart';
import 'Screens/usher_register_page.dart';
import 'Screens/creator_register_page.dart';
import 'Screens/company_register_page.dart';
import 'Screens/forget_password_page.dart';
import 'Screens/reset_password_page.dart';
import 'Screens/signup_options_page.dart';
import 'Screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoadingProvider())],
      child: MaterialApp(
        title: 'Company Auth App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Cairo'),
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup-options': (context) => const SignUpOptionsPage(),
          '/register-usher': (context) => const UsherRegisterPage(),
          '/register-creator': (context) => const ContentCreatorRegisterPage(),
          '/register-company': (context) => const CompanyRegisterPage(),
          '/forgot-password': (context) => const ForgetPasswordPage(),
          '/home': (context) => const HomePage(),
        },
        // We use onGenerateRoute for routes that need parameters
        onGenerateRoute: (settings) {
          // For verification code page
          if (settings.name == '/verification') {
            final String email = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => VerificationCodePage(email: email),
            );
          }

          // For reset password page
          if (settings.name == '/reset-password') {
            final String email = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ResetPasswordPage(email: email),
            );
          }

          return null;
        },
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              Consumer<LoadingProvider>(
                builder: (context, loadingProvider, _) {
                  if (!loadingProvider.isLoading) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.brown),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
