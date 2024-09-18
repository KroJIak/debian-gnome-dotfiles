'use strict';
const {Gio, GLib, GObject, St} = imports.gi;
const PopupMenu = imports.ui.popupMenu;
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const Config = imports.misc.config;
const [major] = Config.PACKAGE_VERSION.split('.');
const shellVersion42 = Number.parseInt(major) === 42;

const gettextDomain = Me.metadata['gettext-domain'];
const Gettext = imports.gettext.domain(gettextDomain);
const _ = Gettext.gettext;

var BluetoothDeviceItem = GObject.registerClass({
    Properties: {
        'batteryPercentage': GObject.ParamSpec.string('batteryPercentage', '', '',
            GObject.ParamFlags.READWRITE,
            null),
    },
}, class BluetoothDeviceItem extends PopupMenu.PopupBaseMenuItem {
    constructor(toggle, device, iconCompatable, batteryInfoReported) {
        super({
            style_class: 'bt-device-item',
        });
        this._toggle = toggle;
        this._settings = toggle._settings;
        this._client = toggle._client;
        this._extensionPath = toggle._extensionPath;
        this._showBatteryPercentage = toggle._showBatteryPercentage;
        this._showBatteryIcon = toggle._showBatteryIcon;
        this._swapIconText = toggle._swapIconText;
        if (!shellVersion42) {
            this._connectedColor = toggle._connectedColor;
            this._disconnectedColor = toggle._disconnectedColor;
        }
        this._device = device;
        this._iconCompatable = iconCompatable;
        this._batteryEnabled = false;


        this._icon = new St.Icon({
            style_class: 'popup-menu-icon',
        });
        this.add_child(this._icon);

        this._label = new St.Label({
            x_expand: true,
        });
        this.add_child(this._label);

        if (this._swapIconText) {
            this._displayBatteryLevelIcon();
            this._displayBatteryLevelTextPercentage();
        } else {
            this._displayBatteryLevelTextPercentage();
            this._displayBatteryLevelIcon();
        }

        this._pairIcon = new St.Icon({
            icon_size: 16,
        });
        this.add_child(this._pairIcon);

        this._device.bind_property('connectable',
            this, 'visible',
            GObject.BindingFlags.SYNC_CREATE);

        this._device.bind_property('icon',
            this._icon, 'icon-name',
            GObject.BindingFlags.SYNC_CREATE);

        this._device.bind_property('alias',
            this._label, 'text',
            GObject.BindingFlags.SYNC_CREATE);

        this._device.bind_property_full('connected',
            this, 'accessible_name',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, source ? _('Disconnect') : _('Connect')],
            null);

        this._assignPairingIcon(false);

        this.activate = __ => {
            this._toggleConnected().catch(logError);
        };

        this._device.connectObject(
            'notify::connected', () => {
                this._assignPairingIcon(false);
            },
            this
        );

        if (this._iconCompatable && !batteryInfoReported) {
            this._device.bind_property('battery_percentage',
                this, 'batteryPercentage',
                GObject.BindingFlags.SYNC_CREATE);
            this._notiftId = this.connect(
                'notify::batteryPercentage', () => {
                    if (this._device.battery_percentage > 0) {
                        this._addBatterySupportedDevice();
                        this.disconnect(this._notiftId);
                        this._notiftId = null;
                    }
                }
            );
        }

        this.connectObject('destroy', () => {
            if (this._iconChangeTimerId)
                GLib.source_remove(this._iconChangeTimerId);
            this._iconChangeTimerId = null;
            if (this._idleTimerId)
                GLib.source_remove(this._idleTimerId);
            this._idleTimerId = null;
            if (this._notiftId)
                this.disconnect(this._notiftId);
        }, this);
    }

    updateProps(batteryEnabled) {
        this._batteryEnabled = batteryEnabled;

        if (this._iconCompatable && this._showBatteryIcon)
            this._batteryIcon.visible =  this._batteryEnabled && this._device.battery_percentage > 0;

        if (this._iconCompatable && this._showBatteryPercentage)
            this._batteryPercentageLabel.visible =  this._batteryEnabled && this._device.battery_percentage > 0;
    }

    _addBatterySupportedDevice() {
        this._toggle.addBatterySupportedDevices(this._device);
        this.disconnectObject(this);
    }

    _displayBatteryLevelTextPercentage() {
        if (this._iconCompatable && this._showBatteryPercentage) {
            this._batteryPercentageLabel = new St.Label({text: '100%'});
            this.add_child(this._batteryPercentageLabel);
            if (this._idleTimerId)
                GLib.source_remove(this._idleTimerId);
            this._idleTimerId = GLib.idle_add(GLib.PRIORITY_LOW, () => {
                if (!this._batteryPercentageLabel.get_parent())
                    return GLib.SOURCE_CONTINUE;
                if (this._swapIconText) {
                    this._batteryPercentageLabel.set_width(this._batteryPercentageLabel.get_width());
                    this._batteryPercentageLabel.style_class = 'bbm-bt-percentage-label';
                }
                this._batteryPercentageLabel.text = '';
                this._bindLabel();
                return GLib.SOURCE_REMOVE;
            });
        }
    }

    _bindLabel() {
        this._device.bind_property_full('battery_percentage',
            this._batteryPercentageLabel, 'visible',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, this._batteryEnabled && source > 0], null);

        this._device.bind_property_full('battery_percentage',
            this._batteryPercentageLabel, 'text',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, `${source}%`], null);

        this._idleTimerId = null;
    }

    _displayBatteryLevelIcon() {
        if (this._iconCompatable && this._showBatteryIcon) {
            this._batteryIcon = new St.Icon({
                icon_size: 16,
            });
            this.add_child(this._batteryIcon);

            this._device.bind_property_full('battery_percentage',
                this._batteryIcon, 'visible',
                GObject.BindingFlags.SYNC_CREATE,
                (bind, source) => [true, this._batteryEnabled && source > 0], null);

            this._device.bind_property_full('battery_percentage',
                this._batteryIcon, 'icon-name',
                GObject.BindingFlags.SYNC_CREATE,
                (bind, source) => [true, source <= 0 ? '' : `battery-level-${10 * Math.floor(source / 10)}-symbolic`],
                null);
        }
    }

    async _toggleConnected() {
        this._assignPairingIcon(true);
        await this._client.toggleDevice(this._device);
        this._assignPairingIcon(false);
    }

    _assignPairingIcon(toggleActivated) {
        if (toggleActivated) {
            if (this._iconChangeTimerId)
                GLib.source_remove(this._iconChangeTimerId);
            this._counter = 4;
            const connected = this._device.connected;
            if (!connected) {
                if (shellVersion42)
                    this._pairIcon?.add_style_class_name('shell-link');
                else
                    this._pairIcon?.set_style(`color: ${this._connectedColor};`);
            } else {
                if (shellVersion42)
                   this._pairIcon?.remove_style_class_name('shell-link');
                else
                    this._pairIcon?.set_style(`color: ${this._disconnectedColor};`);
            }
            this._iconChangeTimerId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300, () => {
                this._pairIcon?.set_gicon(this._device.connected ? this._getIcon(`bbm-bluetooth-disconnecting-${this._counter}-symbolic`)
                    : this._getIcon(`bbm-bluetooth-connecting-${this._counter}-symbolic`));
                this._counter = this._counter <= 1 ? 4 : this._counter - 1;
                return GLib.SOURCE_CONTINUE;
            });
        } else {
            if (this._iconChangeTimerId)
                GLib.source_remove(this._iconChangeTimerId);
            this._iconChangeTimerId = null;
            if (this._device.connected) {
                this._pairIcon?.set_gicon(this._getIcon('bbm-bluetooth-connected-symbolic'));
                if (shellVersion42)
                    this._pairIcon?.add_style_class_name('shell-link');
                else
                    this._pairIcon?.set_style(`color: ${this._connectedColor};`);
            } else {
                this._pairIcon?.set_gicon(this._getIcon('bbm-bluetooth-disconnecting-1-symbolic'));
                if (shellVersion42)
                    this._pairIcon?.remove_style_class_name('shell-link');
                else
                    this._pairIcon?.set_style(`color: ${this._disconnectedColor};`);
            }
        }
    }

    _getIcon(iconName) {
        return Gio.icon_new_for_string(`${this._extensionPath}/icons/hicolor/scalable/actions/${iconName}.svg`);
    }
});


