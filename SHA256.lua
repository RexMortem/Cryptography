--[[
  PRE-NOTE: This was originally made for my blockchain project which is in another public repository on my profile! 

	SHA stands for Secure Hashing Algorithm; a hashing algorithm is a one-way cryptographic function
	Note that SHA-256 is the same thing as SHA-2; the 2 refers to the version, whereas 256 refers to the number of bits 
--]]

local SHA256 = {

}

-- let's ensure that everything is in ASCII so fits in a byte lmao
local function ConvertNumberTo8BitBinary(n) 
	local BinaryString = ""
	
	local p2 = 7
	
	while (p2 > -1) do
		if not (n > 0) then
			local left = 8 - #BinaryString
			BinaryString ..= string.rep("0", left)
			
			break
		end
		
		local r = math.pow(2, p2)
		
		if n < r then
			BinaryString ..= "0"
		else
			BinaryString ..= "1"
			n -= r 
		end
		
		p2 -= 1
	end
	
	return BinaryString
end

local function ConvertNumberTo4BitBinary(n) 
	local BinaryString = ""

	local p2 = 3

	while (p2 > -1) do
		if not (n > 0) then
			local left = 4 - #BinaryString
			BinaryString ..= string.rep("0", left)

			break
		end

		local r = math.pow(2, p2)

		if n < r then
			BinaryString ..= "0"
		else
			BinaryString ..= "1"
			n -= r 
		end

		p2 -= 1
	end

	return BinaryString
end

local function ConvertNumberToBinary(n)
	if n == 0 then
		return "0"
	end	
	
	local BinaryString = ""
	
	local p2 = 0
	local r = 1

	-- first we must find the biggest power of 2 that fits inside this
	
	while n >= r do
		p2 += 1 
		r = math.pow(2, p2)
	end
	
	local len = p2
	p2 -= 1 
	
	while (p2 > -1) do
		if not (n > 0) then
			local left = len - #BinaryString
			BinaryString ..= string.rep("0", left)

			break
		end

		local r = math.pow(2, p2)

		if n < r then
			BinaryString ..= "0"
		else
			BinaryString ..= "1"
			n -= r 
		end

		p2 -= 1
	end
	
	return BinaryString
end

local function ConvertStringTo8BitBinary(Message)
	local BinaryPhrase = ""

	for i = 1,#Message do
		local Ascii = string.byte(string.sub(Message, i, i))
		BinaryPhrase ..= ConvertNumberTo8BitBinary(Ascii)
	end
	
	return BinaryPhrase
end

local function RightRotate(String, Rotations)
	local LenString = #String
	Rotations = (Rotations % LenString) -- for a string 16 bits rotating 32 = {16, 0 etc}
	
	local Cutoff = string.sub(String, (LenString - Rotations) + 1, LenString)
	String = Cutoff .. String
	String = string.sub(String, 1, LenString)
	
	return String
end

