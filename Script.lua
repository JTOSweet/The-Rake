local __lt = (function() 
    local globalEnv = (getgenv and getgenv()) or _G or {}
    local sharedEnv = rawget(_G, "shared")
    local cacheHost = type(sharedEnv) == "table" and sharedEnv or (type(globalEnv) == "table" and globalEnv or nil)
    
    if cacheHost then 
        local cached = rawget(cacheHost, "__lt_service_resolver")
        if type(cached) == "table" then return cached end
    end
    
    local loader = loadstring or load
    if type(loader) ~= "function" then error("Service resolver loader unavailable") end
    
    local resolver = loader(game:HttpGet("https://ltseverydayyou.github.io/ServiceResolver.luau"), "@ServiceResolver.luau")
    if type(resolver) ~= "function" then error("Service resolver failed to compile") end
    
    local loaded = resolver()
    if type(loaded) ~= "table" then error("Service resolver failed to load") end
    
    if cacheHost then cacheHost.__lt_service_resolver = loaded end
    return loaded
end)()

---@diagnostic disable: undefined-global
if game.GameId ~= 847722000 then return end
if getgenv().RakeGui then return end

local function ClonedService(name)
    local Service = function(_, serviceName) return __lt.gs(serviceName) end
    local Reference = (cloneref) or function(reference) return reference end
    return __lt.cs(name, Reference)
end0

pcall(function() getgenv().RakeGui = true end)

local Workspace = ClonedService("Workspace")
local Players = ClonedService("Players")
local RunService = ClonedService("RunService")
local UserInputService = ClonedService("UserInputService")
local ReplicatedStorage = ClonedService("ReplicatedStorage")
local TweenService = ClonedService("TweenService")

local LocalPlayer = Players.LocalPlayer
local AllowRunService = true

_G.FreeCam = false
_G.FreeCamSpeed = 0.2
_G.NoFog = false
_G.InfStamina = false
_G.InfNightVision = false
_G.ExtendedHitbox = false
_G.RakeKillAura = false
_G.RakeChams = false
_G.PlayerESP = false
_G.PlayerESPShowDistance = false
_G.FlareGunESP = false
_G.SupplyDropESP = false
_G.LocationESP = false
_G.ScrapESP = false
_G.BearTrapESP = false
_G.NoFallDMG = false
_G.InstaOpenSupplyDrop = false
_G.FieldOfView = 70
_G.enableFOV = false
_G.WalkSpeedd = 16
_G.enableSpeed = false

local HidePart = Instance.new("Part")
HidePart.Size = Vector3.new(20, 1000, 20)
HidePart.Position = Vector3.new(0, 10000, 0)
HidePart.Anchored = true
HidePart.Parent = Workspace

local HidePartHightLight = Instance.new("Highlight")
HidePartHightLight.Name = "HidePartHightLight"
HidePartHightLight.FillColor = Color3.new(255, 255, 255)
HidePartHightLight.OutlineColor = Color3.new(170, 0, 0)
HidePartHightLight.FillTransparency = 0.8
HidePartHightLight.OutlineTransparency = 0.8
HidePartHightLight.Parent = HidePart

local FreeCamPart = Instance.new("Part")
FreeCamPart.Anchored = true
FreeCamPart.Size = Vector3.new(1, 1, 1)
FreeCamPart.CFrame = CFrame.new(0, 10000, 0)
FreeCamPart.Transparency = 1
FreeCamPart.Name = "FreeCamPart"
FreeCamPart.Parent = Workspace

local Locations = {
    ["Power_Station"] = { Position = Vector3.new(-281.68, 21.50, -212.74), hasESP = false },
    ["Safe_House"]    = { Position = Vector3.new(-363.49, 16.87, 70.30), hasESP = false },
    ["Base_Camp"]     = { Position = Vector3.new(-70.71, 17.61, 209.00), hasESP = false },
    ["Shop"]          = { Position = Vector3.new(-25.15, 17.20, -258.36), hasESP = false }
}
	
local function GetHumanoid()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return false
end

local function GetRootPart()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function SetRootPartCFrame(cf)
    local hrp = GetRootPart()
    if hrp then hrp.CFrame = cf end
