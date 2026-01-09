import 'package:sri_tel_flutter_web_mob/entities/user.dart';

class GlobalAuthData {
    static final GlobalAuthData _instance = GlobalAuthData._internal();

    // private fields
    late User _user;
    static bool _initialized = false;

    static bool get isInitialized => _initialized;
    User get user => _user;

    factory GlobalAuthData.initialize(User user) {
        if (_initialized) {
            throw Exception("GlobalAuthData has already been initialized");
        }
        _instance._init(user);
        _initialized = true;
        return _instance;
    }
    GlobalAuthData._internal();
    void _init(User user) {
        _user = user;
    }
    static GlobalAuthData get instance {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        return _instance;
    }
}

class NetworkConfigs {
    static const bool isDevMode = true;
    static const String apiLocalUrl = "http://localhost:5000";
    static const String apiLiveUrl = "https://api-gateway-ysfa.onrender.com";
    static const int timeoutDuration = 30;

    static final Map<String, String> defaultHeaders = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": GlobalAuthData.isInitialized ? "Bearer ${GlobalAuthData.instance._user.token}" : "",
    };

    static String getBaseUrl() {
        if(isDevMode) {
          return apiLocalUrl;
        }
        else {
          return apiLiveUrl;
        }
  }
}