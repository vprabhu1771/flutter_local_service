class Constants {

  static const String SERVER_DOMAIN = "http://192.168.1.211:8000";

  static const String BASE_URL = SERVER_DOMAIN + "/api";

  static const String LOGIN_ROUTE = "/login";

  static const String LOGOUT_ROUTE = "/logout";

  static const String USER_ROUTE = "/user";

  static const String USER_REGISTER_ROUTE = "/register";

  static const String USER_PROFILE_PIC_UPLOAD_ROUTE = "/upload profile pic";

  static const String IMAGE_ERROR_ROUTE = SERVER_DOMAIN + "/storage";

  static const String NOTIFICATION_ROUTE = '/notifications';

  static const String CATEGORY_ROUTE = '/categories';

  static const String SERVICES_ROUTE = '/services?category_id=';

  static const String SETTINGS_ROUTE = '/settings';

  static const String FILTER_BY_SERVICE = '/services/filter?service_id=';

  static const String SUBMIT_BOOKING_ROUTE = '/submit-appointment';

  static const String SUBMIT_FEEDBACK_ROUTE = "/submit-feedback";
}