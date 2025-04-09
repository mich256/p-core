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

def one_peel(t, tab):
	i = 0
	j = len(tab[0])-1
	temp = tab[i][j]
	tab[i].pop()
	for k in range(t-1):
		try:
			if tab[i+1][j] == temp or tab[i+1][j] == temp-1:
				temp = tab[i+1][j]
				tab[i+1].pop(j)
				i += 1
			else:
				temp = tab[i][j-1]
				tab[i].pop(j-1)
				i += 1
		except IndexError:
			print('no more rim hooks of length t')
			raise
	return tab

def peel(t, pp):
	q = [list(tup) for tup in pp.to_tableau()]
	while True:
		try:
			q = one_peel(t, q)
		except:
			return PlanePartition([x for x in q if x])

