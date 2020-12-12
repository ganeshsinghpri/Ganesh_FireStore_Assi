abstract class AuthImplementation {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<void> signOut();
  Future<String> getCurrentUserId();
  Future<String> getCurrentUserEmail();
}