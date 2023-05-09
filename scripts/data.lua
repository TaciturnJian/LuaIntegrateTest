local t = {}

t["a"] = 1
t["b"] = t["a"] + 2
table.insert(t, tostring(t.b))

return t