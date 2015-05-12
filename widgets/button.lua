Button = {}

function Button:new(id, text, x, y, onclick, w, h)
	local button = {}
	setmetatable(button, self)
	self.__index = self

	button.id = id
	button.font = love.graphics.newFont()
	button.text = text
	button.x = x
	button.y = y
	button.onclick = onclick or function() end
	button.w = w or button.font:getWidth(text) + 8
	button.h = h or button.font:getHeight(text) + 4
	button.bgcolor = {}
	button.bgcolor[1] = gui.theme.button_body_color[1]
	button.bgcolor[2] = gui.theme.button_body_color[2]
	button.bgcolor[3] = gui.theme.button_body_color[3]

	return button
end

function Button:update()
	local mx, my = love.mouse.getPosition()
	if mx > self.x-4 and mx < self.x-4 + self.w+8 and my > self.y-2 and my < self.y-2 + self.h+4 then
		if self.bgcolor[1] < gui.theme.button_highlight_color[1] then self.bgcolor[1] = self.bgcolor[1] + 5 end
		if self.bgcolor[2] < gui.theme.button_highlight_color[2] then self.bgcolor[2] = self.bgcolor[2] + 5 end
		if self.bgcolor[3] < gui.theme.button_highlight_color[3] then self.bgcolor[3] = self.bgcolor[3] + 5 end
	else
		if self.bgcolor[1] > gui.theme.button_body_color[1] then self.bgcolor[1] = self.bgcolor[1] - 5 end
		if self.bgcolor[2] > gui.theme.button_body_color[2] then self.bgcolor[2] = self.bgcolor[2] - 5 end
		if self.bgcolor[3] > gui.theme.button_body_color[3] then self.bgcolor[3] = self.bgcolor[3] - 5 end
	end
	if self.clicking then
		self.bgcolor = {100, 100, 100}
	end
end

function Button:draw()
	love.graphics.setLineStyle("rough")
	love.graphics.setColor(self.bgcolor)
	love.graphics.rectangle("fill", self.x-4, self.y-2, self.w, self.h)
	love.graphics.setColor(gui.theme.button_outline_color)
	love.graphics.rectangle("line", self.x-2, self.y-1, self.w-4, self.h-3)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(self.text, self.x, self.y)
end

function Button:mousepressed(x, y, b)
	if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
		if b == "l" then
			self.clicking = true
		end
	end
end

function Button:mousereleased(x, y, b)
	if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
		if b == "l" and self.clicking then
			self.onclick()
		end
	end
	self.clicking = false
end
