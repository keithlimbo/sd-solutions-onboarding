import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../main.dart';

final authBloc =
    BlocProvider.of<AuthBloc>(MainApp.navigatorKey.currentContext!);
