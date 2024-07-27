import 'package:flutter_base_app/config/services/injection.dart';
import 'package:flutter_base_app/config/util/utility.dart';
import 'package:flutter_base_app/data/model/tv_show.dart';
import 'package:flutter_base_app/domain/repository/app_repository.dart';
import 'package:flutter_base_app/presentation/pages/tv_show/detail/tv_show_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TvShowDetailCubit extends Cubit<TvShowDetailState> {
  TvShowDetailCubit() : super(TvShowInitial());

  var appRepository = getIt<AppRepository>();

  void insertWatchListTvShow(TvShow tvShow) async {
    try {
      emit(TvShowLoading());
      await appRepository.insertTvShow(tvShow);
      emit(TvShowSaved());
    } catch (e) {
      emit(TvShowError(error: Utility.handleErrorString(e.toString())));
    }
  }

  void getTvShowById(int id) async {
    try {
      emit(TvShowLoading());
      var result = await appRepository.getTvShowById(id);
      if (result) {
        emit(TvShowIsWatchList());
      } else {
        emit(TvShowIsNotWatchList());
      }
    } catch (e) {
      emit(TvShowError(error: Utility.handleErrorString(e.toString())));
    }
  }

  void deleteTvShow(int id) async {
    try {
      emit(TvShowLoading());
      await appRepository.deleteTvShow(id);
      emit(TvShowDeleted());
    } catch (e) {
      emit(TvShowError(error: Utility.handleErrorString(e.toString())));
    }
  }
}
