-- ==========================================
-- PROJETO ACADÊMICO: Auto Farm & Service Manager
-- Jogo: Steal an Egg (Roblox)
-- ==========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Configurações do Sistema (Estado Global)
getgenv().BotSettings = {
    AutoSteal = true,
    AutoHatch = true,
    AutoUpgrade = true,
    AntiAFK = true,
    WebhookURL = "", -- Cole seu webhook do Discord aqui se quiser testar
    CheckInterval = 1.5
}

print("=== [Miranda Hub Style / Acadêmico] Inicializado com sucesso! ===")

-- 1. Módulo Anti-AFK 24/7
if BotSettings.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[Anti-AFK] Sinal de inatividade evitado.")
    end)
end

-- 2. Sistema de Integração com Webhook (Discord API)
local function SendWebhookLog(title, description)
    if BotSettings.WebhookURL == "" then return end
    pcall(function()
        request({
            Url = BotSettings.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ["embeds"] = {{
                    ["title"] = "🤖 [Bot Log] - " .. title,
                    ["description"] = description,
                    ["color"] = 3447003,
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            })
        })
    end)
end

-- 3. Algoritmo de Varredura e Roubo de Ovos (Auto Steal)
local function RunAutoSteal()
    if not BotSettings.AutoSteal then return end
    
    pcall(function()
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = character.HumanoidRootPart

        -- Varre a pasta de ovos no Workspace (ajuste o nome conforme o mapa do jogo)
        local eggsFolder = Workspace:FindFirstChild("EggsFolder") or Workspace:FindFirstChild("Eggs")
        if eggsFolder then
            for _, egg in ipairs(eggsFolder:GetChildren()) do
                if egg:IsA("BasePart") or egg:IsA("Model") then
                    local targetPos = egg:IsA("Model") and egg:GetPivot().Position or egg.Position
                    local distance = (rootPart.Position - targetPos).Magnitude
                    
                    -- Se o ovo estiver próximo, executa a ação de pegar
                    if distance < 60 then
                        rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                        task.wait(0.2)
                    end
                end
            end
        end
    end)
end

-- 4. Rotinas Assíncronas por Concorrência (Threads)
task.spawn(function()
    while true do
        RunAutoSteal()
        task.wait(BotSettings.CheckInterval)
    end
end)

-- Notificação visual no executor/jogo
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Academic Bot Ativo",
        Text = "O script de automação começou a rodar!",
        Duration = 5
    })
end)

SendWebhookLog("Script Iniciado", "O sistema acadêmico foi injetado com sucesso via Solara.")
