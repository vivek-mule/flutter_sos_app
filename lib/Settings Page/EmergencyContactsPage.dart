import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import '../Helper Functions/DatabaseHelper.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {

  List<Map<String, dynamic>> _contacts = []; // List of Maps to hold the contacts along with their names

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }


  // This function loads all the saved contacts from the database
  Future<void> _loadContacts() async {
    final contacts = await DatabaseHelper().getContacts();
    setState(() => _contacts = contacts);
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Contacts',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            _buildCard(
              icon: Icons.contacts,
              title: 'Add Emergency Contacts',
              subtitle: 'Manage your emergency contacts',
              onTap: () => _buildEmergencyContactsDialog(context, screenWidth),
            ),
            _buildCard(
              icon: Icons.quick_contacts_dialer_rounded,
              title: 'Add from Contacts',
              subtitle: 'Add from your saved contacts',
              onTap: () => _pickContact(),
            ),
            const SizedBox(height: 16),
            if (_contacts.isEmpty)
              Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No Contacts Added yet',
                      style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ),
              )
            else ...[
              // Card just for heading
              Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Your Added Contact(s)',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Separate card for list
              Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildContactsList(context),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }


  // This function builds the fancy card UI for the settings
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          leading: Icon(icon, color: Colors.redAccent, size: 28),
          title: Text(title, style: GoogleFonts.lato(fontSize: 16, color: Colors.white)),
          subtitle: Text(subtitle, style: GoogleFonts.lato(fontSize: 14, color: Colors.white70)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
        ),
      ),
    );
  }


  // This function builds the dialog so that users can add their own contacts
  Future<void> _buildEmergencyContactsDialog(
      BuildContext context, double screenWidth) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    List<Map<String, String>> newContacts = [];
    String? errorMessage;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                "Add Emergency Contact(s)",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              content: SizedBox(
                width: screenWidth * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Phone",
                                labelStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.redAccent),
                            onPressed: () async {
                              String name = nameController.text.trim();
                              String rawPhone = phoneController.text.trim();

                              if (name.isEmpty || rawPhone.isEmpty) {
                                setState(() => errorMessage = "Please enter both name and phone number.");
                                return;
                              }

                              String? normalizedPhone = validateAndNormalizeIndianPhone(rawPhone);

                              if (normalizedPhone == null) {
                                setState(() => errorMessage = "Phone number must be a valid 10-digit Indian number.");
                                return;
                              }

                              bool alreadyInList = newContacts.any(
                                    (c) => validateAndNormalizeIndianPhone(c['phone']!) == normalizedPhone,
                              );
                              if (alreadyInList) {
                                setState(() => errorMessage = "This number is already in your list.");
                                return;
                              }

                              final db = await DatabaseHelper().database;
                              final existing = await db.query(
                                'contacts',
                                where: 'phone = ?',
                                whereArgs: [normalizedPhone],
                              );

                              if (existing.isNotEmpty) {
                                setState(() => errorMessage = "This number is already saved.");
                                return;
                              }

                              // All clear — add to list
                              setState(() {
                                newContacts.add({
                                  'name': name,
                                  'phone': normalizedPhone,
                                });
                                errorMessage = null;
                                nameController.clear();
                                phoneController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage!,
                            style: GoogleFonts.lato(color: Colors.redAccent),
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (newContacts.isNotEmpty)
                        Column(
                          children: newContacts.map((contact) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                title: Text(
                                  contact['name']!,
                                  style: GoogleFonts.lato(color: Colors.white),
                                ),
                                subtitle: Text(
                                  contact['phone']!,
                                  style: GoogleFonts.lato(color: Colors.white70, fontSize: 13),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white70),
                                  onPressed: () {
                                    setState(() {
                                      newContacts.remove(contact);
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Close", style: GoogleFonts.lato(color: Colors.white70)),
                ),
                TextButton(
                  onPressed: () async {
                    for (var contact in newContacts) {
                      await DatabaseHelper().insertContact(
                        contact['name']!,
                        contact['phone']!,
                      );
                    }
                    await _loadContacts();
                    Navigator.of(context).pop();
                  },
                  child: Text("Save", style: GoogleFonts.lato(color: Colors.redAccent)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  // This function is required to validate the user entered number
  String? validateAndNormalizeIndianPhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    // If starts with 91 and total length is 12 (e.g. 918830905960)
    if (digitsOnly.startsWith('91') && digitsOnly.length == 12) {
      return digitsOnly.substring(2); // return only 10-digit number
    }

    // If exactly 10 digits
    if (digitsOnly.length == 10) {
      return digitsOnly;
    }

    return null; // Invalid input
  }


  // It builds the contact list by fetching all the contacts form the database
  Widget _buildContactsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: const Icon(Icons.person, color: Colors.redAccent, size: 28),
            title: Text(
              contact['name'],
              style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
            ),
            subtitle: Text(
              contact['phone'],
              style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => _showEditDialog(context, contact),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white70),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        backgroundColor: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text('Delete Contact?', style: GoogleFonts.lato(fontSize: 18, color: Colors.white)),
                        content: Text('Are you sure you want to delete ${contact['name']}?', style: GoogleFonts.lato(fontSize: 14, color: Colors.white70)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c, false), child: Text('Cancel', style: GoogleFonts.lato(color: Colors.white70))),
                          TextButton(onPressed: () => Navigator.pop(c, true), child: Text('Delete', style: GoogleFonts.lato(color: Colors.redAccent))),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await DatabaseHelper().deleteContact(contact['id']);
                      await _loadContacts();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // This dialog allows the user to edit the contacts
  void _showEditDialog(BuildContext context, Map<String, dynamic> contact) {
    final nameController = TextEditingController(text: contact['name']);
    final phoneController = TextEditingController(text: contact['phone']);
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Edit Contact',
            style: GoogleFonts.lato(fontSize: 18, color: Colors.redAccent),
          ),
          content: SizedBox(
            width: screenWidth * 0.6,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: GoogleFonts.lato(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () async {
                String newName = nameController.text.trim();
                String newPhone = phoneController.text.trim();

                if (newName.isEmpty || newPhone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Name and phone cannot be empty."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                // Normalize the phone number
                String? normalizedPhone = validateAndNormalizeIndianPhone(newPhone);

                // Check if normalization failed
                if (normalizedPhone == null || normalizedPhone.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phone number must be a valid 10-digit Indian number."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                // Check for duplicates (excluding current ID)
                final db = await DatabaseHelper().database;
                final duplicate = await db.query(
                  'contacts',
                  where: 'phone = ? AND id != ?',
                  whereArgs: [normalizedPhone, contact['id']],
                );

                if (duplicate.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("This phone number already exists."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                // All good – update contact
                await DatabaseHelper().updateContact(
                  contact['id'],
                  newName,
                  normalizedPhone,
                );

                await _loadContacts();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: GoogleFonts.lato(color: Colors.redAccent)),
            )
          ],
        );
      },
    );
  }


  // This function allows users to select contacts from their contact list (contacts saved on their phones)
  Future<void> _pickContact() async {
    final picker = FlutterNativeContactPicker();

    try {
      Contact? contact = await picker.selectPhoneNumber();

      if (contact != null) {
        final name = contact.fullName?.trim() ?? 'Unknown';
        final rawPhone = contact.selectedPhoneNumber?.trim();

        if (rawPhone == null || rawPhone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Selected contact has no phone number."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        final normalizedPhone = validateAndNormalizeIndianPhone(rawPhone);

        if (normalizedPhone == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid number. Only Indian 10-digit numbers are allowed."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        // Check for duplicates
        final db = await DatabaseHelper().database;
        final existing = await db.query(
          'contacts',
          where: 'phone = ?',
          whereArgs: [normalizedPhone],
        );

        if (existing.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This contact already exists."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        // Save contact
        await DatabaseHelper().insertContact(name, normalizedPhone);
        await _loadContacts();
      }
    } catch (e) {
      debugPrint('Contact pick failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to pick contact."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


}
