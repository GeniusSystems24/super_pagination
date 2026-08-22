import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_pagination/super_pagination.dart';

/// Runnable example for SuperPaginationCubit.setRequest.
///
/// The datasource stays fixed. Runtime filters are carried by the request and
/// replaced with [SuperPaginationCubit.setRequest].
class V5SetRequestScreen extends StatefulWidget {
  const V5SetRequestScreen({super.key});

  @override
  State<V5SetRequestScreen> createState() => _V5SetRequestScreenState();
}

class _V5SetRequestScreenState extends State<V5SetRequestScreen> {
  late final SuperPaginationCubit<int, SuperPaginationRequest> _cubit;
  var _showEven = false;

  late final SuperPaginationProvider<int, SuperPaginationRequest> _source =
      SuperPaginationProvider.pageFuture((context, request) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    final showEven = request.filters?['parity'] == 'even';
    final pageSize = request.pageSize ?? 10;
    const totalPages = 5;
    final start = (request.page - 1) * pageSize;

    return PagePaginationResult<int>(
      pageNumber: request.page,
      totalPages: totalPages,
      items: [
        for (var i = 0; i < pageSize; i++)
          start * 2 + i * 2 + (showEven ? 2 : 1),
      ],
      hasMore: request.page < totalPages,
    );
  });

  SuperPaginationRequest _requestFor(bool showEven) => SuperPaginationRequest(
        pageSize: 10,
        filters: <String, dynamic>{
          'parity': showEven ? 'even' : 'odd',
        },
      );

  @override
  void initState() {
    super.initState();
    _cubit = SuperPaginationCubit<int, SuperPaginationRequest>(
      request: _requestFor(_showEven),
      provider: _source,
    )..fetchPaginatedList();
  }

  @override
  void dispose() {
    _cubit.dispose();
    _cubit.close();
    super.dispose();
  }

  void _switchRequest() {
    setState(() => _showEven = !_showEven);
    _cubit.setRequest(_requestFor(_showEven));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('v5 · setRequest')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _switchRequest,
        icon: const Icon(Icons.tune_rounded),
        label: Text(_showEven ? 'Show odd request' : 'Show even request'),
      ),
      body: BlocBuilder<SuperPaginationCubit<int, SuperPaginationRequest>,
          SuperPaginationState<int>>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is SuperPaginationInitial<int>) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SuperPaginationError<int>) {
            return Center(child: Text(state.error.toString()));
          }

          final loaded = state as SuperPaginationLoaded<int>;
          final parity = _cubit.currentRequest.filters?['parity'] ?? 'odd';

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Active request: parity=$parity · '
                  'pageSize=${_cubit.currentRequest.pageSize}',
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      loaded.items.length + (loaded.hasReachedEnd ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index == loaded.items.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilledButton(
                          onPressed: _cubit.fetchPaginatedList,
                          child: const Text('Load next page'),
                        ),
                      );
                    }
                    return ListTile(
                      title: Text('Value ${loaded.items[index]}'),
                      subtitle: Text('Request parity: $parity'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
