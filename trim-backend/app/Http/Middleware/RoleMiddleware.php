<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Contoh pemakaian di route: ->middleware('role:pengurus,ubs')
     */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if (! $user || ! in_array($user->role, $roles, true)) {
            return response()->json([
                'message' => 'Akses ditolak. Endpoint ini khusus role: '.implode(', ', $roles).'.',
            ], 403);
        }

        return $next($request);
    }
}
