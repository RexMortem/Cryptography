local Module = {}

local function WrapAround(a, range, val)
	val -= a 
	return a + (val % range)
end

local function IsLetter(character)
	local i = string.byte(character)
	
	if ((i > 64) and (i < 91)) or ((i > 96) and (i < 123)) then
		return true
	end
end

function Module:CaesarCipher(text, offset) -- ONLY changes characters (not numbers)
	-- can generate raw string using gmatch (%a) (ignoring non-alphanumeric characters)
	local newStr = ""
	local letter,letterCode,modVal
	
	for i = 1,#text do 
		letter = string.sub(text,i,i)
		letterCode = string.byte(letter)
		
		if ((letterCode > 64) and (letterCode < 91)) then -- capital chars
			modVal = WrapAround(65, 26,letterCode + offset)
		elseif  ((letterCode > 96) and (letterCode < 123)) then -- lower case chars
			modVal = WrapAround(97, 26, letterCode + offset)
			
		else
			newStr ..= letter
			continue
		end
		
		newStr ..= string.char(modVal)
	end
	
	return newStr
end

function Module:TranspositionCipher(text, numInRow)
	
end

function Module:RailFence(text, numInRow) -- same numInRow call will reverse the cipher [f-1(x) = f(x)]
	local newStr = ""

	for i = 1, numInRow do
		for d = i, #text, numInRow do
			newStr ..= string.sub(text,d,d)
		end
	end
	
	return newStr
end

return Module
