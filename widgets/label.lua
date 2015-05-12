Label = {}

function Label:new(id, text, x, y, scaling, w)
	local label = {}
	setmetatable(label, self)
	self.__index = self

	label.font = love.graphics.newFont()
	label.id = id
	label.text = text
	label.x = x
	label.y = y
	label.scaling = scaling or false
	label.w = w or label.font:getWidth(text)

	return label
end


function Label:draw()
	love.graphics.setLineStyle("rough")
	love.graphics.setColor(100, 100, 100)

	if self.scaling == true then
		love.graphics.rectangle("fill", self.x-4, self.y-2, self.font:getWidth(self.text)+8, self.font:getHeight(self.text)+4)
	else
		love.graphics.rectangle("fill", self.x-4, self.y-2, self.w+8, self.font:getHeight(self.text)+4)
	end

	love.graphics.setColor(25, 25, 25)

	if self.scaling == true then
		love.graphics.rectangle("line", self.x-2, self.y-1, self.font:getWidth(self.text)+5, self.font:getHeight(self.text)+1)
	else
		love.graphics.rectangle("line", self.x-2, self.y-1, self.w+5, self.font:getHeight(self.text)+1)
	end

	love.graphics.print(self.text, self.x, self.y)
end
