print("Loading..")

-- service
local others = game:GetService("Players")
local rs = game:GetService("RunService")
local me = others.LocalPlayer
local char, hum, hrp, minigun, remote, letsgo

-- ui library
local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/turtle"))()

-- toggles
local minigun_aura_en = false
local minigun_aura_conn = false
local anti_death_en = false

-- setting
local radius = 60

-- function
local function minigun_aura()
    if me.Character ~= nil then
        hrp = me.Character.HumanoidRootPart
        if me.Character:FindFirstChild("Minigun") then
            minigun = workspace:FindFirstChild(me.Name).Minigun
        else
            return
        end
        if minigun then
            remote = minigun.RemoteFunction
        else
            return
        end
        for i, other in pairs(others:GetPlayers()) do
            if other ~= me and other.Character ~= nil then
                local p_hrp = other.Character.HumanoidRootPart
                if (p_hrp.Position - hrp.Position).Magnitude <= radius then
                    if other.Character.Humanoid.Health ~= 0 and not other.Character:FindFirstChild("ForceField") then
                        remote:InvokeServer(p_hrp.Position + p_hrp.Velocity/3.5)
                        task.wait()
                    end
                end
            end
        end
    else
        return
    end
    task.wait()
end

-- gui
local w = l:Window("Pain")

w:Button("Get minigun", function()
    me.PlayerGui.Select.Frame.RemoteEvent:FireServer("Minigun")
end)

w:Toggle("Anti death", false, function(e) 
    anti_death_en = e
    while anti_death_en do
        if me.Character ~= nil and anti_death_en then
            hrp = me.Character.HumanoidRootPart
            local old_pos = hrp.Position.Y
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(hrp.Position.X + 50, 100, hrp.Position.Z)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(hrp.Position.X - 50, 50, hrp.Position.Z)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(hrp.Position.X, old_pos, hrp.Position.Z)
            task.wait()
        end
        task.wait()
    end
end)

w:Toggle("Minigun aura", false, function(e) 
    minigun_aura_en = e
    if minigun_aura_en then
        minigun_aura_conn = rs.Heartbeat:Connect(function()
            minigun_aura()
        end)
    else
        if minigun_aura_conn ~= nil then
            minigun_aura_conn:Disconnect()
        end
    end
end)

w:Slider("aura radius",0,500,60, function(value)
    radius = value
end)

print("Loaded!")
