class AppStrings {
  const AppStrings._();

  static const String appName = 'E-Ticketing Helpdesk';
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String forgotPassword = 'Lupa Password';
  static const String forgotPasswordHint =
      'Masukkan email atau username untuk mereset password.';
  static const String forgotPasswordSuccess =
      'Instruksi reset password telah dikirim ke email Anda.';
  static const String forgotPasswordNotFound =
      'Email atau username tidak ditemukan.';
  static const String resetPassword = 'Reset Password';
  static const String sendResetLink = 'Kirim Tautan Reset';
}

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String shell = '/shell';
  static const String dashboard = '/dashboard';
  static const String ticketList = '/tickets';
  static const String ticketDetail = '/tickets/detail';
  static const String createTicket = '/tickets/create';
  static const String notification = '/notifications';
  static const String profile = '/profile';
}
