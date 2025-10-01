-- HypeHub Library - Versão Melhorada
-- By: Redz

local HypeHub = {}
HypeHub.__index = HypeHub

-- Serviços
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configurações de transparência
local TRANSPARENCY_SETTINGS = {
    Background = 0.15,  -- Mais transparente
    Section = 0.1,
    Element = 0.2,
    Stroke = 0.7
}

function HypeHub.new(Name)
    local self = setmetatable({}, HypeHub)
    
    -- ScreenGui principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Parent = CoreGui
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Name = Name or "HypeHubLib"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Tabs e elementos
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateMainUI()
    self:CreateReopenFrame()
    
    return self
end

function HypeHub:CreateMainUI()
    -- Menu Principal com transparência
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.Size = UDim2.new(0, 650, 0, 450)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.MainFrame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = self.MainFrame

    -- Stroke com transparência
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = Color3.fromRGB(100, 100, 100)
    Stroke.Transparency = TRANSPARENCY_SETTINGS.Stroke
    Stroke.Parent = self.MainFrame

    -- TopBar transparente
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BackgroundTransparency = TRANSPARENCY_SETTINGS.Background
    TopBar.Parent = self.MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar

    -- Título
    local Title = Instance.new("TextLabel")
    Title.Text = "HypeHub Library"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Botões de controle
    self:CreateControlButtons(TopBar)
    
    -- Estrutura de conteúdo
    self:CreateContentStructure()
    
    -- Sistema de arrasto
    self:MakeDraggable(TopBar)
end

function HypeHub:CreateControlButtons(TopBar)
    -- Botão minimizar
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 35, 0, 35)
    MinBtn.Position = UDim2.new(1, -75, 0.5, -17.5)
    MinBtn.Text = "_"
    MinBtn.BackgroundTransparency = 1
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.Parent = TopBar

    -- Botão fechar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -17.5)
    CloseBtn.Text = "×"
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.Parent = TopBar

    -- Eventos
    MinBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.ReopenFrame.Visible = true
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
end

function HypeHub:CreateContentStructure()
    -- Container principal
    local Content = Instance.new("Frame")
    Content.Position = UDim2.new(0, 160, 0, 45)
    Content.Size = UDim2.new(1, -160, 1, -45)
    Content.BackgroundTransparency = 1
    Content.Parent = self.MainFrame

    -- Lista de tabs
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Position = UDim2.new(0, 10, 0, 45)
    self.TabList.Size = UDim2.new(0, 140, 1, -55)
    self.TabList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.TabList.BackgroundTransparency = TRANSPARENCY_SETTINGS.Section
    self.TabList.ScrollBarThickness = 3
    self.TabList.Parent = self.MainFrame
    
    local TabListCorner = Instance.new("UICorner")
    TabListCorner.CornerRadius = UDim.new(0, 8)
    TabListCorner.Parent = self.TabList

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = self.TabList

    -- Container de páginas
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 1, 0)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = Content
end

function HypeHub:CreateTab(Name)
    local Tab = {}
    
    -- Botão da tab
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Text = Name
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.BorderSizePixel = 0
    Button.Parent = self.TabList
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    -- Página da tab
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 4
    TabPage.Visible = false
    TabPage.Parent = self.TabContainer
    
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 10)
    UIList.Parent = TabPage

    -- Evento de clique
    Button.MouseButton1Click:Connect(function()
        self:SwitchTab(TabPage)
        
        -- Efeito visual
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
    Tab.Elements = {}
    
    table.insert(self.Tabs, Tab)
    
    -- Primeira tab é selecionada por padrão
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

-- Sistema de arrasto melhorado :cite[1]
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

-- Frame de reabrir melhorado
function HypeHub:CreateReopenFrame()
    self.ReopenFrame = Instance.new("Frame")
    self.ReopenFrame.Size = UDim2.new(0, 140, 0, 45)
    self.ReopenFrame.Position = UDim2.new(1, -150, 0, 20)
    self.ReopenFrame.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    self.ReopenFrame.BackgroundTransparency = 0.2
    self.ReopenFrame.Visible = false
    self.ReopenFrame.Parent = self.ScreenGui
    
    local ReopenCorner = Instance.new("UICorner")
    ReopenCorner.CornerRadius = UDim.new(0, 10)
    ReopenCorner.Parent = self.ReopenFrame

    local ReopenText = Instance.new("TextLabel")
    ReopenText.Size = UDim2.new(1, 0, 1, 0)
    ReopenText.Text = "🔧 Reabrir Menu"
    ReopenText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ReopenText.BackgroundTransparency = 1
    ReopenText.Font = Enum.Font.GothamBold
    ReopenText.TextSize = 14
    ReopenText.Parent = self.ReopenFrame

    -- Sistema de arrasto para o reopen frame :cite[1]
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

-- COMPONENTES DA LIBRARY

function HypeHub:CreateSection(Tab, Name)
    local Section = {}
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Section
    Frame.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = Name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    Section.Frame = Frame
    return Section
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
    TextLabel.TextSize = 12
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame
    
    -- Ajuste automático de altura
    TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        TextLabel.Size = UDim2.new(1, 0, 0, TextLabel.TextBounds.Y)
        Frame.Size = UDim2.new(1, -10, 0, TextLabel.TextBounds.Y + 5)
    end)
    
    return Frame
