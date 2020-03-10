import numpy as np


w1 = 0.5
w2 = 0.5

xd = []
yd = []

n_data = 100
generation_num = 100

for x1 in range(1,n_data):
    for x2 in range(1,n_data):
        xd.append([x1,x2])
        yd.append(x1*w1+x2*w2)


def fit_func(w):
    e = 0
    for i,x in enumerate(xd):
        e += abs(yd[i] - (x[0]*w[0]+x[1]*w[1]))
    return e

w = np.random.uniform(size=(generation_num,2))

error = 100000

while(error > 0.5):
    error_list = []
    for i,wi in enumerate(w):
        error_list.append((fit_func(w),i))
    # error = min(error_list)
    print(error_list)
    error_list.sort(key=lambda x: x[0])
    print("--------------")
    print(error_list)
    break
