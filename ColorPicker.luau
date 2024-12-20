-- Made by Mystifine

local ReplicatedStorage = game.ReplicatedStorage;
local UserInputService = game:GetService("UserInputService")
local Players = game.Players;
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer;
local mouse = player:GetMouse();
local playergui = player:WaitForChild("PlayerGui");

export type ColorPicker = {
	_selected_color : Color3,
	
	_h : number,
	_s : number,
	_v : number,
	
	_color_picker_ui : ScreenGui,
	_is_destroyed : boolean,
	_is_picking_color : boolean,
	_pick_color_event_bindable : BindableEvent,
	
	UpdateColorUI : (self : ColorPicker) -> nil,
	Pick : (self : ColorPicker, x : number, y : number) -> Color3,
	Destroy : (self : ColorPicker) -> nil,
	
	_mouseInFrame : (frame : GuiObject) -> boolean,
	_getRoundedRGB : (color : Color3) -> (number, number, number),
	_getRoundedHSV : (color : Color3) -> (number, number, number),
	_getRGB : (color : Color3) -> (number, number, number),
	_getHSV : (color : Color3) -> (number, number, number),
	_bindResponeEvents : (color_picker : ColorPicker) -> nil,
	_validateHSVInput : (original_value : number, input : string) -> number,
	_validateRGBInput : (original_value : number, input : string) -> number,
	_bindHSVInputEvents : (color_picker : ColorPicker) -> nil,
	_bindRGBInputEvents : (color_picker : ColorPicker) -> nil, 
	_bindHSVSliderEvents : (color_picker : ColorPicker) -> nil,
	new : () -> ColorPicker
}

local ColorPicker = {};
ColorPicker.__index = ColorPicker;

function ColorPicker:UpdateColorUI()
	local color_picker : ColorPicker = self;
	
	local is_destroyed = color_picker._is_destroyed;
	if is_destroyed then warn("Attempted to update a destroyed color picker.") return end
	
	local h, s, v = color_picker._h, color_picker._s, color_picker._v;
	local color = Color3.fromHSV(h,s,v);
	local rounded_r, rounded_g, rounded_b = ColorPicker._getRoundedRGB(color);
	local rounded_h, rounded_s, rounded_v = ColorPicker._getRoundedHSV(color);
	
	local color_picker_ui = color_picker._color_picker_ui;
	
	local hsv_frame = color_picker_ui.color_picker_frame.color_input.hsv_frame;
	hsv_frame.h.input.Text = rounded_h;
	hsv_frame.s.input.Text = rounded_s;
	hsv_frame.v.input.Text = rounded_v;
	
	local rgb_frame = color_picker_ui.color_picker_frame.color_input.rgb_frame;
	rgb_frame.r.input.Text = rounded_r;
	rgb_frame.g.input.Text = rounded_g;
	rgb_frame.b.input.Text = rounded_b;
	
	-- updating the bar
	local color_picker_frame = color_picker_ui.color_picker_frame.color_picker_frame;
	color_picker_frame.bottom_frame.color_display.BackgroundColor3 = color;
	
	local hue_cursor_pos : UDim2 = color_picker_frame.hue_bar.cursor.Position;
	color_picker_frame.hue_bar.cursor.Position = UDim2.new(h/1,hue_cursor_pos.X.Offset,hue_cursor_pos.Y.Scale,hue_cursor_pos.Y.Offset);
	
	local saturation_cursor_pos : UDim2 = color_picker_frame.saturation_bar.cursor.Position;
	color_picker_frame.saturation_bar.cursor.Position = UDim2.new(s/1,saturation_cursor_pos.X.Offset,saturation_cursor_pos.Y.Scale,saturation_cursor_pos.Y.Offset);
	color_picker_frame.saturation_bar.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(h, 0, v)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, v)),
	});
	
	local value_cursor_pos : UDim2 = color_picker_frame.value_bar.cursor.Position;
	color_picker_frame.value_bar.cursor.Position = UDim2.new(v/1,value_cursor_pos.X.Offset,value_cursor_pos.Y.Scale,value_cursor_pos.Y.Offset);
	color_picker_frame.value_bar.UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHSV(h, s, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, 1)),
	});
end

function ColorPicker:Destroy()
	local color_picker : ColorPicker = self;
	
	if color_picker._is_destroyed then warn("Attempted to destroy a already destroyed color picker") return end;
	
	color_picker._is_destroyed = true;
	color_picker._pick_color_event_bindable:Fire();
	color_picker._pick_color_event_bindable = color_picker._pick_color_event_bindable:Destroy();
	color_picker._color_picker_ui = color_picker._color_picker_ui:Destroy();
