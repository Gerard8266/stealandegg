-- ==========================================
-- SCRIPT DE AUTOMATIZACIÓN - STEAL AN EGG
-- ==========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

print(">>> [Academic Bot] Iniciando script personalizado...")

-- Módulo Anti-AFK Básico
LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    print("[Anti-AFK] Inactividad prevenida.")
end)

-- Loop principal de ejemplo
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            -- Lógica de automatización del juego aqui
        end)
    end
end)
