local Proohio = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function Tween(obj, props, dur, style, dir)
    TweenService:Create(obj, TweenInfo.new(dur or 0.15, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = p
    return c
end

local function Stroke(p, col, tr, th)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(255,255,255)
    s.Transparency = tr or 0.93
    s.Thickness = th or 1
    s.Parent = p
    return s
end

local function CreateFrame(props)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = props.Alpha or 0
    f.BackgroundColor3 = props.Color or Color3.fromRGB(0,0,0)
    f.BorderSizePixel = 0
    if props.Size then f.Size = props.Size end
    if props.Pos then f.Position = props.Pos end
    if props.Anchor then f.AnchorPoint = props.Anchor end
    if props.Z then f.ZIndex = props.Z end
    if props.Clip then f.ClipsDescendants = true end
    if props.Parent then f.Parent = props.Parent end
    return f
end

local THEMES = {
    Proohio = {Bg=Color3.fromRGB(14,14,14), Header=Color3.fromRGB(10,10,10), Sidebar=Color3.fromRGB(10,10,10), El=Color3.fromRGB(22,22,22), Text=Color3.fromRGB(255,255,255), Sub=Color3.fromRGB(136,136,136), Muted=Color3.fromRGB(51,51,51)},
    Dark = {Bg=Color3.fromRGB(5,5,5), Header=Color3.fromRGB(0,0,0), Sidebar=Color3.fromRGB(0,0,0), El=Color3.fromRGB(18,18,18), Text=Color3.fromRGB(255,255,255), Sub=Color3.fromRGB(100,100,100), Muted=Color3.fromRGB(40,40,40)},
    Light = {Bg=Color3.fromRGB(242,242,242), Header=Color3.fromRGB(228,228,228), Sidebar=Color3.fromRGB(228,228,228), El=Color3.fromRGB(255,255,255), Text=Color3.fromRGB(20,20,20), Sub=Color3.fromRGB(120,120,120), Muted=Color3.fromRGB(200,200,200)},
    Ocean = {Bg=Color3.fromRGB(18,22,40), Header=Color3.fromRGB(14,18,34), Sidebar=Color3.fromRGB(14,18,34), El=Color3.fromRGB(24,30,52), Text=Color3.fromRGB(210,210,255), Sub=Color3.fromRGB(100,110,180), Muted=Color3.fromRGB(50,55,100)}
}

local UI_NAME = "Proohio_Main"
local ScreenGui, MainUI, FloatBtn, UIVisible, IsMobile, CurrentTheme

local function DetectMobile()
    local vs = workspace.CurrentCamera.ViewportSize
    IsMobile = vs.X < 800 or UserInputService.TouchEnabled
end

local function GetSize()
    DetectMobile()
    local vs = workspace.CurrentCamera.ViewportSize
    return IsMobile and UDim2.new(0, vs.X*0.88, 0, vs.Y*0.65) or UDim2.new(0, 580, 0, 420)
end

local function GetTextSz() 
    return IsMobile and 13 or 11 
end

local function GetElH() 
    return IsMobile and 46 or 40 
end

function Proohio:ToggleUI()
    UIVisible = not UIVisible
    if MainUI then
        MainUI.Visible = UIVisible
        Tween(MainUI, {Size = UIVisible and GetSize() or UDim2.new(0,0,0,0)}, 0.25, Enum.EasingStyle.Back)
    end
end

function Proohio.CreateLib(name, theme)
    CurrentTheme = type(theme)=="string" and THEMES[theme] or type(theme)=="table" and theme or THEMES.Proohio
    name = name or "Proohio UI"
    
    for _,v in ipairs(game.CoreGui:GetChildren()) do
        if v.Name == UI_NAME then v:Destroy() end
    end
    
    if gethui then
        local hui = gethui()
        for _,v in ipairs(hui:GetChildren()) do
            if v.Name == UI_NAME then v:Destroy() end
        end
    end
    
    local parentGui = (gethui and gethui()) or game.CoreGui
    
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = UI_NAME
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parentGui
    ScreenGui.DisplayOrder = 100

    FloatBtn = CreateFrame({Color=CurrentTheme.Header, Size=UDim2.new(0,48,0,48), Pos=UDim2.new(0.5,-24,0.5,-24), Parent=ScreenGui, Z=1000})
    Corner(FloatBtn,12)
    Stroke(FloatBtn, CurrentTheme.Sub, 0.8, 2)
    
    local Icon = Instance.new("ImageLabel")
    Icon.Parent = FloatBtn
    Icon.BackgroundTransparency = 1
    Icon.Size = UDim2.new(1,-10,1,-10)
    Icon.Position = UDim2.new(0,5,0,5)
    Icon.Image = "rbxassetid://74489035156742"
    Icon.ScaleType = Enum.ScaleType.Crop
    Icon.ZIndex = 1001

    local FloatBtnClick = Instance.new("TextButton")
    FloatBtnClick.BackgroundTransparency = 1
    FloatBtnClick.Size = UDim2.new(1,0,1,0)
    FloatBtnClick.Text = ""
    FloatBtnClick.Parent = FloatBtn
    FloatBtnClick.MouseButton1Click:Connect(function() Proohio:ToggleUI() end)

    local dragging = false
    local dragInput, dragStart, startPos

    FloatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    FloatBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            FloatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    MainUI = CreateFrame({Color=CurrentTheme.Bg, Size=UDim2.new(0,0,0,0), Pos=UDim2.new(0.5,-290,0.5,-210), Clip=true, Parent=ScreenGui})
    MainUI.Visible = false
    Corner(MainUI,12)
    local mS=Stroke(MainUI,Color3.fromRGB(255,255,255),1)
    Tween(mS,{Transparency=0.9},0.4)

    local TitleBar = CreateFrame({Color=CurrentTheme.Header, Size=UDim2.new(1,0,0,38), Z=2, Parent=MainUI})
    Corner(TitleBar,12)
    
    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency=1
    Title.Position=UDim2.new(0,16,0,0)
    Title.Size=UDim2.new(1,-32,1,0)
    Title.Font=Enum.Font.GothamBold
    Title.Text=name
    Title.TextColor3=CurrentTheme.Sub
    Title.TextSize=GetTextSz()
    Title.TextXAlignment=Enum.TextXAlignment.Left
    Title.ZIndex=2
    Title.Parent=TitleBar

    local uiDragging = false
    local uiDragInput, uiDragStart, uiStartPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            uiDragging=true
            uiDragStart=input.Position
            uiStartPos=MainUI.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then uiDragging=false end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then uiDragInput=input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input==uiDragInput and uiDragging then
            local delta=input.Position-uiDragStart
            MainUI.Position=UDim2.new(uiStartPos.X.Scale,uiStartPos.X.Offset+delta.X,uiStartPos.Y.Scale,uiStartPos.Y.Offset+delta.Y)
        end
    end)

    local Sidebar = CreateFrame({Color=CurrentTheme.Sidebar, Size=UDim2.new(0,130,1,-38), Pos=UDim2.new(0,0,0,38), Parent=MainUI})
    Corner(Sidebar,12)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.BackgroundTransparency=1
    TabScroll.BorderSizePixel=0
    TabScroll.Size=UDim2.new(1,0,1,-54)
    TabScroll.ScrollBarThickness=0
    TabScroll.CanvasSize=UDim2.new(0,0,0,0)
    TabScroll.Parent=Sidebar

    local TabLL = Instance.new("UIListLayout")
    TabLL.SortOrder=Enum.SortOrder.LayoutOrder
    TabLL.Padding=UDim.new(0,3)
    TabLL.Parent=TabScroll

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop=UDim.new(0,6)
    TabPad.PaddingLeft=UDim.new(0,8)
    TabPad.PaddingRight=UDim.new(0,8)
    TabPad.Parent=TabScroll

    TabLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize=UDim2.new(0,0,0,TabLL.AbsoluteContentSize.Y+12)
    end)

    local Profile = CreateFrame({Color=CurrentTheme.Sidebar, Alpha=0, Size=UDim2.new(1,0,0,54), Pos=UDim2.new(0,0,1,-54), Parent=Sidebar})
    Corner(Profile,12)

    local AvHolder = CreateFrame({Color=Color3.fromRGB(26,26,26), Size=UDim2.new(0,30,0,30), Pos=UDim2.new(0,10,0.5,-15), Parent=Profile})
    Corner(AvHolder,100)
    Stroke(AvHolder,Color3.fromRGB(255,255,255),0.9)

    local AvImg = Instance.new("ImageLabel")
    AvImg.BackgroundTransparency=1
    AvImg.Size=UDim2.new(1,0,1,0)
    AvImg.ScaleType=Enum.ScaleType.Crop
    AvImg.Parent=AvHolder
    Corner(AvImg,100)

    local DispName = Instance.new("TextLabel")
    DispName.BackgroundTransparency=1
    DispName.Position=UDim2.new(0,46,0,10)
    DispName.Size=UDim2.new(1,-56,0,14)
    DispName.Font=Enum.Font.GothamBold
    DispName.Text="..."
    DispName.TextColor3=Color3.fromRGB(200,200,200)
    DispName.TextSize=11
    DispName.TextXAlignment=Enum.TextXAlignment.Left
    DispName.TextTruncate=Enum.TextTruncate.AtEnd
    DispName.Parent=Profile

    local UserName = Instance.new("TextLabel")
    UserName.BackgroundTransparency=1
    UserName.Position=UDim2.new(0,46,0,26)
    UserName.Size=UDim2.new(1,-56,0,12)
    UserName.Font=Enum.Font.Gotham
    UserName.Text="@..."
    UserName.TextColor3=Color3.fromRGB(68,68,68)
    UserName.TextSize=9
    UserName.TextXAlignment=Enum.TextXAlignment.Left
    UserName.TextTruncate=Enum.TextTruncate.AtEnd
    UserName.Parent=Profile

    local Status = CreateFrame({Color=Color3.fromRGB(34,197,94), Size=UDim2.new(0,5,0,5), Pos=UDim2.new(1,-18,0.5,-2.5), Parent=Profile})
    Corner(Status,100)

    local lp = Players.LocalPlayer
    DispName.Text = lp.DisplayName
    UserName.Text = "@"..lp.Name
    pcall(function()
        local img = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        AvImg.Image = img
    end)

    local Content = CreateFrame({Alpha=1, Size=UDim2.new(1,-130,1,-38), Pos=UDim2.new(0,130,0,38), Parent=MainUI})
    Corner(Content,12)
    Content.ClipsDescendants=true

    local Pages = Instance.new("Folder")
    Pages.Parent=Content
    local Tabs, allTabs, first = {}, {}, true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local isFirst = first
        first = false

        local TabBtn = Instance.new("TextButton")
        TabBtn.BackgroundColor3=Color3.fromRGB(255,255,255)
        TabBtn.BackgroundTransparency=isFirst and 0.9 or 1
        TabBtn.BorderSizePixel=0
        TabBtn.Size=UDim2.new(1,0,0,30)
        TabBtn.AutoButtonColor=false
        TabBtn.Font=Enum.Font.GothamMedium
        TabBtn.Text=tabName
        TabBtn.TextColor3=isFirst and CurrentTheme.Text or CurrentTheme.Sub
        TabBtn.TextSize=GetTextSz()
        TabBtn.ZIndex=2
        TabBtn.Parent=TabScroll
        Corner(TabBtn,6)
        local tS=Stroke(TabBtn,Color3.fromRGB(255,255,255),isFirst and 0.9 or 1)

        local Page = Instance.new("ScrollingFrame")
        Page.BackgroundTransparency=1
        Page.BorderSizePixel=0
        Page.Size=UDim2.new(1,0,1,0)
        Page.ScrollBarThickness=3
        Page.ScrollBarImageColor3=Color3.fromRGB(255,255,255)
        Page.ScrollBarImageTransparency=0.9
        Page.CanvasSize=UDim2.new(0,0,0,0)
        Page.Visible=isFirst
        Page.Parent=Content

        local PageLL = Instance.new("UIListLayout")
        PageLL.SortOrder=Enum.SortOrder.LayoutOrder
        PageLL.Padding=UDim.new(0,10)
        PageLL.Parent=Page

        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop=UDim.new(0,10)
        PagePad.PaddingLeft=UDim.new(0,10)
        PagePad.PaddingRight=UDim.new(0,10)
        PagePad.PaddingBottom=UDim.new(0,10)
        PagePad.Parent=Page

        local function Refresh() Page.CanvasSize=UDim2.new(0,0,0,PageLL.AbsoluteContentSize.Y+20) end
        PageLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Refresh)

        table.insert(allTabs, {btn=TabBtn, stroke=tS, page=Page})

        TabBtn.MouseButton1Click:Connect(function()
            for _,d in ipairs(allTabs) do
                d.page.Visible=false
                Tween(d.btn,{BackgroundTransparency=1,TextColor3=CurrentTheme.Sub},0.12)
                Tween(d.stroke,{Transparency=1},0.12)
            end
            Page.Visible=true
            Tween(TabBtn,{BackgroundTransparency=0.9,TextColor3=CurrentTheme.Text},0.15)
            Tween(tS,{Transparency=0.9},0.15)
            Refresh()
        end)

        local Sections = {}
        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            hidden = hidden or false
            local SecF = CreateFrame({Alpha=1, Size=UDim2.new(1,0,0,8), Parent=Page})
            local SecLL = Instance.new("UIListLayout")
            SecLL.SortOrder=Enum.SortOrder.LayoutOrder
            SecLL.Padding=UDim.new(0,5)
            SecLL.Parent=SecF

            if not hidden then
                local SecT = Instance.new("TextLabel")
                SecT.BackgroundTransparency=1
                SecT.AutomaticSize=Enum.AutomaticSize.X
                SecT.Size=UDim2.new(0,0,0,16)
                SecT.Font=Enum.Font.GothamBold
                SecT.Text=string.upper(secName)
                SecT.TextColor3=CurrentTheme.Muted
                SecT.TextSize=9
                SecT.TextXAlignment=Enum.TextXAlignment.Left
                SecT.Parent=SecF
            end

            local Hold = CreateFrame({Alpha=1, Size=UDim2.new(1,0,0,0), Parent=SecF})
            local HoldLL = Instance.new("UIListLayout")
            HoldLL.SortOrder=Enum.SortOrder.LayoutOrder
            HoldLL.Padding=UDim.new(0,5)
            HoldLL.Parent=Hold

            local function Resize()
                Hold.Size=UDim2.new(1,0,0,HoldLL.AbsoluteContentSize.Y)
                SecF.Size=UDim2.new(1,0,0,SecLL.AbsoluteContentSize.Y)
                Refresh()
            end
            HoldLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
            SecLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

            local function El(h)
                local f=CreateFrame({Color=CurrentTheme.El, Size=UDim2.new(1,0,0,h or GetElH()), Parent=Hold})
                Corner(f,10)
                local s=Stroke(f,Color3.fromRGB(255,255,255),0.92)
                return f,s
            end

            local Elements = {}
            function Elements:NewButton(n,_,cb)
                n=n or "Button"
                cb=cb or function() end
                local f,s=El(GetElH())
                local L=Instance.new("TextLabel")
                L.BackgroundTransparency=1
                L.Position=UDim2.new(0,12,0,0)
                L.Size=UDim2.new(1,-24,1,0)
                L.Font=Enum.Font.GothamMedium
                L.Text=n
                L.TextColor3=CurrentTheme.Sub
                L.TextSize=GetTextSz()
                L.TextXAlignment=Enum.TextXAlignment.Left
                L.Parent=f
                local Hit=Instance.new("TextButton")
                Hit.BackgroundTransparency=1
                Hit.BorderSizePixel=0
                Hit.Size=UDim2.new(1,0,1,0)
                Hit.Text=""
                Hit.AutoButtonColor=false
                Hit.ZIndex=2
                Hit.Parent=f
                Hit.MouseButton1Click:Connect(function()
                    Tween(f,{BackgroundColor3=Color3.fromRGB(255,255,255)},0.06)
                    Tween(L,{TextColor3=Color3.fromRGB(0,0,0)},0.06)
                    task.delay(0.12,function() Tween(f,{BackgroundColor3=CurrentTheme.El},0.12) Tween(L,{TextColor3=CurrentTheme.Sub},0.12) end)
                    cb()
                end)
                Hit.MouseEnter:Connect(function() Tween(s,{Transparency=0.85},0.08) Tween(L,{TextColor3=Color3.fromRGB(200,200,200)},0.08) end)
                Hit.MouseLeave:Connect(function() Tween(s,{Transparency=0.92},0.08) Tween(L,{TextColor3=CurrentTheme.Sub},0.08) end)
                Resize()
                local F={}
                function F:UpdateButton(t) L.Text=t end
                return F
            end
            
            function Elements:NewToggle(n,_,cb)
                n=n or "Toggle"
                cb=cb or function() end
                local on=false
                local f,s=El(GetElH())
                local L=Instance.new("TextLabel")
                L.BackgroundTransparency=1
                L.Position=UDim2.new(0,12,0,0)
                L.Size=UDim2.new(1,-54,1,0)
                L.Font=Enum.Font.GothamMedium
                L.Text=n
                L.TextColor3=CurrentTheme.Sub
                L.TextSize=GetTextSz()
                L.TextXAlignment=Enum.TextXAlignment.Left
                L.Parent=f
                local Pill=CreateFrame({Color=Color3.fromRGB(42,42,42), Size=UDim2.new(0,34,0,20), Pos=UDim2.new(1,-48,0.5,-10), Parent=f})
                Corner(Pill,100)
                local Circ=CreateFrame({Color=Color3.fromRGB(85,85,85), Size=UDim2.new(0,14,0,14), Pos=UDim2.new(0,3,0.5,-7), Parent=Pill})
                Corner(Circ,100)
                local Hit=Instance.new("TextButton")
                Hit.BackgroundTransparency=1
                Hit.BorderSizePixel=0
                Hit.Size=UDim2.new(1,0,1,0)
                Hit.Text=""
                Hit.AutoButtonColor=false
                Hit.ZIndex=2
                Hit.Parent=f
                local function Set(st)
                    on=st
                    if on then Tween(Pill,{BackgroundColor3=Color3.fromRGB(255,255,255)},0.15) Tween(Circ,{Position=UDim2.new(1,-17,0.5,-7),BackgroundColor3=Color3.fromRGB(17,17,17)},0.15)
                    else Tween(Pill,{BackgroundColor3=Color3.fromRGB(42,42,42)},0.15) Tween(Circ,{Position=UDim2.new(0,3,0.5,-7),BackgroundColor3=Color3.fromRGB(85,85,85)},0.15) end
                end
                Hit.MouseButton1Click:Connect(function() Set(not on) cb(on) end)
                Hit.MouseEnter:Connect(function() Tween(s,{Transparency=0.85},0.08) Tween(L,{TextColor3=Color3.fromRGB(200,200,200)},0.08) end)
                Hit.MouseLeave:Connect(function() Tween(s,{Transparency=0.92},0.08) Tween(L,{TextColor3=CurrentTheme.Sub},0.08) end)
                Resize()
                local F={}
                function F:UpdateToggle(nt,st) if nt then L.Text=nt end if st~=nil then Set(st) cb(on) end end
                return F
            end
            
            function Elements:NewSlider(n,_,mx,mn,cb)
                n=n or "Slider"
                mx=mx or 100
                mn=mn or 0
                cb=cb or function() end
                local f,s=El(56)
                local L=Instance.new("TextLabel")
                L.BackgroundTransparency=1
                L.Position=UDim2.new(0,12,0,8)
                L.Size=UDim2.new(1,-60,0,14)
                L.Font=Enum.Font.GothamMedium
                L.Text=n
                L.TextColor3=CurrentTheme.Sub
                L.TextSize=GetTextSz()
                L.TextXAlignment=Enum.TextXAlignment.Left
                L.Parent=f
                local VB=CreateFrame({Color=Color3.fromRGB(31,31,31), Size=UDim2.new(0,34,0,18), Pos=UDim2.new(1,-48,0,8), Parent=f})
                Corner(VB,6)
                Stroke(VB,Color3.fromRGB(255,255,255),0.9)
                local VL=Instance.new("TextLabel")
                VL.BackgroundTransparency=1
                VL.Size=UDim2.new(1,0,1,0)
                VL.Font=Enum.Font.GothamBold
                VL.Text=tostring(mn)
                VL.TextColor3=CurrentTheme.Text
                VL.TextSize=10
                VL.Parent=VB
                local Tr=CreateFrame({Color=Color3.fromRGB(255,255,255), Alpha=0.9, Size=UDim2.new(1,-24,0,4), Pos=UDim2.new(0,12,1,-14), Parent=f})
                Corner(Tr,100)
                local Fl=CreateFrame({Color=Color3.fromRGB(255,255,255), Alpha=0.3, Size=UDim2.new(0,0,1,0), Parent=Tr})
                Corner(Fl,100)
                local Kn=CreateFrame({Color=Color3.fromRGB(255,255,255), Size=UDim2.new(0,12,0,12), Pos=UDim2.new(0,-6,0.5,-6), Z=3, Parent=Tr})
                Corner(Kn,100)
                local HA=Instance.new("TextButton")
                HA.BackgroundTransparency=1
                HA.BorderSizePixel=0
                HA.Position=UDim2.new(0,-6,0,-8)
                HA.Size=UDim2.new(1,12,1,16)
                HA.Text=""
                HA.AutoButtonColor=false
                HA.ZIndex=4
                HA.Parent=Tr
                local cv=mn
                local sl=false
                local function SetV(px)
                    local tw=Tr.AbsoluteSize.X
                    local tx=Tr.AbsolutePosition.X
                    local pc=math.clamp((px-tx)/tw,0,1)
                    cv=math.floor(mn+(mx-mn)*pc)
                    Fl.Size=UDim2.new(pc,0,1,0)
                    Kn.Position=UDim2.new(pc,-6,0.5,-6)
                    VL.Text=tostring(cv)
                    cb(cv)
                end
                HA.MouseButton1Down:Connect(function() sl=true SetV(UserInputService:GetMouseLocation().X) end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then sl=false end end)
                UserInputService.InputChanged:Connect(function(i) if sl and i.UserInputType==Enum.UserInputType.MouseMovement then SetV(i.Position.X) end end)
                f.MouseEnter:Connect(function() Tween(s,{Transparency=0.85},0.08) Tween(L,{TextColor3=Color3.fromRGB(200,200,200)},0.08) end)
                f.MouseLeave:Connect(function() Tween(s,{Transparency=0.92},0.08) Tween(L,{TextColor3=CurrentTheme.Sub},0.08) end)
                Resize()
            end
            
            function Elements:NewTextBox(n,_,cb)
                n=n or "TextBox"
                cb=cb or function() end
                local f,s=El(GetElH())
                local L=Instance.new("TextLabel")
                L.BackgroundTransparency=1
                L.Position=UDim2.new(0,12,0,0)
                L.Size=UDim2.new(0,90,1,0)
                L.Font=Enum.Font.GothamMedium
                L.Text=n
                L.TextColor3=CurrentTheme.Sub
                L.TextSize=GetTextSz()
                L.TextXAlignment=Enum.TextXAlignment.Left
                L.Parent=f
                local IB=CreateFrame({Color=Color3.fromRGB(15,15,15), Size=UDim2.new(1,-110,0,22), Pos=UDim2.new(0,108,0.5,-11), Parent=f})
                Corner(IB,7)
                local iS=Stroke(IB,Color3.fromRGB(255,255,255),0.9)
                local Box=Instance.new("TextBox")
                Box.BackgroundTransparency=1
                Box.BorderSizePixel=0
                Box.Position=UDim2.new(0,7,0,0)
                Box.Size=UDim2.new(1,-14,1,0)
                Box.Font=Enum.Font.Gotham
                Box.PlaceholderText="Enter..."
                Box.PlaceholderColor3=Color3.fromRGB(68,68,68)
                Box.Text=""
                Box.TextColor3=CurrentTheme.Text
                Box.TextSize=10
                Box.TextXAlignment=Enum.TextXAlignment.Left
                Box.ClearTextOnFocus=false
                Box.Parent=IB
                Box.Focused:Connect(function() Tween(iS,{Transparency=0.78},0.08) end)
                Box.FocusLost:Connect(function(en) Tween(iS,{Transparency=0.9},0.08) if en then cb(Box.Text) end end)
                f.MouseEnter:Connect(function() Tween(s,{Transparency=0.85},0.08) end)
                f.MouseLeave:Connect(function() Tween(s,{Transparency=0.92},0.08) end)
                Resize()
            end
            
            function Elements:NewLabel(t)
                t=t or "Label"
                local f=CreateFrame({Color=Color3.fromRGB(17,17,17), Size=UDim2.new(1,0,0,32), Parent=Hold})
                Corner(f,10)
                Stroke(f,Color3.fromRGB(255,255,255),0.94)
                local L=Instance.new("TextLabel")
                L.BackgroundTransparency=1
                L.Position=UDim2.new(0,12,0,0)
                L.Size=UDim2.new(1,-24,1,0)
                L.Font=Enum.Font.Gotham
                L.Text=t
                L.TextColor3=Color3.fromRGB(68,68,68)
                L.TextSize=10
                L.TextXAlignment=Enum.TextXAlignment.Left
                L.Parent=f
                Resize()
                local F={}
                function F:UpdateLabel(nt) L.Text=nt end
                return F
            end
            
            function Elements:NewDropdown(n,_,lst,cb)
                n=n or "Dropdown"
                lst=lst or {}
                cb=cb or function() end
                local op=false
                local Wrap=CreateFrame({Alpha=1, Size=UDim2.new(1,0,0,GetElH()), Clip=true, Parent=Hold})
                local Head=CreateFrame({Color=CurrentTheme.El, Size=UDim2.new(1,0,0,GetElH()), Parent=Wrap})
                Corner(Head,10)
                local hS=Stroke(Head,Color3.fromRGB(255,255,255),0.92)
                local HL=Instance.new("TextLabel")
                HL.BackgroundTransparency=1
                HL.Position=UDim2.new(0,12,0,0)
                HL.Size=UDim2.new(1,-36,1,0)
                HL.Font=Enum.Font.GothamMedium
                HL.Text=n
                HL.TextColor3=CurrentTheme.Sub
                HL.TextSize=GetTextSz()
                HL.TextXAlignment=Enum.TextXAlignment.Left
                HL.Parent=Head
                local Arr=Instance.new("TextLabel")
                Arr.BackgroundTransparency=1
                Arr.AnchorPoint=Vector2.new(1,0.5)
                Arr.Position=UDim2.new(1,-12,0.5,0)
                Arr.Size=UDim2.new(0,14,0,14)
                Arr.Font=Enum.Font.GothamBold
                Arr.Text="v"
                Arr.TextColor3=Color3.fromRGB(68,68,68)
                Arr.TextSize=9
                Arr.Parent=Head
                local HBtn=Instance.new("TextButton")
                HBtn.BackgroundTransparency=1
                HBtn.BorderSizePixel=0
                HBtn.Size=UDim2.new(1,0,1,0)
                HBtn.Text=""
                HBtn.AutoButtonColor=false
                HBtn.ZIndex=2
                HBtn.Parent=Head
                local OB=CreateFrame({Color=Color3.fromRGB(17,17,17), Size=UDim2.new(1,0,0,0), Clip=true, Parent=Wrap})
                Corner(OB,10)
                Stroke(OB,Color3.fromRGB(255,255,255),0.88)
                local OLL=Instance.new("UIListLayout")
                OLL.SortOrder=Enum.SortOrder.LayoutOrder
                OLL.Parent=OB
                local function Build(ops)
                    for _,c in ipairs(OB:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _,o in ipairs(ops) do
                        local Btn=Instance.new("TextButton")
                        Btn.BackgroundTransparency=1
                        Btn.BackgroundColor3=Color3.fromRGB(255,255,255)
                        Btn.BorderSizePixel=0
                        Btn.Size=UDim2.new(1,0,0,28)
                        Btn.AutoButtonColor=false
                        Btn.Font=Enum.Font.Gotham
                        Btn.Text="  "..o
                        Btn.TextColor3=Color3.fromRGB(102,102,102)
                        Btn.TextSize=10
                        Btn.TextXAlignment=Enum.TextXAlignment.Left
                        Btn.ZIndex=3
                        Btn.Parent=OB
                        Instance.new("UIPadding",Btn).PaddingLeft=UDim.new(0,12)
                        Btn.MouseButton1Click:Connect(function()
                            HL.Text=o
                            cb(o)
                            op=false
                            Tween(OB,{Size=UDim2.new(1,0,0,0)},0.12)
                            Tween(Arr,{Rotation=0},0.12)
                            Wrap.Size=UDim2.new(1,0,0,GetElH())
                            Resize()
                        end)
                        Btn.MouseEnter:Connect(function() Tween(Btn,{BackgroundTransparency=0.93,TextColor3=CurrentTheme.Text},0.08) end)
                        Btn.MouseLeave:Connect(function() Tween(Btn,{BackgroundTransparency=1,TextColor3=Color3.fromRGB(102,102,102)},0.08) end)
                    end
                end
                Build(lst)
                HBtn.MouseButton1Click:Connect(function()
                    op=not op
                    local oh=OLL.AbsoluteContentSize.Y+6
                    if op then Tween(OB,{Size=UDim2.new(1,0,0,oh)},0.15) Tween(Arr,{Rotation=180},0.12) Wrap.Size=UDim2.new(1,0,0,GetElH()+4+oh)
                    else Tween(OB,{Size=UDim2.new(1,0,0,0)},0.12) Tween(Arr,{Rotation=0},0.12) Wrap.Size=UDim2.new(1,0,0,GetElH()) end
                    Resize()
                end)
                HBtn.MouseEnter:Connect(function() Tween(hS,{Transparency=0.85},0.08) Tween(HL,{TextColor3=Color3.fromRGB(200,200,200)},0.08) end)
                HBtn.MouseLeave:Connect(function() Tween(hS,{Transparency=0.92},0.08) Tween(HL,{TextColor3=CurrentTheme.Sub},0.08) end)
                Resize()
                local F={}
                function F:Refresh(nl) Build(nl) op=false OB.Size=UDim2.new(1,0,0,0) Arr.Rotation=0 Wrap.Size=UDim2.new(1,0,0,GetElH()) Resize() end
                return F
            end
            Resize()
            return Elements
        end
        return Sections
    end
    return Tabs
end

return Proohio
