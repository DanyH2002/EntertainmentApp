<?php

namespace App\Http\Controllers;

use App\Services\TMDBService;

class TMDBController extends Controller
{
    protected $tmdb;

    public function __construct(TMDBService $tmdb)
    {
        $this->tmdb = $tmdb;
    }

    /**
     * Funcion para ver las peliculas mas populares
     */
    public function popularMovies()
    {
        return response()->json($this->tmdb->popularMovies());
    }

    /**
     * Funcion para ver las series mas populares
     */
    public function popularSeries()
    {
        return response()->json($this->tmdb->popularSeries());
    }

    /**
     * Funcion para ver la informacion de una pelicula
     */
    public function movieDetails($id)
    {
        return response()->json($this->tmdb->movieDetails($id));
    }

    /**
     * Funcion para ver la informacion de una serie
     */
    public function seriesDetails($id)
    {
        return response()->json($this->tmdb->seriesDetails($id));
    }

    /**
     * Funcion para buscar una pelicula
     */
    public function searchMovie()
    {
        $query = request()->query('q');

        if (!$query) {
            return response()->json(['error' => 'Debe enviar un parámetro q'], 400);
        }

        return response()->json($this->tmdb->searchMovie($query));
    }

    /**
     * Funcion para buscar una serie
     */
    public function searchSerie()
    {
        $query = request()->query('q');

        if (!$query) {
            return response()->json(['error' => 'Debe enviar un parámetro q'], 400);
        }

        return response()->json($this->tmdb->searchSerie($query));
    }
}
