--[[
    ╔══════════════════════════════════════════════════════╗
    ║   🥚 MANZZY EGG HUB  —  Steal an Egg (Roblox)         ║
    ║   AFK 24/7 Automation | by Manzzy x Hermes Agent      ║
    ╚══════════════════════════════════════════════════════╝

    ── KEY SYSTEM ──────────────────────────────────────────
    Isi MY_KEY di bawah dengan key lu sebelum Execute.
    Default: "ManzzyGanteng"

    Validasi: key dicek terhadap daftar di
      https://raw.githubusercontent.com/ManzzyGacor/egg/main/keys.txt
    Kalau key lu nggak ada di daftar itu → script berhenti.
    Owner repo bisa nambah/hapus key kapan aja tanpa
    perlu re-push script-nya.

    Kalau fetch gagal (executor blokir HttpGet / offline),
    script fallback ke mode OFFLINE dan tetap jalan pakai
    key lokal. Set STRICT_KEY = true kalau mau gagal total
    saat nggak bisa verifikasi online.

    JUJUR: key system client-side SELALU bisa di-bypass sama
    orang yang bisa ngedit script. Ini buat nahan orang iseng,
    bukan buat keamanan beneran.
]]

-- ↓↓↓ ISI KEY LU DI SINI ↓↓↓
local MY_KEY      = "ManzzyGanteng"
local STRICT_KEY  = false
local KEY_FILE_URL = "https://raw.githubusercontent.com/ManzzyGacor/egg/main/keys.txt"
-- ↑↑↑ ISI KEY LU DI SINI ↑↑↑

do
    local valid = false
    local reason = ""

    local okHttp, body = pcall(function()
        return game:HttpGet(KEY_FILE_URL, true)
    end)

    if okHttp and type(body) == "string" and #body > 0 then
        local list = {}
        for line in string.gmatch(body, "[^\r\n]+") do
            line = line:gsub("^%s+", ""):gsub("%s+$", "")
            if #line > 0 and line:sub(1, 1) ~= "#" then
                list[line] = true
            end
        end
        if list[MY_KEY] then
            valid = true
        else
            reason = "key '" .. tostring(MY_KEY) .. "' nggak ada di daftar server"
        end
    else
        reason = "gagal fetch key server (offline/diblokir)"
        if not STRICT_KEY then
            -- mode offline: terima key lokal apa adanya
            valid = true
            reason = reason .. " → OFFLINE MODE"
        end
    end

    if not valid then
        warn("[MANZZY EGG HUB] ❌ KEY INVALID: " .. reason)
        pcall(function()
            local gui = Instance.new("ScreenGui")
            gui.ResetOnSpawn = false
            local parentOk = pcall(function() gui.Parent = gethui() end)
            if not parentOk or not gui.Parent then
                pcall(function() gui.Parent = game:GetService("CoreGui") end)
            end
            if not gui.Parent then
                gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
            end
            local f = Instance.new("Frame", gui)
            f.Size = UDim2.new(0, 320, 0, 90)
            f.Position = UDim2.new(0.5, -160, 0.5, -45)
            f.BackgroundColor3 = Color3.fromRGB(40, 12, 12)
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -16, 1, -8)
            l.Position = UDim2.new(0, 8, 0, 4)
            l.BackgroundTransparency = 1
            l.TextColor3 = Color3.fromRGB(255, 140, 140)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 13
            l.TextWrapped = true
            l.Text = "❌ MANZZY EGG HUB — KEY INVALID\n" .. reason
        end)
        return
    end

    print("[MANZZY EGG HUB] ✅ Key accepted. " .. reason)
end

-- ==================================================================
--  MAIN SCRIPT
-- ==================================================================

