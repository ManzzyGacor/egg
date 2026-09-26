# 🥚 Manzzy Egg Hub — Steal an Egg (Roblox)

AFK 24/7 automation script untuk game Roblox **Steal an Egg**. Self-contained, tanpa remote code execution di dalam script-nya.

> Dibuat oleh **Manzzy** x Hermes Agent.

---

## 🚀 Cara Pakai

### Opsi A — Paste manual (paling aman)
1. Buka executor (Delta / Wave / Solara / Xeno / dll) lalu **Attach** ke Roblox.
2. Join game **Steal an Egg**.
3. Copy seluruh isi [`ManzzyEggHub.lua`](ManzzyEggHub.lua) → paste → **Execute**.
4. GUI muncul di layar. Nyalakan toggle yang dibutuhkan.

### Opsi B — Loader one-liner
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/ManzzyGacor/egg/main/ManzzyEggHub.lua"))()
```
> ⚠️ One-liner ini **menjalankan kode langsung dari internet**. Lebih aman: download filenya, baca isinya, baru execute. Jangan pernah pakai one-liner dari repo yang bukan punya lu sendiri.

### Opsi C — AFK 24/7 beneran ✨
Taruh `ManzzyEggHub.lua` di folder **auto-execute** executor lu:
```
<executor>/autoexecute/ManzzyEggHub.lua
```
Dengan ini script otomatis jalan tiap kali join/rejoin — termasuk setelah Auto Rejoin. Tanpa ini AFK 24/7 nggak akan jalan, karena script mati tiap rejoin.

---

## ⚙️ Fitur

| Fitur | Fungsi |
|---|---|
| **Anti AFK** | Blok kick otomatis Roblox tiap 20 menit |
| **Anti Kick** | Blok `:Kick()` client-side (butuh executor yang support `getrawmetatable`) |
| **Auto Farm Egg** | Cari egg terdekat → pathfinding → ambil otomatis |
| **Auto Return** | Habis nyuri egg, jalan pulang ke base |
| **Auto Prompt** | Auto-fire ProximityPrompt (steal / hatch / place / collect / claim) |
| **Auto Treadmill** | Nongkrong di treadmill buat grinding Speed |
| **Auto Unstuck** | Deteksi nyangkut → lompat + nudge acak |
| **Auto Rejoin** | Nyangkut 4x / karakter hilang 90 detik → rejoin server |
| **GUI Draggable** | Toggle ON/OFF, stats live, bisa di-minimize |

**Tombol aksi:**
- `SET BASE 📍` — berdiri di base lu, lalu pencet ini (kalau auto-detect gagal)
- `DEBUG DUMP` — cetak semua object & prompt yang kedeteksi ke console
- `REJOIN 🔄` — pindah server manual
- `UNLOAD ✖` — berhentiin semua loop + hancurin GUI bersih

---

## 🔑 Key System

Script diverifikasi terhadap [`keys.txt`](keys.txt) di repo ini.

1. Edit `MY_KEY` di bagian atas script:
   ```lua
   local MY_KEY = "ManzzyGanteng"
   ```
2. Key harus terdaftar di `keys.txt`. Owner bisa nambah/hapus key tanpa perlu re-push script.
3. `STRICT_KEY = true` → script berhenti total kalau nggak bisa verifikasi online.
   `false` (default) → fallback **OFFLINE MODE** kalau HttpGet diblokir executor.

> **Jujur:** key system client-side selalu bisa di-bypass orang yang bisa ngedit script. Ini buat nahan orang iseng, bukan keamanan beneran.

---

## 🛠️ Tuning

Deteksi egg / treadmill pakai **pencocokan nama object** (heuristik). Kalau AutoFarm diem aja:

1. Pencet **`DEBUG DUMP`** di GUI.
2. Lihat output console — nampilin jumlah egg/prompt/treadmill yang match + sample nama & path object.
3. Sesuaikan keyword di blok `CONFIG`:
   ```lua
   EggKeywords       = {"egg", "nest"},
   TreadmillKeywords = {"treadmill", "training"},
   PromptKeywords    = {"steal", "grab", "take", "collect", "claim", "hatch", "place", "pick"},
   IgnoreKeywords    = {"fake", "decoy", "troll", "trap", "shop", "buy", "sell", "sign"},
   ```

Angka lain yang sering perlu di-tweak: `MaxFarmDistance`, `CarryTimeoutSec`, `BaseSafeRadius`, `ScanNodeLimit`.

---

## ⚠️ Disclaimer

- Memakai executor **melanggar Terms of Service Roblox** dan berisiko **banned akun**. Pakai akun alt, jangan akun utama.
- Game ini punya anti-cheat sendiri; behavior mencurigakan bisa bikin karakter di-kick atau mati — di luar kendali script.
- Repo ini untuk tujuan edukasi & personal. Pakai dengan risiko sendiri.

---

## 📦 Struktur Repo

```
egg/
├── ManzzyEggHub.lua   # script utama (key gate + logic + GUI)
├── keys.txt           # daftar key valid
└── README.md
```
