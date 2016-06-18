import sys, json
import numpy as np

N = 1000
sigma = 100

values = json.loads(sys.stdin.readlines()[0])

D = np.array(values)

def density(x):
	return np.exp(-(((D - x)**2)/(2*sigma**2))).sum()

X = (np.array(range(N)).astype(float)/N)*D.max()
Y = np.array([density(x) for x in X])

result = [list(v) for v in zip(X,Y)]

print json.dumps(result, allow_nan=False)