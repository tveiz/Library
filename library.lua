-- HypeHub Library - Sistema Completo
local HypeHub = {}
HypeHub.__index = HypeHub

-- Serviços
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configurações
local TRANSPARENCY_SETTINGS = {
    Background = 0.15,
    Section = 0.1,
    Element = 0.2,
    Stroke = 0.7
}

function HypeHub.new(Name)
    local self = setmetatable({}, HypeHub)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Parent = CoreGui
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Name = Name or "HypeHubLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    self.Tabs = {}
    self.Flags = {}
    self.CurrentTab = nil
    
    self:CreateMainUI()
    self:CreateReopenFrame()
    
    return self
end

-- UI Principal
function HypeHub:CreateMainUI()
    -- Frame Principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.MainFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    local MainCorner = Instance.new("UICorner", self.MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke", self.MainFrame)
    Stroke.Thickness = 1.5
    Stroke.Color = Color3.fromRGB(100, 100, 100)
    Stroke.Transparency = TRANSPARENCY_SETTINGS.Stroke

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BackgroundTransparency = TRANSPARENCY_SETTINGS.Background
    TopBar.Parent = self.MainFrame
    
    local TopBarCorner = Instance.new("UICorner", TopBar)
    TopBarCorner.CornerRadius = UDim.new(0, 10)

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Text = "HypeHub Library"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Botões de Controle
    self:CreateControlButtons(TopBar)
    self:CreateContentStructure()
    self:MakeDraggable(TopBar)
end

function HypeHub:CreateControlButtons(TopBar)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 35, 0, 35)
    MinBtn.Position = UDim2.new(1, -75, 0, 0)
    MinBtn.Text = "_"
    MinBtn.BackgroundTransparency = 1
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 16
    MinBtn.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.Text = "×"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 18
    CloseBtn.Parent = TopBar

    MinBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.ReopenFrame.Visible = true
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
end

function HypeHub:CreateContentStructure()
    -- Container de Conteúdo
    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.Size = UDim2.new(1, -150, 1, -40)
    Content.BackgroundTransparency = 1
    Content.Parent = self.MainFrame

    -- Lista de Tabs
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Position = UDim2.new(0, 10, 0, 40)
    self.TabList.Size = UDim2.new(0, 130, 1, -50)
    self.TabList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.TabList.BackgroundTransparency = TRANSPARENCY_SETTINGS.Section
    self.TabList.ScrollBarThickness = 3
    self.TabList.Parent = self.MainFrame
    
    local TabListCorner = Instance.new("UICorner", self.TabList)
    TabListCorner.CornerRadius = UDim.new(0, 8)

    local TabLayout = Instance.new("UIListLayout", self.TabList)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)

    -- Container de Páginas
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 1, 0)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = Content
end

-- Sistema de Tabs
function HypeHub:CreateTab(Name)
    local Tab = {}
    
    -- Botão da Tab
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 32)
    Button.Text = Name
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.BorderSizePixel = 0
    Button.Parent = self.TabList
    
    local ButtonCorner = Instance.new("UICorner", Button)
    ButtonCorner.CornerRadius = UDim.new(0, 6)

    -- Página da Tab
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 4
    TabPage.Visible = false
    TabPage.Parent = self.TabContainer
    
    local UIList = Instance.new("UIListLayout", TabPage)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)

    -- Evento de Clique
    Button.MouseButton1Click:Connect(function()
        self:SwitchTab(TabPage)
        for _, btn in pairs(self.TabList:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }):Play()
            end
        end
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 120, 220)
        }):Play()
    end)

    Tab.Button = Button
    Tab.Page = TabPage
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        self:SwitchTab(TabPage)
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 120, 220)
        }):Play()
    end
    
    return Tab
end

function HypeHub:SwitchTab(TabPage)
    for _, tab in pairs(self.Tabs) do
        tab.Page.Visible = false
    end
    TabPage.Visible = true
    self.CurrentTab = TabPage
end

-- Sistema de Flags para salvar configurações
function HypeHub:SetFlag(Flag, Value)
    self.Flags[Flag] = Value
end

function HypeHub:GetFlag(Flag)
    return self.Flags[Flag]
end

-- COMPONENTES COM FORMATAÇÃO PEDIDA

function HypeHub:CreateSection(Tab, Name)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, -10, 0, 30)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SectionFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Section
    SectionFrame.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner", SectionFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = string.upper(Name)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SectionFrame

    return SectionFrame
