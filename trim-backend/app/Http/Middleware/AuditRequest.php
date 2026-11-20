<?php

namespace App\Http\Middleware;

use App\Models\AuditLog;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;
use Throwable;

class AuditRequest
{
    /**
     * Catat request mutasi yang gagal (validasi, 403, 404, 405, 429, 500).
     * Request sukses dicatat oleh observer model atau AuthController.
     *
     * Catatan: Laravel mengubah exception di dalam routing pipeline menjadi
     * Response sebelum middleware ini menerimanya, sehingga pengecekan
     * dilakukan pada status response, bukan pada catch exception.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        $isMutating = in_array($request->method(), ['POST', 'PUT', 'PATCH', 'DELETE'], true);
        $isDenied = in_array($response->getStatusCode(), [401, 403], true);

        if (($isMutating && $response->getStatusCode() >= 400) || $isDenied) {
            try {
                AuditLog::record(
                    action: strtolower($request->method()).' '.$request->path(),
                    objectType: 'http_request',
                    objectId: $request->path(),
                    result: 'failed',
                    httpStatus: $response->getStatusCode(),
                );
            } catch (Throwable $auditError) {
                Log::error('Gagal menulis audit request gagal.', [
                    'error' => $auditError->getMessage(),
                ]);
            }
        }

        return $response;
    }
}
