abstract interface class SeedDataGateway {
  Future<void> seedAllData({void Function(String message)? onProgress});

  Future<void> seedProducts({void Function(String message)? onProgress});

  Future<void> seedUsers({void Function(String message)? onProgress});

  Future<void> seedMessages({void Function(String message)? onProgress});

  Future<void> seedPosts({void Function(String message)? onProgress});

  Future<void> clearAllData({void Function(String message)? onProgress});
}
