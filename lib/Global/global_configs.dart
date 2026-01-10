import 'package:sri_tel_flutter_web_mob/entities/user.dart';

class GlobalAuthData {
    static final GlobalAuthData _instance = GlobalAuthData._internal();

    // private fields
    User? _user;
    static bool _initialized = false;

    static bool get isInitialized => _initialized;
    User get user => _initialized ? _user! : throw Exception("GlobalAuthData is not initialized");

    factory GlobalAuthData.initialize(User user) {
        if (_initialized) {
            throw Exception("GlobalAuthData has already been initialized");
        }
        _instance._init(user);
        _initialized = true;
        return _instance;
    }
    factory GlobalAuthData.clear() {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        _instance._erase();
        _initialized = false;
        return _instance;
    }
    GlobalAuthData._internal();
    void _init(User user) {
        _user = user;
    }
    void _erase() {
        _user = null;
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

    static Map<String, String> getHeaders () => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "x-user-id": GlobalAuthData.isInitialized ? "${GlobalAuthData.instance.user.uid}" : "",
        "Authorization": GlobalAuthData.isInitialized ? "Bearer ${GlobalAuthData.instance.user.token}" : "",
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