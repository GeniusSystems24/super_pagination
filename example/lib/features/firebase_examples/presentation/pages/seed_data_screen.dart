// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'package:super_pagination_example/app/dependencies/example_dependencies.dart';
import 'package:super_pagination_example/features/firebase_examples/presentation/controllers/seed_data_controller.dart';

/// Screen to manage Firebase seed data
class SeedDataScreen extends StatefulWidget {
  const SeedDataScreen({super.key});

  @override
  State<SeedDataScreen> createState() => _SeedDataScreenState();
}

class _SeedDataScreenState extends State<SeedDataScreen> {
  late final SeedDataController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SeedDataController(ExampleDependencies.seedData)
      ..addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _runOperation(
    Future<SeedOperationResult> Function() operation,
  ) async {
    final result = await operation();
    if (!mounted) return;
    _showSnackBar(
      result.message,
      result.isSuccess ? Colors.green : Colors.red,
    );
  }

  Future<void> _seedAllData() => _runOperation(_controller.seedAllData);
  Future<void> _seedProducts() => _runOperation(_controller.seedProducts);
  Future<void> _seedUsers() => _runOperation(_controller.seedUsers);
  Future<void> _seedMessages() => _runOperation(_controller.seedMessages);
  Future<void> _seedPosts() => _runOperation(_controller.seedPosts);

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all seeded data from Firebase. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _runOperation(_controller.clearAllData);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Data Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                Icon(Icons.storage, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Seed demo data for Firebase examples',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Seed All button
                  _buildMainActionCard(
                    title: 'Seed All Data',
                    subtitle:
                        'Populate all Firebase collections with demo data',
                    icon: Icons.cloud_upload,
                    color: Colors.green,
                    // onPressed: _controller.isLoading ? null : _seedAllData,
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Individual Collections',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Individual seed buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSeedChip(
                        label: 'Products (75)',
                        icon: Icons.shopping_bag,
                        color: Colors.purple,
                        // onPressed: _controller.isLoading ? null : _seedProducts,
                      ),
                      _buildSeedChip(
                        label: 'Users (30)',
                        icon: Icons.people,
                        color: Colors.blue,
                        // onPressed: _controller.isLoading ? null : _seedUsers,
                      ),
                      _buildSeedChip(
                        label: 'Messages (20)',
                        icon: Icons.chat,
                        color: Colors.teal,
                        // onPressed: _controller.isLoading ? null : _seedMessages,
                      ),
                      _buildSeedChip(
                        label: 'Posts (20)',
                        icon: Icons.article,
                        color: Colors.orange,
                        // onPressed: _controller.isLoading ? null : _seedPosts,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Clear data button
                  _buildMainActionCard(
                    title: 'Clear All Data',
                    subtitle: 'Remove all seeded data from Firebase',
                    icon: Icons.delete_forever,
                    color: Colors.red,
                    // onPressed: _controller.isLoading ? null : _clearAllData,
                  ),

                  const SizedBox(height: 24),

                  // Collection Info
                  _buildCollectionInfoCard(),

                  const SizedBox(height: 24),

                  // Logs section
                  if (_controller.logs.isNotEmpty) ...[
                    Row(
                      children: [
                        const Text(
                          'Activity Log',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _controller.clearLogs(),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _controller.logs.length,
                        itemBuilder: (context, index) {
                          final log = _controller.logs[index];
                          Color textColor = Colors.white70;
                          if (log.contains('✅')) textColor = Colors.green;
                          if (log.contains('❌')) textColor = Colors.red;

                          return Text(
                            log,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: textColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Loading indicator
          if (_controller.isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(_controller.currentAction ?? 'Processing...'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: onPressed == null ? Colors.grey : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeedChip({
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildCollectionInfoCard() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, size: 20),
                SizedBox(width: 8),
                Text(
                  'Data Collections',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCollectionRow(
              'products',
              'Firestore',
              'Used by: Pagination, Filters, Offline',
            ),
            _buildCollectionRow('users', 'Firestore', 'Used by: Search'),
            _buildCollectionRow('messages', 'Firestore', 'Used by: Realtime'),
            _buildCollectionRow('posts', 'RTDB', 'Used by: Realtime Database'),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionRow(String name, String type, String usage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: type == 'Firestore'
                  ? Colors.orange.shade100
                  : Colors.amber.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 10,
                color: type == 'Firestore'
                    ? Colors.orange.shade800
                    : Colors.amber.shade800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              usage,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seed Data Manager'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This tool helps you populate Firebase with demo data:'),
            SizedBox(height: 12),
            Text('• Products: 75 items across 5 categories'),
            Text('• Users: 30 team members'),
            Text('• Messages: 20 chat messages'),
            Text('• Posts: 20 social media posts'),
            SizedBox(height: 12),
            Text(
              'The data is used by various Firebase example screens '
              'to demonstrate pagination, filtering, search, and real-time updates.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
