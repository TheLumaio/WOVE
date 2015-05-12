CheckBox = {}

function CheckBox:new(id, text, x, y, selected)
	local checkbox = {}
	setmetatable(checkbox, self)
	self.__index = self

	checkbox.font = love.graphics.newFont()
	checkbox.id = id
	checkbox.text = text
	checkbox.x = x
	checkbox.y = y
	checkbox.isSelected = selected or false

	return checkbox
end

function CheckBox:draw()
	love.graphics.setLineStyle("rough")

	if self.isSelected then
		love.graphics.setColor(gui.theme.checkbox_selected_color)
	else
		love.graphics.setColor(gui.theme.checkbox_body_color)
	end


	love.graphics.rectangle("fill", self.x, self.y, 13, 13)
	love.graphics.setColor(50, 50, 50)
	love.graphics.rectangle("fill", self.x+13, self.y, self.font:getWidth(self.text)+5, 14)
	love.graphics.setColor(gui.theme.checkbox_outline_color)
	love.graphics.rectangle("line", self.x, self.y, 13, 13)
	love.graphics.rectangle("line", self.x+13, self.y, self.font:getWidth(self.text)+5, 13)
	love.graphics.setColor(gui.theme.checkbox_text_color)
	love.graphics.print(self.text, self.x + 15, self.y)
	love.graphics.setColor(255, 255, 255)
end

function CheckBox:mousepressed(x, y, b)
	if x > self.x and x < self.x + 13 and y > self.y and y < self.y + 13 then
		self.isSelected = not self.isSelected
	end
end
