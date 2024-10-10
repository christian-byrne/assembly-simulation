


#a = 0b0001
#b = 0b1111

#invert = ~(b | b) + 0b0001

#print(r)





f = lambda x: '      ' + ' '.join([f'{x:016b}'[i:i+4] for i in range(0, 32, 4)])
p = lambda x: print(f(x))

x = 0xed7a
mask = 0x00f0

print("Mask")
p(mask)
print("Input")
p(x)
print("Output")

x = x & mask
p(x)








