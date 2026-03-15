import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';

class StoreSetupScreen extends StatefulWidget {
  final String? storeId;
  const StoreSetupScreen({super.key, this.storeId});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final List<String> _allTags = ['Handmade', 'Sustainable', 'Vintage', 'African Print'];
  final Set<String> _selectedTags = {'Handmade'};

  XFile? _bannerImage;
  XFile? _avatarImage;
  String? _existingBannerUrl;
  String? _existingAvatarUrl;
  
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedLocation;
  bool _isSaving = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.storeId != null) {
      _loadStoreData();
    }
  }

  Future<void> _loadStoreData() async {
    setState(() => _isLoading = true);
    try {
      final market = context.read<MarketProvider>();
      final data = await market.getStoreInfo(widget.storeId!);
      if (data != null && mounted) {
        _nameController.text = data['name'] ?? '';
        _descController.text = data['description'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _selectedLocation = data['location'] as String?;
        _existingBannerUrl = data['banner'] as String?;
        _existingAvatarUrl = data['image'] as String?;
        
        final tags = data['tags'] as List?;
        if (tags != null) {
          _selectedTags.clear();
          _selectedTags.addAll(tags.map((t) => t.toString()));
        }
      }
    } catch (e) {
      debugPrint('Error loading store: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(bool isBanner) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isBanner) {
          _bannerImage = image;
        } else {
          _avatarImage = image;
        }
      });
    }
  }

  Future<void> _saveStore() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter store name')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final market = context.read<MarketProvider>();
      
      String? bannerUrl = _existingBannerUrl;
      String? avatarUrl = _existingAvatarUrl;

      if (_bannerImage != null) {
        bannerUrl = await market.uploadStoreImage(_bannerImage!, 'banner');
      }
      if (_avatarImage != null) {
        avatarUrl = await market.uploadStoreImage(_avatarImage!, 'avatar');
      }

      final storeData = {
        'name': _nameController.text,
        'description': _descController.text,
        'phoneNumber': _phoneController.text,
        'banner': bannerUrl,
        'image': avatarUrl ?? bannerUrl,
        'tags': _selectedTags.toList(),
      };

      if (widget.storeId != null) {
        await market.updateStore(widget.storeId!, storeData);
      } else {
        await market.createStore(storeData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.storeId != null ? 'Store updated successfully! ✅' : 'Store created successfully! ✅'), 
            backgroundColor: AppColors.primary
          )
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: AppColors.backgroundDark, body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1)))),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => context.pop()),
              Expanded(child: Text(widget.storeId != null ? 'Edit Store' : 'Store Setup', textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(width: 48),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Banner
                GestureDetector(
                  onTap: () => _pickImage(true),
                  child: Container(
                    height: 180, width: double.infinity,
                    decoration: BoxDecoration(
                      image: (_bannerImage != null || _existingBannerUrl != null)
                          ? DecorationImage(
                              image: _bannerImage != null 
                                ? (kIsWeb ? NetworkImage(_bannerImage!.path) : FileImage(File(_bannerImage!.path)) as ImageProvider)
                                : NetworkImage(_existingBannerUrl!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAEwZArksvSjPKtRBZ8g82CbdrfW9fsIoX35ZItzHRPBCfpuFhvITc7LvxUxA1sPKscV8--Naa0sBbdZxpfVSxwUlC04xII9yDDk-CEJSSPLVg_m5b4K4abeyB3scZYnlLVLBsQF0zOhR95GnpWmkqVdEj0FNfdc84eicr1k6fc-0Yv5xUWMCoDL3SqfxsV5CKVdYShdVY4f2cWE2u-qhEERbVPpZAiDr9IZU8ZAqi1W-x3hiTu33KK6Ef9wKUuTq-ZHRURIi8r644Z'),
                              fit: BoxFit.cover,
                            ),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.add_a_photo, color: AppColors.primary, size: 36),
                        const SizedBox(height: 6),
                        Text(widget.storeId != null ? 'Update Banner' : 'Upload Store Banner', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Recommended: 1600 x 400px', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                      ]),
                    ),
                  ),
                ),
                // Avatar
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Center(child: GestureDetector(
                    onTap: () => _pickImage(false),
                    child: Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B), shape: BoxShape.circle,
                        border: Border.all(color: AppColors.backgroundDark, width: 4),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
                        image: (_avatarImage != null || _existingAvatarUrl != null)
                            ? DecorationImage(
                                image: _avatarImage != null
                                    ? (kIsWeb ? NetworkImage(_avatarImage!.path) : FileImage(File(_avatarImage!.path)) as ImageProvider)
                                    : NetworkImage(_existingAvatarUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: (_avatarImage == null && _existingAvatarUrl == null) ? const Icon(Icons.storefront, color: AppColors.primary, size: 36) : null,
                    ),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.storeId != null ? 'Edit Your Brand' : 'Create Your Fashion Hub', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Set up your brand presence in the heart of Uganda.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                    const SizedBox(height: 24),
                    // Store name
                    const Text('Store Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'e.g. Kampala Chic Boutique', contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    const Text('Store Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      decoration: const InputDecoration(hintText: 'Tell customers about your style and unique pieces...', contentPadding: EdgeInsets.all(16)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    // Phone number
                    const Text('WhatsApp / Phone Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: 'e.g. +256 700 000 000', contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    // Tags
                    const Text('Store Tags', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      ..._allTags.map((tag) {
                        final sel = _selectedTags.contains(tag);
                        return GestureDetector(
                          onTap: () => setState(() => sel ? _selectedTags.remove(tag) : _selectedTags.add(tag)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.primary.withOpacity(0.2) : AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: sel ? AppColors.primary.withOpacity(0.3) : Colors.transparent),
                            ),
                            child: Text(tag, style: TextStyle(color: sel ? AppColors.primary : const Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
                          ),
                        );
                      }),
                    ]),
                    const SizedBox(height: 32),
                    // Buttons
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveStore,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: _isSaving ? Colors.grey : AppColors.primary,
                        ),
                        child: _isSaving 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(widget.storeId != null ? 'Update Store' : 'Complete Setup', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity, height: 50,
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500, fontSize: 15)),
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
