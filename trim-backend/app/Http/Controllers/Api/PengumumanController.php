<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pengumuman;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PengumumanController extends Controller
{
    /**
     * GET /api/pengumuman
     * Pengumuman teks dari pengurus (bukan jadwal kegiatan).
     */
    public function index(Request $request): JsonResponse
    {
        $items = Pengumuman::with('pengurus:id_pengurus,nama')
            ->when($request->query('status'), fn ($q, $status) => $q->where('status', $status))
            ->orderByDesc('tanggal_pengumuman')
            ->orderByDesc('id_pengumuman')
            ->get()
            ->map(fn (Pengumuman $p) => $this->payload($p));

        return response()->json(['data' => $items]);
    }

    public function store(Request $request): JsonResponse
    {
        $pengurus = $request->user()->pengurus;
        abort_if(! $pengurus, 403, 'Akun pengurus belum memiliki profil.');

        $data = $request->validate([
            'judul' => ['required', 'string', 'max:255'],
            'deskripsi' => ['required', 'string'],
            'tanggal_pengumuman' => ['required', 'date'],
            'status' => ['sometimes', 'in:aktif,nonaktif'],
        ]);

        $pengumuman = Pengumuman::create([
            'id_pengurus' => $pengurus->id_pengurus,
            'judul' => $data['judul'],
            'deskripsi' => $data['deskripsi'],
            'tanggal_pengumuman' => $data['tanggal_pengumuman'],
            'status' => $data['status'] ?? 'aktif',
        ]);

        return response()->json([
            'message' => 'Pengumuman berhasil diterbitkan.',
            'data' => $this->payload($pengumuman->load('pengurus')),
        ], 201);
    }

    public function update(Request $request, Pengumuman $pengumuman): JsonResponse
    {
        $data = $request->validate([
            'judul' => ['sometimes', 'string', 'max:255'],
            'deskripsi' => ['sometimes', 'string'],
            'tanggal_pengumuman' => ['sometimes', 'date'],
            'status' => ['sometimes', 'in:aktif,nonaktif'],
        ]);

        $pengumuman->update($data);

        return response()->json([
            'message' => 'Pengumuman diperbarui.',
            'data' => $this->payload($pengumuman->fresh()->load('pengurus')),
        ]);
    }

    public function destroy(Pengumuman $pengumuman): JsonResponse
    {
        $pengumuman->update(['status' => 'nonaktif']);

        return response()->json(['message' => 'Pengumuman dinonaktifkan.']);
    }

    private function payload(Pengumuman $p): array
    {
        return [
            'id' => (int) $p->id_pengumuman,
            'judul' => $p->judul,
            'deskripsi' => $p->deskripsi,
            'tanggal' => $p->tanggal_pengumuman?->toDateString(),
            'tanggal_pengumuman' => $p->tanggal_pengumuman?->toDateString(),
            'status' => $p->status,
            'pengurus' => $p->pengurus?->only(['id_pengurus', 'nama']),
        ];
    }
}
