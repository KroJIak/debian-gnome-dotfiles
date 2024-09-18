const KeyboardUI = imports.ui.keyboard;

let _originalLastDeviceIsTouchscreen;

function _modifiedLastDeviceIsTouchscreen() {
    return false;
}

function init() {

}

function enable() {
    _originalLastDeviceIsTouchscreen = KeyboardUI.KeyboardManager.prototype._lastDeviceIsTouchscreen;
    KeyboardUI.KeyboardManager.prototype._lastDeviceIsTouchscreen = _modifiedLastDeviceIsTouchscreen;
}

function disable() {
    KeyboardUI.KeyboardManager.prototype._lastDeviceIsTouchscreen = _originalLastDeviceIsTouchscreen;
    _originalLastDeviceIsTouchscreen = null;
}
