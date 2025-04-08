import math

R.<t> = QQ['t']
K = R.fraction_field()

def pp(t,i):
	return (1-t^i)^(-i)

def cs(t,i):
	return (1-t^(2*i-1))^(-i)*(1-t^(2*i))^(-i)

def generating_function(n,f,p):
	return math.prod([f(t,i)/f(t^p,i)^p for i in range(n)])

def positivity_test(n,p):
	counter = 0
	R.<t> = QQ['t']
	for i in R(generating_function(n,p)).coefficients():
		if i < 0:
			return counter
		counter += 1

def cs_pp_gf(a,b,c,k):
	s = SymmetricFunctions(QQ).s()
	try:
		return sum([s(p) for p in Partitions(k,max_part=a,length=b)]).expand(c)
	except AttributeError:
		print('emptyset')
		return

def is_cs(pp):
	return all([len(t) == len(set(t)) for t in pp.transpose()])

def cs_pp(a,b,c,k):
	return [pp for pp in PlanePartitions([a,b,c]) if is_cs(pp) and pp.number_of_boxes()==k]