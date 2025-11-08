import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/core/theme/app_theme.dart';
import 'package:klaussified/core/routes/app_router.dart';

class KlaussifiedApp extends StatelessWidget {
  const KlaussifiedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(const AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => GroupBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Klaussified',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
