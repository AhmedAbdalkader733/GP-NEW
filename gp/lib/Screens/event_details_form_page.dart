import 'package:flutter/material.dart' hide Row, SizedBox;
import 'package:flutter/material.dart' as material show Row, SizedBox;
import '../constants.dart' show mainColor;

class EventDetailsFormPage extends StatefulWidget {
  const EventDetailsFormPage({super.key});

  @override
  State<EventDetailsFormPage> createState() => _EventDetailsFormPageState();
}

class _EventDetailsFormPageState extends State<EventDetailsFormPage> {
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _ushersController = TextEditingController();
  final _creatorsController = TextEditingController();

  DateTime? _dateFrom;
  DateTime? _dateTo;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _locationController.dispose();
    _descController.dispose();
    _ushersController.dispose();
    _creatorsController.dispose();
    super.dispose();
  }

  Future<void> pickDate(BuildContext context, bool from) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: mainColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (from) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  Future<void> pickTime(BuildContext context, bool from) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: mainColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (from) {
          _timeFrom = picked;
        } else {
          _timeTo = picked;
        }
      });
    }
  }

  String getDateStr(DateTime? d) {
    if (d == null) return '';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String getTimeStr(TimeOfDay? t) {
    if (t == null) return '';
    return t.format(context);
  }

  InputDecoration fieldDeco({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFEAEAEA),
      prefixIcon: icon != null ? Icon(icon, color: mainColor) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: mainColor, width: 1.7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 27),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Event Details'),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      )),
                  const material.SizedBox(height: 8),
                  material.Row(
                    children: [
                      // From Date
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickDate(context, true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: fieldDeco(
                                  hint: _dateFrom == null
                                      ? 'From'
                                      : getDateStr(_dateFrom),
                                  icon: Icons.calendar_month),
                              validator: (_) =>
                                  _dateFrom == null ? 'Required' : null,
                            ),
                          ),
                        ),
                      ),
                      const material.SizedBox(width: 18),
                      // To Date
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickDate(context, false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: fieldDeco(
                                  hint: _dateTo == null
                                      ? 'To'
                                      : getDateStr(_dateTo),
                                  icon: Icons.calendar_today_outlined),
                              validator: (_) =>
                                  _dateTo == null ? 'Required' : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const material.SizedBox(height: 18),
                  const Text(
                    'Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const material.SizedBox(height: 8),
                  material.Row(
                    children: [
                      // From Time
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickTime(context, true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: fieldDeco(
                                  hint: _timeFrom == null
                                      ? 'From'
                                      : getTimeStr(_timeFrom),
                                  icon: Icons.access_time),
                              validator: (_) =>
                                  _timeFrom == null ? 'Required' : null,
                            ),
                          ),
                        ),
                      ),
                      const material.SizedBox(width: 18),
                      // To Time
                      Expanded(
                        child: GestureDetector(
                          onTap: () => pickTime(context, false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: fieldDeco(
                                  hint: _timeTo == null
                                      ? 'To'
                                      : getTimeStr(_timeTo),
                                  icon: Icons.access_time_outlined),
                              validator: (_) =>
                                  _timeTo == null ? 'Required' : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const material.SizedBox(height: 18),
                  TextFormField(
                    controller: _locationController,
                    decoration: fieldDeco(hint: 'Location', icon: Icons.place),
                    validator: (v) =>
                        v!.trim().isEmpty ? 'Location is required' : null,
                  ),
                  const material.SizedBox(height: 13),
                  TextFormField(
                    controller: _descController,
                    decoration: fieldDeco(hint: 'Describe your event', icon: Icons.edit),
                    maxLines: 2,
                    validator: (v) => v!.trim().isEmpty ? 'Event description required' : null,
                  ),
                  const material.SizedBox(height: 13),
                  TextFormField(
                    controller: _ushersController,
                    decoration: fieldDeco(
                        hint: 'Numbers of total ushers',
                        icon: Icons.people_outline),
                    keyboardType: TextInputType.number,
                  ),
                  const material.SizedBox(height: 13),
                  TextFormField(
                    controller: _creatorsController,
                    decoration: fieldDeco(
                        hint: 'Numbers of total contents creators',
                        icon: Icons.group_outlined),
                    keyboardType: TextInputType.number,
                  ),
                  const material.SizedBox(height: 28),
                  material.SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data sent successfully!'),
                              backgroundColor: mainColor,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9))),
                      child: material.Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Next',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          material.SizedBox(width: 9),
                          Icon(Icons.arrow_forward, size: 22),
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