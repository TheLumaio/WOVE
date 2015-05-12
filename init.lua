-- Wöve (Löve Widgets) gui library


-- require all widgets
local path = ...
require (path .. ".widgets.button")
require (path .. ".widgets.checkbox")
require (path .. ".widgets.label")
require (path .. ".widgets.textbox")
require (path .. ".widgets.panel")

gui = {}

local count = 0
local function counter()
	count = count + 1
	return count
end

local default_theme = {
	label_outline_color = {0, 0, 0},
	label_body_color = {100, 100, 100},

	button_body_color = {100, 100, 100},
	button_highlight_color = {150, 150, 150},
	button_outline_color = {0, 0, 0},
	button_clicked_color = {100, 100, 100},

	textbox_body_color = {100, 100, 100},
	textbox_outline_color = {0, 0, 0},

	checkbox_body_color = {100, 100, 100},
	checkbox_selected_color = {150, 25, 25},
	checkbox_outline_color = {0, 0, 0},
	checkbox_text_color = {200, 50, 50},

	panel_body_color = {100, 100, 100, 200},
	panel_title_color = {100, 100, 100},
	panel_outline_color = {0, 0, 0}
}

function gui:init()

	self.hovered = 0

	self.widgets = {}

	self.state = "default"
	self.theme = default_theme
end

function gui:getById(id)
	for i,v in pairs(self.widgets) do
		if v.id == id then return v end
	end
	return nil
end

function gui:removeById(id)
	for i,v in pairs(self.widgets) do
		if v.id == id then
			table.remove(self.widgets, i)
		end
	end
end

function gui:addWidget(widget)
	widget.z = counter()
	table.insert(self.widgets, widget)
end

function gui:getTop()
	return self.widgets[#self.widgets]
end

function gui:update(dt)
	table.sort(self.widgets, function (a,b) return a.z < b.z end)
	for i,v in pairs(self.widgets) do
		if v.update then
			v:update(dt)
		end
	end
end

function gui:draw()
	for i,v in pairs(self.widgets) do
		v:draw()
	end
end

function gui:mousepressed(x, y, b)
	for i,v in pairs(self.widgets) do
		if v.mousepressed then
			v:mousepressed(x, y, b)
		end
	end
end

function gui:mousereleased(x, y, b)
	for i,v in pairs(self.widgets) do
		if v.mousereleased then
			v:mousereleased(x, y, b)
		end
	end
end

function gui:keypressed(key)
	for i,v in pairs(self.widgets) do
		if v.keypressed then
			v:keypressed(key)
		end
	end
end

function gui:textentered(text)
	for i,v in pairs(self.widgets) do
		if v.textentered then
			v:textentered(text)
		end
	end
end
