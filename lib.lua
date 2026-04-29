local Proohio = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Tween(obj, props, duration, style, dir)
    TweenService:Create(obj, TweenInfo.new(duration or 0.15, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0.93
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function CreateFrame(props)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = props.Alpha or 0
    frame.BackgroundColor3 = props.Color or Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    if props.Size then frame.Size = props.Size end
    if props.Pos then frame.Position = props.Pos end
    if props.Anchor then frame.AnchorPoint = props.Anchor end
    if props.ZIndex then frame.ZIndex = props.ZIndex end
    if props.Clip then frame.ClipsDescendants = true end
    if props.Parent then frame.Parent = props.Parent end
    return frame
end

local THEMES = {
    Proohio = {
        Bg = Color3.fromRGB(14, 14, 14),
        Header = Color3.fromRGB(10, 10, 10),
        Sidebar = Color3.fromRGB(10, 10, 10),
        Element = Color3.fromRGB(22, 22, 22),
        Text = Color3.fromRGB(255, 255, 255),
        Subtext = Color3.fromRGB(136, 136, 136),
        Muted = Color3.fromRGB(51, 51, 51),
    },
    Dark = {
        Bg = Color3.fromRGB(5, 5, 5),
        Header = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(0, 0, 0),
        Element = Color3.fromRGB(18, 18, 18),
        Text = Color3.fromRGB(255, 255, 255),
        Subtext = Color3.fromRGB(100, 100, 100),
        Muted = Color3.fromRGB(40, 40, 40),
    },
    Light = {
        Bg = Color3.fromRGB(242, 242, 242),
        Header = Color3.fromRGB(228, 228, 228),
        Sidebar = Color3.fromRGB(228, 228, 228),
        Element = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(20, 20, 20),
        Subtext = Color3.fromRGB(120, 120, 120),
        Muted = Color3.fromRGB(200, 200, 200),
    },
    Ocean = {
        Bg = Color3.fromRGB(18, 22, 40),
        Header = Color3.fromRGB(14, 18, 34),
        Sidebar = Color3.fromRGB(14, 18, 34),
        Element = Color3.fromRGB(24, 30, 52),
        Text = Color3.fromRGB(210, 210, 255),
        Subtext = Color3.fromRGB(100, 110, 180),
        Muted = Color3.fromRGB(50, 55, 100),
    },
}

local LibName = tostring(math.random(100000, 999999))
local ScreenGui = nil
local MainUI = nil
local FloatBtn = nil
local UIVisible = false
local IsMobile = false

local function DetectMobile()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    IsMobile = viewportSize.X < 800 or UserInputService.TouchEnabled
    return IsMobile
end

local function GetOptimalSize()
    DetectMobile()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    if IsMobile then
        return UDim2.new(0, viewportSize.X * 0.88, 0, viewportSize.Y * 0.65)
    else
        return UDim2.new(0, 580, 0, 420) -- Compact PC size
    end
end

local function GetOptimalTextSize()
    return IsMobile and 13 or 11
end

local function GetOptimalElementHeight()
    return IsMobile and 46 or 40
end

function Proohio:ToggleUI()
    UIVisible = not UIVisible
    if MainUI then
        MainUI.Visible = UIVisible
        if UIVisible then
            Tween(MainUI, {Size = GetOptimalSize()}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(MainUI, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        end
    end
end

function Proohio.CreateLib(libName, themeChoice)
    local T = THEMES.Proohio
    if type(themeChoice) == "string" and THEMES[themeChoice] then
        T = THEMES[themeChoice]
    elseif type(themeChoice) == "table" then
        T = themeChoice
    end
    libName = libName or "Proohio UI"

    for _, v in ipairs(game.CoreGui:GetChildren()) do
        if v.Name == LibName then v:Destroy() end
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    ScreenGui.DisplayOrder = 100

    -- Floating Toggle Button (bottom-right corner)
    FloatBtn = CreateFrame({
        Color = T.Header,
        Size = UDim2.new(0, 42, 0, 42),
        Pos = UDim2.new(1, -52, 1, -52),
        Parent = ScreenGui,
    })
    CreateCorner(FloatBtn, 100)
    CreateStroke(FloatBtn, Color3.fromRGB(255, 255, 255), 0.9)
    FloatBtn.ZIndex = 1000

    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Parent = FloatBtn
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Size = UDim2.new(1, -8, 1, -8)
    FloatIcon.Position = UDim2.new(0, 4, 0, 4)
    FloatIcon.Image = "rbxassetid://74489035156742"
    FloatIcon.ScaleType = Enum.ScaleType.Crop
    FloatIcon.ZIndex = 1001

    -- Hover effects for float button
    FloatBtn.MouseEnter:Connect(function()
        Tween(FloatBtn, {BackgroundColor3 = Color3.fromRGB(T.Header.r*255+15, T.Header.g*255+15, T.Header.b*255+15)}, 0.1)
    end)
    FloatBtn.MouseLeave:Connect(function()
        Tween(FloatBtn, {BackgroundColor3 = T.Header}, 0.1)
    end)

    FloatBtn.MouseButton1Click:Connect(function()
        Proohio:ToggleUI()
    end)

    -- Make float button draggable
    do
        local drag, dragInput, dragStart, startPos
        FloatBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = true
                dragStart = input.Position
                startPos = FloatBtn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then drag = false end
                end)
            end
        end)
        FloatBtn.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and drag then
                local delta = input.Position - dragStart
                FloatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Main UI Window
    MainUI = CreateFrame({
        Color = T.Bg,
        Size = UDim2.new(0, 0, 0, 0),
        Pos = UDim2.new(0.5, -290, 0.5, -210),
        Clip = true,
        Parent = ScreenGui,
    })
    MainUI.Visible = false
    CreateCorner(MainUI, 12)
    local mainStroke = CreateStroke(MainUI, Color3.fromRGB(255, 255, 255), 1)
    mainStroke.Transparency = 1
    TweenService:Create(mainStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Transparency = 0.9}):Play()

    -- Title Bar
    local TitleBar = CreateFrame({
        Color = T.Header,
        Size = UDim2.new(1, 0, 0, 38),
        ZIndex = 2,
        Parent = MainUI,
    })
    CreateCorner(TitleBar, 12)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 16, 0, 0)
    TitleLbl.Size = UDim2.new(1, -32, 1, 0)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.Text = libName
    TitleLbl.TextColor3 = T.Subtext
    TitleLbl.TextSize = GetOptimalTextSize()
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.ZIndex = 2
    TitleLbl.Parent = TitleBar

    -- Drag functionality for main UI
    do
        local drag, dragInput, dragStart, startPos
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = true
                dragStart = input.Position
                startPos = MainUI.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then drag = false end
                end)
            end
        end)
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and drag then
                local delta = input.Position - dragStart
                MainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Sidebar
    local Sidebar = CreateFrame({
        Color = T.Sidebar,
        Size = UDim2.new(0, 130, 1, -38),
        Pos = UDim2.new(0, 0, 0, 38),
        Parent = MainUI,
    })
    CreateCorner(Sidebar, 12)

    -- Tab Scroll
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.Size = UDim2.new(1, 0, 1, -54)
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = Sidebar

    local TabLL = Instance.new("UIListLayout")
    TabLL.SortOrder = Enum.SortOrder.LayoutOrder
    TabLL.Padding = UDim.new(0, 3)
    TabLL.Parent = TabScroll

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop = UDim.new(0, 6)
    TabPad.PaddingLeft = UDim.new(0, 8)
    TabPad.PaddingRight = UDim.new(0, 8)
    TabPad.Parent = TabScroll

    TabLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabLL.AbsoluteContentSize.Y + 12)
    end)

    -- Profile Section (bottom of sidebar)
    local ProfileArea = CreateFrame({
        Color = T.Sidebar,
        Alpha = 0,
        Size = UDim2.new(1, 0, 0, 54),
        Pos = UDim2.new(0, 0, 1, -54),
        Parent = Sidebar,
    })
    CreateCorner(ProfileArea, 12)

    local AvatarHolder = CreateFrame({
        Color = Color3.fromRGB(26, 26, 26),
        Size = UDim2.new(0, 30, 0, 30),
        Pos = UDim2.new(0, 10, 0.5, -15),
        Parent = ProfileArea,
    })
    CreateCorner(AvatarHolder, 100)
    CreateStroke(AvatarHolder, Color3.fromRGB(255, 255, 255), 0.9)

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Size = UDim2.new(1, 0, 1, 0)
    AvatarImg.ScaleType = Enum.ScaleType.Crop
    AvatarImg.Parent = AvatarHolder
    CreateCorner(AvatarImg, 100)

    local DispNameLbl = Instance.new("TextLabel")
    DispNameLbl.BackgroundTransparency = 1
    DispNameLbl.Position = UDim2.new(0, 46, 0, 10)
    DispNameLbl.Size = UDim2.new(1, -56, 0, 14)
    DispNameLbl.Font = Enum.Font.GothamBold
    DispNameLbl.Text = "..."
    DispNameLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    DispNameLbl.TextSize = 11
    DispNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    DispNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    DispNameLbl.Parent = ProfileArea

    local UserNameLbl = Instance.new("TextLabel")
    UserNameLbl.BackgroundTransparency = 1
    UserNameLbl.Position = UDim2.new(0, 46, 0, 26)
    UserNameLbl.Size = UDim2.new(1, -56, 0, 12)
    UserNameLbl.Font = Enum.Font.Gotham
    UserNameLbl.Text = "@..."
    UserNameLbl.TextColor3 = Color3.fromRGB(68, 68, 68)
    UserNameLbl.TextSize = 9
    UserNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    UserNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    UserNameLbl.Parent = ProfileArea

    local StatusDot = CreateFrame({
        Color = Color3.fromRGB(34, 197, 94),
        Size = UDim2.new(0, 5, 0, 5),
        Pos = UDim2.new(1, -18, 0.5, -2.5),
        Parent = ProfileArea,
    })
    CreateCorner(StatusDot, 100)

    -- Load player info
    local lp = Players.LocalPlayer
    DispNameLbl.Text = lp.DisplayName
    UserNameLbl.Text = "@" .. lp.Name
    pcall(function()
        local img = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        AvatarImg.Image = img
    end)

    -- Content Area
    local ContentArea = CreateFrame({
        Alpha = 1,
        Size = UDim2.new(1, -130, 1, -38),
        Pos = UDim2.new(0, 130, 0, 38),
        Parent = MainUI,
    })
    CreateCorner(ContentArea, 12)
    ContentArea.ClipsDescendants = true

    local Pages = Instance.new("Folder")
    Pages.Parent = ContentArea

    local Tabs = {}
    local allTabData = {}
    local firstTab = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local isFirst = firstTab
        firstTab = false

        local TabBtn = Instance.new("TextButton")
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = isFirst and 0.9 or 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = tabName
        TabBtn.TextColor3 = isFirst and T.Text or T.Subtext
        TabBtn.TextSize = GetOptimalTextSize()
        TabBtn.ZIndex = 2
        TabBtn.Parent = TabScroll
        CreateCorner(TabBtn, 6)
        local tabStroke = CreateStroke(TabBtn, Color3.fromRGB(255, 255, 255), isFirst and 0.9 or 1)

        local Page = Instance.new("ScrollingFrame")
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        Page.ScrollBarImageTransparency = 0.9
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = isFirst
        Page.Parent = ContentArea

        local PageLL = Instance.new("UIListLayout")
        PageLL.SortOrder = Enum.SortOrder.LayoutOrder
        PageLL.Padding = UDim.new(0, 10)
        PageLL.Parent = Page

        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0, 10)
        PagePad.PaddingLeft = UDim.new(0, 10)
        PagePad.PaddingRight = UDim.new(0, 10)
        PagePad.PaddingBottom = UDim.new(0, 10)
        PagePad.Parent = Page

        local function RefreshCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLL.AbsoluteContentSize.Y + 20)
        end
        PageLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RefreshCanvas)

        local entry = {btn = TabBtn, stroke = tabStroke, page = Page}
        table.insert(allTabData, entry)

        TabBtn.MouseButton1Click:Connect(function()
            for _, d in ipairs(allTabData) do
                d.page.Visible = false
                Tween(d.btn, {BackgroundTransparency = 1, TextColor3 = T.Subtext}, 0.12)
                Tween(d.stroke, {Transparency = 1}, 0.12)
            end
            Page.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.9, TextColor3 = T.Text}, 0.15)
            Tween(tabStroke, {Transparency = 0.9}, 0.15)
            RefreshCanvas()
        end)

        TabBtn.MouseEnter:Connect(function()
            if not Page.Visible then
                Tween(TabBtn, {TextColor3 = Color3.fromRGB(180, 180, 180)}, 0.1)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not Page.Visible then
                Tween(TabBtn, {TextColor3 = T.Subtext}, 0.1)
            end
        end)

        local Sections = {}

        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            hidden = hidden or false

            local SecFrame = CreateFrame({
                Alpha = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Parent = Page,
            })

            local SecLL = Instance.new("UIListLayout")
            SecLL.SortOrder = Enum.SortOrder.LayoutOrder
            SecLL.Padding = UDim.new(0, 5)
            SecLL.Parent = SecFrame

            if not hidden then
                local SecTitleLbl = Instance.new("TextLabel")
                SecTitleLbl.BackgroundTransparency = 1
                SecTitleLbl.AutomaticSize = Enum.AutomaticSize.X
                SecTitleLbl.Size = UDim2.new(0, 0, 0, 16)
                SecTitleLbl.Font = Enum.Font.GothamBold
                SecTitleLbl.Text = string.upper(secName)
                SecTitleLbl.TextColor3 = T.Muted
                SecTitleLbl.TextSize = 9
                SecTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                SecTitleLbl.Parent = SecFrame
            end

            local ContentHolder = CreateFrame({
                Alpha = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Parent = SecFrame,
            })

            local ContentLL = Instance.new("UIListLayout")
            ContentLL.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLL.Padding = UDim.new(0, 5)
            ContentLL.Parent = ContentHolder

            local function Resize()
                ContentHolder.Size = UDim2.new(1, 0, 0, ContentLL.AbsoluteContentSize.Y)
                SecFrame.Size = UDim2.new(1, 0, 0, SecLL.AbsoluteContentSize.Y)
                RefreshCanvas()
            end
            ContentLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
            SecLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

            local function El(h)
                local f = CreateFrame({
                    Color = T.Element,
                    Size = UDim2.new(1, 0, 0, h or GetOptimalElementHeight()),
                    Parent = ContentHolder,
                })
                CreateCorner(f, 10)
                local s = CreateStroke(f, Color3.fromRGB(255, 255, 255), 0.92)
                return f, s
            end

            local Elements = {}

            function Elements:NewButton(btnName, btnInfo, callback)
                btnName = btnName or "Button"
                callback = callback or function() end
                local f, s = El(GetOptimalElementHeight())

                local Lbl = Instance.new("TextLabel")
                Lbl.BackgroundTransparency = 1
                Lbl.Position = UDim2.new(0, 12, 0, 0)
                Lbl.Size = UDim2.new(1, -24, 1, 0)
                Lbl.Font = Enum.Font.GothamMedium
                Lbl.Text = btnName
                Lbl.TextColor3 = T.Subtext
                Lbl.TextSize = GetOptimalTextSize()
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = f

                local HitBtn = Instance.new("TextButton")
                HitBtn.BackgroundTransparency = 1
                HitBtn.BorderSizePixel = 0
                HitBtn.Size = UDim2.new(1, 0, 1, 0)
                HitBtn.Text = ""
                HitBtn.AutoButtonColor = false
                HitBtn.ZIndex = 2
                HitBtn.Parent = f

                HitBtn.MouseButton1Click:Connect(function()
                    Tween(f, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.06)
                    Tween(Lbl, {TextColor3 = Color3.fromRGB(0, 0, 0)}, 0.06)
                    task.delay(0.12, function()
                        Tween(f, {BackgroundColor3 = T.Element}, 0.12)
                        Tween(Lbl, {TextColor3 = T.Subtext}, 0.12)
                    end)
                    callback()
                end)
                HitBtn.MouseEnter:Connect(function()
                    Tween(s, {Transparency = 0.85}, 0.08)
                    Tween(Lbl, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.08)
                end)
                HitBtn.MouseLeave:Connect(function()
                    Tween(s, {Transparency = 0.92}, 0.08)
                    Tween(Lbl, {TextColor3 = T.Subtext}, 0.08)
                end)

                Resize()
                local Funcs = {}
                function Funcs:UpdateButton(t) Lbl.Text = t end
                return Funcs
            end

            function Elements:NewToggle(togName, togInfo, callback)
                togName = togName or "Toggle"
                callback = callback or function() end
                local on = false
                local f, s = El(GetOptimalElementHeight())

                local Lbl = Instance.new("TextLabel")
                Lbl.BackgroundTransparency = 1
                Lbl.Position = UDim2.new(0, 12, 0, 0)
                Lbl.Size = UDim2.new(1, -54, 1, 0)
                Lbl.Font = Enum.Font.GothamMedium
                Lbl.Text = togName
                Lbl.TextColor3 = T.Subtext
                Lbl.TextSize = GetOptimalTextSize()
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = f

                local Pill = CreateFrame({
                    Color = Color3.fromRGB(42, 42, 42),
                    Size = UDim2.new(0, 34, 0, 20),
                    Pos = UDim2.new(1, -48, 0.5, -10),
                    Parent = f,
                })
                CreateCorner(Pill, 100)

                local Circle = CreateFrame({
                    Color = Color3.fromRGB(85, 85, 85),
                    Size = UDim2.new(0, 14, 0, 14),
                    Pos = UDim2.new(0, 3, 0.5, -7),
                    Parent = Pill,
                })
                CreateCorner(Circle, 100)

                local HitBtn = Instance.new("TextButton")
                HitBtn.BackgroundTransparency = 1
                HitBtn.BorderSizePixel = 0
                HitBtn.Size = UDim2.new(1, 0, 1, 0)
                HitBtn.Text = ""
                HitBtn.AutoButtonColor = false
                HitBtn.ZIndex = 2
                HitBtn.Parent = f

                local function SetOn(state)
                    on = state
                    if on then
                        Tween(Pill, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
                        Tween(Circle, {Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.fromRGB(17, 17, 17)}, 0.15)
                    else
                        Tween(Pill, {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}, 0.15)
                        Tween(Circle, {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Color3.fromRGB(85, 85, 85)}, 0.15)
                    end
                end

                HitBtn.MouseButton1Click:Connect(function()
                    SetOn(not on)
                    callback(on)
                end)
                HitBtn.MouseEnter:Connect(function()
                    Tween(s, {Transparency = 0.85}, 0.08)
                    Tween(Lbl, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.08)
                end)
                HitBtn.MouseLeave:Connect(function()
                    Tween(s, {Transparency = 0.92}, 0.08)
                    Tween(Lbl, {TextColor3 = T.Subtext}, 0.08)
                end)

                Resize()
                local Funcs = {}
                function Funcs:UpdateToggle(newText, state)
                    if newText then Lbl.Text = newText end
                    if state ~= nil then SetOn(state) callback(on) end
                end
                return Funcs
            end

            function Elements:NewSlider(sliderName, sliderInfo, maxVal, minVal, callback)
                sliderName = sliderName or "Slider"
                maxVal = maxVal or 100
                minVal = minVal or 0
                callback = callback or function() end
                local f, s = El(56)

                local Lbl = Instance.new("TextLabel")
                Lbl.BackgroundTransparency = 1
                Lbl.Position = UDim2.new(0, 12, 0, 8)
                Lbl.Size = UDim2.new(1, -60, 0, 14)
                Lbl.Font = Enum.Font.GothamMedium
                Lbl.Text = sliderName
                Lbl.TextColor3 = T.Subtext
                Lbl.TextSize = GetOptimalTextSize()
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = f

                local ValBox = CreateFrame({
                    Color = Color3.fromRGB(31, 31, 31),
                    Size = UDim2.new(0, 34, 0, 18),
                    Pos = UDim2.new(1, -48, 0, 8),
                    Parent = f,
                })
                CreateCorner(ValBox, 6)
                CreateStroke(ValBox, Color3.fromRGB(255, 255, 255), 0.9)

                local ValLbl = Instance.new("TextLabel")
                ValLbl.BackgroundTransparency = 1
                ValLbl.Size = UDim2.new(1, 0, 1, 0)
                ValLbl.Font = Enum.Font.GothamBold
                ValLbl.Text = tostring(minVal)
                ValLbl.TextColor3 = T.Text
                ValLbl.TextSize = 10
                ValLbl.Parent = ValBox

                local Track = CreateFrame({
                    Color = Color3.fromRGB(255, 255, 255),
                    Alpha = 0.9,
                    Size = UDim2.new(1, -24, 0, 4),
                    Pos = UDim2.new(0, 12, 1, -14),
                    Parent = f,
                })
                CreateCorner(Track, 100)

                local Fill = CreateFrame({
                    Color = Color3.fromRGB(255, 255, 255),
                    Alpha = 0.3,
                    Size = UDim2.new(0, 0, 1, 0),
                    Parent = Track,
                })
                CreateCorner(Fill, 100)

                local Knob = CreateFrame({
                    Color = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 12, 0, 12),
                    Pos = UDim2.new(0, -6, 0.5, -6),
                    ZIndex = 3,
                    Parent = Track,
                })
                CreateCorner(Knob, 100)

                local HitArea = Instance.new("TextButton")
                HitArea.BackgroundTransparency = 1
                HitArea.BorderSizePixel = 0
                HitArea.Position = UDim2.new(0, -6, 0, -8)
                HitArea.Size = UDim2.new(1, 12, 1, 16)
                HitArea.Text = ""
                HitArea.AutoButtonColor = false
                HitArea.ZIndex = 4
                HitArea.Parent = Track

                local curVal = minVal
                local sliding = false

                local function SetVal(px)
                    local tw = Track.AbsoluteSize.X
                    local tx = Track.AbsolutePosition.X
                    local pct = math.clamp((px - tx) / tw, 0, 1)
                    curVal = math.floor(minVal + (maxVal - minVal) * pct)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Knob.Position = UDim2.new(pct, -6, 0.5, -6)
                    ValLbl.Text = tostring(curVal)
                    callback(curVal)
                end

                HitArea.MouseButton1Down:Connect(function()
                    sliding = true
                    SetVal(UserInputService:GetMouseLocation().X)
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        SetVal(inp.Position.X)
                    end
                end)

                f.MouseEnter:Connect(function()
                    Tween(s, {Transparency = 0.85}, 0.08)
                    Tween(Lbl, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.08)
                end)
                f.MouseLeave:Connect(function()
                    Tween(s, {Transparency = 0.92}, 0.08)
                    Tween(Lbl, {TextColor3 = T.Subtext}, 0.08)
                end)

                Resize()
            end

            function Elements:NewTextBox(tbName, tbInfo, callback)
                tbName = tbName or "TextBox"
                callback = callback or function() end
                local f, s = El(GetOptimalElementHeight())

                local Lbl = Instance.new("TextLabel")
                Lbl.BackgroundTransparency = 1
                Lbl.Position = UDim2.new(0, 12, 0, 0)
                Lbl.Size = UDim2.new(0, 90, 1, 0)
                Lbl.Font = Enum.Font.GothamMedium
                Lbl.Text = tbName
                Lbl.TextColor3 = T.Subtext
                Lbl.TextSize = GetOptimalTextSize()
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = f

                local InputBg = CreateFrame({
                    Color = Color3.fromRGB(15, 15, 15),
                    Size = UDim2.new(1, -110, 0, 22),
                    Pos = UDim2.new(0, 108, 0.5, -11),
                    Parent = f,
                })
                CreateCorner(InputBg, 7)
                local iStroke = CreateStroke(InputBg, Color3.fromRGB(255, 255, 255), 0.9)

                local Box = Instance.new("TextBox")
                Box.BackgroundTransparency = 1
                Box.BorderSizePixel = 0
                Box.Position = UDim2.new(0, 7, 0, 0)
                Box.Size = UDim2.new(1, -14, 1, 0)
                Box.Font = Enum.Font.Gotham
                Box.PlaceholderText = "Enter..."
                Box.PlaceholderColor3 = Color3.fromRGB(68, 68, 68)
                Box.Text = ""
                Box.TextColor3 = T.Text
                Box.TextSize = 10
                Box.TextXAlignment = Enum.TextXAlignment.Left
                Box.ClearTextOnFocus = false
                Box.Parent = InputBg

                Box.Focused:Connect(function() Tween(iStroke, {Transparency = 0.78}, 0.08) end)
                Box.FocusLost:Connect(function(enter)
                    Tween(iStroke, {Transparency = 0.9}, 0.08)
                    if enter then callback(Box.Text) end
                end)
                f.MouseEnter:Connect(function() Tween(s, {Transparency = 0.85}, 0.08) end)
                f.MouseLeave:Connect(function() Tween(s, {Transparency = 0.92}, 0.08) end)

                Resize()
            end

            function Elements:NewLabel(labelText)
                labelText = labelText or "Label"
                local f = CreateFrame({
                    Color = Color3.fromRGB(17, 17, 17),
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = ContentHolder,
                })
                CreateCorner(f, 10)
                CreateStroke(f, Color3.fromRGB(255, 255, 255), 0.94)

                local Lbl = Instance.new("TextLabel")
                Lbl.BackgroundTransparency = 1
                Lbl.Position = UDim2.new(0, 12, 0, 0)
                Lbl.Size = UDim2.new(1, -24, 1, 0)
                Lbl.Font = Enum.Font.Gotham
                Lbl.Text = labelText
                Lbl.TextColor3 = Color3.fromRGB(68, 68, 68)
                Lbl.TextSize = 10
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = f

                Resize()
                local Funcs = {}
                function Funcs:UpdateLabel(t) Lbl.Text = t end
                return Funcs
            end

            function Elements:NewDropdown(dropName, dropInfo, list, callback)
                dropName = dropName or "Dropdown"
                list = list or {}
                callback = callback or function() end
                local opened = false

                local Wrap = CreateFrame({
                    Alpha = 1,
                    Size = UDim2.new(1, 0, 0, GetOptimalElementHeight()),
                    Clip = true,
                    Parent = ContentHolder,
                })

                local Header = CreateFrame({
                    Color = T.Element,
                    Size = UDim2.new(1, 0, 0, GetOptimalElementHeight()),
                    Parent = Wrap,
                })
                CreateCorner(Header, 10)
                local hStroke = CreateStroke(Header, Color3.fromRGB(255, 255, 255), 0.92)

                local HLbl = Instance.new("TextLabel")
                HLbl.BackgroundTransparency = 1
                HLbl.Position = UDim2.new(0, 12, 0, 0)
                HLbl.Size = UDim2.new(1, -36, 1, 0)
                HLbl.Font = Enum.Font.GothamMedium
                HLbl.Text = dropName
                HLbl.TextColor3 = T.Subtext
                HLbl.TextSize = GetOptimalTextSize()
                HLbl.TextXAlignment = Enum.TextXAlignment.Left
                HLbl.Parent = Header

                local Arrow = Instance.new("TextLabel")
                Arrow.BackgroundTransparency = 1
                Arrow.AnchorPoint = Vector2.new(1, 0.5)
                Arrow.Position = UDim2.new(1, -12, 0.5, 0)
                Arrow.Size = UDim2.new(0, 14, 0, 14)
                Arrow.Font = Enum.Font.GothamBold
                Arrow.Text = "v"
                Arrow.TextColor3 = Color3.fromRGB(68, 68, 68)
                Arrow.TextSize = 9
                Arrow.Parent = Header

                local HBtn = Instance.new("TextButton")
                HBtn.BackgroundTransparency = 1
                HBtn.BorderSizePixel = 0
                HBtn.Size = UDim2.new(1, 0, 1, 0)
                HBtn.Text = ""
                HBtn.AutoButtonColor = false
                HBtn.ZIndex = 2
                HBtn.Parent = Header

                local OptsBox = CreateFrame({
                    Color = Color3.fromRGB(17, 17, 17),
                    Size = UDim2.new(1, 0, 0, 0),
                    Clip = true,
                    Parent = Wrap,
                })
                CreateCorner(OptsBox, 10)
                CreateStroke(OptsBox, Color3.fromRGB(255, 255, 255), 0.88)

                local OptsLL = Instance.new("UIListLayout")
                OptsLL.SortOrder = Enum.SortOrder.LayoutOrder
                OptsLL.Parent = OptsBox

                local function BuildOpts(opts)
                    for _, c in ipairs(OptsBox:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(opts) do
                        local OBtn = Instance.new("TextButton")
                        OBtn.BackgroundTransparency = 1
                        OBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        OBtn.BorderSizePixel = 0
                        OBtn.Size = UDim2.new(1, 0, 0, 28)
                        OBtn.AutoButtonColor = false
                        OBtn.Font = Enum.Font.Gotham
                        OBtn.Text = opt
                        OBtn.TextColor3 = Color3.fromRGB(102, 102, 102)
                        OBtn.TextSize = 10
                        OBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OBtn.ZIndex = 3
                        OBtn.Parent = OptsBox
                        Instance.new("UIPadding", OBtn).PaddingLeft = UDim.new(0, 12)

                        OBtn.MouseEnter:Connect(function()
                            Tween(OBtn, {BackgroundTransparency = 0.93, TextColor3 = T.Text}, 0.08)
                        end)
                        OBtn.MouseLeave:Connect(function()
                            Tween(OBtn, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(102, 102, 102)}, 0.08)
                        end)
                        OBtn.MouseButton1Click:Connect(function()
                            HLbl.Text = opt
                            callback(opt)
                            opened = false
                            Tween(OptsBox, {Size = UDim2.new(1, 0, 0, 0)}, 0.12)
                            Tween(Arrow, {Rotation = 0}, 0.12)
                            Wrap.Size = UDim2.new(1, 0, 0, GetOptimalElementHeight())
                            Resize()
                        end)
                    end
                end

                BuildOpts(list)

                HBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    local oh = OptsLL.AbsoluteContentSize.Y + 6
                    if opened then
                        Tween(OptsBox, {Size = UDim2.new(1, 0, 0, oh)}, 0.15)
                        Tween(Arrow, {Rotation = 180}, 0.12)
                        Wrap.Size = UDim2.new(1, 0, 0, GetOptimalElementHeight() + 4 + oh)
                    else
                        Tween(OptsBox, {Size = UDim2.new(1, 0, 0, 0)}, 0.12)
                        Tween(Arrow, {Rotation = 0}, 0.12)
                        Wrap.Size = UDim2.new(1, 0, 0, GetOptimalElementHeight())
                    end
                    Resize()
                end)

                HBtn.MouseEnter:Connect(function()
                    Tween(hStroke, {Transparency = 0.85}, 0.08)
                    Tween(HLbl, {TextColor3 = Color3.fromRGB(200, 200, 200)}, 0.08)
                end)
                HBtn.MouseLeave:Connect(function()
                    Tween(hStroke, {Transparency = 0.92}, 0.08)
                    Tween(HLbl, {TextColor3 = T.Subtext}, 0.08)
                end)

                Resize()
                local Funcs = {}
                function Funcs:Refresh(newList)
                    BuildOpts(newList)
                    opened = false
                    OptsBox.Size = UDim2.new(1, 0, 0, 0)
                    Arrow.Rotation = 0
                    Wrap.Size = UDim2.new(1, 0, 0, GetOptimalElementHeight())
                    Resize()
                end
                return Funcs
            end

            Resize()
            return Elements
        end

        return Sections
    end

    return Tabs
end

return Proohio
