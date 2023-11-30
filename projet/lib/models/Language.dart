import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TranslationModel extends StateNotifier<String> {
  TranslationModel() : super('fr');
  String _currentLanguage = 'fr'; // Default language

  Map<String, Map<String, String>> _translations = {
    'fr': {
      'hello': 'Bienvenue',
      'hello2': 'Bienvenue à',
      'start': 'Commencer',
      'calcul': "Calculez votre impôt à travers",
      'simulateur': "ce simulateur d'impôt",
      "choice": "Choisir l'impôt que vous voulez",
      "confirm": "Confirmer",
      "priceaqu": "Prix d'acquisiton",
      "depense": "Dépense d'investissement",
      "montant": "Montant des intéréts",
      "prix": "Prix de cession",
      "année": "Année d'aquisition",
      "impot1": "Taxe prix foncier",
      "impot2": "Taxe habitation",
      "impot3": "Taxe service commune",
      "traduction":
          "Ce montant est une valeur approximative, veuillez se référer à l’administration officielle (Ministère de la finance) pour avoir la valeur exacte.",
      "a": "à",
      "chehal": "Chehal Dariba",
      "votre": "Votre impôt est:",
      "valeuLocatAnuu": "Valeur locative annuelle",
      "typeHibation": "type habitation",
      "p": "Principale",
      "s": "Secondaire",
      "typeh": "Type d'habitation",
      "impottsc": "Taxe de services communaux",
      "CU": "communes urbaines",
      "CD": "centre délimité",
      "SE": "station estival hivernal thermal",
      "ZP": "zones périphériques",
      "zone": "Zone habitation"
      // Add more translations
    },
    'ar': {
      'hello': 'مرحبا',
      'hello2': "مرحبا إلى",
      'start': 'ابدأ',
      'calcul': 'احسب ضريبتك عبر',
      'simulateur': 'محاكي الضرائب',
      'choice': 'اختر الضريبة التي تناسبك',
      'confirm': "تأكيد",
      "priceaqu": "ثمن الشراء",
      "depense": "نفقات الاستثمار",
      "montant": "مبلغ الفوائد",
      "prix": "ثمن المبيع",
      "année": "سنة الشراء",
      "impot1": "ضريبة أرباح العقار",
      "impot2": "ضريبة السكن",
      "impot3": "ضريبة الخدمات البلدية",
      "traduction":
          "هذا المبلغ هو قيمة تقريبية، يرجى مراجعة الإدارة الرسمية (وزارة المالية) لمعرفة القيمة الدقيقة",
      "a": "في",
      "chehal": "شحال الضريبة",
      "votre": ":ضريبتكم هي",
      "valeuLocatAnuu": "قيمة الإيجار السنوي",
      "typeHibation": "نوع المسكن",
      "p": "رئيسي",
      "s": "ثانوي",
      "typeh": "نوع المسكن",
      "impottsc": "ضريبة الخدمات البلدية",
      "CU": "المجتمعات الحضرية",
      "CD": "مركز محدد",
      "SE": "المنتجع الحراري الصيفي الشتوي",
      "ZP": "المناطق الطرفية",
      "zone": "منطقة السكن"
      // Add more translations
    },
    // Add more languages
  };

  String translate(String key) {
    return _translations[_currentLanguage]![key] ?? key;
  }

  void changeLanguage(String languageCode) {
    state = languageCode;
    _currentLanguage = languageCode;
  }

  static const List<String> supportedLanguages = ['ar', 'fr'];
}
