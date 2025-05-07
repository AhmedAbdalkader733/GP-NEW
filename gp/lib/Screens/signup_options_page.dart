import 'package:flutter/material.dart';
import '../constants.dart';
import 'company_register_page.dart';
import 'creator_register_page.dart';
import 'usher_register_page.dart';

class SignUpOptionsPage extends StatelessWidget {
  const SignUpOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String companiesImg =
        "https://cdn-icons-png.flaticon.com/512/3135/3135706.png";
    const String creatorImg =
        "https://cdn-icons-png.flaticon.com/512/1055/1055687.png";
    const String usherImg =
        "https://cdn-icons-png.flaticon.com/512/2922/2922561.png";

    Widget buildVerticalCard({
      required String label,
      required String imgUrl,
      required void Function() onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: mainColor, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: mainColor.withAlpha(36), // 0.14 * 255
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F4F0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.contain,
                    height: 44,
                    width: 44,
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: .3,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: mainColor, size: 22),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD5B977), Color(0xFF181511)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: mainColor,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Sign up as",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: mainColor,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 45),
                  ],
                ),
              ),
              const Spacer(flex: 11),
              buildVerticalCard(
                label: "Usher",
                imgUrl: usherImg,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UsherRegisterPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 7),
              buildVerticalCard(
                label: "Companies",
                imgUrl: companiesImg,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompanyRegisterPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 7),
              buildVerticalCard(
                label: "Content Creator",
                imgUrl: creatorImg,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContentCreatorRegisterPage(),
                    ),
                  );
                },
              ),
              const Spacer(flex: 9),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  "Choose your appropriate account type",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
