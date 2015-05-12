TextBox = {}

local utf8 = require ("utf8")

local t = 0

function TextBox:new(id, x, y, w, h)
	local textbox = {}
	setmetatable(textbox, self)
	self.__index = self

	textbox.font = love.graphics.newFont()
	textbox.id = id
	textbox.x = x
	textbox.y = y
	textbox.w = w
	textbox.h = h or textbox.font:getHeight("a") + 4
	textbox.text = ""

	return textbox

end

function TextBox:update(dt)
	if not dt then return end
	t = t + dt
end

function TextBox:draw()
	love.graphics.setLineStyle("rough")
	love.graphics.setColor(100, 100, 100)
	love.graphics.rectangle("fill", self.x-4, self.y-2, self.w+8, self.h)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", self.x-2, self.y-1, self.w+5, self.h-3)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.text, self.x, self.y)

	c = 170 + ((255-170) * math.abs(math.sin(5 * t)))

	if self.isSelected then
		love.graphics.setColor(c, c, c)
		love.graphics.rectangle("fill", self.x+self.font:getWidth(self.text), self.y, 3, self.h-4)
	end
end

function TextBox:keypressed(key)
	if self.isSelected then
		if key == "backspace" then
	    local byteoffset = utf8.offset(self.text, -1)

	    if byteoffset then
	      self.text = string.sub(self.text, 1, byteoffset - 1)
	    end
	  end
	end
end

function TextBox:mousepressed(x, y, b)
	if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
		self.isSelected = true
	else
		self.isSelected = false
	end
end

function TextBox:textentered(text)
	if self.isSelected then
		print(text)
		local newText = self.text .. text
		if self.font:getWidth(newText) > self.w then return end
		self.text = self.text .. text
	end
end
