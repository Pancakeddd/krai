LUA = lua5.1

compile: 
	moonc .
	$(LUA) test.lua > test.html