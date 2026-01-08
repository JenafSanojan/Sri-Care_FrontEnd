class GlobalAuthData {
    static final GlobalAuthData _instance = GlobalAuthData._internal();

    late String userId;
    late String userName;

    static bool _initialized = false;

    static bool get isInitialized => _initialized;

    factory GlobalAuthData.initialize(String userId, String userName, String companyId) {
        if (_initialized) {
            throw Exception("GlobalAuthData has already been initialized");
        }
        _instance._init(userId, userName, companyId);
        _initialized = true;
        return _instance;
    }

    GlobalAuthData._internal();

    void _init(String userId, String userName, String companyId) {
        this.userId = userId;
        this.userName = userName;
    }

    static GlobalAuthData get instance {
        if (!_initialized) {
            throw Exception("GlobalAuthData is not initialized");
        }
        return _instance;
    }
}

class NetworkConfigs {
    static const bool isDevMode = false;
    static const String apiLiveUrl = "http://localhost:5000";
    static const String apiLocalUrl = "https://api-gateway-ysfa.onrender.com";
    static const int timeoutDuration = 30;

    static const Map<String, String> defaultHeaders = {
        "Content-Type": "application/json",
        "Accept": "application/json",
    };

    static String getBaseUrl() {
        if(isDevMode) {
          return apiLiveUrl;
        }
        else {
          return apiLocalUrl;
        }
  }
}