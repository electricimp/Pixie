# Pixie

This class allows the imp to drive [Pixie](https://www.adafruit.com/products/2741) 3W chainable smart LED pixels. The Pixie is an all-in-one RGB LED with integrated shift register and constant-current driver. The parts are daisy-chained, and a proprietary one-wire protocol is used to send data to the chain of LEDs. Each pixel is individually addressable and this allows the part to be used for a wide range of effects animations.

**Library still under test, please copy and paste the `Pixie.class.nut` file at the top of your device code **

## Class Usage

All public methods in the Pixie class return `this`, allowing you to easily chain multiple commands together:

```squirrel
pixels
    .set(0, [255,0,0])
    .set(1, [0,255,0])
    .fill([0,0,255], 2, 4)
    .draw();
```

### Constructor: Pixie(spi, frameSize)

Instantiate the class with an unconfigured UART object and the number of pixels that are connected. The constructor will configure the UART.

```squirrel
// Select uart
uart <- hardware.uartFG;

// Instantiate LEDs with 4 pixels
pixels <- Pixie(uart, 4);
```

## Class Methods

### set(*index, color*)

The *set* method changes the color of a particular pixel in the frame buffer. The color is passed as as an array of three integers between 0 and 255 representing `[red, green, blue]`.

NOTE: The *set* method does not output the changes to the pixel strip. After setting up the frame, you must call `draw` (see below) to output the frame to the strip.

```squirrel
// Set and draw a pixel
pixels.set(0, [127,0,0]).draw();
```

### fill(*color, [start], [end]*)

The *fill* methods sets all pixels in the specified range to the desired color. If no range is selected, the entire frame will be filled with the specified color.

NOTE: The *fill* method does not output the changes to the pixel strip. After setting up the frame, you must call `draw` (see below) to output the frame to the strip.

```squirrel
// Turn all LEDs off
pixels.fill([0,0,0]).draw();
```

```squirrel
// Set half the array red
// and the other half blue
pixels
    .fill([100,0,0], 0, 2)
    .fill([0,0,100], 3, 4);
    .draw();
```

### draw()

The *draw* method draws writes the current frame to the pixel array (see examples above).

## License

The Pixie class is licensed under the [MIT License](/LICENSE).