end

function HypeHub:CreateParagraph(Tab, Text)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 0)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Tab.Page
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 0, 0)
    TextLabel.Text = Text
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextSize = 11
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame
    
    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        TextLabel.Size = UDim2.new(1, 0, 0, TextLabel.TextBounds.Y)
        Frame.Size = UDim2.new(1, -10, 0, TextLabel.TextBounds.Y + 5)
    end)
    
    return Frame
end

-- TOGGLE com formatação correta
function HypeHub:CreateToggle(Config)
    local Tab = Config.Tab or self.CurrentTab
    local Section = Config.Section
    
    local Container = Section or Tab.Page
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    ToggleFrame.Parent = Container
    
    local Corner = Instance.new("UICorner", ToggleFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    -- Configuração em cima
    local ConfigLabel = Instance.new("TextLabel")
    ConfigLabel.Text = "Toggle"
    ConfigLabel.Size = UDim2.new(1, -10, 0, 20)
    ConfigLabel.Position = UDim2.new(0, 10, 0, 5)
    ConfigLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ConfigLabel.BackgroundTransparency = 1
    ConfigLabel.Font = Enum.Font.Gotham
    ConfigLabel.TextSize = 10
    ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
    ConfigLabel.Parent = ToggleFrame

    -- Nome embaixo
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = Config.Name
    NameLabel.Size = UDim2.new(1, -50, 0, 20)
    NameLabel.Position = UDim2.new(0, 10, 0, 25)
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 13
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = ToggleFrame

    -- Switch
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 45, 0, 22)
    Switch.Position = UDim2.new(1, -50, 0, 25)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Switch.AutoButtonColor = false
    Switch.Text = ""
    Switch.Parent = ToggleFrame
    
    local SwitchCorner = Instance.new("UICorner", Switch)
    SwitchCorner.CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.Parent = Switch
    
    local KnobCorner = Instance.new("UICorner", Knob)
    KnobCorner.CornerRadius = UDim.new(1, 0)

    local Enabled = Config.CurrentValue or false
    
    local function updateToggle()
        TweenService:Create(Knob, TweenInfo.new(0.2), {
            Position = Enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(200, 200, 200)
        }):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = Enabled and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(60, 60, 60)
        }):Play()
        
        if Config.Flag then
            self:SetFlag(Config.Flag, Enabled)
        end
    end

    Switch.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        updateToggle()
        if Config.Callback then
            Config.Callback(Enabled)
        end
    end)

    updateToggle()
    
    return {
        SetValue = function(self, Value)
            Enabled = Value
            updateToggle()
        end,
        GetValue = function(self)
            return Enabled
        end
    }
end

