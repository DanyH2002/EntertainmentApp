<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    /**
     * Funcion para listar los favoritos de un usuario
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $favorites = $request
            ->user()
            ->favorites()
            ->orderBy('id', 'desc')
            ->get();

        $movies = $favorites->where('type', 'movie')->values();
        $series = $favorites->where('type', 'serie')->values();

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email
            ],
            'favorites' => [
                'movies' => $movies,
                'series' => $series
            ]
        ]);
    }

    /**
     * Funcion para agregar favoritos
     */
    public function add(Request $request)
    {
        $validated = $request->validate([
            'item_id' => 'required',
            'type'    => 'required|string|in:movie,serie',
            'title'   => 'required|string'
        ]);

        $exists = Favorite::where('user_id', $request->user()->id)
            ->where('item_id', $validated['item_id'])
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Este elemento ya está en favoritos'
            ], 409);
        }

        $favorite = Favorite::create([
            'user_id' => $request->user()->id,
            'item_id' => $validated['item_id'],
            'type'    => $validated['type'],
            'title'   => $validated['title'],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Agregado a favoritos',
            'favorite' => $favorite
        ], 201);
    }

    /**
     * Funcion para eliminar un favorito
     */
    public function destroy(Request $request, $id)
    {
        $favorite = Favorite::where('user_id', $request->user()->id)
            ->where('id', $id)
            ->first();

        if (!$favorite) {
            return response()->json([
                'success' => false,
                'message' => 'Este favorito no existe'
            ], 404);
        }

        $favorite->delete();

        return response()->json([
            'success' => true,
            'message' => 'Eliminado de favoritos'
        ]);
    }
}
