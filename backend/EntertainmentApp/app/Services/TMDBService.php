<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class TMDBService
{
    protected $baseUrl;
    protected $apiKey;

    public function __construct()
    {
        $this->baseUrl = config('tmdb.base_url');
        $this->apiKey = config('tmdb.key');
    }

    private function get($endpoint, $params = [])
    {
        return Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->apiKey,
            'accept' => 'application/json'
        ])->get($this->baseUrl . $endpoint, $params)->json();
    }

    public function popularMovies()
    {
        return $this->get('movie/popular', [
            'language' => 'es-MX'
        ]);
    }

    public function popularSeries()
    {
        return $this->get('tv/popular', [
            'language' => 'es-MX'
        ]);
    }

    public function movieDetails($id)
    {
        return $this->get("movie/{$id}", [
            'language' => 'es-MX'
        ]);
    }

    public function seriesDetails($id)
    {
        return $this->get("tv/{$id}", [
            'language' => 'es-MX'
        ]);
    }

    public function search($query)
    {
        return $this->get("search/multi", [
            'query' => $query,
            'language' => 'es-MX'
        ]);
    }

    public function movieVideos($id)
    {
        return $this->get("movie/{$id}/videos", [
            'language' => 'es-MX'
        ]);
    }

    public function seriesVideos($id)
    {
        return $this->get("tv/{$id}/videos", [
            'language' => 'es-MX'
        ]);
    }
}