--[[
    SELF-CONTAINED: tidak ada loadstring / tidak execute remote code.
    Satu-satunya request keluar adalah GET keys.txt di atas (data, bukan kode).

    CARA PAKAI:
    1. Attach executor (Delta / Wave / Solara / Xeno / dll) ke Roblox
    2. Masuk game Steal an Egg
    3. Paste script ini → Execute
    4. GUI muncul — nyalakan toggle yang dibutuhkan
    5. AFK 24/7: taruh file ini di folder AUTO-EXECUTE executor lu,
       biar otomatis jalan lagi tiap rejoin.

    ⚠️  Executor = melanggar ToS Roblox → risiko banned.
        Pakai akun alt, jangan akun utama.
]]
--[[
    🥚 MANZZY EGG HUB — Steal an Egg | 24/7 AFK Tool
    Dibuat khusus buat Manzzy oleh Hermes Agent.

    SELF-CONTAINED: tidak ada loadstring/HttpGet, tidak ada key system,
    tidak ada remote code. Semua bisa lu baca di file ini.

    CARA PAKAI:
    1. Buka executor lu (Delta / Wave / Solara / Xeno / dll)
    2. Attach ke Roblox, masuk game Steal an Egg
    3. Paste script ini, Execute
    4. GUI muncul di layar — nyalakan toggle yang dibutuhkan
    5. Untuk AFK 24/7 beneran: taruh file ini di folder AUTO-EXECUTE
       executor lu (biasanya /autoexecute atau /workspace) biar
       otomatis jalan tiap join game, termasuk setelah auto-rejoin.

    ⚠️  PERINGATAN JUJUR:
    - Executor = melanggar ToS Roblox. Risiko banned akun.
      Pakai akun alt / kaitun, jangan akun utama.
    - Game ini punya anti-cheat; behavior mencurigakan bisa
      bikin karakter lu di-kick/mati. Itu di luar kendali script.
    - Deteksi egg/prompt/treadmill di sini HEURISTIK (berdasarkan
      nama object). Kalau AutoFarm nggak nemu apa-apa, pencet
      [DEBUG DUMP] di GUI, copy output console, kirim ke bot lu
      biar keyword CONFIG di bawah bisa di-tuning.
]]

local SCRIPT_VERSION = "2.0.0-macro"
local VERSION_URL = "https://raw.githubusercontent.com/ManzzyGacor/egg/main/VERSION"

-- ============================= CONFIG =============================
local CONFIG = {
    -- Fitur inti AFK
    AntiAFK        = true,   -- blok kick AFK 20 menit dari Roblox
    AntiKick       = true,   -- blok :Kick() client-side; ini yang nahan kick blacklist BAC-xxxx
    AutoUnstuck    = true,   -- lompat kalau nyangkut (macro mode: tanpa teleport)
    AutoRejoin     = false,  -- OFF: habis ke-kick anticheat, auto-rejoin = loop kick->ban

    -- Farming
    AutoFarm       = false,  -- cari & ambil egg otomatis
    AutoReturn     = true,   -- habis ambil egg, balik ke base
    AutoPrompt     = true,   -- auto-fire ProximityPrompt yg cocok keyword
    AutoTreadmill  = false,  -- nongkrong di treadmill (latih Speed)

    -- Keyword pencocokan nama (lowercase, plain text)
    EggKeywords       = {"egg", "nest"},
    TreadmillKeywords = {"treadmill", "training"},
    PromptKeywords    = {"steal", "grab", "take", "collect", "claim", "hatch", "place", "pick"},
    IgnoreKeywords    = {"fake", "decoy", "troll", "trap", "shop", "buy", "sell", "sign"},

    -- MACRO MODE (default ON) — simulasi input manusia, bukan panggilan API langsung.
    -- Ini yang bikin jejaknya lebih kecil, BUKAN bypass anticheat.
    MacroMode          = true,
    MacroMinDelay      = 0.35,  -- jeda minimum antar aksi (detik)
    MacroMaxDelay      = 1.15,  -- jeda maksimum antar aksi
    MacroMaxFirePerMin = 25,    -- batas prompt-fire per menit
    MacroKeyHoldMin    = 0.06,  -- durasi tahan tombol minimum
    MacroKeyHoldMax    = 0.16,  -- durasi tahan tombol maksimum

    -- Angka-angka
    MaxFarmDistance  = 800,  -- studs; egg lebih jauh dari ini diabaikan
    CarryTimeoutSec  = 240,  -- reset status "bawa egg" setelah sekian detik
    BaseSafeRadius   = 25,   -- egg sedekat ini dari base dianggap punya sendiri
    EggScanSec       = 5,    -- interval scan egg
    PromptScanSec    = 3,    -- interval scan prompt
    TreadmillScanSec = 60,   -- interval scan treadmill
    UnstuckCheckSec  = 20,
    RejoinCheckSec   = 60,
    ScanNodeLimit    = 20000, -- batas node di-scan biar nggak lag

    BasePosition     = nil,  -- diisi via tombol [SET BASE] atau auto-detect
}

-- ============================= SERVICES =============================
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TeleportService    = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local UserInputService   = game:GetService("UserInputService")
local VirtualUser        = game:GetService("VirtualUser")
local Workspace          = game:GetService("Workspace")

local LP = Players.LocalPlayer

-- ============================= STATE =============================
local state = {
    running         = true,
    startTime       = os.time(),
    lastAction      = "booting...",
    eggsGrabbed     = 0,
    promptsFired    = 0,
    carrying        = false,
    carrySince      = 0,
    eggCache        = {},
    eggCacheTime    = 0,
    promptCache     = {},
    promptCacheTime = 0,
    promptLastFire  = setmetatable({}, {__mode = "k"}),
    tmCache         = nil,
    tmCacheTime     = 0,
    lastPos         = nil,
    stuckCount      = 0,
    rejoins         = 0,
    noCharSince     = nil,
}