end

function ColorPicker:Pick(x : number, y : number)
	local color_picker : ColorPicker = self;
	
	if color_picker._is_destroyed then warn("Can not pick color from destroyed color picker") return end;
	if color_picker._is_picking_color then warn("Already picking a color.") return end;
	
	color_picker._is_picking_color = true;
	
	-- Parent and place the UI
	color_picker._color_picker_ui.Parent = playergui;
	local color_picker_frame_abs_position : Vector2 = color_picker._color_picker_ui.color_picker_frame.AbsolutePosition;
	local color_picker_frame_abs_size : Vector2 = color_picker._color_picker_ui.color_picker_frame.AbsoluteSize;
	local abs_screen_size : Vector2 = color_picker._color_picker_ui.AbsoluteSize;
	
	local x_pos = math.clamp(x, 0, abs_screen_size.X - color_picker_frame_abs_size.X);
	local y_pos = math.clamp(y, 0, abs_screen_size.Y - color_picker_frame_abs_size.Y);

	color_picker._color_picker_ui.color_picker_frame.Position = UDim2.new(x_pos / abs_screen_size.X, 0, y_pos / abs_screen_size.Y, 0);

	local selected_color = color_picker._pick_color_event_bindable.Event:Wait();
	color_picker:Destroy();
	return selected_color;
end

function ColorPicker._mouseInFrame(frame : GuiObject) : boolean
	local x : number, y : number = mouse.X, mouse.Y

	local abs_size_x : number = frame.AbsoluteSize.X
	local abs_size_y : number = frame.AbsoluteSize.Y

	local lower_bound_x : number = frame.AbsolutePosition.X;
	local upper_bound_x : number = frame.AbsolutePosition.X + abs_size_x;

	local upper_bound_y : number = frame.AbsolutePosition.Y + abs_size_y;
	local lower_bound_y : number = frame.AbsolutePosition.Y;

	if x >= lower_bound_x and x <= upper_bound_x and y >= lower_bound_y and y <= upper_bound_y then
		return true;
	end

end

function ColorPicker._getHSV(color : Color3)
	return color:ToHSV();
end

function ColorPicker._getRoundedHSV(color : Color3)
	local h, s, v = color:ToHSV();
	h, s, v = math.floor(h * 100) / 100, math.floor(s * 100) / 100, math.floor(v * 100) / 100;
	return h, s, v;
end

function ColorPicker._getRGB(color : Color3)
	return color.R * 255, color.G * 255, color.B * 255;
end

function ColorPicker._getRoundedRGB(color : Color3)
	local r, g, b = color.R * 255, color.G * 255, color.B * 255;
	r, g, b = math.floor(r * 100) / 100, math.floor(g * 100) / 100, math.floor(b * 100) / 100;
	return r, g, b;
end

function ColorPicker._bindResponeEvents(color_picker : ColorPicker)
	local bindable_event = color_picker._pick_color_event_bindable;
	
	-- Events to select the color
	local bottom_frame = color_picker._color_picker_ui.color_picker_frame.color_picker_frame.bottom_frame;
	bottom_frame.accept_button.Activated:Connect(function()
		bindable_event:Fire(Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v));
	end)

	bottom_frame.cancel_button.Activated:Connect(function()
		bindable_event:Fire(color_picker._selected_color);
	end)
end

function ColorPicker._validateHSVInput(original_value : number, input : string)
	local value = tonumber(input);

	if typeof(value) ~= "number" then
		value = original_value;
	end;
	
	return math.clamp(value, 0, 1);
end

function ColorPicker._validateRGBInput(original_value : number, input : string)
	local value = tonumber(input);

	if typeof(value) ~= "number" then
		value = original_value;
	end;

	return math.clamp(value, 0, 255);
end

function ColorPicker._bindHSVInputEvents(color_picker : ColorPicker)
	local hsv_frame = color_picker._color_picker_ui.color_picker_frame.color_input.hsv_frame;
	
	hsv_frame.h.input.FocusLost:Connect(function()
		local h, s, v = Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v);

		local new_h = ColorPicker._validateHSVInput(h, hsv_frame.h.input.Text);
		color_picker._h = new_h;
		color_picker:UpdateColorUI(color_picker);
	end)
	
	hsv_frame.s.input.FocusLost:Connect(function()
		local h, s, v = Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v);

		local new_s = ColorPicker._validateHSVInput(s, hsv_frame.s.input.Text);
		color_picker._s = new_s;
		color_picker:UpdateColorUI();
	end)
	
	hsv_frame.v.input.FocusLost:Connect(function()
		local h, s, v = Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v);

		local new_v = ColorPicker._validateHSVInput(v, hsv_frame.v.input.Text);
		color_picker._v = new_v;
		color_picker:UpdateColorUI();
	end)
