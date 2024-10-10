f = lambda x: '      ' + ' '.join([f'{x:016b}'[i:i+4] for i in range(0, 32, 4)])
p = lambda x: print(f(x))

#x = 0xed7a
x = 0x007d
shift = 0x0004

print("Shift")
p(shift)
print("Input")
p(x)
print("Output")
x = x << shift
p(x)
mask = 0x00f0
print("Mask")
p(mask)
x = x & mask
print("Masked Output")
p(x)









