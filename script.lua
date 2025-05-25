print("Loading..")

-- service
    local others = game:GetService("Players")
    local rs = game:GetService("RunService")
    local debris = game:GetService("Debris")
    local me = others.LocalPlayer
    local char, hum, hrp, remote, anim

-- ui library
    local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/turtle"))()

-- toggles
    local invis_explosion_en = false
    local anti_decoy_c4_en = false
    local minigun_aura_en = false
    local anti_death_en = false
    local dash_anim_en = false

-- connections
    local anti_decoy_c4_conn = nil
    local minigun_aura_conn = nil

-- setting
    local radius = 60

-- functions
    local function minigun_aura()
        if me.Character ~= nil then
            pcall(function()
                hrp = me.Character.HumanoidRootPart
                local minigun
                if me.Character:FindFirstChild("Minigun") then minigun = workspace:FindFirstChild(me.Name).Minigun else return end
                if minigun then remote = minigun.RemoteFunction else return end
                for i, other in pairs(others:GetPlayers()) do
                    if other ~= me and other.Character ~= nil then
                        local p_hrp = other.Character.HumanoidRootPart
                        if (p_hrp.Position - hrp.Position).Magnitude <= radius and p_hrp.Position.Y < 500 then
                            if other.Character.Humanoid.Health ~= 0 and not other.Character:FindFirstChild("ForceField") then
                                remote:InvokeServer(p_hrp.Position + p_hrp.Velocity/5); task.wait()
                            end
                        end
                    end
                end
            end)
        else return end; task.wait()
    end

-- gui
    local w = l:Window("Attack")
    local w2 = l:Window("Defense")
    local w3 = l:Window("Fun")

    w:Button("Get minigun", function()
        me.PlayerGui.Select.Frame.RemoteEvent:FireServer("Minigun"); task.wait(.1)
        me.PlayerGui.Select.Frame.RemoteEvent:FireServer("Spear")
    end)

    w:Toggle("Minigun aura", false, function(e) 
        minigun_aura_en = e; if minigun_aura_en then minigun_aura_conn = rs.Heartbeat:Connect(function() minigun_aura() end)
        elseif minigun_aura_conn then minigun_aura_conn:Disconnect() end
    end)

    w:Slider("Aura radius",0,500,60, function(value) radius = value end)

    w2:Toggle("Anti death", false, function(e) 
        anti_death_en = e; if anti_death_en then
            if me.Character ~= nil and anti_death_en then
                hrp = me.Character.HumanoidRootPart
                local old_pos = hrp.Position.Y
                while anti_death_en do
                    pcall(function()
                        hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z + 50)
                        task.wait(0.1)
                        hrp.CFrame = CFrame.new(hrp.Position.X + 50, 100, hrp.Position.Z)
                        task.wait(0.1)
                        hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                        task.wait(0.1)
                        hrp.CFrame = CFrame.new(hrp.Position.X - 50, 50, hrp.Position.Z)
                        task.wait(0.1)
                        hrp.CFrame = CFrame.new(hrp.Position.X, old_pos, hrp.Position.Z - 50)
                        task.wait()
                    end); task.wait()
                end
            end
        end
    end)

    w2:Toggle("Invis explosion", false, function(e) 
        invis_explosion_en = e
        workspace.ChildAdded:Connect(function(child)
            if child.Name == "Explosion" and invis_explosion_en then
                child.BlastRadius = 0
                child.BlastPressure = 0
                child.TimeScale = 0
                child.Visible = false
            end
        end)
    end)

    w3:Toggle("Loop dash", false, function(e) 
        dash_anim_en = e; if me.Character ~= nil and dash_anim_en then
            dash_anim = Instance.new("Animation")
            dash_anim.AnimationId = "rbxassetid://6237974108"
            dash_animer = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator")
            dash_anim_track = dash_animer:LoadAnimation(dash_anim)
            me.Character.Humanoid.WalkSpeed = 50
            while dash_anim_en do
                pcall(function()
                    task.wait(0.2)
                    dash_anim_track:Play()
                end)
            end
        else
            dash_anim_track:Stop()
            me.Character.Humanoid.WalkSpeed = 16
        end
    end)



print("Loaded!")