local function RightShift(String, Shift)
	return string.rep("0", Shift) .. string.sub(String, 1, #String - Shift)
end

-- We know the strings have to be same length so we don't need to worry about padding
local function XOR(a, b)
	local n = ""
	
	for i = 1,#a do
		local aC = string.sub(a, i, i)
		local bC = string.sub(b, i, i)
		
		if ((aC == "0") and (bC == "0")) or ((aC == "1") and (bC == "1")) then
			n ..= "0"
		else
			n ..= "1"
		end
	end
	
	return n
end

local function AND(a, b)
	local n = ""

	for i = 1,#a do
		local aC = string.sub(a, i, i)
		local bC = string.sub(b, i, i)

		if(aC == "1") and (bC == "1") then
			n ..= "1"
		else
			n ..= "0"
		end
	end

	return n
end


local function NOT(a)
	local b = ""
	
	for i = 1,#a do
		local c = string.sub(a, i, i)
		c = ((c == "1") and "0") or "1"
		
		b ..= c
	end
	
	return b
end

local function BinaryAdd(a, b, modulo) -- if modulo then e.g. no change 32 bit into 33 
	local sum = ""
	
	if #b > #a then
		a,b = b,a 
	end
	
	local carry = false
	
	for i = #a, 1, -1 do
		local aC = string.sub(a, i, i)
		local bC = string.sub(b, i, i)
		
		if carry then
			if aC == "1" then
				aC = "0"
				carry = true
			else
				aC = "1"
				carry = false
			end
		end
		
		if not carry then
			if (aC == "1") and (bC == "1") then
				carry = true
			end
		end
		
		if ((aC == "1") and (bC == "1")) or ((aC == "0") and (bC == "0")) then
			sum = "0" .. sum
		else
			sum = "1" .. sum
		end
	end
	
	if (not modulo) and carry then
		sum = "1" .. sum
	end
	
	return sum
end

local HexValues = {
	[10] = "a";
	[11] = "b";
	[12] = "c";
	[13] = "d";
	[14] = "e";
	[15] = "f";
}

local ReverseHexValues = {
	["a"] = 10;
	["b"] = 11; 
	["c"] = 12;
	["d"] = 13;
	["e"] = 14;
	["f"] = 15;
}

local function BinaryToHex(BinaryString)
	local HexString = ""
	
	for i = 1,#BinaryString - 3, 4 do
		local BinaryNumber = string.sub(BinaryString, i, i + 3)
		
		local sum = 0
		
		for d = 1,4 do
			if string.sub(BinaryNumber, d, d) == "1" then
				sum += math.pow(2, 4 - d)
			end
		end
		
		if HexValues[sum] then
			HexString ..= HexValues[sum]
		else
			HexString ..= tostring(sum)
		end
	end
	
	return HexString
end

local function HexToBinary(HexString)
	local BinaryString = ""
	
	for i = 1,#HexString do
		local Character = string.sub(HexString, i, i)
		local value = ReverseHexValues[Character] or tonumber(Character)

		BinaryString ..= ConvertNumberTo4BitBinary(value)
	end
	
	return BinaryString
end

local function SplitInto32BitStrings(Message)
	local Strings = {}
	
	local n = 0
	
	for i = 1,(#Message - 31),32 do
		n += 1
		Strings[n] = string.sub(Message, i, i + 31)
	end
	
	return Strings
end

local function InitialHashValues()
	local Default = {
		"6a09e667",
		"bb67ae85",
		"3c6ef372",
		"a54ff53a",
		"510e527f",
		"9b05688c",
		"1f83d9ab",
		"5be0cd19"
	}

	for i = 1,#Default do
		Default[i] = HexToBinary(Default[i])
	end
	
	return Default
end

local function RoundConstants()
	local Default = {
		"0x428a2f98 0x71374491 0xb5c0fbcf 0xe9b5dba5 0x3956c25b 0x59f111f1 0x923f82a4 0xab1c5ed5",
		"0xd807aa98 0x12835b01 0x243185be 0x550c7dc3 0x72be5d74 0x80deb1fe 0x9bdc06a7 0xc19bf174",
		"0xe49b69c1 0xefbe4786 0x0fc19dc6 0x240ca1cc 0x2de92c6f 0x4a7484aa 0x5cb0a9dc 0x76f988da",
		"0x983e5152 0xa831c66d 0xb00327c8 0xbf597fc7 0xc6e00bf3 0xd5a79147 0x06ca6351 0x14292967",
		"0x27b70a85 0x2e1b2138 0x4d2c6dfc 0x53380d13 0x650a7354 0x766a0abb 0x81c2c92e 0x92722c85",
		"0xa2bfe8a1 0xa81a664b 0xc24b8b70 0xc76c51a3 0xd192e819 0xd6990624 0xf40e3585 0x106aa070",
		"0x19a4c116 0x1e376c08 0x2748774c 0x34b0bcb5 0x391c0cb3 0x4ed8aa4a 0x5b9cca4f 0x682e6ff3",
		"0x748f82ee 0x78a5636f 0x84c87814 0x8cc70208 0x90befffa 0xa4506ceb 0xbef9a3f7 0xc67178f2"
	}
	
	local ArrayFormat = {}
	local n = 0
	
	for row = 1,#Default do
		for HexNumber in string.gmatch(Default[row], "%w+") do
			n += 1
			ArrayFormat[n] = HexToBinary(string.sub(HexNumber, 3, #HexNumber))
		end
	end
	
	return ArrayFormat
end

function SHA256:Encrypt(Message)
	local Phrase = ConvertStringTo8BitBinary(Message)
	local PhraseSize = #Phrase
	
	Phrase ..= "1" -- for some reason SHA-256 adds a 1 not sure why
	
	local NumberOfZeros = 448 - (#Phrase % 512) -- 448 bits is 512 - 64 since 64 bits are allocated to more stuff
	
	if NumberOfZeros < 0 then
		-- we must split into 2 blocks
		NumberOfZeros += 512 
	end
	
	Phrase ..= string.rep("0", NumberOfZeros)
	
	PhraseSize = ConvertNumberToBinary(PhraseSize)
	
	local End64Bits = string.rep("0", 64 - #PhraseSize) .. PhraseSize
	Phrase ..= End64Bits

	local HashConstants	= InitialHashValues()

	for BlockIndex = 1, #Phrase - 511, 512 do
		local Block = SplitInto32BitStrings(string.sub(Phrase, BlockIndex, BlockIndex + 511))

		for i = 17, 64 do
			local s0 = XOR(XOR(RightRotate(Block[i - 15], 7), RightRotate(Block[i - 15], 18)), RightShift(Block[i - 15], 3))
			local s1 = XOR(XOR(RightRotate(Block[i - 2], 17), RightRotate(Block[i - 2], 19)), RightShift(Block[i - 2], 10))
			
			Block[i] = BinaryAdd(BinaryAdd(BinaryAdd(Block[i - 16], s0, true), Block[i - 7], true), s1, true)
		end
		
		local a,b,c,d,e,f,g,h = unpack(HashConstants)
		
		local k = RoundConstants()

		for i = 1, 64 do
			-- Compression rounds
			local s0 = XOR(XOR(RightRotate(a, 2),RightRotate(a, 13)), RightRotate(a, 22))
			local s1 = XOR(XOR(RightRotate(e, 6), RightRotate(e, 11)), RightRotate(e, 25))
			
			local ch = XOR(AND(e, f), AND(NOT(e), g))

			local t1 = BinaryAdd(BinaryAdd(BinaryAdd(BinaryAdd(h, s1, true), ch, true), k[i], true), Block[i], true)
			
			local maj = XOR(XOR(AND(a, b), AND(a, c)), AND(b, c))
			local t2 = BinaryAdd(s0, maj, true)
			
			h = g
			g = f
			f = e
			e = BinaryAdd(d, t1, true)
			d = c
			c = b
			b = a
			a = BinaryAdd(t1, t2, true)
		end
		
		local AlphabetThings = {a, b, c, d, e, f, g, h}
		local FinalHash = ""
		
		if (#Phrase - 511) == BlockIndex then
			for i = 1, #HashConstants do
				FinalHash ..= BinaryToHex(BinaryAdd(HashConstants[i], AlphabetThings[i], true))
			end
			
			return FinalHash
		else
			for i = 1, #HashConstants do
				FinalHash ..= BinaryAdd(HashConstants[i], AlphabetThings[i], true)
			end
			
			HashConstants = SplitInto32BitStrings(FinalHash)
		end
	end
end


return SHA256