end

local function TweenPart(time, part, targetCFrame)
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
    local tween = __lt.cm("TweenService", "Create", part, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
end

local function DestroyUI()
    AllowRunService = false
    FreeCamPart:Remove()
    HidePart:Remove()
    
    for _, v in pairs(Workspace.Filter.ScrapSpawns:QueryDescendants("Instance")) do
        pcall(function()
            if v:GetAttribute("ScrapESP") == true then
                v:SetAttribute("ScrapESP", false)
            end
        end)
    end
    
    getgenv().RakeGui = false
    if Rayfield then Rayfield:Destroy() end
end

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/ltseverydayyou/Rayfield-backup/main/Rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = The Rake JTO",
    LoadingTitle = "Let's Larp",
    LoadingSubtitle = "Just This Once...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JTORake",
        FileName = "Rake"
    }
})

local PlayerTab = Window:CreateTab("Player", 11252440515)
local ClientTab = Window:CreateTab("Client", 4483345998)
local ExploitsTab = Window:CreateTab("Exploits", 11252440817)
local SettingsTab = Window:CreateTab("Settings", 11252440305)

ClientTab:CreateToggle({
    Name = "FreeCam",
    CurrentValue = false,
    Flag = "freeCam",
    Callback = function(state)
        _G.FreeCam = state
        if _G.FreeCam then
            pcall(function() FreeCamPart.CFrame = LocalPlayer.Character.Head.CFrame end)
            task.spawn(function()
                while _G.FreeCam do
                    task.wait()
                    pcall(function()
                        Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                        Workspace.CurrentCamera.CameraSubject = FreeCamPart
                        
                        local mouse = LocalPlayer:GetMouse()
                        GetRootPart().Anchored = true
                        FreeCamPart.CFrame = CFrame.new(FreeCamPart.Position, mouse.Hit.Position)
                        
                        if __lt.cm("UserInputService", "IsKeyDown", Enum.KeyCode.Space) then
                            TweenPart(0.04, FreeCamPart, FreeCamPart.CFrame + Vector3.new(0, _G.FreeCamSpeed, 0))
                        elseif __lt.cm("UserInputService", "IsKeyDown", Enum.KeyCode.LeftShift) then
                            TweenPart(0.04, FreeCamPart, FreeCamPart.CFrame + Vector3.new(0, -_G.FreeCamSpeed, 0))
                        end
                        
                        if __lt.cm("UserInputService", "IsKeyDown", Enum.KeyCode.W) then
                            TweenPart(0.04, FreeCamPart, FreeCamPart.CFrame + FreeCamPart.CFrame.LookVector * _G.FreeCamSpeed)
                        elseif __lt.cm("UserInputService", "IsKeyDown", Enum.KeyCode.S) then
                            TweenPart(0.04, FreeCamPart, FreeCamPart.CFrame + FreeCamPart.CFrame.LookVector * -_G.FreeCamSpeed)
                        end
                    end)
                end
                
                pcall(function()
                    GetRootPart().Anchored = false
                    Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                    Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Head
                end)
            end)
        end
    end,
})

ClientTab:CreateSlider({
    Name = "FreeCam Speed", Range = {0.01, 20}, Increment = 0.01, CurrentValue = 0.2, Flag = "Speed",
    Callback = function(Value) _G.FreeCamSpeed = Value end,
})

ClientTab:CreateToggle({
    Name = "No Fog", CurrentValue = false, Flag = "NoFog",
    Callback = function(state)
        _G.NoFog = state
        if not state then ReplicatedStorage.CurrentLightingProperties.FogEnd.Value = 75 end
    end,
})

ClientTab:CreateButton({
    Name = "Third Person",
    Callback = function()
        local sw = LocalPlayer.Character.RagdollTime.RagdollSwitch
        sw.Value = true
        sw.Value = false
    end,
})

