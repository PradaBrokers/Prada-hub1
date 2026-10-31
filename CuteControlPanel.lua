--[[
    Cute Control Panel - Roblox Studio LocalScript
    Place in StarterPlayer > StarterPlayerScripts.
    GUI toggle: RightControl
    This is a UI and visual-customization starter for an experience you own.
    It does not include injector code, aimbot, hitbox exploits, or anticheat bypasses.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("CuteControlPanel")
if old then old:Destroy() end

local PINK = Color3.fromRGB(255, 126, 190)
local PALE = Color3.fromRGB(255, 194, 224)
local DARK = Color3.fromRGB(28, 23, 34)
local PANEL = Color3.fromRGB(39, 31, 47)
local TEXT = Color3.fromRGB(255, 244, 250)
local MUTED = Color3.fromRGB(190, 171, 188)

local screen = Instance.new("ScreenGui")
screen.Name = "CuteControlPanel"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.Parent = playerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or PINK
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
end

local function label(parent, text, size, pos, fontSize, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = pos
    l.Font = Enum.Font.Gotham
    l.TextSize = fontSize or 14
    l.TextColor3 = color or TEXT
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(570, 390)
main.Position = UDim2.new(0.5, -285, 0.5, -195)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = screen
corner(main, 14)
stroke(main, PINK, 1.5, 0.12)

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 48)
top.BackgroundColor3 = PANEL
top.BorderSizePixel = 0
top.Parent = main
corner(top, 14)

-- Cover the lower rounded corners of the title bar for a clean rectangular join.
local topCover = Instance.new("Frame")
topCover.Size = UDim2.new(1, 0, 0, 14)
topCover.Position = UDim2.new(0, 0, 1, -14)
topCover.BackgroundColor3 = PANEL
topCover.BorderSizePixel = 0
topCover.Parent = top

label(top, "  ♡  CANDY PANEL", UDim2.new(1, -120, 1, 0), UDim2.new(0, 8, 0, 0), 16, PALE)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -42, 0, 9)
close.BackgroundColor3 = PINK
close.Text = "×"
close.TextColor3 = DARK
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.Parent = top
corner(close, 9)

-- Drag the panel from its title bar.
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(12, 60)
sidebar.Size = UDim2.fromOffset(135, 318)
sidebar.BackgroundColor3 = PANEL
sidebar.BorderSizePixel = 0
sidebar.Parent = main
corner(sidebar, 10)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(158, 60)
content.Size = UDim2.new(1, -170, 1, -72)
content.BackgroundColor3 = PANEL
content.BorderSizePixel = 0
content.Parent = main
corner(content, 10)

local pages = {}
local function makePage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    pages[name] = page
    return page
end

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = (pageName == name)
    end
end

local function makeButton(parent, text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 34)
    b.Position = UDim2.fromOffset(8, y)
    b.BackgroundColor3 = DARK
    b.Text = text
    b.TextColor3 = TEXT
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = true
    b.Parent = parent
    corner(b, 8)
    b.Activated:Connect(callback)
    return b
end

local home = makePage("Home")
label(home, "Welcome back ♡", UDim2.new(1, -24, 0, 30), UDim2.fromOffset(14, 12), 20, PALE)
label(home, "A lightweight control panel for your own experience.", UDim2.new(1, -24, 0, 44), UDim2.fromOffset(14, 48), 13, TEXT)
label(home, "GUI toggle: Right Ctrl", UDim2.new(1, -24, 0, 25), UDim2.fromOffset(14, 100), 13, MUTED)
label(home, "Tip: drag this window by its top bar.", UDim2.new(1, -24, 0, 25), UDim2.fromOffset(14, 130), 13, MUTED)
label(home, "Visual features are local and intended for Studio projects you control.", UDim2.new(1, -24, 0, 48), UDim2.fromOffset(14, 176), 12, MUTED)

local visuals = makePage("Visuals")
label(visuals, "VISUAL SETTINGS", UDim2.new(1, -24, 0, 28), UDim2.fromOffset(14, 10), 16, PALE)
local skyLabel = label(visuals, "Sky tint: pink", UDim2.new(1, -24, 0, 24), UDim2.fromOffset(14, 48), 13, TEXT)
local skyColors = {
    {name = "Pink", color = Color3.fromRGB(255, 160, 210)},
    {name = "Lavender", color = Color3.fromRGB(177, 145, 255)},
    {name = "Blue", color = Color3.fromRGB(125, 190, 255)},
    {name = "Mint", color = Color3.fromRGB(135, 240, 205)},
    {name = "Default", color = nil},
}
local colorRow = Instance.new("Frame")
colorRow.BackgroundTransparency = 1
colorRow.Position = UDim2.fromOffset(10, 78)
colorRow.Size = UDim2.new(1, -20, 0, 42)
colorRow.Parent = visuals
local colorLayout = Instance.new("UIListLayout")
colorLayout.FillDirection = Enum.FillDirection.Horizontal
colorLayout.Padding = UDim.new(0, 5)
colorLayout.Parent = colorRow

local originalAmbient = Lighting.Ambient
local originalOutdoor = Lighting.OutdoorAmbient
local originalClock = Lighting.ClockTime
for _, entry in ipairs(skyColors) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 67, 0, 32)
    b.BackgroundColor3 = entry.color or DARK
    b.Text = entry.name
    b.TextSize = 11
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = entry.name == "Default" and TEXT or DARK
    b.Parent = colorRow
    corner(b, 8)
    b.Activated:Connect(function()
        skyLabel.Text = "Sky tint: " .. entry.name
        if entry.color then
            Lighting.Ambient = entry.color
            Lighting.OutdoorAmbient = entry.color
        else
            Lighting.Ambient = originalAmbient
            Lighting.OutdoorAmbient = originalOutdoor
            Lighting.ClockTime = originalClock
        end
    end)