local conns = {}          -- semua koneksi, buat unload bersih
local guiObj = nil        -- ScreenGui
local statusLabel = nil   -- label status di GUI
local toggleRefresh = {}  -- fungsi refresh indikator toggle

-- ============================= UTIL =============================
local function lower(s)
    return string.lower(tostring(s or ""))
end

local function containsAny(txt, keywords)
    for _, kw in ipairs(keywords) do
        if #kw > 0 and string.find(txt, lower(kw), 1, true) then
            return true
        end
    end
    return false
end

local function matches(name, keywords)
    return containsAny(lower(name), keywords)
end

local function isIgnored(obj)
    local o = obj
    local depth = 0
    while o and o ~= Workspace and depth < 4 do
        if matches(o.Name, CONFIG.IgnoreKeywords) then
            return true
        end
        o = o.Parent
        depth = depth + 1
    end
    return false
end

local function getChar()
    local c = LP.Character
    if c and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChild("HumanoidRootPart") then
        return c, c.HumanoidRootPart, c:FindFirstChildOfClass("Humanoid")
    end
    return nil, nil, nil
end

local function getPos(obj)
    if not obj or not obj.Parent then return nil end
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local ok, pivot = pcall(function() return obj:GetPivot() end)
        if ok then return pivot.Position end
        local pp = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
        if pp then return pp.Position end
    end
    return nil
end

local function inCharacter(obj)
    local o = obj
    while o do
        if o:IsA("Model") and Players:GetPlayerFromCharacter(o) then
            return true
        end
        o = o.Parent
    end
    return false
end

-- BFS seluruh workspace dengan batas node, biar nggak freeze di server gede
local function deepScan(visitor)
    local count = 0
    local stack = {Workspace}
    while #stack > 0 do
        local node = table.remove(stack)
        count = count + 1
        if count > CONFIG.ScanNodeLimit then break end
        local ok, children = pcall(function() return node:GetChildren() end)
        if ok then
            for _, c in ipairs(children) do
                pcall(visitor, c)
                table.insert(stack, c)
            end
        end
    end
end

-- ============================= MOVEMENT =============================
local function moveStep(targetPos)
    -- satu langkah pathfinding (non-blocking). return true kalau sudah dekat.
    local char, root, hum = getChar()
    if not root or not hum or hum.Health <= 0 then return false end
    local dist = (root.Position - targetPos).Magnitude
    if dist < 6 then
        return true
    end
    local point = targetPos
    pcall(function()
        local path = PathfindingService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
        })
        path:ComputeAsync(root.Position, targetPos)
        if path.Status == Enum.PathStatus.Success then
            local wps = path:GetWaypoints()
            if #wps >= 2 then
                point = wps[2].Position
            end
        end
    end)
    hum:MoveTo(point)
    return false
end

local function rejoin(reason)
    state.rejoins = state.rejoins + 1
    state.lastAction = "rejoining (" .. tostring(reason) .. ")"
    task.wait(1)
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LP)
    end)
end

-- ============================= PROMPT =============================
-- rate limiter: manusia nggak bisa nekan E 200x per menit
local fireTimes = {}
local function fireRateBlocked()
    if not CONFIG.MacroMode then return false end
    local now = os.clock()
    local kept, n = {}, 0
    for _, t in ipairs(fireTimes) do
        if now - t < 60 then
            n = n + 1
            table.insert(kept, t)
        end
    end
    fireTimes = kept
    return n >= CONFIG.MacroMaxFirePerMin
end

local function macroWait(minD, maxD)
    task.wait(math.random() * (maxD - minD) + minD)
end

