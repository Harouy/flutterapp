import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/Language.dart';

final translationProvider =
    StateNotifierProvider<TranslationModel, String>((ref) {
  return TranslationModel();
});
  
   // Default language is English