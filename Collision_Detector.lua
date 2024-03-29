-- GENERAL USE PHYSICS ENGINE (1.0)

function aabb(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function collide(a,b)
	return aabb(a.x, a.y, a.width, a.height, b.x, b.y, b.width, b.height)
end

function getsides(ax1,ay1,aw,ah, bx1,by1,bw,bh)
	if aabb(ax1,ay1,aw,ah, bx1,by1,bw,bh) then
		local onx = ax1 < bx1 and 'right' or (ax1 > bx1 and 'left' or 'superposed')
		local ony = ay1 < by1 and 'down' or (ay1 > by1 and 'up' or 'superposed')
		return onx,ony
	end
end

function pixelcollision(a, x, y) -- WITH OBJECTS
	local ax2,ay2,bx2,by2 = a.x + a.width, a.y + a.height, x + 1, y + 1
	return a.x < bx2 and ax2 > x and a.y < by2 and ay2 > y
end

function getdist(x1, y1, x2, y2)
	dx = x2 - x1
	dy = y2 - y1
	return math.sqrt((dx^2 + dy^2))
end

function getcollision(a, b, pressision)
	if aabb(a.x, a.y, a.width, a.height, b.x, b.y, b.width, b.height) then
		local left = b.x - (a.x + a.width)
		local right = (b.x + b.width) - a.x
		local up = b.y - (a.y + a.height)
		local down = (b.y + b.height) - a.y
		local pressision = pressision or 2
	
		local table = {}

		if math.abs(left) < right then 
			table.x = left
			table.xside = "right"
		else
			table.x = right
			table.xside = "left"
		end

		if math.abs(up) < down then
			table.y = up
			table.yside = "down"
		else
			table.y = down
			table.yside = "up"
		end
		
		if math.abs(table.x) < pressision and math.abs(table.x - table.y) < pressision then -- adds pressision
			return false
		end
	
		if math.abs(table.x) < math.abs(table.y) then
			table.y = 0
			table.side = table.xside
			table.hor = true
		else
			table.x = 0
			table.side = table.yside
			table.ver = true
		end
	
		return table
	else
		return false
	end

end

--[[function collide(a,b) --------------- ITS AN EXAMPLE
	local col = getcollision(self,b)
	if col then
		if col.hor then
			self.x = self.x + col.x 
			self.velx = 0
		end
		if col.ver then
			self.y = self.y + col.y
			self.vely = 0
		end
		if col.side = "right" then
			bla
		end
	end
end]]

function setbounds(obj, x, y, size)
	local size = size or 1
	local y = y or x
	if obj.x < x * tilesize then
		obj.x = x * tilesize
	elseif obj.x + (tilesize * size) > wx - (x * tilesize) then
		obj.x = wx - x * tilesize * size - tilesize
	end

	if obj.y < y * tilesize then
		obj.y = y * tilesize
	elseif obj.y + tilesize * size > wy - y * tilesize   then
		obj.y = wy - y * tilesize * size - tilesize
	end
end

------------ Pixel base collision

function pixgroundcol(obj, target, tweak)
	local tweak = tweak or 2
	if pixelcollision(target, obj.x + tweak, obj.y + obj.height) or pixelcollision(target, obj.x + obj.width - tweak, obj.y + obj.height) then
		return true
	else
		return false
	end
end

function pixheadcol(obj, target, tweak)
	local fix = 1
	local tweak = tweak or 2  
	if pixelcollision(target, obj.x + tweak, obj.y - fix) or pixelcollision(target, obj.x + obj.width - tweak, obj.y - fix) then
		return true
	else 
		return false
	end
end

function pixrightcol(obj, target, tweak)
	local tweak = tweak or 2
	if pixelcollision(target, obj.x + obj.width, obj.y + tweak) or pixelcollision(target, obj.x + obj.width, obj.y + obj.height - tweak) then
		return true
	else 
		return false
	end
end

function pixleftcol(obj, target, tweak)
	local fix = 1
	local tweak = tweak or 2 
	if pixelcollision(target, obj.x - fix, obj.y + tweak) or pixelcollision(target, obj.x - fix, obj.y + obj.height - tweak) then
		return true
	else 
		return false
	end
end
