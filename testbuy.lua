-- ================================================
-- 📱 MOBILE COMPATIBLE SMART BYPASS v3.1
-- ⚡ RANDOM PATTERNS EDITION
-- ⚡ WORKING WITH: loadstring(game:HttpGet(""))()
-- ================================================

-- First, check if we're on mobile
local isMobile = false
pcall(function()
    isMobile = game:GetService("UserInputService").TouchEnabled
end)

print("📱 Mobile Mode:", isMobile)

-- Use safe service getting
local function getService(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    return success and service or nil
end

-- Get services safely
local Players = getService("Players")
local HttpService = getService("HttpService")
local ReplicatedStorage = getService("ReplicatedStorage")
local UserInputService = getService("UserInputService") or {TouchEnabled = false}

if not Players or not ReplicatedStorage then
    print("❌ Essential services not available")
    return
end

local plr = Players.LocalPlayer
if not plr then
    print("❌ Player not found")
    return
end

-- Simplified configuration for mobile
local MOBILE_CONFIG = {
    Version = "RANDOM_v3.1",
    MaxRuntime = 60, -- Shorter for mobile
    MaxRequests = 2, -- Slower for mobile
    UseSimpleUI = true
}

-- Mobile-optimized variables
local attackActive = false
local attackStartTime = 0

-- ================================================
-- 🎲 RANDOM PATTERN GENERATOR
-- ================================================

-- Generate RANDOM payloads each time
local function generateRandomPayloads(productId)
    -- All possible payload structures
    local allPatterns = {
        -- Pattern 1: Simple ID
        function(id) return id end,
        
        -- Pattern 2: Table with 'id'
        function(id) return {id = id} end,
        
        -- Pattern 3: Table with 'productId'
        function(id) return {productId = id} end,
        
        -- Pattern 4: Table with 'itemId'
        function(id) return {itemId = id} end,
        
        -- Pattern 5: Table with 'assetId'
        function(id) return {assetId = id} end,
        
        -- Pattern 6: Table with 'gamepassId'
        function(id) return {gamepassId = id} end,
        
        -- Pattern 7: String version
        function(id) return tostring(id) end,
        
        -- Pattern 8: Table with extra data
        function(id) return {
            id = id,
            player = plr.Name,
            timestamp = os.time()
        } end,
        
        -- Pattern 9: Nested table
        function(id) return {
            purchase = {
                item = id,
                price = 0
            }
        } end,
        
        -- Pattern 10: Minimal
        function(id) return {i = id} end
    }
    
    -- Shuffle patterns randomly (Fisher-Yates shuffle)
    local shuffled = {}
    for i = 1, #allPatterns do
        table.insert(shuffled, allPatterns[i])
    end
    
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    
    -- Generate 3-5 random payloads
    local numPayloads = math.random(3, 5)
    local payloads = {}
    
    for i = 1, numPayloads do
        local patternFunc = shuffled[i]
        if patternFunc then
            local payload = patternFunc(productId)
            
            -- Add random metadata 30% of the time
            if math.random(1, 10) <= 3 and type(payload) == "table" then
                payload._r = math.random(1000, 9999)
                payload._t = os.time()
            end
            
            table.insert(payloads, payload)
        end
    end
    
    print("🎲 Generated", #payloads, "random patterns")
    return payloads
end

-- ================================================
-- 📱 MOBILE-OPTIMIZED FUNCTIONS
-- ================================================

-- Safe request function for mobile
local function mobileSafeRequest(func)
    if attackActive then
        local currentTime = os.clock()
        -- Simple rate limiting
        task.wait(0.5 + math.random() * 0.5)
        
        local success, result = pcall(func)
        return success and result or nil
    end
    return nil
end

-- ================================================
-- 📊 LIVE REPORT SYSTEM (NEW ADDITION)
-- ================================================

-- دالة لإنشاء تقرير بسيط تحت الواجهة
local function createLiveReport(resultText)
    -- انتظر قليلاً حتى تظهر الواجهة الأساسية
    task.wait(0.5)
    
    -- ابحث عن الواجهة الرئيسية
    local gui = plr.PlayerGui:FindFirstChild("MobileBypassUI")
    if not gui then return end
    
    local mainFrame = gui:FindFirstChild("Frame")
    if not mainFrame then return end
    
    -- أزل أي تقرير قديم
    local oldReport = mainFrame:FindFirstChild("LiveReport")
    if oldReport then
        oldReport:Destroy()
    end
    
    -- أنشئ تقرير جديد
    local report = Instance.new("TextLabel")
    report.Name = "LiveReport"
    report.Text = "📊 النتائج الحية:\n" .. resultText
    report.Size = UDim2.new(0.8, 0, 0.35, 0)
    report.Position = UDim2.new(0.1, 0, 1.05, 0) -- تحت الواجهة مباشرة
    report.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    report.TextColor3 = Color3.new(1, 1, 1)
    report.Font = Enum.Font.Gotham
    report.TextSize = 12
    report.TextWrapped = true
    report.BorderSizePixel = 0
    report.TextXAlignment = Enum.TextXAlignment.Center
    report.TextYAlignment = Enum.TextYAlignment.Top
    report.Parent = mainFrame
    
    -- تلقائياً يختفي بعد 10 ثواني
    task.spawn(function()
        task.wait(10)
        if report then
            report:Destroy()
        end
    end)
    
    return report
end

-- دالة مساعدة للحصول على اسم النمط
local function getPatternName(payload)
    local pType = type(payload)
    if pType == "table" then
        local keys = {}
        for k, _ in pairs(payload) do
            table.insert(keys, k)
        end
        table.sort(keys)
        return "جدول {" .. table.concat(keys, ",") .. "}"
    elseif pType == "string" then
        return "نص"
    elseif pType == "number" then
        return "رقم"
    else
        return pType
    end
end

-- Mobile-optimized attack WITH RANDOM PATTERNS AND LIVE REPORTS
local function MOBILE_BYPASS_ATTACK(productId)
    if attackActive then
        return {"❌ Attack already running"}
    end
    
    attackActive = true
    attackStartTime = os.time()
    local results = {}
    local patternResults = {}
    
    -- Auto-stop timer for mobile
    task.spawn(function()
        while attackActive do
            task.wait(1)
            if os.time() - attackStartTime >= MOBILE_CONFIG.MaxRuntime then
                attackActive = false
                print("⏰ Mobile auto-stop")
                break
            end
        end
    end)
    
    -- 🔄 GENERATE NEW RANDOM PAYLOADS EACH TIME
    local mobilePayloads = generateRandomPayloads(productId)
    
    -- Try to find remotes safely
    task.spawn(function()
        local remotesFound = 0
        
        if ReplicatedStorage then
            -- Get all remotes first
            local allRemotes = {}
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    table.insert(allRemotes, remote)
                end
            end
            
            -- Shuffle remotes randomly too
            for i = #allRemotes, 2, -1 do
                local j = math.random(1, i)
                allRemotes[i], allRemotes[j] = allRemotes[j], allRemotes[i]
            end
            
            remotesFound = #allRemotes
            
            -- Try random remotes with random patterns
            for remoteIndex, remote in ipairs(allRemotes) do
                if not attackActive then break end
                
                -- Try different payloads in random order
                local payloadsCopy = {}
                for i, p in ipairs(mobilePayloads) do
                    payloadsCopy[i] = p
                end
                
                -- Shuffle payloads for this remote
                for i = #payloadsCopy, 2, -1 do
                    local j = math.random(1, i)
                    payloadsCopy[i], payloadsCopy[j] = payloadsCopy[j], payloadsCopy[i]
                end
                
                for patternIndex, payload in ipairs(payloadsCopy) do
                    if not attackActive then break end
                    
                    local patternStart = os.clock()
                    
                    local result = mobileSafeRequest(function()
                        local success = pcall(function()
                            remote:FireServer(payload)
                        end)
                        
                        -- إذا نجح، احسب الوقت وأنشئ تقرير
                        if success then
                            local patternTime = os.clock() - patternStart
                            local patternName = getPatternName(payload)
                            
                            -- سجل النتيجة
                            local resultMsg = string.format(
                                "✅ النمط %d نجح\n⏱️ الوقت: %.3f ثانية\n📁 Remote: %s",
                                patternIndex,
                                patternTime,
                                remote.Name
                            )
                            
                            table.insert(patternResults, resultMsg)
                            
                            -- أظهر التقرير المباشر
                            createLiveReport(
                                "🎉 نجاح!\n" ..
                                "النمط: " .. patternName .. "\n" ..
                                "الوقت: " .. string.format("%.3f", patternTime) .. " ثانية\n" ..
                                "Remote: " .. remote.Name
                            )
                            
                            -- طباعة في الكونسول أيضاً
                            print(string.format("[✅] النمط %d نجح خلال %.3f ثانية - %s", 
                                patternIndex, patternTime, remote.Name))
                        end
                        
                        return success and "🎲→" .. remote.Name or nil
                    end)
                    
                    if result then
                        table.insert(results, result)
                        break
                    end
                    
                    task.wait(0.3 + math.random() * 0.2) -- Random delay
                end
            end
        end
        
        print("📱 Remotes scanned:", remotesFound)
        
        -- بعد انتهاء الهجوم، أظهر ملخص النتائج
        if #patternResults > 0 then
            local summary = "🎯 ملخص النتائج:\n"
            for i, res in ipairs(patternResults) do
                summary = summary .. "\n" .. res
            end
            
            createLiveReport(summary)
            print("\n" .. summary)
        else
            local runTime = os.time() - attackStartTime
            local noSuccessMsg = string.format("❌ لم ينجح أي نمط\n⏱️ وقت التشغيل: %d ثانية", runTime)
            createLiveReport(noSuccessMsg)
            print(noSuccessMsg)
        end
        
        attackActive = false
    end)
    
    -- Wait for attack to complete
    local waitTime = 0
    while attackActive and waitTime < MOBILE_CONFIG.MaxRuntime do
        task.wait(1)
        waitTime = waitTime + 1
    end
    
    return results
end

-- ================================================
-- 📱 MOBILE SIMPLE UI
-- ================================================

local function CREATE_MOBILE_UI()
    -- Remove existing UI
    if plr.PlayerGui:FindFirstChild("MobileBypassUI") then
        plr.PlayerGui.MobileBypassUI:Destroy()
    end
    
    -- Create simple UI
    local gui = Instance.new("ScreenGui")
    gui.Name = "MobileBypassUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main container
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0.9, 0, 0.35, 0)
    main.Position = UDim2.new(0.05, 0, 0.1, 0)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    main.BorderSizePixel = 0
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "🎲 RANDOM BYPASS"
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    
    -- Input for ID
    local input = Instance.new("TextBox")
    input.PlaceholderText = "Enter ID here..."
    input.Text = ""
    input.Size = UDim2.new(0.8, 0, 0.2, 0)
    input.Position = UDim2.new(0.1, 0, 0.25, 0)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    
    -- Start button
    local button = Instance.new("TextButton")
    button.Text = "🎲 START RANDOM"
    button.Size = UDim2.new(0.8, 0, 0.25, 0)
    button.Position = UDim2.new(0.1, 0, 0.5, 0)
    button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Text = "Ready - Random patterns"
    status.Size = UDim2.new(0.8, 0, 0.15, 0)
    status.Position = UDim2.new(0.1, 0, 0.8, 0)
    status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    status.TextColor3 = Color3.new(1, 1, 1)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    
    -- Close button
    local close = Instance.new("TextButton")
    close.Text = "X"
    close.Size = UDim2.new(0.1, 0, 0.15, 0)
    close.Position = UDim2.new(0.85, 0, 0.02, 0)
    close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.TextColor3 = Color3.new(1, 1, 1)
    close.Font = Enum.Font.GothamBold
    
    -- Assemble UI
    title.Parent = main
    input.Parent = main
    button.Parent = main
    status.Parent = main
    close.Parent = main
    main.Parent = gui
    gui.Parent = plr.PlayerGui
    
    -- Button functionality
    button.MouseButton1Click:Connect(function()
        if attackActive then
            status.Text = "Please wait..."
            return
        end
        
        local targetId = tonumber(input.Text)
        if not targetId then
            status.Text = "Enter valid number"
            task.wait(1.5)
            status.Text = "Ready"
            return
        end
        
        button.Text = "🎲 GENERATING..."
        button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        status.Text = "Creating random patterns..."
        
        task.spawn(function()
            -- Small delay to show "generating" message
            task.wait(0.5)
            
            status.Text = "Random attack started"
            
            local results = MOBILE_BYPASS_ATTACK(targetId)
            
            if #results > 0 then
                status.Text = "✅ " .. #results .. " random hits"
                status.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                
                -- Print results to output
                for _, r in ipairs(results) do
                    print("[RANDOM] " .. r)
                end
            else
                status.Text = "❌ No success"
                status.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            end
            
            button.Text = "🎲 START RANDOM"
            button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            
            task.wait(3)
            status.Text = "Ready - Random patterns"
            status.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end)
    end)
    
    -- Close button
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    print("✅ Mobile UI created (Random Edition)")
    return gui
end

-- ================================================
-- 📱 INITIALIZATION FOR MOBILE
-- ================================================

print("\n" .. string.rep("=", 50))
print("🎲 RANDOM PATTERN BYPASS LOADED")
print("⚡ Different patterns EVERY time")
print("📱 Optimized for mobile")
print("📊 Live reporting system ENABLED")
print(string.rep("=", 50))

-- Wait a bit then create UI
task.wait(2)

if plr and plr.PlayerGui then
    CREATE_MOBILE_UI()
    
    -- Mobile notification
    task.spawn(function()
        local notify = Instance.new("TextLabel")
        notify.Text = "🎲 Random Patterns Ready\n📊 Live Reports Enabled"
        notify.Size = UDim2.new(0.7, 0, 0.07, 0)
        notify.Position = UDim2.new(0.15, 0, 0.05, 0)
        notify.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
        notify.TextColor3 = Color3.new(1, 1, 1)
        notify.Font = Enum.Font.GothamBold
        notify.TextSize = 12
        notify.TextWrapped = true
        notify.Parent = plr.PlayerGui
        
        task.wait(4)
        pcall(function() notify:Destroy() end)
    end)
else
    print("⚠️ Could not create UI - using console mode")
    print("Type: MobileBypass(123) to test ID 123")
end

-- Export functions
_G.MobileBypass = MOBILE_BYPASS_ATTACK
_G.MobileStatus = function()
    return {
        active = attackActive,
        runtime = attackActive and (os.time() - attackStartTime) or 0
    }
end

-- Test function to see random patterns
_G.TestPatterns = function(id)
    local patterns = generateRandomPayloads(id or 123)
    print("\n🎲 Random Patterns for ID:", id)
    for i, p in ipairs(patterns) do
        print(i .. ":", p)
    end
    return patterns
end

print("\n✅ READY! Use on mobile with: loadstring(game:HttpGet('URL'))()")
print("🎲 Every attack uses DIFFERENT random patterns")
print("📊 Live reports appear BELOW the interface")
return "🎲 Random Pattern Bypass v3.1 with Live Reports Loaded"
