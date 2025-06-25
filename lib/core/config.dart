import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isupply_app/features/home/data/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/home/data/models/product.dart';
import '../features/home/presentation/controllers/home_controller.dart';

const int customersCacheTimeIntervalInHours = 48;
final Faker faker = Faker.instance;
late final String supabaseUrl;
late final String supabaseAnonKey;
late Box<Product> productsBox;
final supabase = Supabase.instance.client;

Future<void> init() async {
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");
  supabaseUrl = dotenv.env['SUPABASE_URL']!;
  supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  Get.put(HomeController());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ProductAdapter());
  productsBox = await Hive.openBox<Product>('products');
  productsBox.clear();
}
