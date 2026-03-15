local screenGui = Instance.new("ScreenGui")
screenGui.Name = "car Fly dedsamodell.paid"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 10) -- правый верхний угол
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.Text = "≡"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton


local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui


local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame
shadow.ZIndex = -1


local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Text = "dedsamodell.car fly free version 0.9"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = mainFrame

-- Скругление заголовка
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- При нажатии на кнопку показывать/скрывать меню
toggleButton.MouseButton1Click:Connect(function(H)
    mainFrame.Visible = not mainFrame.Visible
end)


local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = scrollFrame

local vehicleSettings = {
    enabled = false,
    noClip = false,
    speed = 100,
    verticalSpeed = 30,
    activeVehicles = {},
    lastScan = 0,
    flightActive = false,
    stabilize = true
}

local function createToggle(name, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 35)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = scrollFrame
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 0, 0, 0)
    toggleText.BackgroundTransparency = 1
    toggleText.Text = text
    toggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleText.Font = Enum.Font.SourceSans
    toggleText.TextSize = 14
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    toggleText.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.25, 0, 0.7, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 12
    toggleButton.Name = name
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        local newState = not (toggleButton.Text == "ON")
        toggleButton.BackgroundColor3 = newState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 0, 0)
        toggleButton.Text = newState and "ON" or "OFF"
        callback(newState)
    end)
    
    return toggleButton
end


local function createSlider(name, text, min, max, default, suffix, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = scrollFrame
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.Position = UDim2.new(0, 0, 0, 0)
    sliderText.BackgroundTransparency = 1
    sliderText.Text = text
    sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderText.Font = Enum.Font.SourceSans
    sliderText.TextSize = 14
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    sliderText.Parent = sliderFrame
    
    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(1, 0, 0, 20)
    valueText.Position = UDim2.new(0, 0, 0, 20)
    valueText.BackgroundTransparency = 1
    valueText.Text = default .. suffix
    valueText.TextColor3 = Color3.fromRGB(200, 200, 200)
    valueText.Font = Enum.Font.SourceSans
    valueText.TextSize = 12
    valueText.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = fill
    
    local dragging = false
    
    local function updateSlider(xPosition)
        local relativeX = math.clamp((xPosition - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relativeX)
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        valueText.Text = value .. suffix
        callback(value)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    return sliderBg
end


local function createSeparator()
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    separator.BorderSizePixel = 0
    separator.Parent = scrollFrame
    return separator
end

createToggle("enableSystem", "Включить систему полёта", false, function(state)
    vehicleSettings.enabled = state
    if state then
        scanForVehicles()
        game.StarterGui:SetCore("SendNotification", {
            Title = "car Fly",
            Text = "Найдено транспорта: "..#vehicleSettings.activeVehicles,
            Duration = 2
        })
    else
        for _, vehicle in pairs(vehicleSettings.activeVehicles) do
            if vehicle.mainPart then
                vehicle.mainPart.AssemblyLinearVelocity = Vector3.zero
                vehicle.mainPart.AssemblyAngularVelocity = Vector3.zero
            end
        end
        vehicleSettings.flightActive = false
    end
end)

createToggle("flightActive", "Активировать полёт (B)", false, function(state)
    vehicleSettings.flightActive = state
end)

createSeparator()

createToggle("stabilize", "Автовыравнивание", true, function(state)
    vehicleSettings.stabilize = state
end)

createSeparator()

createSlider("speed", "Скорость полёта", 15, 500, 100, " studs/s", function(value)
    vehicleSettings.speed = value
end)

createSlider("verticalSpeed", "Вертикальная скорость", 10, 100, 30, " studs/s", function(value)
    vehicleSettings.verticalSpeed = value
end)

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 0, 30)
infoText.Position = UDim2.new(0, 10, 1, -35)
infoText.BackgroundTransparency = 1
infoText.Text = "≡ (кнопка справа вверху) - скрыть/показать меню\nB - включить/выключить полёт"
infoText.TextColor3 = Color3.fromRGB(180, 180, 180)
infoText.Font = Enum.Font.SourceSans
infoText.TextSize = 12
infoText.TextXAlignment = Enum.TextXAlignment.Center
infoText.Parent = mainFrame


local function scanForVehicles()
    if tick() - vehicleSettings.lastScan < 2 then return end
    vehicleSettings.lastScan = tick()
    
    vehicleSettings.activeVehicles = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local hasSeat = obj:FindFirstChildWhichIsA("VehicleSeat") or 
                          (obj:FindFirstChild("Seat") and obj.Seat:FindFirstChild("SeatWeld"))
            
            local isLikelyVehicle = obj:FindFirstChild("Body") or 
                                  obj:FindFirstChild("Main") or
                                  obj.Name:match("Car") or
                                  obj.Name:match("Vehicle")
            
            if hasSeat or isLikelyVehicle then
                local mainPart = obj.PrimaryPart or 
                               obj:FindFirstChild("Body") or
                               obj:FindFirstChildWhichIsA("BasePart", true)
                
                if mainPart then
                    table.insert(vehicleSettings.activeVehicles, {
                        model = obj,
                        mainPart = mainPart,
                        seat = hasSeat and (obj:FindFirstChildWhichIsA("VehicleSeat") or obj.Seat) or nil,
                        originalCFrame = mainPart.CFrame
                    })
                end
            end
        end
    end
end


local function stabilizeVehicle(vehicle)
    if not vehicleSettings.stabilize then return end
    
    local mainPart = vehicle.mainPart
    if not mainPart then return end
    
    local currentCF = mainPart.CFrame
    mainPart.CFrame = CFrame.new(
        currentCF.Position,
        currentCF.Position + Vector3.new(0, 0, -1)
    )
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        vehicleSettings.flightActive = not vehicleSettings.flightActive
        game.StarterGui:SetCore("SendNotification", {
            Title = "Vehicle Fly",
            Text = "Полёт "..(vehicleSettings.flightActive and "включен" or "выключен"),
            Duration = 2
        })
    end
end)


