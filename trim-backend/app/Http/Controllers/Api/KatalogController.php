<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KategoriSampah;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KatalogController extends Controller
{
    /**
     * GET /api/katalog
     * Pada trimset, harga ditetapkan per kategori sampah.
     */
    public function index(Request $request): JsonResponse
    {
        $items = KategoriSampah::query()
            ->when(! $request->boolean('semua'), fn ($q) => $q->where('status', 'aktif'))
            ->when($request->query('kategori'), function ($q, $nama) {
                $q->where('nama_kategori', 'like', "%{$nama}%");
            })
            ->orderBy('nama_kategori')
            ->get()
            ->map(fn (KategoriSampah $k) => $this->payload($k));

        return response()->json(['data' => $items]);
    }

    /**
     * GET /api/kategori
     */
    public function kategori(): JsonResponse
    {
        $items = KategoriSampah::where('status', 'aktif')
            ->orderBy('nama_kategori')
            ->get()
            ->map(fn (KategoriSampah $k) => [
                'id' => (int) $k->id_kategori,
                'id_kategori' => (int) $k->id_kategori,
                'nama' => $k->nama_kategori,
                'nama_kategori' => $k->nama_kategori,
                'deskripsi' => $k->deskripsi,
                'warna' => $this->warna($k->nama_kategori),
                'harga_per_kg' => (float) $k->harga_per_kg,
                'jumlah_item' => 1,
            ]);

        return response()->json(['data' => $items]);
    }

    public function store(Request $request): JsonResponse
    {
        $nama = trim((string) (
            $request->input('nama_kategori')
            ?? $request->input('nama')
            ?? $request->input('nama_sampah')
            ?? ''
        ));

        $request->merge([
            'nama_kategori' => $nama,
            'status' => $request->input(
                'status',
                $request->has('is_active') && ! $request->boolean('is_active') ? 'nonaktif' : 'aktif'
            ),
        ]);

        $data = $request->validate([
            'nama_kategori' => ['required', 'string', 'max:100', 'unique:kategori_sampah,nama_kategori'],
            'deskripsi' => ['nullable', 'string'],
            'harga_per_kg' => ['required', 'numeric', 'min:0'],
            'status' => ['required', 'in:aktif,nonaktif'],
        ]);

        $kategori = KategoriSampah::create($data);

        return response()->json([
            'message' => 'Kategori sampah ditambahkan.',
            'data' => $this->payload($kategori),
        ], 201);
    }

    public function update(Request $request, KategoriSampah $katalog): JsonResponse
    {
        $nama = trim((string) (
            $request->input('nama_kategori')
            ?? $request->input('nama')
            ?? $request->input('nama_sampah')
            ?? $katalog->nama_kategori
        ));

        $request->merge([
            'nama_kategori' => $nama,
            'status' => $request->input(
                'status',
                $request->has('is_active')
                    ? ($request->boolean('is_active') ? 'aktif' : 'nonaktif')
                    : $katalog->status
            ),
        ]);

        $data = $request->validate([
            'nama_kategori' => [
                'required', 'string', 'max:100',
                'unique:kategori_sampah,nama_kategori,'.$katalog->id_kategori.',id_kategori',
            ],
            'deskripsi' => ['nullable', 'string'],
            'harga_per_kg' => ['sometimes', 'numeric', 'min:0'],
            'status' => ['required', 'in:aktif,nonaktif'],
        ]);

        $katalog->update($data);

        return response()->json([
            'message' => 'Kategori sampah diperbarui.',
            'data' => $this->payload($katalog->fresh()),
        ]);
    }

    public function destroy(KategoriSampah $katalog): JsonResponse
    {
        $katalog->update(['status' => 'nonaktif']);

        return response()->json(['message' => 'Kategori sampah dinonaktifkan.']);
    }

    private function payload(KategoriSampah $k): array
    {
        $harga = (float) $k->harga_per_kg;

        return [
            'id' => (int) $k->id_kategori,
            'id_kategori' => (int) $k->id_kategori,
            'kategori_id' => (int) $k->id_kategori,
            'nama_kategori' => $k->nama_kategori,
            'nama' => $k->nama_kategori,
            'nama_sampah' => $k->nama_kategori,
            'kategori' => $k->nama_kategori,
            'warna' => $this->warna($k->nama_kategori),
            'deskripsi' => $k->deskripsi,
            'harga_per_kg' => $harga,
            'harga' => 'Rp '.number_format($harga, 0, ',', '.').'/kg',
            'status' => $k->status,
            'is_active' => $k->status === 'aktif',
        ];
    }

    private function warna(string $nama): string
    {
        return match (strtolower($nama)) {
            'plastik' => '#2E7D32',
            'logam' => '#1565C0',
            'kertas', 'kertas/kardus', 'kertas & kardus' => '#EF6C00',
            'limbah' => '#C62828',
            default => '#6D4C41',
        };
    }
}
