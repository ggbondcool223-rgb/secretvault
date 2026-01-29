import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:secret_vault/pages/sv_calculator_sound/sv_calculator_sound_rule.dart';
import 'package:secret_vault/pages/sv_password_create/sv_password_create_binding.dart';
import 'package:secret_vault/pages/sv_password_create/sv_password_create_view.dart';
import 'package:secret_vault/pages/sv_tab/sv_tab_binding.dart';
import 'package:secret_vault/pages/sv_tab/sv_tab_view.dart';
import 'package:secret_vault/pages/sv_calculator/sv_calculator_binding.dart';
import 'package:secret_vault/pages/sv_calculator/sv_calculator_view.dart';
import 'package:secret_vault/pages/sv_calculator_history/sv_calculator_history_binding.dart';
import 'package:secret_vault/pages/sv_calculator_history/sv_calculator_history_view.dart';
import 'package:secret_vault/pages/sv_calculator_decimal/sv_calculator_decimal_binding.dart';
import 'package:secret_vault/pages/sv_calculator_decimal/sv_calculator_decimal_view.dart';
import 'package:secret_vault/pages/sv_calculator_sound/sv_calculator_sound_binding.dart';
import 'package:secret_vault/pages/sv_calculator_sound/sv_calculator_sound_view.dart';
import 'package:secret_vault/pages/sv_privacy/sv_privacy_binding.dart';
import 'package:secret_vault/pages/sv_privacy/sv_privacy_view.dart';
import 'package:secret_vault/pages/sv_privacy_set_password/sv_privacy_set_password_binding.dart';
import 'package:secret_vault/pages/sv_privacy_set_password/sv_privacy_set_password_view.dart';
import 'package:secret_vault/pages/sv_privacy_album/sv_privacy_album_binding.dart';
import 'package:secret_vault/pages/sv_privacy_album/sv_privacy_album_view.dart';
import 'package:secret_vault/pages/sv_privacy_album_detail/sv_privacy_album_detail_binding.dart';
import 'package:secret_vault/pages/sv_privacy_album_detail/sv_privacy_album_detail_view.dart';
import 'package:secret_vault/pages/sv_privacy_notes/sv_privacy_notes_binding.dart';
import 'package:secret_vault/pages/sv_privacy_notes/sv_privacy_notes_view.dart';
import 'package:secret_vault/pages/sv_privacy_note_detail/sv_privacy_note_detail_binding.dart';
import 'package:secret_vault/pages/sv_privacy_note_detail/sv_privacy_note_detail_view.dart';
import 'package:secret_vault/pages/sv_settings/sv_settings_binding.dart';
import 'package:secret_vault/pages/sv_settings/sv_settings_view.dart';
import 'package:secret_vault/pages/sv_settings_reset_password/sv_settings_reset_password_binding.dart';
import 'package:secret_vault/pages/sv_settings_reset_password/sv_settings_reset_password_view.dart';
import 'package:secret_vault/pages/sv_privacy_note_template/sv_privacy_note_template_binding.dart';
import 'package:secret_vault/pages/sv_privacy_note_template/sv_privacy_note_template_view.dart';
import 'package:secret_vault/pages/sv_settings_emergency/sv_settings_emergency_binding.dart';
import 'package:secret_vault/pages/sv_settings_emergency/sv_settings_emergency_view.dart';
import 'package:secret_vault/pages/sv_privacy_setup_security/sv_privacy_setup_security_binding.dart';
import 'package:secret_vault/pages/sv_privacy_setup_security/sv_privacy_setup_security_view.dart';
import 'package:secret_vault/pages/sv_privacy_recover_password/sv_privacy_recover_password_binding.dart';
import 'package:secret_vault/pages/sv_privacy_recover_password/sv_privacy_recover_password_view.dart';
import 'package:secret_vault/db_sv/data.dart';
import 'package:secret_vault/utils/sound_service.dart';
import 'package:secret_vault/utils/user_preferences.dart';



