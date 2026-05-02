import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Programming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final email = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(email: email ?? ''),
          );
        }
        return null;
      },
    );
  }
}

// ============ LOGIN SCREEN ============
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';
  bool isPasswordVisible = false;

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(value);
    
    if (!hasLetters || !hasNumbers) {
      return 'Password harus kombinasi huruf dan angka';
    }
    
    return null;
  }

  // Handle login
  void _handleLogin() {
    // Reset error message
    setState(() {
      errorMessage = '';
    });

    if (_formKey.currentState!.validate()) {
      // Simulate login process
      setState(() {
        isLoading = true;
      });

      // Simulate delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to dashboard dengan pushReplacement dan pass email
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(
            context,
            '/dashboard',
            arguments: _emailController.text,
          );
        });
      });
    } else {
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan perbaiki error di form'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        validator: _validatePassword,
                        enabled: !isLoading,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleLogin,
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Forgot Password Button
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(context, '/forgot-password');
                              },
                        child: const Text('Lupa Password?'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ============ FORGOT PASSWORD SCREEN ============
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool isLoading = false;

  // Email validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Handle send reset link
  void _handleSendResetLink() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate sending email
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Link reset password telah dikirim ke ${_emailController.text}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear email field
        _emailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Masukkan email Anda untuk menerima link reset password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Send Reset Link Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleSendResetLink,
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Send Reset Link',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Back to Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: isLoading ? null : () => Navigator.pop(context),
                          child: const Text('Back to Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

// ============ DASHBOARD SCREEN ============
class DashboardScreen extends StatelessWidget {
  final String email;

  const DashboardScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data - Produk Baju
    final List<Map<String, String>> items = [
      {
        'title': 'T-Shirt Polos Katun',
        'description': 'T-shirt premium 100% katun - Rp 89.000',
        'category': 'Casual',
      },
      {
        'title': 'Kemeja Formal Putih',
        'description': 'Kemeja formal lengan panjang - Rp 249.000',
        'category': 'Formal',
      },
      {
        'title': 'Hoodie Abu-abu',
        'description': 'Hoodie nyaman ukuran S-XXL - Rp 159.000',
        'category': 'Casual',
      },
      {
        'title': 'Blazer Navy',
        'description': 'Blazer formal elegant warna navy - Rp 349.000',
        'category': 'Formal',
      },
      {
        'title': 'Tank Top Olahraga',
        'description': 'Tank top breathable untuk gym - Rp 79.000',
        'category': 'Sport',
      },
      {
        'title': 'Jaket Denim Biru',
        'description': 'Jaket denim vintage style - Rp 199.000',
        'category': 'Casual',
      },
      {
        'title': 'Polo Shirt Warna-warni',
        'description': 'Polo shirt quality cotton - Rp 119.000',
        'category': 'Casual',
      },
      {
        'title': 'Sweater Wool Premium',
        'description': 'Sweater wool tebal hangat - Rp 279.000',
        'category': 'Formal',
      },
      {
        'title': 'Jersey Sepak Bola',
        'description': 'Jersey olahraga quick dry - Rp 99.000',
        'category': 'Sport',
      },
      {
        'title': 'Cardigan Coklat',
        'description': 'Cardigan kasual warna coklat muda - Rp 149.000',
        'category': 'Casual',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Welcome section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          // List section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: item['category'] == 'Casual'
                                    ? Colors.orange.shade100
                                    : item['category'] == 'Formal'
                                        ? Colors.blue.shade100
                                        : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['category']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: item['category'] == 'Casual'
                                      ? Colors.orange
                                      : item['category'] == 'Formal'
                                          ? Colors.blue
                                          : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('Logout'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
