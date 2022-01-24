def findThePrimes():
	import math
	for i in range(1,100):
		isprime = True
		for j in range(2,int(math.sqrt(i))+1):
			if i%j == 0:
				isprime=False
				break
		if isprime:
			print(i);