ClientTab:CreateToggle({ Name = "Rake Chams", CurrentValue = false, Flag = "RakeChams", Callback = function(s) _G.RakeChams = s end })
ClientTab:CreateToggle({ Name = "Player ESP", CurrentValue = false, Flag = "PlrEsp", Callback = function(s) _G.PlayerESP = s end })
ClientTab:CreateToggle({ Name = "Show Distance Travelled", CurrentValue = false, Flag = "ShowDistanceTravelled", Callback = function(s) _G.PlayerESPShowDistance = s end })
ClientTab:CreateToggle({ Name = "Flare Gun ESP", CurrentValue = false, Flag = "FlareGunESP", Callback = function(s) _G.FlareGunESP = s end })
ClientTab:CreateToggle({ Name = "SupplyDrop ESP", CurrentValue = false, Flag = "SupplyDropESP", Callback = function(s) _G.SupplyDropESP = s end })
ClientTab:CreateToggle({ Name = "Location ESP", CurrentValue = false, Flag = "LocationESP", Callback = function(s) _G.LocationESP = s end })
ClientTab:CreateToggle({ Name = "Scrap ESP", CurrentValue = false, Flag = "ScrapESP", Callback = function(s) _G.ScrapESP = s end })
ClientTab:CreateToggle({ Name = "Bear Trap ESP", CurrentValue = false, Flag = "BearTrapESP", Callback = function(s) _G.BearTrapESP = s end })

PlayerTab:CreateToggle({
    Name = "Inf Stamina", CurrentValue = false, Flag = "InfStamina",
    Callback = function(state)
        _G.InfStamina = state
        if state then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "STAMINA_REGEN") then
                    v.STAMINA_REGEN = 100
                    v.JUMP_STAMINA = 0
                    v.JUMP_COOLDOWN = 0
                    v.STAMINA_TAKE = 0
                    v.stamina = 100
                end
            end
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "Inf Night Vision", CurrentValue = false, Flag = "InfNightVision",
    Callback = function(state)
        _G.InfNightVision = state
        if state then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "NVG_TAKE") then
                    v.NVG_TAKE = 0
                    v.NVG_REGEN = 100
                end
            end
        end
    end,
})

PlayerTab:CreateToggle({ Name = "No Fall Damage", CurrentValue = false, Flag = "NoFallDamage", Callback = function(s) _G.NoFallDMG = s end })
PlayerTab:CreateToggle({ Name = "Toggle FOV", CurrentValue = false, Flag = "tglFOV", Callback = function(s) _G.enableFOV = s end })
PlayerTab:CreateSlider({ Name = "Field Of View", Range = {0, 120}, Increment = 1, CurrentValue = 70, Flag = "FOV", Callback = function(s) _G.FieldOfView = s end })
PlayerTab:CreateToggle({ Name = "Toggle WalkSpeed", CurrentValue = false, Flag = "tglSpeed", Callback = function(s) _G.enableSpeed = s end })
PlayerTab:CreateSlider({ Name = "WalkSpeed", Range = {0, 30}, Increment = 1, CurrentValue = 16, Flag = "walkspeed", Callback = function(s) _G.WalkSpeedd = s end })

ExploitsTab:CreateToggle({
    Name = "Extended Hitbox",
    CurrentValue = false,
    Flag = "ExtHitbox",
    Callback = function(state)
        _G.ExtendedHitbox = state
        Rayfield:Notify({Title = "Hitbox", Content = "Extended Hitbox: " .. tostring(state), Duration = 2})
    end,
})

local KillAuraToggle = ExploitsTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "RakeAura",
    Callback = function(state)
        _G.RakeKillAura = state
        
        if state then
            task.spawn(function()
                while _G.RakeKillAura do
                    task.wait(0.1)
                    if _G.ExtendedHitbox then
                        pcall(function()
                            local rake = Workspace:FindFirstChild("Rake")
                            local hrp = GetRootPart()
                            if rake and hrp and (rake.HumanoidRootPart.Position - hrp.Position).Magnitude < 200 then
                                LocalPlayer.Character.StunStick.Event:FireServer("S")
                                task.wait()
                                LocalPlayer.Character.StunStick.Event:FireServer("H", rake.HumanoidRootPart) 
                            end
                        end)
                    end
                end
            end)
        end
    end,
})

ExploitsTab:CreateKeybind({
    Name = "Toggle Kill Aura",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Flag = "KillAuraKeybind",
    Callback = function() 
        KillAuraToggle:Set(not _G.RakeKillAura) 
    end,
})

