import 'package:get_it/get_it.dart';
import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';
// import 'package:spotify/domain/usecases/auth/get_user.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/domain/usecases/auth/signin.dart';

// import 'package:spotify/domain/usecases/song/add_or_remove_favorite_song.dart';
// import 'package:spotify/domain/usecases/song/get_favorite_songs.dart';
// import 'package:spotify/domain/usecases/song/get_news_songs.dart';
// import 'package:spotify/domain/usecases/song/get_play_list.dart';
// import 'package:spotify/domain/usecases/song/is_favorite_song.dart';
//
// import 'data/repository/song/song_repository_impl.dart';
// import 'data/sources/song/song_firebase_service.dart';
// import 'domain/repository/song/song.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(
      AuthFirebaseServiceImpl()
  );

  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl()
  );

  sl.registerSingleton<SignupUseCase>(
      SignupUseCase()
  );

  sl.registerSingleton<SigninUseCase>(
      SigninUseCase()
  );
}