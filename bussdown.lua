local Players           = game:GetService("Players")
local Player            = Players.LocalPlayer
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService   = game:GetService("TextChatService")

for _, gui in ipairs(CoreGui:GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name == "AetherDeathProof" or gui.Name == "BustDownClient") then
        gui:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BustDownClient"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Target = nil
local BotActive = false
local DanceActive = false
local Connections = {}
local DanceTrack = nil
local SoloDanceTrack = nil
local CURRENT_DANCE_ID = "rbxassetid://118364690209655" 

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 500) 
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BUSS DOWN CLIENT v5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -25, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    StopBot()
    StopSoloDance()
end)

local Dragging = false
local DragInput, DragStart, StartPosition

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPosition = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)

local function UpdateDrag(input)
    if not Dragging then return end
    
    local delta = input.Position - DragStart
    Frame.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + delta.Y
    )
end

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        UpdateDrag(input)
    end
end)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0, 35)
SearchBox.PlaceholderText = "Search players..."
SearchBox.Text = ""
SearchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.Parent = Frame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.9, 0, 0, 200)
PlayerList.Position = UDim2.new(0.05, 0, 0, 75)
PlayerList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerList.ScrollBarThickness = 6
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = Frame

local DanceIdLabel = Instance.new("TextLabel")
DanceIdLabel.Size = UDim2.new(0.9, 0, 0, 20)
DanceIdLabel.Position = UDim2.new(0.05, 0, 0, 285)
DanceIdLabel.BackgroundTransparency = 1
DanceIdLabel.Text = "Dance Animation ID:"
DanceIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DanceIdLabel.TextSize = 12
DanceIdLabel.Font = Enum.Font.Gotham
DanceIdLabel.TextXAlignment = Enum.TextXAlignment.Left
DanceIdLabel.Parent = Frame

local DanceIdBox = Instance.new("TextBox")
DanceIdBox.Size = UDim2.new(0.9, 0, 0, 30)
DanceIdBox.Position = UDim2.new(0.05, 0, 0, 305)
DanceIdBox.PlaceholderText = "rbxassetid://118364690209655"
DanceIdBox.Text = CURRENT_DANCE_ID
DanceIdBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DanceIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DanceIdBox.TextSize = 12
DanceIdBox.Font = Enum.Font.Gotham
DanceIdBox.Parent = Frame

local CurrentDanceLabel = Instance.new("TextLabel")
CurrentDanceLabel.Size = UDim2.new(0.9, 0, 0, 15)
CurrentDanceLabel.Position = UDim2.new(0.05, 0, 0, 340)
CurrentDanceLabel.BackgroundTransparency = 1
CurrentDanceLabel.Text = "Current: 118364690209655"
CurrentDanceLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
CurrentDanceLabel.TextSize = 10
CurrentDanceLabel.Font = Enum.Font.Gotham
CurrentDanceLabel.TextXAlignment = Enum.TextXAlignment.Left
CurrentDanceLabel.Parent = Frame

local SoloDanceBtn = Instance.new("TextButton")
SoloDanceBtn.Size = UDim2.new(0.9, 0, 0, 30)
SoloDanceBtn.Position = UDim2.new(0.05, 0, 0, 360)
SoloDanceBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SoloDanceBtn.Text = "SOLO DANCE: OFF"
SoloDanceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SoloDanceBtn.TextSize = 14
SoloDanceBtn.Font = Enum.Font.GothamBold
SoloDanceBtn.Parent = Frame

local BotBtn = Instance.new("TextButton")
BotBtn.Size = UDim2.new(0.9, 0, 0, 40)
BotBtn.Position = UDim2.new(0.05, 0, 0, 395)
BotBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
BotBtn.Text = "DANCE BOT: OFF"
BotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BotBtn.TextSize = 16
BotBtn.Font = Enum.Font.GothamBold
BotBtn.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(0.9, 0, 0, 40)
Status.Position = UDim2.new(0.05, 0, 0, 445)
Status.BackgroundTransparency = 1
Status.Text = "Select a player to start"
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.TextSize = 14
Status.Font = Enum.Font.Gotham
Status.Parent = Frame

local function SendChat(msg)
    if not msg or msg == "" then return end
    pcall(function() if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then TextChatService.TextChannels.RBXGeneral:SendAsync(msg) end end)
    pcall(function() ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All") end)
    for _, v in ReplicatedStorage:GetDescendants() do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("say") or v.Name:lower():find("message")) then
            pcall(function() v:FireServer(msg, "All") end)
        end
    end
    pcall(function() Players:Chat(msg) end)
end

local function Notify(t, txt) 
    pcall(function() 
        game.StarterGui:SetCore("SendNotification", {
            Title = t, 
            Text = txt, 
            Duration = 3
        }) 
    end)
end

local function GetDanceIdNumber(danceId)
    local number = danceId:match("%d+")
    return number or "Invalid ID"
end