ExploitsTab:CreateButton({
    Name = "Bring Scraps",
    Callback = function()
        for _, v in pairs(Workspace.Filter.ScrapSpawns:QueryDescendants("Instance")) do
            if v.Name:lower() == "scrap" then
                v:PivotTo(LocalPlayer.Character:GetPivot())
            end
        end
    end,
})

ExploitsTab:CreateButton({
    Name = "Remove Invis Walls",
    Callback = function()
        for _, v in pairs(Workspace.Filter.InvisibleWalls:GetChildren()) do
            if v.Name:lower() == "invisiblewall" or v.Name:lower() == "invis" then
                v:Remove()
            end
        end
    end,
})

ExploitsTab:CreateToggle({
    Name = "Hide", CurrentValue = false, Flag = "Hide",
    Callback = function(state)
        local hrp = GetRootPart()
        if not hrp then return end
        
        if state then
            hrp.Anchored = false
            for i = 1, 10 do
                hrp.CFrame = CFrame.new(hrp.Position) + Vector3.new(0, 5, 0)
                task.wait()
                hrp.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(0, -5, 0)
            end
            hrp.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(0, -15, 0)
            task.wait()
            hrp.Anchored = true
            HidePart.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, -505, 0)
            HidePartHightLight.Adornee = HidePart   
            HidePartHightLight.Parent = HidePart    
        else
            hrp.Anchored = false
            for i = 1, 10 do
                hrp.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(0, 5, 0)
                task.wait()
                hrp.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(0, -5, 0)
            end
            hrp.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) + Vector3.new(0, 15, 0)
            task.wait()
            hrp.Anchored = false
            HidePartHightLight.Adornee = nil    
            HidePartHightLight.Parent = nil     
        end
    end,
})

ExploitsTab:CreateToggle({ Name = "Insta Open SupplyDrop", CurrentValue = false, Flag = "InstaOpenSupplyDrop", Callback = function(s) _G.InstaOpenSupplyDrop = s end })

local RakeTargetCounter = ExploitsTab:CreateLabel("Rake's Target : ")
local TimeUntilDayCounter = ExploitsTab:CreateLabel("Time Until Day : ")

SettingsTab:CreateButton({ Name = "Unload Gui", Callback = DestroyUI })

local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt, false)

RunService.Heartbeat:Connect(function()
    if not AllowRunService then return end

    if _G.FlareGunESP then
        local flare = Workspace:FindFirstChild("FlareGunPickUp")
        if flare and not flare:GetAttribute("FlareGunESP") then
            flare:SetAttribute("FlareGunESP", true)
            local esp = Drawing.new("Text")
            esp.Text = "[ Flare Gun ]"
            esp.Color = Color3.fromRGB(0, 225, 255)
            esp.Center = true
            esp.Size = 13
            esp.Outline = true
            
            task.spawn(function()
                while _G.FlareGunESP and flare:IsDescendantOf(Workspace) do
                    local cam = Workspace.CurrentCamera
                    local pos, onScreen = cam:WorldToViewportPoint(flare.PrimaryPart.Position)
                    if onScreen then
                        esp.Visible = true
                        esp.Position = Vector2.new(pos.X, pos.Y)
                    else
                        esp.Visible = false
                    end
                    task.wait()
                end
                esp:Remove()
                flare:SetAttribute("FlareGunESP", false)
            end)
        end
    end

    if _G.RakeChams then
        local rake = Workspace:FindFirstChild("Rake")
        if rake and rake:FindFirstChild("Head") and not rake:GetAttribute("hasESP") then
            rake:SetAttribute("hasESP", true)
            local rakeEsp = Drawing.new("Text")
            rakeEsp.Color = Color3.fromRGB(255, 0, 0)
            rakeEsp.Center = true
            rakeEsp.Outline = true
            rakeEsp.Size = 14

            task.spawn(function()
                while _G.RakeChams and rake:IsDescendantOf(Workspace) do
                    local cam = Workspace.CurrentCamera
                    local pos, onScreen = cam:WorldToViewportPoint(rake.Head.Position)
                    if onScreen then
                        local health = rake:FindFirstChild("Monster") and rake.Monster.Health or 0
                        rakeEsp.Text = "Rake [HP: " .. math.floor(health) .. "]"
                        rakeEsp.Visible = true
                        rakeEsp.Position = Vector2.new(pos.X, pos.Y)
                    else
                        rakeEsp.Visible = false
                    end
                    task.wait()
                end
                rakeEsp:Remove()
                rake:SetAttribute("hasESP", false)
            end)
        end
    end
end)
	
