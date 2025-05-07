import 'package:flutter/material.dart';
import '../constants.dart';
import 'creator_role_page.dart';
import 'usher_role_page.dart';
import 'both_roles_page.dart';

class DualSelectPage extends StatefulWidget {
  const DualSelectPage({super.key});
  @override
  State<DualSelectPage> createState() => _DualSelectPageState();
}

class _DualSelectPageState extends State<DualSelectPage> {
  bool isUsherSelected = false;
  bool isCreatorSelected = false;

  final String usherImg = "https://cdn-icons-png.flaticon.com/512/2922/2922561.png";
  final String creatorImg = "https://cdn-icons-png.flaticon.com/512/1055/1055687.png";

  void selectBoth() {
    setState(() {
      isUsherSelected = true;
      isCreatorSelected = true;
    });
  }

  Widget buildSelectableCard({
    required String title,
    required String imgUrl,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? mainColor.withAlpha(33) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? mainColor : Colors.grey.shade300,
            width: selected ? 2.2 : 1.2,
          ),
          boxShadow: [
            if(selected) BoxShadow(
              color: mainColor.withAlpha(28),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imgUrl,
                width: 54,
                height: 54,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: mainColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .3,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: selected
                  ? const Icon(Icons.check_circle_rounded, color: mainColor, key: ValueKey(true), size: 26)
                  : const Icon(Icons.circle_outlined, color: Colors.grey, key: ValueKey(false), size: 26),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Choose Category",
          style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD5B977), Color(0xFF181511)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  buildSelectableCard(
                    title: "Usher",
                    imgUrl: usherImg,
                    selected: isUsherSelected,
                    onTap: () {
                      setState(() => isUsherSelected = !isUsherSelected);
                    },
                  ),
                  buildSelectableCard(
                    title: "Content Creator",
                    imgUrl: creatorImg,
                    selected: isCreatorSelected,
                    onTap: () {
                      setState(() => isCreatorSelected = !isCreatorSelected);
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.select_all),
                      label: const Text("Both", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      onPressed: selectBoth,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // زرار next
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isCreatorSelected && !isUsherSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CreatorRolePage()),
                          );
                        } else if (isUsherSelected && !isCreatorSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const UsherRolePage()),
                          );
                        } else if (isUsherSelected && isCreatorSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const BothRolesPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('يرجى اختيار نوع واحد أو كلاهما للمتابعة.'),
                              backgroundColor: mainColor,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 7),
                          Icon(Icons.arrow_forward, size: 19)
                        ],
                      ),
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