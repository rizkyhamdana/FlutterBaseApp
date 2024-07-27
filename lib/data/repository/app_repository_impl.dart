import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base_app/data/database/app_database.dart';
import 'package:flutter_base_app/data/model/movie.dart';
import 'package:flutter_base_app/data/model/tv_show.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_base_app/config/services/call_api_service.dart';
import 'package:flutter_base_app/config/services/injection.dart';
import 'package:flutter_base_app/config/util/constant.dart';
import 'package:flutter_base_app/config/util/utility.dart';
import 'package:flutter_base_app/domain/repository/app_repository.dart';

@LazySingleton(as: AppRepository)
class AppRepositoryImpl implements AppRepository {
  var callService = getIt<CallApiService>();

  @override
  Future<MovieResponse> getListMovie(String type) async {
    try {
      var path = Constant.getMoviePopular;
      switch (type) {
        case Constant.MOVPOPULAR:
          path = Constant.getMoviePopular;
          break;
        case Constant.MOVNOWPLAYING:
          path = Constant.getMovieNowPlaying;
          break;
        case Constant.MOVTOPRATED:
          path = Constant.getMovieTopRated;
          break;
        case Constant.MOVUPCOMING:
          path = Constant.getMovieUpcoming;
          break;

        default:
          break;
      }
      var response = await callService.connect(
        path,
        {},
        Constant.get,
      );

      return movieResponseFromJson(jsonEncode(response.data));
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<TvShowResponse> getListTvShow(String type) async {
    try {
      var path = Constant.getTvPopular;
      switch (type) {
        case Constant.TVPOPULAR:
          path = Constant.getTvPopular;
          break;
        case Constant.TVAIRING:
          path = Constant.getTvAiring;
          break;
        case Constant.TVONTHEAIR:
          path = Constant.getTvOnTheAir;
          break;
        case Constant.TVTOPRATED:
          path = Constant.getTvTopRated;
          break;
        default:
          break;
      }
      var response = await callService.connect(
        path,
        {},
        Constant.get,
      );

      return tvShowResponseFromJson(jsonEncode(response.data));
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<MovieResponse> getListSearchMovie(String query) async {
    try {
      var path = '${Constant.getMovieSearch}?query="$query"';

      var response = await callService.connect(
        path,
        {},
        Constant.get,
      );

      return movieResponseFromJson(jsonEncode(response.data));
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<TvShowResponse> getListSearchTvShow(String query) async {
    try {
      var path = '${Constant.getTvSearch}?query="$query"';

      var response = await callService.connect(
        path,
        {},
        Constant.get,
      );

      return tvShowResponseFromJson(jsonEncode(response.data));
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<List<Movie>> getMovieWatchlist() async {
    try {
      var listMovie = await AppDatabase.instance.queryAllMovie();
      return listMovie;
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<List<TvShow>> getTvShowWatchList() async {
    try {
      var listTvShow = await AppDatabase.instance.queryAllTvShow();
      return listTvShow;
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<void> insertMovie(Movie movie) async {
    try {
      AppDatabase.instance.insertMovie(movie.toDb());
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<void> insertTvShow(TvShow tvShow) async {
    try {
      await AppDatabase.instance.insertTvShow(tvShow.toDb());
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<bool> getMovieById(int id) async {
    try {
      var result = await AppDatabase.instance.queryMovieById(id);
      if (result.isEmpty) {
        return false;
      } else {
        return true;
      }
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<bool> getTvShowById(int id) async {
    try {
      var result = await AppDatabase.instance.queryTvShowById(id);
      if (result.isEmpty) {
        return false;
      } else {
        return true;
      }
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<bool> deleteMovie(int id) async {
    try {
      await AppDatabase.instance.deleteMovie(id);
      return true;
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }

  @override
  Future<bool> deleteTvShow(int id) async {
    try {
      await AppDatabase.instance.deleteTvShow(id);
      return true;
    } on DioException catch (e) {
      throw Exception(Utility.handleError(e));
    }
  }
}
