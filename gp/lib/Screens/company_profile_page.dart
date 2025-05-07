import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants.dart';
import 'dual_select_page.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});
  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  File? profilePhoto;
  String companyName = "Company name";
  String companyNumber = "13245637";
  String email = "testmail@gmail.com";
  String phone = "01010101010";
  String address = "Cairo, Egypt";

  List<String> previousProjects = ["Cairo ICT", "Amr Diab concert"];
  List<String> inProgress = ["Cairo ICT"];

  Future pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => profilePhoto = File(img.path));
  }

  void showEditProfileSheet() {
    final nameController = TextEditingController(text: companyName);
    final mailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final numController = TextEditingController(text: companyNumber);
    final addrController = TextEditingController(text: address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181511),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(19))),
      builder: (c) {
        return Padding(
          padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: mainColor,
                      backgroundImage: profilePhoto != null
                          ? FileImage(profilePhoto!)
                          : const NetworkImage(
                              'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80'
                            ) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () async {
                          await pickImage();
                          Navigator.of(context).pop();
                          showEditProfileSheet();
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt, color: mainColor, size: 19),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _editField("Company name", nameController),
                _editField("Company number", numController, keyboardType: TextInputType.number),
                _editField("Email", mailController, icon: Icons.email),
                _editField("Phone", phoneController, icon: Icons.phone),
                _editField("Address", addrController, icon: Icons.place),
                const SizedBox(height: 17),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      setState(() {
                        companyName = nameController.text.trim();
                        companyNumber = numController.text.trim();
                        email = mailController.text.trim();
                        phone = phoneController.text.trim();
                        address = addrController.text.trim();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 7),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _editField(String hint, TextEditingController c, {IconData? icon, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: icon != null ? Icon(icon, color: mainColor) : null,
          filled: true,
          fillColor: const Color(0xFF26201A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: mainColor, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _projectGroup({required String label, required List<String> projects}) {
    bool isPrevious = label == "Previous Projects";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const Spacer(),
              if (isPrevious)
                IconButton(
                  onPressed: () async {
                    String? newProject = await showDialog(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text("Add Project", style: TextStyle(color: mainColor)),
                          content: TextField(
                            controller: controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Project Name",
                              hintStyle: const TextStyle(color: Colors.white54),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: mainColor)),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor,
                                  foregroundColor: Colors.black),
                              onPressed: () {
                                if (controller.text.trim().isNotEmpty) {
                                  Navigator.pop(context, controller.text.trim());
                                }
                              },
                              child: const Text("Add"),
                            )
                          ],
                        );
                      },
                    );
                    if (newProject != null && newProject.isNotEmpty) {
                      setState(() {
                        previousProjects.add(newProject);
                      });
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline, color: mainColor),
                  tooltip: "Add Project",
                ),
            ],
          ),
          const SizedBox(height: 10),
          ...projects.map((proj) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                child: Text(
                  proj,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD5B977), Color(0xFF181511)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 49,
                        backgroundColor: mainColor,
                        backgroundImage: profilePhoto != null
                            ? FileImage(profilePhoto!)
                            : const NetworkImage(
                                'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80'
                              ) as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(companyName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(companyNumber,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 15, fontWeight: FontWeight.w500)),
                  const Divider(height: 30, color: Colors.white38, thickness: 1),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, color: mainColor, size: 22),
                      const SizedBox(width: 11),
                      Expanded(child: Text(email, style: const TextStyle(color: Colors.white, fontSize: 15),
                      overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: mainColor, size: 22),
                      const SizedBox(width: 11),
                      Text(phone, style: const TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: mainColor, size: 22),
                      const SizedBox(width: 11),
                      Expanded(child: Text(address, style: const TextStyle(color: Colors.white, fontSize: 15),
                      overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 41,
                    child: ElevatedButton(
                      onPressed: showEditProfileSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                      ),
                      child: const Text('Edit Profile',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _projectGroup(
                    label: "Previous Projects",
                    projects: previousProjects,
                  ),
                  const SizedBox(height: 23),
                  _projectGroup(
                    label: "Inprogress",
                    projects: inProgress,
                  ),
                  const SizedBox(height: 38),
                  SizedBox(
                    width: 170,
                    height: 43,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DualSelectPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'New Project',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}