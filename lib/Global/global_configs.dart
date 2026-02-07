import 'package:sri_tel_flutter_web_mob/entities/user.dart';

class GlobalAuthConfigs {
    static final GlobalAuthConfigs _instance = GlobalAuthConfigs._internal();

    // private fields
    User? _user;
    static bool _initialized = false;

    static bool get isInitialized => _initialized;
    User get user => _initialized ? _user! : throw Exception("GlobalAuthData is not initialized");

    factory GlobalAuthConfigs.initialize(User user) {
        if (_initialized) {
            throw Exception("GlobalAuthData has already been initialized");
        }
        _instance._init(user);
        _initialized = true;
        return _instance;
    }
    factory GlobalAuthConfigs.clear() {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        _instance._erase();
        _initialized = false;
        return _instance;
    }
    GlobalAuthConfigs._internal();
    void _init(User user) {
        _user = user;
    }
    void _erase() {
        _user = null;
    }
    static GlobalAuthConfigs get instance {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        return _instance;
    }
}

class NetworkConfigs {
    // no setters, only getters
    static const bool isDevMode = true;
    static const String apiLocalUrl = "http://localhost:5000";
    static const String apiLiveUrl = "https://api-gateway-ysfa.onrender.com"; // not-working, giving errors of too many requests, when services call each other
    static const int timeoutDuration = 30;

    static Map<String, String> getHeaders () => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "x-user-id": GlobalAuthConfigs.isInitialized ? "${GlobalAuthConfigs.instance.user.uid}" : "",
        "Authorization": GlobalAuthConfigs.isInitialized ? "Bearer ${GlobalAuthConfigs.instance.user.token}" : "",
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

class InterfaceConfigs {
    static final InterfaceConfigs _instance = InterfaceConfigs._internal();

    // private fields
    static bool? _isAgent; // to decide how the chat screen should be shown
    static bool _initialized = false;

    static bool get isAgent => _initialized ? _isAgent! : throw Exception("InterfaceConfigs is not initialized");
    static bool get isInitialized => _initialized;

    factory InterfaceConfigs.initialize(User user) {
        if (_initialized) {
            throw Exception("GlobalAuthData has already been initialized");
        }
        _instance._init(user);
        _initialized = true;
        return _instance;
    }
    factory InterfaceConfigs.clear() {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        _instance._erase();
        _initialized = false;
        return _instance;
    }
    InterfaceConfigs._internal();
    void _init(User user) {
        _isAgent = user.email.endsWith("agent@sritel.com");
    }
    void _erase() {
        _isAgent = null;
    }
    static InterfaceConfigs get instance {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        return _instance;
    }

}