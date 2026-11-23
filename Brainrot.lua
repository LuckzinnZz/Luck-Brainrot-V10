local Players=game:GetService('Players')
local player=Players.LocalPlayer
local M={}
function M.nearest(radius)
 local root=player.Character and player.Character:FindFirstChild('HumanoidRootPart')
 local map=workspace:FindFirstChild('Map')
 local bases=map and map:FindFirstChild('Bases')
 if not root or not bases then return nil end
 local nearest,owner,distance,grab=nil,nil,radius or 14,nil
 for _,base in ipairs(bases:GetChildren()) do
  local config=base:FindFirstChild('Configuration')
  local value=config and config:FindFirstChild('Player')
  local name=value and tostring(value.Value) or ''
  if name~='' and name~=player.Name and name~=tostring(player.UserId) then
   local slots=base:FindFirstChild('Slots')
   if slots then
    for _,slot in ipairs(slots:GetChildren()) do
     for _,model in ipairs(slot:GetChildren()) do
      if model:IsA('Model') then
       local ok,pivot=pcall(function() return model:GetPivot() end)
       if ok then
        local d=(root.Position-pivot.Position).Magnitude
        if d<distance then
         nearest,owner,distance,grab=model,name,d,nil
         for _,desc in ipairs(model:GetDescendants()) do
          if desc:IsA('ProximityPrompt') and desc.ActionText:lower()=='grab' then grab=desc;break end
         end
        end
       end
      end
     end
    end
   end
  end
 end
 return nearest,owner,distance,grab
end
return M
