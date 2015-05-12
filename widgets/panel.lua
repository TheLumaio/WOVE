Panel = {}

function max(t)
	fn = function(a, b) return a < b end
  if #t == 0 then return nil, nil end
  local key, value = 1, t[1].z
  for i = 2, #t do
    if fn(value, t[i].z) then
      key, value = i, t[i].z
    end
  end
  return value
end

function Panel:new(id, text, x, y, w, h)
	local panel = {}
	setmetatable(panel, self)
	self.__index = self

	panel.widgets = {}

	panel.id = id
	panel.text = text
	panel.x = x
	panel.y = y
	panel.w = w
	panel.h = h

	panel.dragging = false
	panel.diffx = 0
	panel.diffy = 0

	panel.hovered = 0

	panel.isInForeground = false

	return panel
end

function Panel:addWidget(widget)
	widget.x = self.x + widget.x
	widget.y = self.y + widget.y
	table.insert(self.widgets, widget)
end

function Panel:getById(id)
	for i,v in ipairs(self.widgets) do
		if v.id == id then return v end
	end
	return nil
end

function Panel:close()
	print(self.id)
	for i = 1, #self.widgets do
		if self.widgets[i].kill then
			self.widgets[i]:kill()
		end
		self.widgets[i] = nil
	end
	gui:removeById(self.id)
end

function Panel:update(dt)

	local mx, my = love.mouse.getPosition()

	hovered = 0
	for i,v in pairs(gui.widgets) do
		if mx > v.x and mx < v.x + v.w and my > v.y-20 and my < v.y+v.w then
			hovered = hovered + 1
		end
	end
	self.hovered = hovered
	gui.hovered = hovered

	if gui:getTop().id ~= self.id then return nil end

	for i,v in pairs(self.widgets) do if v.update then v:update(dt) end end

	if self.dragging then
		self.x = love.mouse.getX()-self.diffx
		self.y = love.mouse.getY()-self.diffy
		for i,v in pairs(self.widgets) do
			v.x = love.mouse.getX()-v.diffx
			v.y = love.mouse.getY()-v.diffy
		end
	end
end

function Panel:draw()
	-- Main body
	love.graphics.setColor(gui.theme.panel_body_color)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(gui.theme.panel_outline_color)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	-- Title bar
	love.graphics.setLineStyle("smooth")
	if self.z ~= max(gui.widgets) then
		love.graphics.setColor(75, 75, 75)
	else
		love.graphics.setColor(100, 100, 100)
	end
	love.graphics.polygon("fill", self.x, self.y-20, self.x+self.w-40, self.y-20, self.x+self.w-20, self.y, self.x, self.y)
	love.graphics.setColor(gui.theme.panel_outline_color)
	love.graphics.polygon("line", self.x, self.y-20, self.x+self.w-40, self.y-20, self.x+self.w-20, self.y, self.x, self.y)
	love.graphics.print(self.text, self.x+5, self.y-15)

	-- Close button
	love.graphics.setColor(150, 0, 0)
	love.graphics.polygon("fill", self.x+self.w-40, self.y-20,
																	self.x+self.w, self.y-20,
																	self.x+self.w, self.y,
																	self.x+self.w-20, self.y
												)
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("line", self.x+self.w-40, self.y-20,
																	self.x+self.w, self.y-20,
																	self.x+self.w, self.y,
																	self.x+self.w-20, self.y
												)
	love.graphics.print("X", self.x+self.w-15, self.y-16)


	for i,v in pairs(self.widgets) do if v.draw then v:draw() end end
end

function Panel:mousepressed(mx, my, b)
	--if self.hovered > 1 then return end
	if self.z ~= max(gui.widgets) then
		if mx > self.x and mx < self.x + self.w and my > self.y-20 and my < self.y+self.w then
			if self.hovered < 2 then
				self.z = max(gui.widgets) + 1
				self.dragging = true
				self.diffx = mx - self.x
				self.diffy = my - self.y
				for i,v in pairs(self.widgets) do
					v.diffx = mx - v.x
					v.diffy = my - v.y
				end

				local dx = self.x+self.w-20
				if mx > dx and mx < dx+20 and my > self.y-20 and my < self.y then
					self:close()
				end
			end
		end
	end

	if gui:getTop().id ~= self.id then return nil end

	for i,v in pairs(self.widgets) do if v.mousepressed then v:mousepressed(mx, my, b) end end


	-- I have to do this shit twice for some reason, I don't get it
	if b == "l" then

		if mx > self.x and mx < self.x + self.w-20 and my > self.y-20 and my < self.y then
			self.dragging = true
			self.diffx = mx - self.x
			self.diffy = my - self.y
			for i,v in pairs(self.widgets) do
				v.diffx = mx - v.x
				v.diffy = my - v.y
			end
		end

		local dx = self.x+self.w-20
		if mx > dx and mx < dx+20 and my > self.y-20 and my < self.y then
			self:close()
		end
	end
end

function Panel:mousereleased(x, y, b)
	for i,v in pairs(self.widgets) do if v.mousereleased then v:mousereleased(x, y, b) end end
	if b == "l" then self.dragging = false end
end

function Panel:keypressed(key)
	for i,v in pairs(self.widgets) do if v.keypressed then v:keypressed(key) end end
end

function Panel:textentered(text)
	for i,v in pairs(self.widgets) do if v.textentered then v:textentered(text) end end
end