local function firePrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    pcall(function() prompt.HoldDuration = 0 end)

    local fired = false
    if CONFIG.MacroMode then
        -- MACRO: kirim event tombol kayak manusia yang nekan E.
        -- fireproximityprompt sengaja di-skip: itu panggilan executor
        -- langsung ke fungsi game, dan itu sinyal termurah buat di-flag.
        local okVim, vim = pcall(function() return game:GetService("VirtualInputManager") end)
        if okVim and vim then
            local kc = prompt.KeyboardKeyCode or Enum.KeyCode.E
            pcall(function() vim:SendKeyEvent(true, kc, false, game) end)
            macroWait(CONFIG.MacroKeyHoldMin, CONFIG.MacroKeyHoldMax)
            pcall(function() vim:SendKeyEvent(false, kc, false, game) end)
            fired = true
        elseif type(fireproximityprompt) == "function" then
            -- executor nggak punya VirtualInputManager -> last resort
            fired = pcall(fireproximityprompt, prompt)
        end
    else
        if type(fireproximityprompt) == "function" then
            fired = pcall(fireproximityprompt, prompt)
        end
        if not fired then
            local okVim, vim = pcall(function() return game:GetService("VirtualInputManager") end)
            if okVim and vim then
                local kc = prompt.KeyboardKeyCode or Enum.KeyCode.E
                pcall(function()
                    vim:SendKeyEvent(true, kc, false, game)
                    vim:SendKeyEvent(false, kc, false, game)
                end)
                fired = true
            end
        end
    end

    if fired then
        state.promptsFired = state.promptsFired + 1
        table.insert(fireTimes, os.clock())
        local txt = lower(prompt.ActionText) .. "|" .. lower(prompt.ObjectText) .. "|"
            .. lower(prompt.Name) .. "|" .. lower(prompt.Parent and prompt.Parent.Name)
        state.lastAction = "prompt: " .. tostring(prompt.ActionText or prompt.Name)
        if string.find(txt, "steal", 1, true) or string.find(txt, "grab", 1, true)
            or string.find(txt, "take", 1, true) or string.find(txt, "pick", 1, true) then
            state.carrying = true
            state.carrySince = os.time()
        end
        if string.find(txt, "place", 1, true) or string.find(txt, "hatch", 1, true) then
            if state.carrying then
                state.carrying = false
                state.lastAction = "egg placed/hatched 🐣"
            end
        end
    end
    return fired
end

local function refreshPromptCache()
    local now = os.clock()
    if now - state.promptCacheTime < CONFIG.PromptScanSec then return end
    state.promptCacheTime = now
    local list = {}
    deepScan(function(d)
        if d.ClassName == "ProximityPrompt" and #list < 300 then
            table.insert(list, d)
        end
    end)
    state.promptCache = list
end

-- Update check: DATA ONLY. Ambil string versi, bandingkan. Nggak pernah
-- execute kode dari internet — auto-update yang load+run remote code itu
-- jalur masuk malware, apalagi kalau repo-nya bisa di-push orang lain.
local function checkUpdate()
    state.lastAction = "cek update..."
    local ok, body = pcall(function() return game:HttpGet(VERSION_URL, true) end)
    if not ok or type(body) ~= "string" then
        state.lastAction = "cek update gagal (offline/diblokir)"
        warn("[EGG HUB] update check gagal:", body)
        return
    end
    local remoteVer = string.match(body, "^%s*([%w%.%-]+)")
    if not remoteVer then
        state.lastAction = "VERSION file formatnya aneh"
        return
    end
    if remoteVer == SCRIPT_VERSION then
        state.lastAction = "up to date (v" .. SCRIPT_VERSION .. ")"
        print("[EGG HUB] up to date: v" .. SCRIPT_VERSION)
    else
        state.lastAction = "UPDATE ADA: v" .. remoteVer .. " (lu: v" .. SCRIPT_VERSION .. ")"
        warn("[EGG HUB] versi baru di repo: v" .. remoteVer .. " — lu pakai v" .. SCRIPT_VERSION
            .. ". Download ulang ManzzyEggHub.lua, BACA diff-nya, baru execute.")
    end
end

