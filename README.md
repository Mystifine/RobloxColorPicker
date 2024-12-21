# ColorPicker Module

The **ColorPicker** module is an interactive, customizable color picker for Roblox. It allows users to dynamically select colors using HSV sliders, RGB inputs, and real-time previews. This module is designed for easy integration into Roblox projects.

---

## Features

- **HSV and RGB Support**: Users can select colors via HSV sliders or by directly inputting RGB/HSV values.
- **Real-Time UI Updates**: The color display updates dynamically as users adjust sliders or inputs.
- **Customizable Positioning**: Specify where the color picker UI should appear.
- **Event-Driven Design**: Includes accept and cancel events for seamless integration into game logic.
- **Input Validation**: Ensures RGB and HSV values remain within valid ranges.
- **Resource Management**: Automatically handles cleanup of UI components and event listeners.

---

## Installation

1. Visit the [ColorPicker module on the Roblox Creator Marketplace](https://create.roblox.com/store/asset/15732088988/ColorPicker).
2. Add the module to your inventory by clicking "Get" or "Buy."
3. Insert the `ColorPicker` module script into `ReplicatedStorage` or `StarterPlayerScripts` in your game.
4. Ensure the associated UI components (e.g., `color_picker_ui`) are included and properly replicated to the client.

---

## Usage

### Creating a Color Picker
To create a new color picker instance, call the `ColorPicker.new()` method:

```lua
local ColorPicker = require(game.ReplicatedStorage.ColorPicker)

-- Example Usage
local colorPicker = ColorPicker.new(Color3.fromRGB(255, 0, 0))
local selectedColor = colorPicker:Pick(100, 200) -- Display UI at position (100, 200)
print("Selected Color:", selectedColor)
```

### Destroying a Color Picker
When the color picker is no longer needed, call the `Destroy` method to free resources:

```lua
colorPicker:Destroy()
```

---

## API Documentation

### Methods

#### `ColorPicker.new(selectedColor: Color3)`
Creates a new instance of the color picker.

- **Parameters:**
  - `selectedColor` (Color3): The default starting color.
- **Returns:**
  - A `ColorPicker` object.

---

#### `ColorPicker:Pick(x: number, y: number)`
Displays the color picker UI at the specified position and waits for the user to select a color.

- **Parameters:**
  - `x` (number): The horizontal screen position.
  - `y` (number): The vertical screen position.
- **Returns:**
  - The selected `Color3` color if accepted.

---

#### `ColorPicker:Destroy()`
Cleans up the color picker instance, disconnects all event listeners, and removes the UI components.

---

### Events

- **Accept Button**: Fires when the user selects a color and clicks the "Accept" button.
- **Cancel Button**: Fires when the user clicks the "Cancel" button, returning the original selected color.

---

## Internal Design

### Key Methods

- **`UpdateColorUI`**: Updates all UI elements to reflect the currently selected color.
- **`_bindHSVInputEvents`**: Binds user input events to HSV input fields.
- **`_bindRGBInputEvents`**: Binds user input events to RGB input fields.
- **`_bindHSVSliderEvents`**: Manages interactions with sliders for Hue, Saturation, and Value.
- **`_mouseInFrame`**: Utility function to detect if the mouse is inside a frame.
- **`_validateHSVInput`**: Ensures HSV inputs are valid and within range.
- **`_validateRGBInput`**: Ensures RGB inputs are valid and within range.
- **`_getHSV` and `_getRGB`**: Convert between HSV and RGB values.

---

## UI Structure

Ensure the `color_picker_ui` ScreenGui is structured as follows:

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

### Notes
- Ensure all UI components are named as expected to avoid runtime errors.
- The `color_picker_ui` should be a descendant of the `ColorPicker` script for proper functionality.

---

## Example Workflow

1. **Create an Instance**:
   ```lua
   local colorPicker = ColorPicker.new(Color3.fromRGB(255, 0, 0))
   ```

2. **Display the UI and Get a Selection**:
   ```lua
   local selectedColor = colorPicker:Pick(500, 300)
   print("Selected Color:", selectedColor)
   ```

3. **Destroy the Instance After Use**:
   ```lua
   colorPicker:Destroy()
   ```

---

## License

This module is provided "as-is," without warranty of any kind. You are free to use and modify it for your projects.

