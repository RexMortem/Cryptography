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
	
	-- d * e % (EulerTotient) = 1

	local Decryption = (EulerTotient - 1)
	
	return Encryption, Decryption, N
end

return RSAModule
