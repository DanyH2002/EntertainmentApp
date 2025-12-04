<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\TMDBController;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::prefix('favorite')->group(function () {
        Route::get('/list', [FavoriteController::class, 'index']);
        Route::post('/add', [FavoriteController::class, 'add']);
        Route::delete('/delete/{id}', [FavoriteController::class, 'destroy']);
    });

    Route::prefix('tmdb')->group(function () {
        Route::get('/movies/popular', [TMDBController::class, 'popularMovies']);
        Route::get('/series/popular', [TMDBController::class, 'popularSeries']);
        Route::get('/movie/{id}', [TMDBController::class, 'movieDetails']);
        Route::get('/series/{id}', [TMDBController::class, 'seriesDetails']);
        Route::get('/search/movie', [TMDBController::class, 'searchMovie']);
        Route::get('/search/serie', [TMDBController::class, 'searchSerie']);
    });
});