end

-- Toggle melhorado :cite[6]
function HypeHub:CreateToggle(Tab, Config)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    Frame.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = Config.Name
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 45, 0, 22)
    Switch.Position = UDim2.new(1, -50, 0.5, -11)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Switch.AutoButtonColor = false
    Switch.Text = ""
    Switch.Parent = Frame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.Parent = Switch
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local Enabled = Config.CurrentValue or false
    
    local function updateToggle()
        TweenService:Create(Knob, TweenInfo.new(0.2), {
            Position = Enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3 = Enabled and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(200, 200, 200)
        }):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = Enabled and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(60, 60, 60)
        }):Play()
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

-- Slider melhorado :cite[1]:cite[6]
function HypeHub:CreateSlider(Tab, Config)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 60)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Tab.Page

    local Label = Instance.new("TextLabel")
    Label.Text = Config.Name .. ": " .. Config.CurrentValue .. (Config.Suffix or "")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local BarBack = Instance.new("TextButton")
    BarBack.Size = UDim2.new(1, 0, 0, 8)
    BarBack.Position = UDim2.new(0, 0, 0, 30)
    BarBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    BarBack.AutoButtonColor = false
    BarBack.Text = ""
    BarBack.Parent = Frame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = BarBack

    local FillBar = Instance.new("Frame")
    FillBar.Size = UDim2.new((Config.CurrentValue - Config.Range[1]) / (Config.Range[2] - Config.Range[1]), 0, 1, 0)
    FillBar.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
    FillBar.Parent = BarBack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = FillBar

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(FillBar.Size.X.Scale, -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = BarBack
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local draggingSlider = false

    local function setPercent(percent)
        percent = math.clamp(percent, 0, 1)
        FillBar.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, -8, 0.5, -8)
        local Value = math.floor(Config.Range[1] + (Config.Range[2] - Config.Range[1]) * percent)
        Label.Text = Config.Name .. ": " .. Value .. (Config.Suffix or "")
        
        if Config.Callback then 
            Config.Callback(Value) 
        end
    end

    local function onInputChanged(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local absolutePosition = BarBack.AbsolutePosition.X
            local absoluteSize = BarBack.AbsoluteSize.X
            local relative = (mouseX - absolutePosition) / absoluteSize
            setPercent(relative)
        end
    end

    BarBack.MouseButton1Down:Connect(function()
        draggingSlider = true
        local mouseX = UserInputService:GetMouseLocation().X
        local relative = (mouseX - BarBack.AbsolutePosition.X) / BarBack.AbsoluteSize.X
        setPercent(relative)
    end)

    Knob.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(onInputChanged)

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

-- Dropdown melhorado :cite[4]:cite[9]
function HypeHub:CreateDropdown(Tab, Config)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    Frame.ClipsDescendants = true
    Frame.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = Config.Name .. " ▼"
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Open = false
    local OptionFrames = {}

    local function toggleDropdown()
        Open = not Open
        Label.Text = Config.Name .. (Open and " ▲" or " ▼")
        
        for _, optFrame in pairs(OptionFrames) do
            optFrame.Visible = Open
        end
        
        Frame.Size = Open and UDim2.new(1, -10, 0, 35 + #Config.Options * 30) or UDim2.new(1, -10, 0, 35)
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleDropdown()
        end
    end)

    for i, option in ipairs(Config.Options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, -10, 0, 25)
        OptBtn.Position = UDim2.new(0, 5, 0, 35 + (i-1) * 30)
        OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        OptBtn.Text = option
        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 11
        OptBtn.Visible = false
        OptBtn.Parent = Frame
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 4)
        OptCorner.Parent = OptBtn

        OptBtn.MouseButton1Click:Connect(function()
            if Config.Callback then
                Config.Callback(option)
            end
            Label.Text = Config.Name .. " ▼"
            Open = false
            Frame.Size = UDim2.new(1, -10, 0, 35)
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

-- Botão simples
function HypeHub:CreateButton(Tab, Config)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Text = Config.Name
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if Config.Callback then
            Config.Callback()
        end
    end)
    
    return Btn
end

-- TextBox para input
function HypeHub:CreateTextBox(Tab, Config)
    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -10, 0, 35)
    Box.PlaceholderText = Config.Placeholder or "Digite algo..."
    Box.Text = ""
    Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Box.BackgroundTransparency = TRANSPARENCY_SETTINGS.Element
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 12
    Box.ClearTextOnFocus = false
    Box.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Box

    Box.FocusLost:Connect(function(enterPressed)
        if enterPressed and Config.Callback then
            Config.Callback(Box.Text)
        end
    end)
    
    return Box
end

return HypeHub
