local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JumpBoostUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.05, 0, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 50, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "Jump Boost"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(180, 255, 200)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 5)
title.Size = UDim2.new(0, 120, 0, 25)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(0, 135, 0, 5)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.BackgroundColor3 = Color3.fromRGB(40, 80, 50)
minimize.Parent = frame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimize

local unload = Instance.new("TextButton")
unload.Size = UDim2.new(0, 60, 0, 25)
unload.Position = UDim2.new(0, 170, 0, 5)
unload.Text = "Unload"
unload.Font = Enum.Font.Gotham
unload.TextSize = 14
unload.TextColor3 = Color3.fromRGB(255, 255, 255)
unload.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
unload.Parent = frame

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 6)
unloadCorner.Parent = unload

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 16
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.BackgroundColor3 = Color3.fromRGB(60, 100, 70)
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggle

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0, 200, 0, 10)
sliderBack.Position = UDim2.new(0, 10, 0, 85)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 100, 70)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = sliderBack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack

local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(0, 6)
sliderFillCorner.Parent = sliderFill

local jumpPowerLabel = Instance.new("TextLabel")
jumpPowerLabel.Text = "Jump Power: 55"
jumpPowerLabel.Font = Enum.Font.Gotham
jumpPowerLabel.TextSize = 16
jumpPowerLabel.TextColor3 = Color3.fromRGB(180, 255, 200)
jumpPowerLabel.BackgroundTransparency = 1
jumpPowerLabel.Position = UDim2.new(0, 10, 0, 95)
jumpPowerLabel.Size = UDim2.new(1, -20, 0, 25)
jumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpPowerLabel.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Type value (1-100)"
inputBox.Text = "55"
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 16
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 80, 50)
inputBox.Position = UDim2.new(0, 10, 0, 120)
inputBox.Size = UDim2.new(0, 200, 0, 25)
inputBox.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputBox

local credits = Instance.new("TextLabel")
credits.Text = "GreekNinja30 X ThanasisYAMA"
credits.Font = Enum.Font.GothamBold
credits.TextSize = 14
credits.TextColor3 = Color3.fromRGB(0, 255, 128)
credits.BackgroundTransparency = 1
credits.Position = UDim2.new(0, 10, 0, 150)
credits.Size = UDim2.new(1, -20, 0, 20)
credits.TextXAlignment = Enum.TextXAlignment.Left
credits.Parent = frame

local jumpEnabled = false
local jumpPower = 55
local maxPower = 100
local humanoid = nil

local UIS = game:GetService("UserInputService")
local draggingSlider = false

local function updateSlider(value)
	sliderFill.Size = UDim2.new(value / maxPower, 0, 1, 0)
	jumpPowerLabel.Text = "Jump Power: " .. math.floor(value)
end

local function toggleJump()
	jumpEnabled = not jumpEnabled
	if jumpEnabled then
		toggle.Text = "ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = jumpPower
		end
	else
		toggle.Text = "OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(60, 100, 70)
		if humanoid then
			humanoid.JumpPower = 50
		end
	end
end

toggle.MouseButton1Click:Connect(toggleJump)

sliderBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relPos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		jumpPower = math.floor(relPos * maxPower)
		updateSlider(jumpPower)
		inputBox.Text = tostring(jumpPower)
		if jumpEnabled and humanoid then
			humanoid.JumpPower = jumpPower
		end
	end
end)

inputBox.FocusLost:Connect(function(enterPressed)
	local num = tonumber(inputBox.Text)
	if num then
		num = math.clamp(num, 1, maxPower)
		jumpPower = num
		updateSlider(jumpPower)
		if jumpEnabled and humanoid then
			humanoid.JumpPower = jumpPower
		end
	else
		inputBox.Text = tostring(jumpPower)
	end
end)

player.CharacterAdded:Connect(function(char)
	humanoid = char:WaitForChild("Humanoid")
	if jumpEnabled then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = jumpPower
	end
end)

if player.Character then
	humanoid = player.Character:WaitForChild("Humanoid")
end

updateSlider(jumpPower)

minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
	local reopen = Instance.new("TextButton")
	reopen.Size = UDim2.new(0, 100, 0, 30)
	reopen.Position = UDim2.new(0.05, 0, 0.9, 0)
	reopen.Text = "Open Jump Boost"
	reopen.Font = Enum.Font.GothamBold
	reopen.TextSize = 16
	reopen.BackgroundColor3 = Color3.fromRGB(40, 80, 50)
	reopen.TextColor3 = Color3.fromRGB(255, 255, 255)
	reopen.Parent = screenGui
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = reopen
	reopen.MouseButton1Click:Connect(function()
		frame.Visible = true
		reopen:Destroy()
	end)
end)

unload.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
