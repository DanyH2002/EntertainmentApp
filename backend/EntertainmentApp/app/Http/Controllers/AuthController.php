<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException as Exception;

class AuthController extends Controller
{
    /**
     * Funcion para registrar un nuevo usuario
     */
    public function register(Request $request)
    {
        try {
            $validated = $request->validate([
                'name'       => 'required|string|max:255',
                'last_name'  => 'required|string|max:255',
                'email'      => 'required|string|email|unique:users,email',
                'password'   => 'required|string|min:8'
            ]);
        } catch (Exception $e) {
            if (isset($e->errors()['email'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'El correo electrónico ya está registrado.'
                ], 422);
            }
            return response()->json([
                'success' => false,
                'message' => 'Datos inválidos',
                'errors' => $e->errors()
            ], 422);
        }

        $user = User::create([
            'name'      => $validated['name'],
            'last_name' => $validated['last_name'],
            'email'     => $validated['email'],
            'password'  => Hash::make($validated['password']),
        ]);

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Usuario registrado correctamente',
            'token'   => $token,
            'user'    => $user
        ], 201);
    }

    /**
     * Funcion para iniciar sesion
     */
    public function login(Request $request)
    {
        $validated = $request->validate([
            'email'    => 'required|string|email',
            'password' => 'required|string|min:8'
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Credenciales incorrectas'
            ], 401);
        }

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Inicio de sesión correcto',
            'token'   => $token,
            'user'    => $user
        ], 200);
    }

    /**
     * Funcion para cerrar sesion
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'success' => true,
            'message' => 'Usuario deslogueado con éxito',
        ], 200);
    }
}