end

function ColorPicker._bindRGBInputEvents(color_picker : ColorPicker)
	local rgb_frame = color_picker._color_picker_ui.color_picker_frame.color_input.rgb_frame;

	rgb_frame.r.input.FocusLost:Connect(function()
		local current_color = Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v);
		local r, g, b = ColorPicker._getRGB(current_color);

		local new_r = ColorPicker._validateRGBInput(r, rgb_frame.r.input.Text);
		local h, s, v = ColorPicker._getHSV(Color3.fromRGB(new_r, g, b))
		color_picker._h = h;
		color_picker._s = s;
		color_picker._v = v;
		color_picker:UpdateColorUI();
	end)

	rgb_frame.g.input.FocusLost:Connect(function()
		local current_color = Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v);
		local r, g, b = ColorPicker._getRGB(current_color);

		local new_g = ColorPicker._validateRGBInput(g, rgb_frame.g.input.Text);
		local h, s, v = ColorPicker._getHSV(Color3.fromRGB(r, new_g, b))
		color_picker._h = h;
		color_picker._s = s;
		color_picker._v = v;
		color_picker:UpdateColorUI();
	end)

	rgb_frame.b.input.FocusLost:Connect(function()
		local current_color = Color3.fromHSV(color_picker._h, color_picker._s, color_picker._v);
		local r, g, b = ColorPicker._getRGB(current_color);

		local new_b = ColorPicker._validateRGBInput(b, rgb_frame.b.input.Text);
		local h, s, v = ColorPicker._getHSV(Color3.fromRGB(r, g, new_b))
		color_picker._h = h;
		color_picker._s = s;
		color_picker._v = v;
		color_picker:UpdateColorUI();
	end)

end

function ColorPicker._bindHSVSliderEvents(color_picker : ColorPicker)
	local color_picker_frame = color_picker._color_picker_ui.color_picker_frame.color_picker_frame;
	
	local hsv_sliders = {
		h = color_picker_frame.hue_bar;
		s = color_picker_frame.saturation_bar;
		v = color_picker_frame.value_bar;
	};
	
	local holding = false;
	
	for slider_name, slider : ImageButton in pairs(hsv_sliders) do
		slider.InputBegan:Connect(function(input : InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 
				or input.UserInputType == Enum.UserInputType.Touch then
				holding = true;
				while holding do 	
					local mouse_x = mouse.X;
					local slider_abs_pos : Vector2 = slider.AbsolutePosition;
					local slider_abs_size : Vector2 = slider.AbsoluteSize;

					local x = math.clamp(mouse_x - slider_abs_pos.X, 0, slider_abs_size.X);
					local percentage = x / (slider_abs_size.X);
					slider.cursor.Position = UDim2.new( percentage, 0, 0.5, 0);

					local h, s, v = color_picker._h, color_picker._s, color_picker._v;
					
					color_picker["_"..slider_name] = percentage;
					color_picker:UpdateColorUI();
					
					RunService.RenderStepped:Wait();
				end
			end
		end)
		
		slider.InputEnded:Connect(function(input : InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 
				or input.UserInputType == Enum.UserInputType.Touch then
				holding = false;
			end
		end)
	end
end

function ColorPicker.new(selected_color : Color3)
	local color_picker : ColorPicker = setmetatable({}, ColorPicker);
	color_picker._selected_color = selected_color;
	local h, s, v = ColorPicker._getHSV(selected_color);
	color_picker._h = h;
	color_picker._s = s;
	color_picker._v = v;
	color_picker._is_destroyed = false;
		
	local color_picker_ui = script.color_picker_ui:Clone();
	color_picker._color_picker_ui = color_picker_ui;
	
	local bindable_event = Instance.new("BindableEvent")
	bindable_event.Name = "pickColorEvent";
	bindable_event.Parent = color_picker._color_picker_ui;
	color_picker._pick_color_event_bindable = bindable_event;
	
	-- Update to selected color
	color_picker:UpdateColorUI();
	
	-- Events to select the color
	ColorPicker._bindResponeEvents(color_picker);
	
	-- Bind events to input frames
	ColorPicker._bindHSVInputEvents(color_picker);
	ColorPicker._bindRGBInputEvents(color_picker);
	
	-- Bind slider events
	ColorPicker._bindHSVSliderEvents(color_picker);
	
	return color_picker;
end

return ColorPicker