local function processPrompts(radiusOverride)
    -- auto-fire prompt yang cocok keyword di sekitar player
    if not CONFIG.AutoPrompt then return end
    if fireRateBlocked() then
        state.lastAction = "rate limit — nunggu cooldown macro"
        return
    end
    local char, root = getChar()
    if not root then return end
    refreshPromptCache()
    local now = os.clock()
    for _, prompt in ipairs(state.promptCache) do
        pcall(function()
            if prompt.Parent and prompt.Enabled then
                local holder = prompt.Parent
                local pos = getPos(holder)
                if not pos and holder:IsA("Attachment") then
                    pos = holder.WorldPosition
                end
                if pos then
                    local baseD = prompt.MaxActivationDistance or 10
                    -- macro mode: jangan pernah fire dari luar jangkauan prompt.
                    -- Fire dari jarak jauh itu bukti paling jelas bukan manusia.
                    local maxD = CONFIG.MacroMode and baseD or (radiusOverride or (baseD + 3))
                    if (root.Position - pos).Magnitude <= maxD then
                        local txt = lower(prompt.ActionText) .. "|" .. lower(prompt.ObjectText)
                            .. "|" .. lower(holder.Name) .. "|" .. lower(prompt.Name)
                        if not matches(txt, CONFIG.IgnoreKeywords)
                            and containsAny(txt, CONFIG.PromptKeywords) then
                            local last = state.promptLastFire[prompt] or 0
                            local gap = CONFIG.MacroMode and (2 + math.random() * 2.5) or 2
                            if now - last > gap then
                                state.promptLastFire[prompt] = now
                                firePrompt(prompt)
                                if CONFIG.MacroMode then
                                    macroWait(CONFIG.MacroMinDelay, CONFIG.MacroMaxDelay)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- ============================= EGG FARM =============================
local function refreshEggCache()
    local now = os.clock()
    if now - state.eggCacheTime < CONFIG.EggScanSec then return end
    state.eggCacheTime = now
    local list = {}
    deepScan(function(d)
        if #list >= 200 then return end
        if d:IsA("BasePart") or d:IsA("Model") then
            if matches(d.Name, CONFIG.EggKeywords) and not isIgnored(d) and not inCharacter(d) then
                local p = getPos(d)
                if p then
                    table.insert(list, {obj = d, pos = p})
                end
            end
        end
    end)
    state.eggCache = list
end

local function findNearestEgg()
    refreshEggCache()
    local char, root = getChar()
    if not root then return nil end
    local best, bestDist = nil, CONFIG.MaxFarmDistance
    for _, e in ipairs(state.eggCache) do
        if e.obj and e.obj.Parent then
            local p = getPos(e.obj) or e.pos
            if p then
                local isOwnBase = CONFIG.BasePosition and not state.carrying
                    and (p - CONFIG.BasePosition).Magnitude < CONFIG.BaseSafeRadius
                if not isOwnBase then
                    local d = (root.Position - p).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = {obj = e.obj, pos = p, dist = d}
                    end
                end
            end
        end
    end
    return best
end

local function tryGrab(entry)
    local obj = entry.obj
    local fired = false
    pcall(function()
        for _, d in ipairs(obj:GetDescendants()) do
            if d.ClassName == "ProximityPrompt" and not fired then
                if firePrompt(d) then fired = true end
            end
        end
        if not fired and obj:IsA("ProximityPrompt") then
            fired = firePrompt(obj)
        end
    end)
    if fired then
        state.eggsGrabbed = state.eggsGrabbed + 1
        state.carrying = true
        state.carrySince = os.time()
        state.lastAction = "grabbed: " .. tostring(obj.Name) .. " 🥚"
        return true
    end
    -- fallback: sentuh objectnya langsung (kalau game pakai touch-based pickup)
    local char, root, hum = getChar()
    if root and hum then
        local p = getPos(obj)
        if p and (root.Position - p).Magnitude < 10 then
            hum:MoveTo(p)
            state.lastAction = "touching: " .. tostring(obj.Name)
        end
    end
    return false
end

-- ============================= TREADMILL =============================
local function findTreadmill()
    local now = os.clock()
    if state.tmCache and now - state.tmCacheTime < CONFIG.TreadmillScanSec then
        return state.tmCache
    end
    local char, root = getChar()
    if not root then return nil end
    state.tmCacheTime = now
    local best, bestDist = nil, math.huge
    deepScan(function(d)
        if d:IsA("BasePart") and matches(d.Name, CONFIG.TreadmillKeywords) and not isIgnored(d) then
            local dd = (root.Position - d.Position).Magnitude
            if dd < bestDist then
                bestDist = dd
                best = d
            end
        end
    end)
    state.tmCache = best
    return best
end

-- ============================= BASE =============================
local function autoDetectBase()
    if CONFIG.BasePosition then return end
    pcall(function()
        local names = {}
        if #LP.Name > 0 then table.insert(names, lower(LP.Name)) end
        local okDn, dn = pcall(function() return LP.DisplayName end)
        if okDn and dn and #dn > 0 and dn ~= LP.Name then
            table.insert(names, lower(dn))
        end
        if #names == 0 then return end
        for _, d in ipairs(Workspace:GetChildren()) do
            if matches(d.Name, names) then
                local p = getPos(d)
                if p then
                    CONFIG.BasePosition = p
                    state.lastAction = "base auto-detected 📍"
                end
            end
            pcall(function()
                for _, c in ipairs(d:GetChildren()) do
                    if not CONFIG.BasePosition and matches(c.Name, names) then
                        local p2 = getPos(c)
                        if p2 then
                            CONFIG.BasePosition = p2
                            state.lastAction = "base auto-detected 📍"
                        end
                    end
                end
            end)
        end
    end)
end

local function setBaseHere()
    local char, root = getChar()
    if root then
        CONFIG.BasePosition = root.Position
        state.lastAction = "base diset manual 📍"
    else
        state.lastAction = "gagal set base: no character"
    end
end

-- ============================= DEBUG =============================
local function debugDump()
    print("==== MANZZY EGG HUB — DEBUG DUMP ====")
    print("Game:", game.Name, "| PlaceId:", game.PlaceId)
    local eggs, prompts, tms = 0, 0, 0
    local samples = {}
    deepScan(function(d)
        if d.ClassName == "ProximityPrompt" then
            prompts = prompts + 1
            if #samples < 30 then
                table.insert(samples, "[PROMPT] action='" .. tostring(d.ActionText)
                    .. "' object='" .. tostring(d.ObjectText) .. "' parent=" .. d.Parent:GetFullName())
            end
        elseif d:IsA("BasePart") or d:IsA("Model") then
            if matches(d.Name, CONFIG.EggKeywords) then
                eggs = eggs + 1
                if #samples < 45 then table.insert(samples, "[EGG?] " .. d:GetFullName()) end
            end
            if matches(d.Name, CONFIG.TreadmillKeywords) then
                tms = tms + 1
                if #samples < 50 then table.insert(samples, "[TREADMILL?] " .. d:GetFullName()) end
            end
        end
    end)
    print("Matched → eggs:", eggs, "| prompts:", prompts, "| treadmills:", tms)
    for _, s in ipairs(samples) do print(s) end
    print("==== END DUMP — kirim output ini buat tuning keyword ====")
    state.lastAction = "debug dump dicetak ke console"
    if type(setclipboard) == "function" then
        pcall(setclipboard, "eggs=" .. eggs .. " prompts=" .. prompts .. " treadmills=" .. tms)
    end
end

-- ============================= PROTEKSI AFK =============================
local function setupAntiAfk()
    table.insert(conns, LP.Idled:Connect(function()
        if CONFIG.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(math.random(1, 400), math.random(1, 400)))
            end)
        end
    end))
