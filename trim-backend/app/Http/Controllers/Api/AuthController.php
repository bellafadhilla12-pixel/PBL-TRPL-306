<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\User;
use App\Models\Warga;
use App\Services\SaldoService;
use App\Support\DatabaseError;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function __construct(private SaldoService $saldo) {}

    /**
     * POST /api/warga/register
     * Membuat users (role warga) lalu profil warga. Trigger trimset
     * otomatis membuat baris saldo setelah profil warga tersimpan.
     */
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'username' => ['nullable', 'string', 'max:100'],
            'nama' => ['required', 'string', 'max:150'],
            'whatsapp' => ['nullable', 'string', 'max:20'],
            'no_hp' => ['nullable', 'string', 'max:20'],
            'password' => [
                'required',
                'string',
                'min:8',
                'regex:/[A-Za-z]/',
                'regex:/[0-9]/',
            ],
            'alamat' => ['nullable', 'string', 'max:255'],
            'blok' => ['nullable', 'string', 'max:10'],
            'nomor_rumah' => ['nullable', 'string', 'max:10'],
            'rt' => ['nullable', 'string', 'max:5'],
            'rw' => ['nullable', 'string', 'max:5'],
            'status_tempat_tinggal' => ['nullable', 'string', 'max:50'],
            'keterangan_tempat_tinggal' => ['nullable', 'string', 'max:255'],
            'detail_tempat_tinggal' => ['nullable', 'string', 'max:255'],
        ], [
            'password.min' => 'Kata sandi minimal 8 karakter.',
            'password.regex' => 'Kata sandi harus mengandung huruf dan angka.',
        ]);

        $noHp = trim((string) ($data['no_hp'] ?? $data['whatsapp'] ?? ''));
        if ($noHp === '') {
            throw ValidationException::withMessages([
                'whatsapp' => ['Nomor WhatsApp wajib diisi.'],
            ]);
        }

        $username = trim((string) ($data['username'] ?? $noHp));

        if (User::where('username', $username)->exists()) {
            throw ValidationException::withMessages([
                'username' => ['Username atau nomor WhatsApp sudah terdaftar.'],
            ]);
        }

        if (Warga::where('no_hp', $noHp)->exists()) {
            throw ValidationException::withMessages([
                'whatsapp' => ['Nomor WhatsApp sudah terdaftar.'],
            ]);
        }

        $alamat = trim((string) ($data['alamat'] ?? ''));
        if ($alamat === '') {
            $bagian = array_filter([
                ! empty($data['blok']) ? 'Blok '.$data['blok'] : null,
                ! empty($data['nomor_rumah']) ? 'No. '.$data['nomor_rumah'] : null,
                ! empty($data['rt']) ? 'RT '.$data['rt'] : null,
                ! empty($data['rw']) ? 'RW '.$data['rw'] : null,
                $data['detail_tempat_tinggal'] ?? null,
            ]);
            $alamat = $bagian ? implode(', ', $bagian) : 'Alamat belum diisi';
        }

        try {
            $user = DB::transaction(function () use ($data, $username, $noHp, $alamat) {
                $user = User::create([
                    'username' => $username,
                    'password' => $data['password'],
                    'role' => 'warga',
                    'status' => 'aktif',
                ]);

                Warga::create([
                    'id_user' => $user->id_user,
                    'nama' => $data['nama'],
                    'no_hp' => $noHp,
                    'alamat' => $alamat,
                    'status_verifikasi' => Warga::STATUS_MENUNGGU,
                ]);

                return $user;
            });
        } catch (QueryException $e) {
            if ($message = DatabaseError::triggerMessage($e)) {
                return response()->json(['message' => $message], 422);
            }

            throw $e;
        }

        $token = $user->createToken('flutter-app')->plainTextToken;

        return response()->json([
            'message' => 'Registrasi berhasil, menunggu verifikasi pengurus.',
            'token' => $token,
            'data' => $this->userPayload($user->fresh()),
        ], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'username' => ['nullable', 'string'],
            'whatsapp' => ['nullable', 'string'],
            'no_hp' => ['nullable', 'string'],
            'password' => ['required', 'string'],
        ]);

        $identity = trim((string) ($data['username'] ?? $data['whatsapp'] ?? $data['no_hp'] ?? ''));
        if ($identity === '') {
            throw ValidationException::withMessages([
                'username' => ['Nomor WhatsApp atau username wajib diisi.'],
            ]);
        }

        $user = User::where('username', $identity)->first();

        // Nomor HP juga boleh dipakai jika username berbeda.
        if (! $user) {
            $warga = Warga::with('user')->where('no_hp', $identity)->first();
            $user = $warga?->user;
        }

        if (! $user || ! Hash::check($data['password'], $user->password)) {
            throw ValidationException::withMessages([
                'username' => ['Nomor WhatsApp/Username atau kata sandi salah.'],
            ]);
        }

        if (! $user->isActive()) {
            throw ValidationException::withMessages([
                'username' => ['Akun ini sedang dinonaktifkan.'],
            ]);
        }

        $user->tokens()->delete();
        $token = $user->createToken('flutter-app')->plainTextToken;

        AuditLog::record(
            action: 'login',
            objectType: 'auth',
            objectId: (string) $user->id_user,
            newValues: ['role' => $user->role],
            result: 'success',
            httpStatus: 200,
            actorUserId: $user->id_user,
            actorRole: $user->role,
        );

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token,
            'role' => $user->role,
            'data' => $this->userPayload($user->fresh()),
        ]);
    }

    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'data' => $this->userPayload($request->user()),
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $user = $request->user();
        $user->currentAccessToken()?->delete();

        AuditLog::record(
            action: 'logout',
            objectType: 'auth',
            objectId: (string) $user->id_user,
            result: 'success',
            httpStatus: 200,
        );

        return response()->json(['message' => 'Logout berhasil']);
    }

    /**
     * GET /api/verifikasi?status=menunggu (pengurus)
     */
    public function verifikasiIndex(Request $request): JsonResponse
    {
        $status = $request->query('status', Warga::STATUS_MENUNGGU);

        $items = Warga::with('user')
            ->when($status !== 'semua', fn ($q) => $q->where('status_verifikasi', $status))
            ->orderBy('id_warga')
            ->get()
            ->map(fn (Warga $w) => $this->wargaPayload($w));

        return response()->json(['data' => $items]);
    }

    /**
     * PATCH /api/verifikasi/{warga} (pengurus)
     */
    public function verifikasiUpdate(Request $request, Warga $warga): JsonResponse
    {
        $data = $request->validate([
            'status' => ['required', 'in:menunggu,terverifikasi,ditolak,disetujui'],
        ]);

        $status = $data['status'] === 'disetujui'
            ? Warga::STATUS_TERVERIFIKASI
            : $data['status'];

        $warga->update(['status_verifikasi' => $status]);

        return response()->json([
            'message' => 'Status verifikasi warga diperbarui menjadi '.$status.'.',
            'data' => $this->wargaPayload($warga->fresh()->load('user')),
        ]);
    }

    private function userPayload(User $user): array
    {
        $user->loadMissing(['warga.saldo', 'pengurus', 'ubs']);

        $payload = [
            'id' => (int) $user->id_user,
            'id_user' => (int) $user->id_user,
            'username' => $user->username,
            'role' => $user->role,
            'status' => $user->status,
            'nama' => $user->username,
            'whatsapp' => null,
            'no_hp' => null,
            'alamat' => null,
            'status_verifikasi' => null,
            'saldo' => 0,
            'saldo_tersedia' => 0,
        ];

        if ($user->role === 'warga' && $user->warga) {
            $w = $user->warga;
            $saldo = $this->saldo->forWarga($w);

            $payload = array_merge($payload, [
                'nama' => $w->nama,
                'whatsapp' => $w->no_hp,
                'no_hp' => $w->no_hp,
                'alamat' => $w->alamat,
                'status_verifikasi' => $w->status_verifikasi,
            ], $saldo);
        } elseif ($user->role === 'pengurus' && $user->pengurus) {
            $payload['nama'] = $user->pengurus->nama;
        } elseif ($user->role === 'ubs' && $user->ubs) {
            $payload['nama'] = $user->ubs->nama;
        }

        return $payload;
    }

    private function wargaPayload(Warga $w): array
    {
        return [
            'id' => (int) $w->id_warga,
            'id_warga' => (int) $w->id_warga,
            'user_id' => (int) $w->id_user,
            'username' => $w->user?->username,
            'nama' => $w->nama,
            'whatsapp' => $w->no_hp,
            'no_hp' => $w->no_hp,
            'alamat' => $w->alamat,
            'status_verifikasi' => $w->status_verifikasi,
            'created_at' => null,
        ];
    }
}
