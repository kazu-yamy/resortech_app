import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final resultProvider = StateProvider<String>((ref) => "---");
final percentProvider = StateProvider<String>((ref) => "---");