import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/product/presentation/state/details/bloc/details_bloc.dart';
import 'package:shop/features/product/presentation/state/home/bloc/home_bloc.dart';
import 'package:shop/features/product/presentation/state/product/bloc/product_bloc.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';
import 'package:shop/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:shop/features/authentication/presentation/pages/login_page.dart';
import 'package:shop/screens/onbording/views/onbording_screnn.dart';
import 'package:shop/core/services/storage_service.dart';
import 'core/injection/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

// Thanks for using our template. You are using the free version of the template.
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
          
        ),
        BlocProvider<ProductBloc>(
          create: (_) => di.sl<ProductBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => di.sl<HomeBloc>(),
        ),
        BlocProvider<DetailsBloc>(
          create: (_) => di.sl<DetailsBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        onGenerateRoute: router.generateRoute,
        home: di.sl<StorageService>().hasSeenOnboarding()
            ? const LoginScreen()
            : const OnBordingScreen(),
      ),
    );
  }
}
