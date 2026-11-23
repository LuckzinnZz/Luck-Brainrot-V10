local url='https://raw.githubusercontent.com/LuckzinnZz/Luck-Brainrot-V10/main/Main.lua'
local ok,err=pcall(function()
 local source=game:HttpGet(url)
 local fn,compileError=loadstring(source)
 assert(fn,compileError)
 fn()
end)
if not ok then warn('[LUCK V11] '..tostring(err)) end
