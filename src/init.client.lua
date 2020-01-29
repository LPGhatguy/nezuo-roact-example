local Roact = require(game.ReplicatedStorage.Roact)

local NestyList

local ListItem = Roact.Component:extend("ListItem")

function ListItem:render()
	local children

	if self.props.selected then
		children = {
			Children = Roact.createElement(NestyList, {
				position = UDim2.new(1, 20, 0, 0),
				options = self.props.item.children,
			}),
		}
	end

	local label = self.props.item.label
	if self.props.item.children ~= nil then
		label = label .. " >"
	end

	return Roact.createElement("TextButton", {
		LayoutOrder = self.props.layoutOrder,
		Size = UDim2.new(0, 220, 0, 60),
		Text = label,
		BackgroundColor3 = Color3.new(1, 1, 1),
		TextSize = 24,
		BorderSizePixel = 0,
		[Roact.Event.Activated] = self.props.onActivate,
	}, children)
end

NestyList = Roact.Component:extend("NestyList")

function NestyList:init()
	self:setState({
		selectedItem = nil,
	})
end

function NestyList:render()
	local children = {}

	for index, item in ipairs(self.props.options) do
		local onActivate

		if item.children ~= nil then
			onActivate = function()
				self:setState({
					selectedItem = item.id,
				})
			end
		elseif item.activate ~= nil then
			onActivate = item.activate
		end

		children[item.id] = Roact.createElement(ListItem, {
			layoutOrder = index,
			item = item,
			selected = self.state.selectedItem == item.id,
			onActivate = onActivate,
		})
	end

	children.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local listHeight = 60 * #self.props.options

	return Roact.createElement("Frame", {
		Position = self.props.position,
		Size = UDim2.new(0, 220, 0, listHeight),
	}, children)
end

local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
gui.Name = "Roact Example"

Roact.mount(Roact.createElement(NestyList, {
	options = {
		{
			id = "foo",
			label = "Foo",
			children = {
				{
					id = "hello",
					label = "Hello",
					activate = function()
						print("foo/hello clicked")
					end,
				},
				{
					id = "world",
					label = "World",
					children = {
						{
							id = "nested",
							label = "Nested more!",
							activate = function()
								print("foo/world/nested clicked")
							end,
						}
					},
				},
			},
		},
		{
			id = "baz",
			label = "Baz",
			children = {
				{
					id = "oh no",
					label = "Oh no!",
					activate = function()
						print("baz/oh no clicked")
					end,
				},
			},
		},
		{
			id = "bahhhhh",
			label = "Bahhhh",
			activate = function()
				print("bahhhhh clicked")
			end,
		},
	}
}), gui)