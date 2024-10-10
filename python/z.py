f = lambda x: '      ' + ' '.join([f'{x:016b}'[i:i+4] for i in range(0, 32, 4)])
p = lambda x: print(f(x))

import random
x = random.randint(0,8192*2**3)
#x = 0xaf02
mask = 0x0080

print("Input")
p(x)
print("Or Mask")
p(mask)
x = x | mask
print("Output")
p(x)