RunService.Heartbeat:Connect(function()
    if not AllowRunService or not _G.PlayerESP then return end
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if not v.Character:GetAttribute("PlayerESP") then
                v.Character:SetAttribute("PlayerESP", true)
                local pEsp = Drawing.new("Text")
                pEsp.Color = Color3.fromRGB(0, 255, 100)
                pEsp.Center = true
                pEsp.Outline = true
                pEsp.Size = 13

                task.spawn(function()
                    while _G.PlayerESP and v.Character and v.Character:Parent() do
                        local cam = Workspace.CurrentCamera
                        local pos, onScreen = cam:WorldToViewportPoint(v.Character.Head.Position)
                        if onScreen then
                            pEsp.Visible = true
                            pEsp.Position = Vector2.new(pos.X, pos.Y)
                            if _G.PlayerESPShowDistance then
                                local dist = v:FindFirstChild("DistanceTravelled") and v.DistanceTravelled.Value or 0
                                pEsp.Text = v.Name .. " [" .. math.floor(dist) .. "m]"
                            else
                                pEsp.Text = v.Name
                            end
                        else
                            pEsp.Visible = false
                        end
                        task.wait()
                    end
                    pEsp:Remove()
                    if v.Character then v.Character:SetAttribute("PlayerESP", false) end
                end)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not AllowRunService then return end

    if _G.ScrapESP then
        for _, v in pairs(Workspace.Filter.ScrapSpawns:GetDescendants()) do
            if v.Name == "Scrap" and not v:GetAttribute("ScrapESP") then
                v:SetAttribute("ScrapESP", true)
                local sEsp = Drawing.new("Text")
                sEsp.Color = Color3.fromRGB(255, 200, 50)
                sEsp.Size = 12
                sEsp.Outline = true
                sEsp.Center = true
                
                local points = v.Parent:FindFirstChild("PointsVal") and v.Parent.PointsVal.Value or 0
                sEsp.Text = "Scrap [Pts: " .. points .. "]"

                task.spawn(function()
                    while _G.ScrapESP and v:IsDescendantOf(Workspace) do
                        local cam = Workspace.CurrentCamera
                        local pos, onScreen = cam:WorldToViewportPoint(v.Position)
                        if onScreen then
                            sEsp.Visible = true
                            sEsp.Position = Vector2.new(pos.X, pos.Y)
                        else
                            sEsp.Visible = false
                        end
                        task.wait()
                    end
                    sEsp:Remove()
                    v:SetAttribute("ScrapESP", false)
                end)
            end
        end
    end

	if _G.BearTrapESP == true then
        local trapFolder = ClonedService("Workspace").Debris:FindFirstChild("Traps")
        if trapFolder then
            for _, trap in pairs(trapFolder:GetChildren()) do
                if trap.Name == "RakeTrapModel" then
                    if not trap:FindFirstChild("TrapChams") then
                        local TrapChams = Instance.new("Highlight")
                        TrapChams.Name = "TrapChams"
                        TrapChams.Parent = trap
                        TrapChams.Adornee = trap
                        TrapChams.FillColor = Color3.fromRGB(255, 105, 180)
                        TrapChams.OutlineColor = Color3.fromRGB(255, 255, 255)
                        TrapChams.FillTransparency = 0.4
                        TrapChams.OutlineTransparency = 0
                        TrapChams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end
        end
    end
			
    if _G.SupplyDropESP then
        for _, v in pairs(Workspace.Debris.SupplyCrates:GetChildren()) do
            if v.Name == "Box" and not v:GetAttribute("SupplyDropESP") then
                v:SetAttribute("SupplyDropESP", true)
                local boxEsp = Drawing.new("Text")
                boxEsp.Text = "[ SUPPLY DROP ]"
                boxEsp.Color = Color3.fromRGB(255, 255, 0)
                boxEsp.Center = true
                boxEsp.Size = 14
                boxEsp.Outline = true

                task.spawn(function()
                    while _G.SupplyDropESP and v:IsDescendantOf(Workspace) do
                        local cam = Workspace.CurrentCamera
                        local pos, onScreen = cam:WorldToViewportPoint(v.HitBox.Position)
                        if onScreen then
                            boxEsp.Visible = true
                            boxEsp.Position = Vector2.new(pos.X, pos.Y)
                        else
                            boxEsp.Visible = false
                        end
                        task.wait()
                    end
                    boxEsp:Remove()
                    v:SetAttribute("SupplyDropESP", false)
                end)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not AllowRunService or not _G.LocationESP then return end
    
    for name, data in pairs(Locations) do
        if not data.hasESP then
            data.hasESP = true
            local locEsp = Drawing.new("Text")
            locEsp.Text = "[ " .. name:gsub("_", " ") .. " ]"
            locEsp.Color = Color3.fromRGB(255, 150, 0)
            locEsp.Center = true
            locEsp.Outline = true
            locEsp.Size = 14

            task.spawn(function()
                while _G.LocationESP do
                    local cam = Workspace.CurrentCamera
                    local pos, onScreen = cam:WorldToViewportPoint(data.Position)
                    if onScreen then
                        locEsp.Visible = true
                        locEsp.Position = Vector2.new(pos.X, pos.Y)
                    else
                        locEsp.Visible = false
                    end
                    task.wait()
                end
                locEsp:Remove()
                data.hasESP = false
            end)
        end
    end
end)

