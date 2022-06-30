--[[
	Source code inspired by ComputerPhile, and researched sources 
--]]

local RSAModule = {
	
}

function RSAModule:ModulusClock(x, p, modulo)
	local oX = x -- since x will change
	
	for i = 2, p do
		x = ((x * oX) % modulo)
	end
	
	return x
end

return RSAModule
