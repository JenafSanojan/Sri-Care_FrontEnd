class CommonError {
  final String? message;

  CommonError({
    this.message,
  });

  /// Converts a User instance to a JSON-compatible Map (for APIs, etc).
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  /// Creates a User instance from a Json.
  factory CommonError.fromJson(Map<String, dynamic> map) {
    return CommonError(
      message: map['message'] as String?,
    );
  }

  @override
  String toString() {
    return 'Error(message: $message)';
  }
}