class Pixie {

    static VERSION = [1, 0, 0];

    static PIXEL_BLOB_SIZE = 3;
    static WRITE_TIMER = 1;

    _leds = null;
    _drawTimer = null;
    _colors = null;
    _colorsUpdate = null;

    constructor(uart, numPixels) {
        // Configure UART
        _leds = uart;
        _leds.configure(115200,8,PARITY_NONE,1,NO_RX);

        // Create and Sync color blobs with all LEDs off
        _colors = blob(numPixels * PIXEL_BLOB_SIZE);
        _colorsUpdate = _colors;
        // Turn off all LEDs
        _leds.write(_colors);
    }

    function set(index, color) {
        index = index * PIXEL_BLOB_SIZE;
        // Move blob write pointer to starting index
        _colorsUpdate.seek(index, 'b');
        // Write color to _colorsUpdate blob
        _storeColor(color);
        return this;
    }

    function fill(color, start = 0, end = null) {
        end = (end == null) ? ((_colors.len() / PIXEL_BLOB_SIZE) - 1) : end * PIXEL_BLOB_SIZE;
        start = start * PIXEL_BLOB_SIZE;
        // Flip if end is before start
        if (end < start) {
            local s = start;
            start = end;
            end = s;
        }
        // Move blob write pointer to starting index
        _colorsUpdate.seek(start, 'b');
        // Write color to _colorsUpdate blob
        for(local i = start; i <= end; i++) {
            _storeColor(color);
        }
        return this;
    }

    function draw() {
        // Sync color blobs
        _colors = _colorsUpdate;
        // cancel _drawTimer
        if (_drawTimer != null) imp.cancelwakeup(_drawTimer);
        // Write _colors to LEDs every second
        _write();
        return this;
    }

    function _write() {
        _leds.write(_colors);
        _drawTimer = imp.wakeup(WRITE_TIMER, _write.bindenv(this));
    }

    function _storeColor(color) {
        foreach (item in color) {
            if (item > 255) item = 255;
            if (item < 0) item = 0;
            _colorsUpdate.writen(item, 'b');
        }
    }

}