end

local function setupAntiKick()
    if not CONFIG.AntiKick then return false end
    local ok = pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" and self == LP then
                state.lastAction = "blocked a kick attempt 🛡️"
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
    return ok
end

-- ============================= LOOPS =============================
local function brain()
    while state.running do
        pcall(function()
            local char, root, hum = getChar()
            if not root or not hum then return end
            if hum.Health <= 0 then
                state.lastAction = "mati — nunggu respawn"
                return
            end

            -- selalu proses prompt di sekitar (hatch/place/collect dsb)
            processPrompts(nil)

            -- kalau lagi bawa egg → pulang
            if state.carrying and CONFIG.AutoReturn then
                if os.time() - state.carrySince > CONFIG.CarryTimeoutSec then
                    state.carrying = false
                    state.lastAction = "carry timeout — reset"
                elseif CONFIG.BasePosition then
                    local d = (root.Position - CONFIG.BasePosition).Magnitude
                    if d < 15 then
                        state.lastAction = "di base — place/hatch egg"
                        processPrompts(20)
                    else
                        moveStep(CONFIG.BasePosition)
                        state.lastAction = string.format("pulang ke base (%.0f studs)", d)
                        return
                    end
                end
            end

            -- farming egg
            if CONFIG.AutoFarm and not state.carrying then
                local egg = findNearestEgg()
                if egg then
                    if egg.dist < 10 then
                        tryGrab(egg)
                    else
                        moveStep(egg.pos)
                        state.lastAction = string.format("menuju egg (%.0f studs)", egg.dist)
                    end
                    return
                end
                if state.lastAction ~= "training on treadmill" then
                    state.lastAction = "nggak ada egg terdeteksi — scanning"
                end
            end

            -- treadmill
            if CONFIG.AutoTreadmill then
                local tm = findTreadmill()
                if tm and tm.Parent then
                    local d = (root.Position - tm.Position).Magnitude
                    if d > 5 then
                        moveStep(tm.Position)
                        state.lastAction = "jalan ke treadmill"
                    else
                        hum:MoveTo(tm.Position)
                        state.lastAction = "training on treadmill 🏃"
                    end
                else
                    state.lastAction = "treadmill nggak ketemu — cek DEBUG DUMP"
                end
            end
        end)
        if CONFIG.MacroMode then
            macroWait(CONFIG.MacroMinDelay + 0.4, CONFIG.MacroMaxDelay + 0.4)
        else
            task.wait(0.75)
        end
    end
end

local function unstuckLoop()
    while state.running do
        task.wait(CONFIG.UnstuckCheckSec)
        if CONFIG.AutoUnstuck then
            pcall(function()
                local char, root, hum = getChar()
                if not root or not hum or hum.Health <= 0 then return end
                if string.find(state.lastAction, "treadmill", 1, true) then return end
                if not CONFIG.AutoFarm then return end
                local p = root.Position
                if state.lastPos then
                    if (p - state.lastPos).Magnitude < 3 then
                        state.stuckCount = state.stuckCount + 1
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        local dir = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5)
                        if dir.Magnitude > 0.01 then
                            if CONFIG.MacroMode then
                                -- MACRO: jalan biasa ke titik acak. TANPA nulis CFrame —
                                -- lompat 15 studs sekali frame itu signature teleport.
                                hum:MoveTo(root.Position + dir.Unit * 12)
                            else
                                pcall(function()
                                    root.CFrame = root.CFrame * CFrame.new(dir.Unit * 15)
                                end)
                            end
                        end
                        state.lastAction = "unstuck #" .. state.stuckCount
                        if state.stuckCount >= 4 and CONFIG.AutoRejoin then
                            state.stuckCount = 0
                            rejoin("stuck 4x")
                        end
                    else
                        state.stuckCount = 0
                    end
                end
                state.lastPos = p
            end)
        end
    end
