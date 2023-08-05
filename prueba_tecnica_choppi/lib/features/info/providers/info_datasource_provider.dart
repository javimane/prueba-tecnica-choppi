import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../datasource/info_datasource.dart';
import '../infrastructure/datasources/info_datasource_impl.dart';

final infoDatasourceProvider = Provider<InfoDatasource>((ref) {
  // Puedes implementar InfoDatasourceImpl aquí y devolverlo
  final accessToken = ref.watch( authProvider ).user?.token ?? '';
  return InfoDatasourceImpl(accessToken: accessToken);
});