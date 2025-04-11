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

def helper(tab, i, t):
	j = len(tab[i])-1
	temp = tab[i][j]
	tab[i][j] -= 1
	for k in range(t-1):
		if i+1 < len(tab) and j < len(tab[i+1]):
			if tab[i+1][j] == temp or tab[i+1][j] == temp-1:
				temp = tab[i+1][j]
				tab[i+1][j] -= 1
				i += 1
		else:
			try:
				temp = tab[i][j-1]
				tab[i][j-1] -= 1
				j -= 1
			except IndexError:
				return None
	return True

def one_peel(t, pp):
	for i in range(len(pp.to_tableau())):
		tab = [list(tup) for tup in pp.to_tableau()]
		if helper(tab, i, t):
			try:
				temp = PlanePartition(tab)
				if is_cs(temp):
					return temp
				else:
					continue
			except ValueError:
				continue
	raise Exception('no more hooks to remove')


def peel(t, pp):
	q = pp
	while True:
		try:
			q = one_peel(t, q)
			print(q)
		except:
			return q

