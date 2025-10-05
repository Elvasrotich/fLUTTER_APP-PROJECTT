// Supabase config values are read from compile-time environment variables
// so you don't store secrets in source control. Provide them with
// --dart-define=SUPABASE_URL="..." --dart-define=SUPABASE_ANON_KEY="..."
// Example PowerShell run (do NOT paste keys into version control):
// flutter run --dart-define=SUPABASE_URL="https://xyz.supabase.co" --dart-define=SUPABASE_ANON_KEY="your-anon-key"

// Read from dart-define (these are compile-time constants).
const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: '',
);
const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: '',
);

bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

// Helpers to validate presence at runtime (call before initializing Supabase).
void ensureSupabaseConfig() {
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError(
      'Supabase configuration not provided. Run the app with --dart-define=SUPABASE_URL="<url>" --dart-define=SUPABASE_ANON_KEY="<anon>"',
    );
  }
}