-- SLIDER com formatação correta
function HypeHub:CreateSlider(Config)
    local Tab = Config.Tab or self.CurrentTab
    local Section = Config.Section
    
    local Container = Section or Tab.Page

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = Container

    -- Configuração em cima
    local ConfigLabel = Instance.new("TextLabel")
    ConfigLabel.Text = "Slider"
    ConfigLabel.Size = UDim2.new(1, 0, 0, 15)
    ConfigLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ConfigLabel.BackgroundTransparency = 1
    ConfigLabel.Font = Enum.Font.Gotham
    ConfigLabel.TextSize = 10
    ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
    ConfigLabel.Parent = SliderFrame

    -- Nome e valor
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = Config.Name .. ": " .. Config.CurrentValue .. (Config.Suffix or "")
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 0, 0, 15)
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 13
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = SliderFrame

    -- Barra do Slider
    local BarBack = Instance.new("TextButton")
    BarBack.Size = UDim2.new(1, 0, 0, 8)
    BarBack.Position = UDim2.new(0, 0, 0, 40)
    BarBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BarBack.AutoButtonColor = false
    BarBack.Text = ""
    BarBack.Parent = SliderFrame
    
    local BarCorner = Instance.new("UICorner", BarBack)
    BarCorner.CornerRadius = UDim.new(0, 4)

    local FillBar = Instance.new("Frame")
    FillBar.Size = UDim2.new((Config.CurrentValue - Config.Range[1]) / (Config.Range[2] - Config.Range[1]), 0, 1, 0)
    FillBar.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    FillBar.Parent = BarBack
    
    local FillCorner = Instance.new("UICorner", FillBar)
    FillCorner.CornerRadius = UDim.new(0, 4)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(FillBar.Size.X.Scale, -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = BarBack
    
    local KnobCorner = Instance.new("UICorner", Knob)
    KnobCorner.CornerRadius = UDim.new(1, 0)

    local draggingSlider = false

    local function setPercent(percent)
        percent = math.clamp(percent, 0, 1)
        FillBar.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, -8, 0.5, -8)
        local Value = math.floor(Config.Range[1] + (Config.Range[2] - Config.Range[1]) * percent)
        NameLabel.Text = Config.Name .. ": " .. Value .. (Config.Suffix or "")
        
        if Config.Flag then
            self:SetFlag(Config.Flag, Value)
        end
        
        if Config.Callback then 
            Config.Callback(Value) 
        end
    end

    BarBack.MouseButton1Down:Connect(function()
        draggingSlider = true
        local mouseX = UserInputService:GetMouseLocation().X
        local relative = (mouseX - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X
        setPercent(relative)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local relative = (mouseX - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X
            setPercent(relative)
        end
    end)

    setPercent((Config.CurrentValue - Config.Range[1]) / (Config.Range[2] - Config.Range[1]))
    
    return {
        SetValue = function(self, Value)
            local percent = (Value - Config.Range[1]) / (Config.Range[2] - Config.Range[1])
            setPercent(percent)
        end,
        GetValue = function(self)
            return math.floor(Config.Range[1] + (Config.Range[2] - Config.Range[1]) * FillBar.Size.X.Scale)
        end
    }
end

-- BUTTON com formatação correta
function HypeHub:CreateButton(Config)
    local Tab = Config.Tab or self.CurrentTab
    local Section = Config.Section
    
    local Container = Section or Tab.Page

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, -10, 0, 50)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ButtonFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    ButtonFrame.Parent = Container
    
    local Corner = Instance.new("UICorner", ButtonFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    -- Configuração em cima
    local ConfigLabel = Instance.new("TextLabel")
    ConfigLabel.Text = "Button"
    ConfigLabel.Size = UDim2.new(1, -10, 0, 20)
    ConfigLabel.Position = UDim2.new(0, 10, 0, 5)
    ConfigLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ConfigLabel.BackgroundTransparency = 1
    ConfigLabel.Font = Enum.Font.Gotham
    ConfigLabel.TextSize = 10
    ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
    ConfigLabel.Parent = ButtonFrame

    -- Nome embaixo
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = Config.Name
    NameLabel.Size = UDim2.new(1, -10, 0, 20)
    NameLabel.Position = UDim2.new(0, 10, 0, 25)
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 13
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = ButtonFrame

    -- Botão clicável
    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = ButtonFrame

    ClickArea.MouseButton1Click:Connect(function()
        if Config.Callback then
            Config.Callback()
        end
    end)
    
    return ButtonFrame
end

-- DROPDOWN com formatação correta
function HypeHub:CreateDropdown(Config)
    local Tab = Config.Tab or self.CurrentTab
    local Section = Config.Section
    
    local Container = Section or Tab.Page

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -10, 0, 50)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    DropdownFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = Container
    
    local Corner = Instance.new("UICorner", DropdownFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    -- Configuração em cima
    local ConfigLabel = Instance.new("TextLabel")
    ConfigLabel.Text = "Dropdown"
    ConfigLabel.Size = UDim2.new(1, -10, 0, 20)
    ConfigLabel.Position = UDim2.new(0, 10, 0, 5)
    ConfigLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ConfigLabel.BackgroundTransparency = 1
    ConfigLabel.Font = Enum.Font.Gotham
    ConfigLabel.TextSize = 10
    ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
    ConfigLabel.Parent = DropdownFrame

    -- Nome embaixo
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Text = Config.Name .. " ▼"
    NameLabel.Size = UDim2.new(1, -10, 0, 20)
    NameLabel.Position = UDim2.new(0, 10, 0, 25)
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 13
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = DropdownFrame

    local Open = false
    local OptionFrames = {}

    local function toggleDropdown()
        Open = not Open
        NameLabel.Text = Config.Name .. (Open and " ▲" or " ▼")
        
        for _, optFrame in pairs(OptionFrames) do
            optFrame.Visible = Open
        end
        
        DropdownFrame.Size = Open and UDim2.new(1, -10, 0, 50 + #Config.Options * 30) or UDim2.new(1, -10, 0, 50)
    end

    DropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleDropdown()
        end
    end)

    for i, option in ipairs(Config.Options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, -10, 0, 25)
        OptBtn.Position = UDim2.new(0, 5, 0, 50 + (i-1) * 30)
        OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        OptBtn.Text = option
        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 11
        OptBtn.Visible = false
        OptBtn.Parent = DropdownFrame
        
        local OptCorner = Instance.new("UICorner", OptBtn)
        OptCorner.CornerRadius = UDim.new(0, 4)

        OptBtn.MouseButton1Click:Connect(function()
            if Config.Callback then
                Config.Callback(option)
            end
            NameLabel.Text = Config.Name .. " ▼"
            Open = false
            DropdownFrame.Size = UDim2.new(1, -10, 0, 50)
            for _, optFrame in pairs(OptionFrames) do
                optFrame.Visible = false
            end
        end)
        
        table.insert(OptionFrames, OptBtn)
    end
    
    return {
        Refresh = function(self, NewOptions)
            Config.Options = NewOptions
            for _, frame in pairs(OptionFrames) do
                frame:Destroy()
            end
            OptionFrames = {}
            -- Recriar opções...
        end
    }
end

-- TEXTBOX com formatação correta
function HypeHub:CreateTextBox(Config)
    local Tab = Config.Tab or self.CurrentTab
    local Section = Config.Section
    
    local Container = Section or Tab.Page

    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Size = UDim2.new(1, -10, 0, 50)
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextBoxFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    TextBoxFrame.Parent = Container
    
    local Corner = Instance.new("UICorner", TextBoxFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    -- Configuração em cima
    local ConfigLabel = Instance.new("TextLabel")
    ConfigLabel.Text = "Text Box"
    ConfigLabel.Size = UDim2.new(1, -10, 0, 20)
    ConfigLabel.Position = UDim2.new(0, 10, 0, 5)
    ConfigLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ConfigLabel.BackgroundTransparency = 1
    ConfigLabel.Font = Enum.Font.Gotham
    ConfigLabel.TextSize = 10
    ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
    ConfigLabel.Parent = TextBoxFrame

    -- Input embaixo
    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(1, -20, 0, 25)
    InputBox.Position = UDim2.new(0, 10, 0, 25)
    InputBox.PlaceholderText = Config.Placeholder or "Digite algo..."
    InputBox.Text = ""
    InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 12
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = TextBoxFrame
    
    local InputCorner = Instance.new("UICorner", InputBox)
    InputCorner.CornerRadius = UDim.new(0, 4)

    InputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and Config.Callback then
            Config.Callback(InputBox.Text)
        end
    end)
    
    return TextBoxFrame
end

-- Sistema de Arrasto
function HypeHub:MakeDraggable(Frame)
    local dragging, dragInput, dragStart, startPos
    
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Frame de Reabrir
function HypeHub:CreateReopenFrame()
    self.ReopenFrame = Instance.new("Frame")
    self.ReopenFrame.Size = UDim2.new(0, 140, 0, 40)
    self.ReopenFrame.Position = UDim2.new(1, -150, 0, 20)
    self.ReopenFrame.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    self.ReopenFrame.BackgroundTransparency = 0.2
    self.ReopenFrame.Visible = false
    self.ReopenFrame.Parent = self.ScreenGui
    
    local ReopenCorner = Instance.new("UICorner", self.ReopenFrame)
    ReopenCorner.CornerRadius = UDim.new(0, 8)

    local ReopenText = Instance.new("TextLabel")
    ReopenText.Size = UDim2.new(1, 0, 1, 0)
    ReopenText.Text = "🔧 Reabrir Menu"
    ReopenText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ReopenText.BackgroundTransparency = 1
    ReopenText.Font = Enum.Font.GothamBold
    ReopenText.TextSize = 12
    ReopenText.Parent = self.ReopenFrame

    -- Sistema de arrasto para reopen
    self:MakeReopenDraggable()
end

function HypeHub:MakeReopenDraggable()
    local draggingReopen = false
    local dragStart, startPos
    local moved = false

    local function updateDrag(input)
        local delta = input.Position - dragStart
        self.ReopenFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            moved = true
        end
    end

    self.ReopenFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingReopen = true
            dragStart = input.Position
            startPos = self.ReopenFrame.Position
            moved = false
        end
    end)

    self.ReopenFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingReopen = false
            if not moved then
                self.MainFrame.Visible = true
                self.ReopenFrame.Visible = false
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingReopen and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateDrag(input)
        end
    end)
end

return HypeHub
