import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:quick_court_booking/models/venue_model.dart';
import 'package:quick_court_booking/screens/admin/owner_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterVenueScreen extends StatefulWidget {
  const RegisterVenueScreen({super.key});

  @override
  State<RegisterVenueScreen> createState() => _RegisterVenueScreenState();
}

class _RegisterVenueScreenState extends State<RegisterVenueScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _rulesController = TextEditingController();

  int? selectedCategory;
  int? selectedCity;
  String selectedStatus = "available";

  bool _loading = false;

  List categories = [];
  List cities = [];
  List facilities = [];

  List<int> selectedFacilities = [];
  List<File> _pickedImages = []; // multi image

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchCities();
    _fetchFacilities();
  }

  Future<void> _fetchFacilities() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.22:8000/api/facilities"));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        setState(() {
          facilities = decoded['facilities']; 
        });

        print("Facilities loaded: $facilities");
      } else {
        throw Exception("Gagal ambil data fasilitas");
      }
    } catch (e) {
      debugPrint("Error fetch facilities: $e");
    }
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(
      Uri.parse("http://192.168.1.22:8000/api/categories"),
    );
    if (response.statusCode == 200) {
      setState(() {
        categories = jsonDecode(response.body);
      });
    }
  }

  Future<void> _fetchCities() async {
    final response = await http.get(
      Uri.parse("http://192.168.1.22:8000/api/city"),
    );
    if (response.statusCode == 200) {
      setState(() {
        cities = jsonDecode(response.body);
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _pickedImages = picked.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _submitVenue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih minimal 1 gambar")),
      );
      return;
    }

    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('laravel_token');

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://192.168.1.22:8000/api/owner/venues"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.fields.addAll({
      "name": _nameController.text,
      "address": _addressController.text,
      "capacity": _capacityController.text,
      "price": _priceController.text,
      "status": selectedStatus,
      "category_id": selectedCategory.toString(),
      "city_id": selectedCity.toString(),
      "deskripsi": _descController.text,
      "rules": _rulesController.text,
    });

    // fasilitas
    for (var facId in selectedFacilities) {
      request.fields['facilities[]'] = facId.toString();
    }

    // multiple images
    for (var img in _pickedImages) {
      request.files.add(await http.MultipartFile.fromPath("images[]", img.path));
    }

    var response = await request.send();

    setState(() => _loading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Venue berhasil didaftarkan")),
      );

      
      final resBody = await response.stream.bytesToString();
      final decoded = jsonDecode(resBody);

      
      final newVenue = decoded['data'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OwnerDashboardScreen(
            venues: [Venue.fromJson(newVenue)], 
          ),
        ),
      );
    } else {
      final resBody = await response.stream.bytesToString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $resBody")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Venue")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              _pickedImages.isNotEmpty
                  ? SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _pickedImages.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(
                            _pickedImages[i],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50),
                      ),
                    ),
              TextButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text("Pilih Gambar"),
              ),
              const SizedBox(height: 16),

              // --- Nama Venue ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Venue"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Alamat"),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: "Kapasitas"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              SizedBox(height: 16),

              
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: "available", child: Text("Available")),
                  DropdownMenuItem(value: "unavailable", child: Text("Unavailable")),
                ],
                onChanged: (val) => setState(() => selectedStatus = val!),
              ),
              SizedBox(height: 16),

              
              DropdownButtonFormField<int>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: "Kategori"),
                items: categories
                    .map<DropdownMenuItem<int>>(
                      (cat) => DropdownMenuItem(
                        value: cat["id"],
                        child: Text(cat["name"]),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
              ),
              SizedBox(height: 16),

              
              DropdownButtonFormField<int>(
                value: selectedCity,
                decoration: const InputDecoration(labelText: "Kota"),
                items: cities
                    .map<DropdownMenuItem<int>>(
                      (city) => DropdownMenuItem(
                        value: city["id"],
                        child: Text(city["name"]),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedCity = val),
              ),
              SizedBox(height: 16),

              
              if (facilities.isNotEmpty)
                MultiSelectDialogField(
                  items: facilities.map<MultiSelectItem<int>>((f) {
                    final id = f['id'] as int;
                    final name = f['name'] as String;
                    return MultiSelectItem(id, name);
                  }).toList(),
                  title: const Text("Fasilitas"),
                  buttonText: const Text("Pilih fasilitas"),
                  onConfirm: (values) {
                    setState(() {
                      selectedFacilities = values.cast<int>();
                    });
                  },
                ),

                SizedBox(height: 16),

              
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              SizedBox(height: 16),

              
              TextFormField(
                controller: _rulesController,
                decoration: const InputDecoration(labelText: "Peraturan"),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),

              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitVenue,
                      child: const Text("Daftarkan Venue"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