local function UpdateDanceId()
    local newId = DanceIdBox.Text
    if newId and newId ~= "" then
        if not newId:find("rbxassetid://") then
            if tonumber(newId) then
                newId = "rbxassetid://" .. newId
            end
        end
        
        CURRENT_DANCE_ID = newId
        local idNumber = GetDanceIdNumber(newId)
        CurrentDanceLabel.Text = "Current: " .. idNumber
      
        if BotActive and DanceTrack then
            DanceTrack:Stop()
            DanceTrack = nil
            StartDancing()
            Notify("Dance Updated", "Changed to ID: " .. idNumber, 2)
        end
        
        if DanceActive and SoloDanceTrack then
            SoloDanceTrack:Stop()
            SoloDanceTrack = nil
            StartSoloDance()
            Notify("Solo Dance Updated", "Changed to ID: " .. idNumber, 2)
        end
    end
end

DanceIdBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        UpdateDanceId()
    end
end)

local function StartSoloDance()
    if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = CURRENT_DANCE_ID
    SoloDanceTrack = Player.Character.Humanoid:LoadAnimation(anim)
    SoloDanceTrack.Priority = Enum.AnimationPriority.Action4
    SoloDanceTrack.Looped = true
    SoloDanceTrack:Play()
    DanceActive = true
    SoloDanceBtn.Text = "SOLO DANCE: ON"
    SoloDanceBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    Notify("SOLO DANCE", "Dancing solo! ID: " .. GetDanceIdNumber(CURRENT_DANCE_ID), 3)
end

local function StopSoloDance()
    DanceActive = false
    SoloDanceBtn.Text = "SOLO DANCE: OFF"
    SoloDanceBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    if SoloDanceTrack then 
        SoloDanceTrack:Stop() 
        SoloDanceTrack = nil 
    end
end
SoloDanceBtn.MouseButton1Click:Connect(function()
    if not DanceActive then
        if BotActive then
            StopBot()
        end
        StartSoloDance()
    else
        StopSoloDance()
    end
end)

local function StartDancing()
    if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = CURRENT_DANCE_ID
    DanceTrack = Player.Character.Humanoid:LoadAnimation(anim)
    DanceTrack.Priority = Enum.AnimationPriority.Action4
    DanceTrack.Looped = true
    DanceTrack:Play()
end

local function OnCharacterAdded(char)
    task.wait(1)
    if BotActive and Target then
        StartDancing()
    end
    if DanceActive then
        StartSoloDance()
    end
end

Player.CharacterAdded:Connect(OnCharacterAdded)

local function UpdateList(search)
    search = search:lower()
    PlayerList:ClearAllChildren()
    
    local yPos = 0
    local playerCount = 0
    
    for _, plr in Players:GetPlayers() do
        if plr ~= Player and (search == "" or plr.Name:lower():find(search) or plr.DisplayName:lower():find(search)) then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            
            btn.MouseButton1Click:Connect(function()
                Target = plr
                Status.Text = "Selected: " .. plr.DisplayName
            end)
            
            btn.Parent = PlayerList
            yPos = yPos + 35
            playerCount = playerCount + 1
        end
    end
    
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    UpdateList(SearchBox.Text)
end)

local function StartBot()
    if not Target or not Target.Character then 
        Notify("Error", "Select a player first!") 
        return 
    end

    if DanceActive then
        StopSoloDance()
    end

    BotActive = true
    BotBtn.Text = "DANCE BOT: ON ("..Target.DisplayName..")"
    BotBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)

    StartDancing()

    table.insert(Connections, RunService.Heartbeat:Connect(function()
        if not BotActive or not Target.Character or not Player.Character then return end
        local tRoot = Target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = Player.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and myRoot then
            myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
        end
    end))

    if Target then
        table.insert(Connections, Target.Chatted:Connect(function(msg)
            if BotActive then 
                task.spawn(SendChat, msg) 
            end
        end))
    end

    local idNumber = GetDanceIdNumber(CURRENT_DANCE_ID)
    Notify("BUST DOWN CLIENT", "Dancing on "..Target.DisplayName.. " (ID: "..idNumber..")", 5)
end

local function StopBot()
    BotActive = false
    Target = nil
    BotBtn.Text = "DANCE BOT: OFF"
    BotBtn.BackgroundColor3 = Color3.fromRGB(255,0,255)
    Status.Text = "Select a player to start"
    
    for _, c in pairs(Connections) do 
        if c.Connected then 
            c:Disconnect() 
        end 
    end
    Connections = {}
    
    if DanceTrack then 
        DanceTrack:Stop() 
        DanceTrack = nil 
    end
    
    Notify("Stopped", "Bot off", 2)
end

BotBtn.MouseButton1Click:Connect(function()
    if not BotActive then
        StartBot()
    else
        StopBot()
    end
end)

Players.PlayerAdded:Connect(function()
    UpdateList(SearchBox.Text)
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == Target then
        StopBot()
    end
    UpdateList(SearchBox.Text)
end)

UpdateList("")
CurrentDanceLabel.Text = "Current: " .. GetDanceIdNumber(CURRENT_DANCE_ID)
Notify("BUSS DOWN", "SHAKE SOME ASS NIGGA", 5)
