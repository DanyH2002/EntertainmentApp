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
     * Funcion para buscar una pelicula o serie
     */
    public function search()
    {
        $query = request()->query('q');

        if (!$query) {
            return response()->json(['error' => 'Debe enviar un parámetro q'], 400);
        }

        return response()->json($this->tmdb->search($query));
    }

    /**
     * Funcion para buscar el trailer de peliculas o seria NOTA: No todas las respuestas tiene un video
     */
    public function movieVideos($id)
    {
        return response()->json($this->tmdb->movieVideos($id));
    }

    public function seriesVideos($id)
    {
        return response()->json($this->tmdb->seriesVideos($id));
    }
}
