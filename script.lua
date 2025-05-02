print("Loading..")

-- service
local others = game:GetService("Players")
local rs = game:GetService("RunService")
local me = others.LocalPlayer
local char, hum, hrp, minigun, remote

-- ui library
local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/turtle"))()

-- toggles
local minigun_aura_en = false
local minigun_aura_conn = false

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
                    if other.Character.Humanoid.Health ~= 0 then
                        remote:InvokeServer(p_hrp.Position)
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

w:Slider("aura radius",0,300,60, function(value)
    radius = value
end)

print("Loaded!")
