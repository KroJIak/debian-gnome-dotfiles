'use strict';
const {Gio, GLib, GObject, Pango, GnomeBluetooth} = imports.gi;
const PopupMenu = imports.ui.popupMenu;
const Main = imports.ui.main;
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const {BluetoothIndicator} = Me.imports.lib.bluetoothIndicator;
const {BluetoothDeviceItem} = Me.imports.lib.bluetoothPopupMenu;

const gettextDomain = Me.metadata['gettext-domain'];
const Gettext = imports.gettext.domain(gettextDomain);
const _ = Gettext.gettext;

const supportedIcons = ['audio-speakers', 'audio-headphones', 'audio-headset', 'input-gaming', 'input-keyboard', 'input-mouse', 'input-tablet'];

Gio._promisify(GnomeBluetooth.Client.prototype, 'connect_service');

var BluetoothBatteryMeter = GObject.registerClass({
}, class BluetoothBatteryMeter extends GObject.Object {
    constructor(settings, extensionPath) {
        super();
        this._extensionPath = extensionPath;
        this._settings = settings;

        this._idleTimerId = GLib.idle_add(GLib.PRIORITY_LOW, () => {
            if (!Main.panel.statusArea.aggregateMenu._bluetooth)
                return GLib.SOURCE_CONTINUE;

            this._startToggle();
            return GLib.SOURCE_REMOVE;
        });
    }

    _startToggle() {
        this._idleTimerId = null;
        this._indicator = Main.panel.statusArea.aggregateMenu._bluetooth;
        this._client = this._indicator._client;
        this._menu = this._indicator._item.menu;

        this._showBatteryPercentage = this._settings.get_boolean('enable-battery-level-text');
        this._showBatteryIcon = this._settings.get_boolean('enable-battery-level-icon');
        this._swapIconText = this._settings.get_boolean('swap-icon-text');

        this._deviceIndicators = new Map();
        this._removedDeviceList = [];
        this._pairedBatteryDevices = new Map();
        this._pullDevicesFromGsetting();
        this._deviceItems = new Map();
        this._deviceSection = new PopupMenu.PopupMenuSection();
        this._placeholderItem = new PopupMenu.PopupMenuItem('', {
            reactive: false,
            can_focus: false,
        });
        this._placeholderItem.label.clutter_text.set({
            ellipsize: Pango.EllipsizeMode.NONE,
            line_wrap: true,
        });
        this._placeholderItem.add_style_class_name('bbm-bt42-menu-placeholder');
        this._placeholderItem.label.add_style_class_name('bbm-bt-menu-placeholder-label');
        this._placeholderItem.setOrnament(PopupMenu.Ornament.HIDDEN);
        this._seperator = new PopupMenu.PopupSeparatorMenuItem();
        const bluetoothToggle = this._indicator._item.menu._getMenuItems()[0];
        const bluetoothSettingsItem = this._indicator._item.menu._getMenuItems()[1];
        this._menu.addMenuItem(this._deviceSection);
        this._menu.addMenuItem(this._placeholderItem);
        this._menu.addMenuItem(this._seperator);
        this._menu.moveMenuItem(bluetoothSettingsItem, 4);
        this._menu.moveMenuItem(bluetoothToggle, 3);

        this._deviceSection.actor.bind_property('visible',
            this._placeholderItem, 'visible',
            GObject.BindingFlags.SYNC_CREATE |
            GObject.BindingFlags.INVERT_BOOLEAN);

        this._menu.connectObject('open-state-changed', isOpen => {
            if (isOpen)
                this._reorderDeviceItems();
        }, this);

        this._client.connectObject(
            'notify::default-adapter-powered', () => this._onActiveChanged(),
            'notify::default-adapter', () => this._onActiveChanged(),
            'device-removed', (c, path) => this._removeDevice(path),
            this);

        this._desktopSettings = new Gio.Settings({schema_id: 'org.gnome.desktop.interface'});
        this._desktopSettings.connectObject(
            'changed::text-scaling-factor', () => {
                this._onActiveChanged();
            },
            this
        );

        this._settings.connectObject(
            'changed::enable-battery-indicator', () => {
                if (this._settings.get_boolean('enable-battery-indicator'))
                    this._sync();
                else
                    this._destroyIndicators();
            },
            'changed::enable-battery-level-text', () => {
                this._showBatteryPercentage = this._settings.get_boolean('enable-battery-level-text');
                this._onActiveChanged();
            },
            'changed::enable-battery-level-icon', () => {
                this._showBatteryIcon = this._settings.get_boolean('enable-battery-level-icon');
                this._onActiveChanged();
            },
            'changed::swap-icon-text', () => {
                this._swapIconText = this._settings.get_boolean('swap-icon-text');
                this._onActiveChanged();
            },
            'changed::paired-supported-device-list', () => {
                this._pullDevicesFromGsetting();
                this._sync();
            },
            this
        );

        this._client.toggleDevice = async device => {
            await this._toggleDevice(device);
        };

        this._indicator._originalSync = this._indicator._sync;
        this._indicator._sync = () => {
            this._sync();
            this._indicator._originalSync();
        };
        this._updatePlaceholder();
        this._sync();
    }

    async _toggleDevice(device) {
        const connect = !device.connected;
        console.debug(`${connect
            ? 'Connect' : 'Disconnect'} device "${device.name}"`);

        try {
            await this._client.connect_service(
                device.get_object_path(),
                connect,
                null);
            log(`Device "${device.name}" ${
                connect ? 'connected' : 'disconnected'}`);
        } catch (e) {
            log(`Failed to ${connect
                ? 'connect' : 'disconnect'} device "${device.name}": ${e.message}`);
        }
    }

    _onActiveChanged() {
        this._updatePlaceholder();

        this._deviceItems.forEach(item => item.destroy());
        this._deviceItems.clear();

        this._sync();
    }

    _updatePlaceholder() {
        this._placeholderItem.label.text = this._client.default_adapter_powered
            ? _('No available or connected devices')
            : _('Turn on Bluetooth to connect to devices');
    }

    _updateDeviceVisibility() {
        this._deviceSection.actor.visible =
            [...this._deviceItems.values()].some(item => item.visible);
    }

    *getDevices() {
        const deviceStore = this._client.get_devices();

        for (let i = 0; i < deviceStore.get_n_items(); i++) {
            const device = deviceStore.get_item(i);

            if (device.paired || device.trusted)
                yield device;
        }
    }

    _getSortedDevices() {
        return [...this.getDevices()].sort((dev1, dev2) => {
            if (dev1.connected !== dev2.connected)
                return dev2.connected - dev1.connected;
            return dev1.alias.localeCompare(dev2.alias);
        });
    }

    _removeDevice(path) {
        this._deviceItems.get(path)?.destroy();
        this._deviceItems.delete(path);
        this._deviceIndicators.get(path)?.destroy();
        this._deviceIndicators.delete(path);
        this._removedDeviceList.push(path);
        if (this._pairedBatteryDevices.has(path)) {
            const props = this._pairedBatteryDevices.get(path);
            props.paired = false;
            this._pairedBatteryDevices.set(path, props);
            this._pushDevicesToGsetting();
        }

        this._updateDeviceVisibility();
    }

    _reorderDeviceItems() {
        const devices = this._getSortedDevices();
        for (const [i, dev] of devices.entries()) {
            const item = this._deviceItems.get(dev.get_object_path());
            if (!item)
                continue;

            this._deviceSection.moveMenuItem(item, i);
        }
    }

    _pullDevicesFromGsetting() {
        this._pairedBatteryDevices.clear();
        const deviceList = this._settings.get_strv('paired-supported-device-list');
        if (deviceList.length !== 0) {
            for (const jsonString of deviceList) {
                const item = JSON.parse(jsonString);
                const path = item.path;
                const props = {
                    'icon': item['icon'],
                    'alias': item['alias'],
                    'paired': item['paired'],
                    'batteryEnabled': item['battery-enabled'],
                    'indicatorEnabled': item['indicator-enabled'],
                };
                this._pairedBatteryDevices.set(path, props);
            }
        }
    }

    _pushDevicesToGsetting() {
        const deviceList = [];
        for (const [path, props] of this._pairedBatteryDevices) {
            const item = {
                path,
                'icon': props.icon,
                'alias': props.alias,
                'paired': props.paired,
                'battery-enabled': props.batteryEnabled,
                'indicator-enabled': props.indicatorEnabled,
            };
            deviceList.push(JSON.stringify(item));
        }
        this._settings.set_strv('paired-supported-device-list', deviceList);
    }

    addBatterySupportedDevices(device) {
        const path = device.get_object_path();
        const props = {
            icon: device.icon,
            alias: device.alias,
            paired: true,
            batteryEnabled: true,
            indicatorEnabled: true,
        };
        this._pairedBatteryDevices.set(path, props);
        this._delayedUpdateDeviceGsettings();
    }

    _delayedUpdateDeviceGsettings() {
        if (this._delayedTimerId)
            GLib.source_remove(this._delayedTimerId);
        this._delayedTimerId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 300, () => {
            this._pushDevicesToGsetting();
            this._delayedTimerId = null;
            return GLib.SOURCE_REMOVE;
        });
    }

    _sync() {
        if (!this._client.default_adapter_powered) {
            this._updateDeviceVisibility();
            return;
        }
        const devices = this._getSortedDevices();
        if (this._removedDeviceList.length > 0) {
            const pathsInDevices = new Set(devices.map(dev => dev.get_object_path()));
            this._removedDeviceList = this._removedDeviceList.filter(path => pathsInDevices.has(path));
        }

        for (const dev of devices) {
            const path = dev.get_object_path();
            if (this._deviceItems.has(path)) {
                if (this._pairedBatteryDevices.has(path)) {
                    const item = this._deviceItems.get(path);
                    item.updateProps(this._pairedBatteryDevices.get(path).batteryEnabled);
                }
                continue;
            }
            if (this._removedDeviceList.length > 0) {
                const pathIndex = this._removedDeviceList.indexOf(path);
                if (pathIndex > -1) {
                    if (dev.connected)
                        this._removedDeviceList.splice(pathIndex, 1);
                    else
                        continue;
                }
            }

            let batteryInfoReported = false;
            let props = {};
            const iconCompatible = supportedIcons.includes(dev.icon);
            if (iconCompatible) {
                if (this._pairedBatteryDevices.has(path)) {
                    let updateGsettingPairedList = false;
                    props = this._pairedBatteryDevices.get(path);
                    if (props.alias !== dev.alias) {
                        props.alias = dev.alias;
                        updateGsettingPairedList = true;
                    }
                    if (props.paired !== dev.paired) {
                        props.paired = dev.paired;
                        updateGsettingPairedList = true;
                    }
                    if (updateGsettingPairedList)
                        this._delayedUpdateDeviceGsettings();
                    batteryInfoReported = true;
                } else if (dev.battery_percentage > 0) {
                    this.addBatterySupportedDevices(dev);
                    batteryInfoReported = true;
                }
            }

            const item = new BluetoothDeviceItem(this, dev, iconCompatible, batteryInfoReported);
            item.connect('notify::visible', () => this._updateDeviceVisibility());
            if (batteryInfoReported)
                item.updateProps(props.batteryEnabled);
            else
                item.updateProps(false);
            this._deviceSection.addMenuItem(item);
            this._deviceItems.set(path, item);
        }

        if (this._settings.get_boolean('enable-battery-indicator')) {
            for (const dev of devices) {
                const path = dev.get_object_path();
                if (this._deviceIndicators.has(path)) {
                    if (!dev.connected || !this._pairedBatteryDevices.get(path).indicatorEnabled) {
                        this._deviceIndicators.get(path)?.destroy();
                        this._deviceIndicators.delete(path);
                    }
                    continue;
                }
                if (this._pairedBatteryDevices.has(path) && this._pairedBatteryDevices.get(path).indicatorEnabled) {
                    const indicator = new BluetoothIndicator(this._settings, dev, this._extensionPath);
                    this._deviceIndicators.set(path, indicator);
                }
            }
        }

        this._updateDeviceVisibility();
    }

    _destroyIndicators() {
        if (this._deviceIndicators) {
            this._deviceIndicators.forEach(indicator => indicator?.destroy());
            this._deviceIndicators.clear();
        }
    }

    destroy() {
        if (this._idleTimerId)
            GLib.source_remove(this._idleTimerId);
        this._idleTimerId = null;
        if (this._client)
            this._client.disconnectObject(this);
        this._settings.disconnectObject(this);
        if (this._delayedTimerId)
            GLib.source_remove(this._delayedTimerId);
        this._delayedTimerId = null;
        if (this._menu)
            this._menu.disconnectObject(this);
        if (this._desktopSettings)
            this._desktopSettings.disconnectObject(this);
        this._destroyIndicators();
        this._deviceItems?.forEach(item => item?.destroy());
        this._deviceItems?.clear();
        this._deviceSection?.destroy();
        this._seperator?.destroy();
        this._placeholderItem?.destroy();
        this._deviceIndicators = null;
        this._deviceItems = null;
        this._pairedBatteryDevices = null;
        this._desktopSettings = null;
        this._settings = null;
        if (this._indicator && this._indicator._originalSync)
            this._indicator._sync = this._indicator._originalSync;
    }
});

