local base='https://raw.githubusercontent.com/LuckzinnZz/Luck-Brainrot-V10/main/'
local env=(type(getgenv)=='function' and getgenv()) or _G
if env.LuckBrainrotV10Stop then pcall(env.LuckBrainrotV10Stop) end
local function requireRemote(name)
 local source=game:HttpGet(base..name)
 local fn,err=loadstring(source)
 assert(fn,err)
 return fn()
end
local Brainrot=requireRemote('Brainrot.lua')
local ui=requireRemote('UI.lua').create()
local running,enabled=true,false
local target,prompt
local connections={}
connections[#connections+1]=ui.toggle.MouseButton1Click:Connect(function()
 enabled=not enabled
 ui.toggle.Text=enabled and 'DETECTAR: ON' or 'DETECTAR: OFF'
 if not enabled then ui.action.Visible=false;ui.status.Text='Desativado' end
end)
connections[#connections+1]=ui.action.MouseButton1Click:Connect(function()
 if not enabled or not target then return end
 if not prompt then
  ui.status.Text='Grab nao encontrado neste Brainrot.'
 elseif not prompt.Enabled then
  ui.status.Text='Grab desativado pelo servidor. Sem transferencia.'
 else
  ui.status.Text='Grab disponivel. Use a interacao normal do jogo.'
 end
end)
task.spawn(function()
 while running do
  if enabled then
   local model,owner,distance,grab=Brainrot.nearest(14)
   target,prompt=model,grab
   ui.action.Visible=model~=nil
   if model then
    ui.status.Text=string.format('Brainrot: %s\nDono: %s\nDistancia: %.1f\nGrab: %s',model.Name,tostring(owner),distance,grab and tostring(grab.Enabled) or 'ausente')
   else ui.status.Text='Aproxime-se de outra base.' end
  end
  task.wait(.3)
 end
end)
env.LuckBrainrotV10Stop=function()
 running=false
 for _,connection in ipairs(connections) do connection:Disconnect() end
 ui.cleanup()
 env.LuckBrainrotV10Stop=nil
end
print('[LUCK V10] Painel carregado; nao transfere Brainrots.')
