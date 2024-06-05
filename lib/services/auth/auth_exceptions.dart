//login exception
class UserNotFoundAuthException implements Exception {}

class WrongPassAuthException implements Exception {}

//register exception
class WeakPassAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exception
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
