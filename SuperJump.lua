local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

local MAX_POWER = 100
local DEFAULT_JUMP_POWER = 50
local COLORS = {
	Background = Color3.fromRGB(28, 30, 34),
	Primary = Color3.fromRGB(45, 48, 54),
	AccentOn = Color3.fromRGB(0, 255, 128),
	AccentOff = Color3.fromRGB(80, 80, 80),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 255, 200),
	Unload = Color3.fromRGB(190, 60, 60)
}

local jumpEnabled = false
local currentJumpPower = DEFAULT_JUMP_POWER
local draggingSlider = false
local connections = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JumpBoostUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 190)
frame.Position = UDim2.new(0.05, 0, 0.5, -95)
frame.BackgroundColor3 = COLORS.Background
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1
stroke.Parent = frame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundTransparency = 1
header.Parent = frame

local headerLayout = Instance.new("UIListLayout")
headerLayout.FillDirection = Enum.FillDirection.Horizontal
headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
headerLayout.Padding = UDim.new(0, 5)
headerLayout.Parent = header

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = header

local title = Instance.new("TextLabel")
title.Text = "Jump Boost"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = COLORS.TextSecondary
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -110, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = COLORS.TextPrimary
minimize.BackgroundColor3 = COLORS.Primary
minimize.Parent = header
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

local unload = Instance.new("TextButton")
unload.Size = UDim2.new(0, 70, 0, 25)
unload.Text = "Unload"
unload.Font = Enum.Font.GothamBold
unload.TextSize = 14
unload.TextColor3 = COLORS.TextPrimary
unload.BackgroundColor3 = COLORS.Unload
unload.Parent = header
Instance.new("UICorner", unload).CornerRadius = UDim.new(0, 6)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

local contentLayout = Instance.new("UIListLayout")
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = content

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, 0, 0, 30)
toggle.Text = "OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
toggle.TextColor3 = COLORS.TextPrimary
toggle.BackgroundColor3 = COLORS.AccentOff
toggle.Parent = content
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(1, 0, 0, 10)
sliderBack.BackgroundColor3 = COLORS.Primary
sliderBack.BorderSizePixel = 0
sliderBack.Parent = content
Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(0, 6)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = COLORS.AccentOn
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 6)

local jumpPowerLabel = Instance.new("TextLabel")
jumpPowerLabel.Text = "Jump Power: " .. DEFAULT_JUMP_POWER
jumpPowerLabel.Font = Enum.Font.Gotham
jumpPowerLabel.TextSize = 16
jumpPowerLabel.TextColor3 = COLORS.TextSecondary
jumpPowerLabel.BackgroundTransparency = 1
jumpPowerLabel.Size = UDim2.new(1, 0, 0, 20)
jumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
jumpPowerLabel.Parent = content

local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Type value (1-100)"
inputBox.Text = tostring(DEFAULT_JUMP_POWER)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 16
inputBox.TextColor3 = COLORS.TextPrimary
inputBox.BackgroundColor3 = COLORS.Primary
inputBox.Size = UDim2.new(1, 0, 0, 25)
inputBox.Parent = content
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

local credits = Instance.new("TextLabel")
credits.Text = player.Name
credits.Font = Enum.Font.GothamBold
credits.TextSize = 14
credits.TextColor3 = COLORS.AccentOn
credits.BackgroundTransparency = 1
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -20)
credits.TextXAlignment = Enum.TextXAlignment.Center
credits.Parent = frame

local function updateJumpPower(power)
	currentJumpPower = math.clamp(tonumber(power) or currentJumpPower, 1, MAX_POWER)
	
	local goal = { Size = UDim2.new(currentJumpPower / MAX_POWER, 0, 1, 0) }
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(sliderFill, tweenInfo, goal)
	tween:Play()
	
	jumpPowerLabel.Text = "Jump Power: " .. math.floor(currentJumpPower)
	inputBox.Text = tostring(math.floor(currentJumpPower))
	
	if jumpEnabled and humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = currentJumpPower
	end
end

local function toggleJump()
	jumpEnabled = not jumpEnabled
	
	local color = jumpEnabled and COLORS.AccentOn or COLORS.AccentOff
	local text = jumpEnabled and "ON" or "OFF"
	
	local tweenInfo = TweenInfo.new(0.3)
	local tween = TweenService:Create(toggle, tweenInfo, { BackgroundColor3 = color })
	tween:Play()
	toggle.Text = text
	
	if jumpEnabled then
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = currentJumpPower
		end
	else
		if humanoid then
			humanoid.JumpPower = DEFAULT_JUMP_POWER
		end
	end
end

local function cleanup()
	if humanoid then
		humanoid.JumpPower = DEFAULT_JUMP_POWER
	end
	
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	
	if screenGui then
		screenGui:Destroy()
	end
end

table.insert(connections, toggle.MouseButton1Click:Connect(toggleJump))

table.insert(connections, sliderBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
		local relPos = (input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X
		updateJumpPower(relPos * MAX_POWER)
	end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relPos = (input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X
		updateJumpPower(relPos * MAX_POWER)
	end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end))

table.insert(connections, inputBox.FocusLost:Connect(function(enterPressed)
	updateJumpPower(inputBox.Text)
end))

table.insert(connections, player.CharacterAdded:Connect(function(char)
	humanoid = char:WaitForChild("Humanoid")
	if jumpEnabled then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = currentJumpPower
	else
		humanoid.JumpPower = DEFAULT_JUMP_POWER
	end
end))

table.insert(connections, minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
	
	local reopen = Instance.new("TextButton")
	reopen.Size = UDim2.new(0, 150, 0, 35)
	reopen.Position = UDim2.new(0.5, -75, 0.02, 0)
	reopen.Text = "Reopen Jump Boost"
	reopen.Font = Enum.Font.GothamBold
	reopen.TextSize = 16
	reopen.BackgroundColor3 = COLORS.Background
	reopen.TextColor3 = COLORS.TextPrimary
	reopen.Parent = screenGui
	
	local reopenCorner = Instance.new("UICorner", reopen)
	reopenCorner.CornerRadius = UDim.new(0, 8)
	local reopenStroke = Instance.new("UIStroke", reopen)
	reopenStroke.Color = Color3.fromRGB(60, 60, 60)
	
	local reopenClickConnection
	reopenClickConnection = reopen.MouseButton1Click:Connect(function()
		frame.Visible = true
		reopen:Destroy()
		reopenClickConnection:Disconnect()
	end)
end))

table.insert(connections, unload.MouseButton1Click:Connect(cleanup))

updateJumpPower(DEFAULT_JUMP_POWER)
