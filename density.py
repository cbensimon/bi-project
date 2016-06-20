import sys, json
import numpy as np

N = 1000

values = json.loads(sys.stdin.readlines()[0])

D = np.array(values)
maxValue = np.percentile(D, 99)/0.99

sigma = maxValue/10.0

def density(x):
	return np.exp(-(((D - x)**2)/(2*sigma**2))).sum()

X = (np.array(range(N)).astype(float)/N)*maxValue
Y = np.array([density(x) for x in X])

Maxs = [((Y[i-1] < Y[i]) and (Y[i+1] <= Y[i])) for i in range(1,  Y.shape[0]-1)]
Maxs.insert(0,False)
Maxs.append(False)
Maxs = np.array(Maxs)*1

result = [list(v) for v in zip(X,Y,Maxs)]

print json.dumps(result, allow_nan=False)