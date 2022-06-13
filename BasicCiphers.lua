local Module = {}

local function WrapAround(a, range, val)
	val -= a 
	return a + (val % range)
end

function Module:IsLetter(character)
	local i = string.byte(character)
	
	if ((i > 64) and (i < 91)) or ((i > 96) and (i < 123)) then
		return true
	end
end

function Module:FrequencyAnalysisCaseSensitive(text)
	local FrequencyTable = {}
	
	for i = 1,#text do
		local letter = string.sub(text,i,i)

		if FrequencyTable[letter] then
			FrequencyTable[letter] += 1 
		else
			FrequencyTable[letter] = 1
		end
	end

	return FrequencyTable 
end

function Module:FrequencyAnalysis(text)
	text = string.lower(text)
	return self:FrequencyAnalysisCaseSensitive(text)
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

function Module:ShiftingCaesarCipher(text, offset, metaOffset) -- ONLY changes characters (not numbers)
	-- can generate raw string using gmatch (%a) (ignoring non-alphanumeric characters)
	local newStr = ""
	local letter,letterCode,modVal

	for i = 1,#text do 
		offset = (offset + metaOffset) % 26 
		
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

function Module:VigenereDecryptionKey(key)
	key = string.lower(key)
	local decryptionKey = ""
	
	for i = 1,#key do
		local offset = string.byte(string.sub(key,i,i)) - 97
		decryptionKey ..= string.char(WrapAround(97,26,123 - offset))
	end
	
	return decryptionKey
end

function Module:VigenereCipher(text,key)
	--[[
		Famous polyalphabetic cipher
		Shifted key to be all lower-case
	]]
	
	key = string.lower(key)
	
	local newStr = ""
	local keyLength = #key
	local letter,letterCode,modVal

	for i = 1,#text do 
		letter = string.sub(text,i,i)
		letterCode = string.byte(letter)
		
		local keyIndex = ((i-1) % keyLength) + 1
		local keyCode = string.byte(string.sub(key,keyIndex,keyIndex)) - 97

		if ((letterCode > 64) and (letterCode < 91)) then -- capital chars
			modVal = WrapAround(65, 26,letterCode + keyCode)
		elseif  ((letterCode > 96) and (letterCode < 123)) then -- lower case chars
			modVal = WrapAround(97, 26, letterCode + keyCode)

		else
			newStr ..= letter
			continue
		end

		newStr ..= string.char(modVal)
	end

	return newStr
end

function Module:OneTimePad(text)
	local key = ""
	
	for i = 1,#text do
		key ..= string.char(math.random(97,122))
	end
	
	local cipherText = self:VigenereCipher(text, self:VigenereDecryptionKey(key))
	
	return cipherText, key
end

function Module:DecryptOneTimePad(text,key)
	return self:VigenereCipher(text, key)
end

function Module:TranspositionCipher(text)
	
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
