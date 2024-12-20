# ColorPicker Module

The **ColorPicker** module is an interactive, customizable color picker for Roblox. It allows users to select colors dynamically using HSV sliders, RGB inputs, and real-time preview.

## Features

- **HSV and RGB Support**: Users can select colors using HSV sliders or by directly inputting RGB/HSV values.
- **Dynamic UI Updates**: The color display updates in real-time as users adjust sliders or inputs.
- **Easy Integration**: Create and use the color picker with a single function call.
- **Event Binding**: Accept and cancel events for easy integration into your game logic.
- **Validation**: Ensures RGB and HSV values remain within valid ranges.
- **Customizable Positioning**: Specify where the color picker UI should appear.
- **Resource Cleanup**: Automatically handles destruction of the UI and connections.

---

## Installation

1. Go to the [ColorPicker model on the Roblox Creator Marketplace](https://create.roblox.com/store/asset/15732088988/ColorPicker).
2. Click "Get" or "Buy" to add it to your inventory.
3. Insert the `ColorPicker` module script into your game's `ReplicatedStorage` or `StarterPlayerScripts`.
4. Ensure the associated UI components (e.g., `color_picker_ui`) are also included in the same script or replicated to the client.

---

## Usage

### Create a Color Picker
To create a new color picker instance, call the `ColorPicker.new()` method:

```lua
local ColorPicker = require(game.ReplicatedStorage.ColorPicker)

-- Example Usage
local colorPicker = ColorPicker.new(Color3.fromRGB(255, 0, 0))
local selectedColor = colorPicker:Pick(100, 200) -- Spawn at position (100, 200)
print("Selected Color:", selectedColor)
```

### Destroy a Color Picker
When you're done with the color picker, call the `Destroy` method to free resources:

```lua
colorPicker:Destroy()
```

---

## Methods

### `ColorPicker.new(selectedColor: Color3)`
Creates a new instance of the color picker.

#### Parameters:
- `selectedColor`: A `Color3` object representing the default starting color.

#### Returns:
- A `ColorPicker` object.

---

### `ColorPicker:Pick(x: number, y: number)`
Displays the color picker at a specified position and waits for user input.

#### Parameters:
- `x`: The horizontal screen position.
- `y`: The vertical screen position.

#### Returns:
- The selected `Color3` color if accepted.

---

### `ColorPicker:Destroy()`
Destroys the color picker, disconnects all event listeners, and removes the UI.

---

## Events

- **Accept Button**: Fires when the user selects a color and clicks "Accept."
- **Cancel Button**: Fires when the user clicks "Cancel," returning the default color.

---

## Internals

### Private Methods

- `_bindHSVInputEvents`: Binds user input events to HSV input fields.
- `_bindRGBInputEvents`: Binds user input events to RGB input fields.
- `_bindHSVSliderEvents`: Handles slider interactions for Hue, Saturation, and Value.
- `_mouseInFrame`: Utility function to detect if the mouse is inside a frame.
- `_validateHSVInput`: Ensures HSV inputs are valid.
- `_validateRGBInput`: Ensures RGB inputs are valid.
- `_getHSV` and `_getRGB`: Convert between HSV and RGB values.

### Helper Methods

- `UpdateColorUI`: Synchronizes the UI components with the current color selection.

---

## UI Requirements

Ensure the `color_picker_ui` ScreenGui is included and properly set up with:

- **Sliders**: For Hue, Saturation, and Value.
- **Input Fields**: For RGB and HSV values.
- **Buttons**: Accept and Cancel actions.
- **Color Preview**: Displays the currently selected color.

---

## Example UI Structure
```plaintext
color_picker_ui (ScreenGui)
|-- color_picker_frame (Frame)
    |-- color_input (Frame)
        |-- hsv_frame (Frame)
            |-- h.input (TextBox)
            |-- s.input (TextBox)
            |-- v.input (TextBox)
        |-- rgb_frame (Frame)
            |-- r.input (TextBox)
            |-- g.input (TextBox)
            |-- b.input (TextBox)
    |-- hue_bar (ImageButton)
    |-- saturation_bar (ImageButton)
    |-- value_bar (ImageButton)
    |-- bottom_frame (Frame)
        |-- accept_button (TextButton)
        |-- cancel_button (TextButton)
    |-- color_display (Frame)
```

---

## Notes

- Ensure that all UI elements are appropriately named and parented to match the expected structure.
- Input validation ensures smooth behavior, but avoid extreme edge cases (e.g., invalid or non-numeric inputs).

---

## License
This module is provided as-is, without warranty. You are free to use and modify it for your projects.