mt.__namecall = function(self, ...)
    if _G.NoFallDMG then
        local args = {...}
        if tostring(self) == "FD_Event" then
            args[1] = 0
            args[2] = 0
            return self.FireServer(self, unpack(args))
        end
    end
    return namecall(self, ...)
end

RunService.Heartbeat:Connect(function()
    if not AllowRunService then return end
    
    if _G.NoFog then ReplicatedStorage.CurrentLightingProperties.FogEnd.Value = 9e9 end

    if _G.ExtendedHitbox then
        pcall(function()
            local rake = Workspace:FindFirstChild("Rake")
            local stick = LocalPlayer.Character:FindFirstChild("StunStick")
            if rake and stick and stick:FindFirstChild("HitPart") then 
                stick.HitPart.Position = rake.HumanoidRootPart.Position 
            end
        end)
    end
			
    if _G.InstaOpenSupplyDrop then
        pcall(function()
            local prompt = Workspace.Debris.SupplyCrates.Box.GUIPart.ProximityPrompt
            for i, v in pairs(prompt:GetAttributes()) do prompt:SetAttribute(tostring(i), false) end
            Workspace.Debris.SupplyCrates.Box.UnlockValue.Value = 100
        end)
    end
    
    local nightVal = ReplicatedStorage.Night.Value
    local timeStr = nightVal and "Time Until Day : " or "Time Until Night : "
    TimeUntilDayCounter:Set(timeStr .. tostring(ReplicatedStorage.Timer.Value))
    
    pcall(function()
        local rake = Workspace:FindFirstChild("Rake")
        if rake and rake.TargetVal.Value then
            RakeTargetCounter:Set("Rake's Target : " .. tostring(rake.TargetVal.Value.Parent))
        end
    end)
    
    if ReplicatedStorage.InitiateBloodHour.Value then
        Rayfield:Notify({Title = "ALERT", Content = "HOLY JESUS BLOOD HOUR IS COMING NOW", Duration = 5, Image = 4483362458})
        ReplicatedStorage.InitiateBloodHour.Value = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not AllowRunService then return end
    
    if _G.enableFOV then
        TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0, Enum.EasingStyle.Linear), {FieldOfView = tonumber(_G.FieldOfView)}):Play()
    end
    
    if _G.enableSpeed and GetHumanoid() then
        GetHumanoid().WalkSpeed = tonumber(_G.WalkSpeedd)
    end
end)

Rayfield:LoadConfiguration()
