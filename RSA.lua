--[[
	Source code inspired by ComputerPhile, and researched sources 
	
	Euler's totient function gives number of coprime integers with N
	but when you have 2 prime factor-pairs then you can just do (p - 1)(q - 1)
	
	In the totient function, used a bruteforce method to find whether 
	2 numbers were coprime. 
	
	In later functions, I will use an alternate method using HCF because I have 
	learned about the euclidean algorithm which quickly finds HCF and if HCF of 2 numbers
	is 1 then they are coprime. 
	
	(HCF is Highest Common Factor; americans call this the GCD - Greatest Common Divisor)
--]]

local RSAModule = {

}

function RSAModule:EulerTotient(n) -- the brute force way (not (p - 1)(q - 1)) lmao
	local factors = {}

	for i = 2,math.sqrt(n) do
		if (n % i) == 0 then
			table.insert(factors, i)
			table.insert(factors, n/i)
		end
	end

	local LenFactors = #factors
	local count = 0

	for i = 1, n-1 do
		local coprime = true

		for d = 1,LenFactors do
			if (i % factors[d]) == 0 then
				coprime = false
				break
			end
		end

		if coprime then
			count += 1
		end
	end

	return count
end

function RSAModule:HCF(a, b)
	if a < b then
		a,b = b,a 
	end
	
	while not ((a == 0) or (b == 0)) do
		local result = (a % b)
		a = b
		b = result
	end
	
	if (a == 0) then
		return b
	else 
		return a 
	end
end

function RSAModule:ModulusClock(x, p, modulo)
	--[[
		The p acts as a public key
		The reverse value for p is the private key
		
		From a computerphile video
	--]]

	local oX = x -- since x will change

	for i = 2, p do
		x = ((x * oX) % modulo)
	end

	return x
end

function RSAModule:EncryptNumber(x, n, e)
	return math.pow(x, n) % e
end

function RSAModule:Encrypt(x, n, e)

end

function RSAModule:BruteForceKey(p, modulo)

end

function RSAModule:FermatsFactorisation(N, MaxIterations)
	--[[ 
		assume that N is made from (a - b)(a + b) where a is some midpoint
		so p = (a - b), q = (a + b) or other way round (doesn't matter)
		
		therefore N = (a - b)(a + b) = a^2 - b^2
		so if N = a^2 - b^2 then 
		
		b^2 = a^2 - N
		b = root(a^2 - N)
		
		Won't work if a or b are not integers; honestly not sure how reliable it is
		Says that it works for "large" prime number factors
		
		Doesn't work for 14 (splits into 7, 2 and their midpoint is not an integer)
	--]]

	local a = math.ceil(math.sqrt(N))
	
	local MaxA = math.min(a + MaxIterations, N)
	local FinalB = -1
	
	while a < MaxA do
		
		local b = math.sqrt(a*a - N)
		print("Fermats" , a, b)
		if math.floor(b) == b then
			FinalB = b
			break
		end 
		
		a += 1
	end
	
	if not (FinalB == -1) then
		return (a - FinalB), (a + FinalB)
	end
end

function RSAModule:GenerateKeys(p, q)
	local N = p * q 
	local EulerTotient = (p - 1) * (q - 1)
	
	local Encryption = nil
	
	for e = 2, EulerTotient - 1 do
		if (self:HCF(N, e) == 1) and (self:HCF(EulerTotient, e) == 1) then
			print(e)
			Encryption = e
			break
		end
	end
	
	-- [d * e] % (EulerTotient) = 1

	local Decryption = (EulerTotient - 1)
	
	return Encryption, Decryption, N
end

return RSAModule
