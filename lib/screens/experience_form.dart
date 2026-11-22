import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  // Kunci untuk mengakses state form (validasi dan reset).
  final _formKey = GlobalKey<FormState>();

  // Controller field tanggal (readOnly, isinya diisi lewat date picker).
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  // Variabel penyimpan input dari tiap field.
  String _name = "";
  String _position = "";
  String _description = "";
  String _category = "Full-Time"; // default
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _categories = [
    'Internship',
    'Research',
    'Volunteer',
    'Part-Time',
    'Full-Time',
    'Freelance',
  ];

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Dekorasi input yang seragam untuk semua field.
  InputDecoration _decoration(String label, String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  // Format tanggal sederhana: dd-mm-yyyy.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  // Membuka date picker lalu menyimpan tanggal yang dipilih.
  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : (_endDate ?? _startDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startController.text = _formatDate(picked);
      } else {
        _endDate = picked;
        _endController.text = _formatDate(picked);
      }
    });
  }

  // Mengosongkan form dan semua variabel setelah dialog ditutup.
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _name = "";
      _position = "";
      _description = "";
      _category = "Full-Time";
      _startDate = null;
      _endDate = null;
      _startController.clear();
      _endController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // Drawer yang sama dengan halaman lain agar navigasi tetap konsisten.
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // Pesan error ikut diperbarui saat pengguna mengubah isian.
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // Konten bisa di-scroll agar semua field dan tombol Simpan tetap
        // terjangkau pada layar sempit atau saat papan ketik tampil.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Name of Experience ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration("Name of Experience", "Seminar"),
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Experience name is required.";
                    }
                    if (value.trim().length < 3) {
                      return "Experience name must be at least 3 characters.";
                    }
                    if (value.trim().length > 100) {
                      return "Experience name must be no more than 100 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Position/Role ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration("Position/Role", "Participant"),
                  onChanged: (String? value) {
                    setState(() {
                      _position = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Position/role is required.";
                    }
                    if (value.trim().length < 2) {
                      return "Position/role must be at least 2 characters.";
                    }
                    if (value.trim().length > 100) {
                      return "Position/role must be no more than 100 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Experience Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: _decoration(
                    "Experience Description",
                    "Describe your experience",
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description is required.";
                    }
                    if (value.trim().length > 1000) {
                      return "Description must be no more than 1000 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Experience Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _decoration(
                    "Experience Category",
                    "Pilih kategori",
                  ),
                  initialValue: _category,
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),

              // === Start Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startController,
                  readOnly: true,
                  decoration: _decoration(
                    "Start Date",
                    "Pilih tanggal",
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(isStart: true),
                  validator: (String? value) {
                    if (_startDate == null) {
                      return "Start date is required.";
                    }
                    return null;
                  },
                ),
              ),

              // === End Date (opsional: kosong = masih berlangsung) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endController,
                  readOnly: true,
                  decoration: _decoration(
                    "End Date",
                    "Kosongkan jika masih berlangsung",
                    suffixIcon: _endDate == null
                        ? const Icon(Icons.calendar_today)
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _endDate = null;
                                _endController.clear();
                              });
                            },
                          ),
                  ),
                  onTap: () => _pickDate(isStart: false),
                  validator: (String? value) {
                    // Boleh kosong; kalau diisi tidak boleh sebelum tanggal mulai.
                    if (_endDate == null) {
                      return null;
                    }
                    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
                      return "End date cannot be before the start date.";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      // Dialog hanya muncul jika semua input lolos validasi.
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            void closeSummary() {
                              Navigator.of(dialogContext).pop();
                              _resetForm();
                            }

                            return AlertDialog(
                              title: const Text(
                                'Experience added successfully!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${_name.trim()}'),
                                    Text('Position/Role: ${_position.trim()}'),
                                    Text('Description: ${_description.trim()}'),
                                    Text('Category: $_category'),
                                    Text(
                                      'Start Date: ${_formatDate(_startDate!)}',
                                    ),
                                    Text(
                                      'End Date: ${_endDate == null ? 'Ongoing' : _formatDate(_endDate!)}',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: closeSummary,
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
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