game:GetService("RunService").Heartbeat:Connect(function()
    if not vehicleSettings.enabled then return end
    
    if tick() - vehicleSettings.lastScan > 5 then
        scanForVehicles()
    end

    for _, vehicle in pairs(vehicleSettings.activeVehicles) do
        stabilizeVehicle(vehicle)
        
        local hasDriver = false
        if vehicle.seat then
            if vehicle.seat:IsA("VehicleSeat") then
                hasDriver = vehicle.seat.Occupant ~= nil
            else
                hasDriver = vehicle.seat:FindFirstChild("SeatWeld") ~= nil
            end
        end

        if vehicleSettings.flightActive and (hasDriver or not vehicle.seat) then
            local cam = workspace.CurrentCamera
            local camDir = cam.CFrame.LookVector
            local moveDir = Vector3.new(camDir.X, 0, camDir.Z).Unit
            
            local velocity = Vector3.zero
            
            local userInputService = game:GetService("UserInputService")
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity += moveDir * vehicleSettings.speed
            elseif userInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity -= moveDir * vehicleSettings.speed
            end
            
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity -= Vector3.new(-moveDir.Z, 0, moveDir.X) * vehicleSettings.speed * 0.7
            elseif userInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity += Vector3.new(-moveDir.Z, 0, moveDir.X) * vehicleSettings.speed * 0.7
            end
            
            if userInputService:IsKeyDown(Enum.KeyCode.N) then
                velocity += Vector3.new(0, vehicleSettings.verticalSpeed, 0)
            elseif userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                velocity -= Vector3.new(0, vehicleSettings.verticalSpeed, 0)
            end
            
            vehicle.mainPart.AssemblyLinearVelocity = velocity
            vehicle.mainPart.AssemblyAngularVelocity = Vector3.zero

            if vehicleSettings.noClip and vehicle.mainPart.Position.Y < 5 then
                vehicle.mainPart.AssemblyLinearVelocity = Vector3.new(velocity.X, 10, velocity.Z)
            end
        else
            if vehicle.mainPart then
                vehicle.mainPart.AssemblyLinearVelocity = Vector3.zero
                vehicle.mainPart.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
end)


game:GetService("RunService").Heartbeat:Connect(function()
    if not vehicleSettings.enabled or not vehicleSettings.noClip then return end
    
    for _, vehicle in pairs(vehicleSettings.activeVehicles) do
        if vehicle.model then
            for _, part in pairs(vehicle.model:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)
