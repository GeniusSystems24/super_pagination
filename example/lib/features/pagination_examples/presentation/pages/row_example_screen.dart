import 'package:flutter/material.dart';
import 'package:super_pagination/super_pagination.dart';
import 'package:super_pagination_example/shared/domain/entities/product.dart';
import 'package:super_pagination_example/shared/presentation/widgets/product_card.dart';
import 'package:super_pagination_example/app/dependencies/example_dependencies.dart';

class RowExampleScreen extends StatefulWidget {
  const RowExampleScreen({super.key});

  @override
  State<RowExampleScreen> createState() => _RowExampleScreenState();
}

class _RowExampleScreenState extends State<RowExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row Layout (Non-scrollable)')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader('Featured Products Row'),
                  const SizedBox(height: 8),
                  const Text(
                    'This section uses SuperPagination.row inside a horizontal SingleChildScrollView. '
                    'SuperPagination.row itself is not scrollable.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Horizontal Scroll View containing SuperPagination.row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  SuperPagination<Product, SuperPaginationRequest>.rowWithProvider(
                request: const SuperPaginationRequest(page: 1, pageSize: 5),
                provider: SuperPaginationProvider.future(
                  (request) => ExampleDependencies.catalog.fetchProducts(request),
                ),
                itemBuilder: (context, items, index) {
                  return SizedBox(
                    width: 200,
                    child: ProductCard(product: items[index]),
                  );
                },
                separator: const SizedBox(width: 12),
                // Custom loading builder
                firstPageLoadingBuilder: (context) => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildHeader('More Content Below'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