end
label(visuals, "This adjusts local ambient lighting, not the server's skybox.", UDim2.new(1, -24, 0, 40), UDim2.fromOffset(14, 132), 12, MUTED)

local playerPage = makePage("Player")
label(playerPage, "PLAYER TOOLS", UDim2.new(1, -24, 0, 28), UDim2.fromOffset(14, 10), 16, PALE)
label(playerPage, "Test controls should only affect your own game.", UDim2.new(1, -24, 0, 40), UDim2.fromOffset(14, 42), 12, MUTED)
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVPreview"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.Size = UDim2.fromOffset(160, 160)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = screen
corner(fovCircle, 100)
stroke(fovCircle, PINK, 2, 0.1)
local fovButton
fovButton = makeButton(playerPage, "FOV preview: OFF", 92, function()
    fovCircle.Visible = not fovCircle.Visible
    fovButton.Text = "FOV preview: " .. (fovCircle.Visible and "ON" or "OFF")
end)
local smaller = makeButton(playerPage, "FOV size: smaller", 134, function()
    local n = math.max(60, fovCircle.Size.X.Offset - 20)
    fovCircle.Size = UDim2.fromOffset(n, n)
end)
local larger = makeButton(playerPage, "FOV size: larger", 176, function()
    local n = math.min(360, fovCircle.Size.X.Offset + 20)
    fovCircle.Size = UDim2.fromOffset(n, n)
end)

local avatar = makePage("Avatar")
label(avatar, "AVATAR", UDim2.new(1, -24, 0, 28), UDim2.fromOffset(14, 10), 16, PALE)
label(avatar, "Avatar outfit copying/preview can be added with Roblox's supported avatar APIs in a game you own.", UDim2.new(1, -28, 0, 80), UDim2.fromOffset(14, 44), 13, TEXT)
label(avatar, "Use a username input and server-validated outfit loading for a safe implementation.", UDim2.new(1, -28, 0, 60), UDim2.fromOffset(14, 132), 12, MUTED)

local settings = makePage("Settings")
label(settings, "SETTINGS", UDim2.new(1, -24, 0, 28), UDim2.fromOffset(14, 10), 16, PALE)
label(settings, "Right Ctrl toggles the whole window.", UDim2.new(1, -24, 0, 25), UDim2.fromOffset(14, 46), 13, TEXT)
label(settings, "Close hides the window; it does not destroy the GUI.", UDim2.new(1, -24, 0, 42), UDim2.fromOffset(14, 76), 12, MUTED)
local resetButton = makeButton(settings, "Reset local lighting", 128, function()
    Lighting.Ambient = originalAmbient
    Lighting.OutdoorAmbient = originalOutdoor
    Lighting.ClockTime = originalClock
    skyLabel.Text = "Sky tint: default"
end)

local tabs = {"Home", "Visuals", "Player", "Avatar", "Settings"}
for i, name in ipairs(tabs) do
    makeButton(sidebar, name, 10 + (i - 1) * 42, function()
        showPage(name)
    end)
end

showPage("Home")

local function toggleGui()
    main.Visible = not main.Visible
end

close.Activated:Connect(function()
    main.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleGui()
    end
end)

-- Keep the preview circle centered without a perpetual RenderStepped loop.
local cameraConnection
local function bindCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    local camera = workspace.CurrentCamera
    if camera then
        cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            fovCircle.Position = UDim2.fromScale(0.5, 0.5)
        end)
    end
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

screen.Destroying:Connect(function()
    if cameraConnection then cameraConnection:Disconnect() end
    Lighting.Ambient = originalAmbient
    Lighting.OutdoorAmbient = originalOutdoor
    Lighting.ClockTime = originalClock
end)