Color primaryColor = const Color(0xFFF39C12);
Color bgColor = const Color(0xFF17181A);
Color surfaceColor = const Color(0xFF2C2E33);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  await UserPreferences.init();


  await Get.putAsync(() => DatabaseService().init());


  Get.put(SoundService());

  runApp(const MyApp());
}

List<GetPage<dynamic>> Cloud = [
  GetPage(
    name: '/',
    page: () => const SvPasswordCreateView(),
    binding: SvPasswordCreateBinding(),
  ),
  GetPage(
    name: '/tab',
    page: () => const SvTabView(),
    binding: SvTabBinding(),
  ),
  GetPage(
    name: '/calculator',
    page: () => const SvCalculatorView(),
    binding: SvCalculatorBinding(),
  ),
  GetPage(
    name: '/calculator/history',
    page: () => const SvCalculatorHistoryView(),
    binding: SvCalculatorHistoryBinding(),
  ),
  GetPage(
    name: '/calculator/decimal',
    page: () => const SvCalculatorDecimalView(),
    binding: SvCalculatorDecimalBinding(),
  ),
  GetPage(
    name: '/calculator/sound',
    page: () => const SvCalculatorSoundView(),
    binding: SvCalculatorSoundBinding(),
  ),
  GetPage(
    name: '/soundrule',
    page: () => const SvCalculatorSoundRule(),
  ),
  GetPage(
    name: '/privacy',
    page: () => const SvPrivacyView(),
    binding: SvPrivacyBinding(),
  ),
  GetPage(
    name: '/privacy/set_password',
    page: () => const SvPrivacySetPasswordView(),
    binding: SvPrivacySetPasswordBinding(),
  ),
  GetPage(
    name: '/privacy/album',
    page: () => const SvPrivacyAlbumView(),
    binding: SvPrivacyAlbumBinding(),
  ),
  GetPage(
    name: '/privacy/album/detail',
    page: () => const SvPrivacyAlbumDetailView(),
    binding: SvPrivacyAlbumDetailBinding(),
  ),
  GetPage(
    name: '/privacy/notes',
    page: () => const SvPrivacyNotesView(),
    binding: SvPrivacyNotesBinding(),
  ),
  GetPage(
    name: '/privacy/notes/detail',
    page: () => const SvPrivacyNoteDetailView(),
    binding: SvPrivacyNoteDetailBinding(),
  ),
  GetPage(
    name: '/settings',
    page: () => const SvSettingsView(),
    binding: SvSettingsBinding(),
  ),
  GetPage(
    name: '/settings/reset_password',
    page: () => const SvSettingsResetPasswordView(),
    binding: SvSettingsResetPasswordBinding(),
  ),
  GetPage(
    name: '/privacy/note_template',
    page: () => const SvPrivacyNoteTemplateView(),
    binding: SvPrivacyNoteTemplateBinding(),
  ),
  GetPage(
    name: '/settings/emergency',
    page: () => const SvSettingsEmergencyView(),
    binding: SvSettingsEmergencyBinding(),
  ),
  GetPage(
    name: '/privacy/setup_security_questions',
    page: () => const SvPrivacySetupSecurityView(),
    binding: SvPrivacySetupSecurityBinding(),
  ),
  GetPage(
    name: '/privacy/recover_password',
    page: () => const SvPrivacyRecoverPasswordView(),
    binding: SvPrivacyRecoverPasswordBinding(),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Cloud,
          initialRoute: '/',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              surface: surfaceColor,
              onSurface: const Color(0xFFECF0F1),
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              backgroundColor: surfaceColor,
              iconTheme: IconThemeData(size: 24, color: Colors.white),
              shadowColor: Colors.white.withValues(alpha: 0.12),
              toolbarHeight: 52,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: primaryColor,
              unselectedItemColor: const Color(0xFF7F8C8D),
              elevation: 0,
              backgroundColor: bgColor,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFF2C2E33),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            dividerTheme: const DividerThemeData(
              thickness: 1,
              color: Colors.white10,
            ),
          ),
        );
      },
    );
  }
}