end

local function watchdogLoop()
    while state.running do
        task.wait(CONFIG.RejoinCheckSec)
        pcall(function()
            -- karakter hilang terlalu lama → rejoin
            local char = getChar()
            if not char then
                state.noCharSince = state.noCharSince or os.time()
                if os.time() - state.noCharSince > 90 and CONFIG.AutoRejoin then
                    state.noCharSince = nil
                    rejoin("no character 90s")
                end
            else
                state.noCharSince = nil
            end
            -- input palsu berkala biar server-side idle check aman
            if CONFIG.AntiAFK then
                pcall(function()
                    VirtualUser:CaptureController()
                end)
            end
            autoDetectBase()
        end)
    end
end

local function fmtTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = math.floor(sec % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function statusLoop()
    while state.running do
        if statusLabel and statusLabel.Parent then
            local carryTxt = state.carrying and "[BAWA EGG 🥚] " or ""
            statusLabel.Text = string.format(
                "⏱ AFK: %s | Eggs: %d | Prompts: %d | Rejoin: %d\n%s%s",
                fmtTime(os.time() - state.startTime),
                state.eggsGrabbed, state.promptsFired, state.rejoins,
                carryTxt, state.lastAction
            )
        end
        task.wait(1)
    end
end

-- ============================= GUI =============================
local function parentGui(gui)
    local ok1 = pcall(function() gui.Parent = gethui() end)
    if ok1 and gui.Parent then return end
    local ok2 = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if ok2 and gui.Parent then return end
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local function buildGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ManzzyEggHub"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    parentGui(gui)
    guiObj = gui

    local win = Instance.new("Frame")
    win.Parent = gui
    win.Size = UDim2.new(0, 290, 0, 442)
    win.Position = UDim2.new(0.5, -145, 0.5, -221)
    win.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    win.BorderSizePixel = 0
    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 10)
    winCorner.Parent = win
    local winStroke = Instance.new("UIStroke")
    winStroke.Color = Color3.fromRGB(90, 70, 160)
    winStroke.Thickness = 1.5
    winStroke.Parent = win

    -- title bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = win
    titleBar.Size = UDim2.new(1, 0, 0, 34)
    titleBar.BackgroundColor3 = Color3.fromRGB(45, 35, 80)
    titleBar.BorderSizePixel = 0
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 10)
    tbCorner.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -30, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "🥚 MANZZY EGG HUB"
    title.TextColor3 = Color3.fromRGB(255, 220, 120)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left

    local minBtn = Instance.new("TextButton")
    minBtn.Parent = titleBar
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -28, 0, 5)
    minBtn.BackgroundColor3 = Color3.fromRGB(70, 55, 120)
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 13
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minBtn

    -- body
    local body = Instance.new("Frame")
    body.Parent = win
    body.Position = UDim2.new(0, 0, 0, 34)
    body.Size = UDim2.new(1, 0, 1, -34)
    body.BackgroundTransparency = 1

    minBtn.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        win.Size = body.Visible and UDim2.new(0, 290, 0, 442) or UDim2.new(0, 290, 0, 34)
    end)

    -- draggable
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    table.insert(conns, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))

    -- toggles
    local rows = {
        {"Anti AFK",        "AntiAFK"},
        {"Anti Kick",       "AntiKick"},
        {"Macro Mode 🐢",   "MacroMode"},
        {"Auto Farm Egg",   "AutoFarm"},
        {"Auto Return",     "AutoReturn"},
        {"Auto Prompt",     "AutoPrompt"},
        {"Auto Treadmill",  "AutoTreadmill"},
        {"Auto Unstuck",    "AutoUnstuck"},
        {"Auto Rejoin",     "AutoRejoin"},
    }
    local y = 6
    for _, row in ipairs(rows) do
        local label, key = row[1], row[2]
        local btn = Instance.new("TextButton")
        btn.Parent = body
        btn.Position = UDim2.new(0, 8, 0, y)
        btn.Size = UDim2.new(1, -16, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(36, 36, 48)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent = btn

        local lbl = Instance.new("TextLabel")
        lbl.Parent = btn
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.Size = UDim2.new(0.6, 0, 1, 0)
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local ind = Instance.new("TextLabel")
        ind.Parent = btn
        ind.BackgroundTransparency = 1
        ind.Position = UDim2.new(0.6, 0, 0, 0)
        ind.Size = UDim2.new(0.4, -10, 1, 0)
        ind.Font = Enum.Font.GothamBold
        ind.TextSize = 12
        ind.TextXAlignment = Enum.TextXAlignment.Right

        local function refresh()
            ind.Text = CONFIG[key] and "ON" or "OFF"
            ind.TextColor3 = CONFIG[key] and Color3.fromRGB(90, 220, 120)
                or Color3.fromRGB(140, 140, 150)
        end
        btn.MouseButton1Click:Connect(function()
            CONFIG[key] = not CONFIG[key]
            refresh()
        end)
        refresh()
        table.insert(toggleRefresh, refresh)
        y = y + 26
    end

    -- tombol aksi
    local actions = {
        {"SET BASE 📍",  setBaseHere},
        {"DEBUG DUMP",   debugDump},
        {"CHECK UPDATE", checkUpdate},
        {"REJOIN 🔄",    function() rejoin("manual") end},
        {"UNLOAD ✖",     function() unload() end},
    }
    y = y + 2
    for i, act in ipairs(actions) do
        local col = (i - 1) % 2
        local rowIdx = math.floor((i - 1) / 2)
        local btn = Instance.new("TextButton")
        btn.Parent = body
        btn.Position = UDim2.new(col * 0.5, 8 + col * 2, 0, y + rowIdx * 26)
        btn.Size = UDim2.new(0.5, -12, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(58, 45, 100)
        btn.BorderSizePixel = 0
        btn.Text = act[1]
        btn.TextColor3 = Color3.from(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = true
        local bc2 = Instance.new("UICorner")
        bc2.CornerRadius = UDim.new(0, 6)
        bc2.Parent = btn
        btn.MouseButton1Click:Connect(act[2])
    end
    y = y + 82

    -- status
    statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = body
    statusLabel.Position = UDim2.new(0, 8, 0, y)
    statusLabel.Size = UDim2.new(1, -16, 0, 46)
    statusLabel.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    statusLabel.BorderSizePixel = 0
    statusLabel.TextColor3 = Color3.fromRGB(160, 200, 255)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 11
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextYAlignment = Enum.TextYAlignment.Top
    statusLabel.Text = "booting..."
    local slCorner = Instance.new("UICorner")
    slCorner.CornerRadius = UDim.new(0, 6)
    slCorner.Parent = statusLabel
    local slPad = Instance.new("UIPadding")
    slPad.PaddingLeft = UDim.new(0, 6)
    slPad.PaddingTop = UDim.new(0, 4)
    slPad.Parent = statusLabel

    -- credit
    local credit = Instance.new("TextLabel")
    credit.Parent = body
    credit.Position = UDim2.new(0, 0, 1, -16)
    credit.Size = UDim2.new(1, 0, 0, 14)
    credit.BackgroundTransparency = 1
    credit.Text = "made for Manzzy 🫡 — hermes agent"
    credit.TextColor3 = Color3.fromRGB(110, 110, 130)
    credit.Font = Enum.Font.Gotham
    credit.TextSize = 10
end

function unload()
    state.running = false
    for _, c in ipairs(conns) do
        pcall(function() c:Disconnect() end)
    end
    if guiObj then
        pcall(function() guiObj:Destroy() end)
    end
    print("[MANZZY EGG HUB] unloaded — semua loop & GUI dibersihin.")
end

-- ============================= RESPAWN =============================
table.insert(conns, LP.CharacterAdded:Connect(function()
    state.carrying = false
    state.stuckCount = 0
    state.lastPos = nil
    state.noCharSince = nil
    state.lastAction = "respawn — lanjut AFK"
end))

-- ============================= INIT =============================
setupAntiAfk()
local kickProtected = setupAntiKick()
autoDetectBase()
buildGui()

task.spawn(brain)
task.spawn(unstuckLoop)
task.spawn(watchdogLoop)
task.spawn(statusLoop)

print("===========================================")
print("🥚 MANZZY EGG HUB v" .. SCRIPT_VERSION .. " loaded!")
print("   Macro mode: " .. (CONFIG.MacroMode and "ON (input-level, no CFrame writes)" or "OFF (direct API calls)"))
print("   Anti-AFK: ON | Anti-Kick: " .. (kickProtected and "ON (protected)" or "OFF (executor nggak support)"))
print("   Atur semuanya lewat GUI di layar.")
print("   AFK 24/7: taruh script ini di folder AUTO-EXECUTE executor lu.")
print("   Deteksi egg/treadmill nggak jalan? Pencet DEBUG DUMP, kirim outputnya.")
print("===========================================")
