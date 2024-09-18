'use strict';
const {Adw, GLib, Gtk, GObject} = imports.gi;

const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();
const gettextDomain = Me.metadata['gettext-domain'];
const Gettext = imports.gettext.domain(gettextDomain);
const _ = Gettext.gettext;

const  DeviceItem = GObject.registerClass({
}, class DeviceItem extends Adw.ActionRow {
    constructor(settings, deviceItem, path, icon, alias, paired, batteryEnabled, indicatorEnabled) {
        super({});
        this._settings = settings;
        this._path = path;
        this._macAddesss = this._pathToMacAddress(path);

        let iconType;
        if (icon === 'audio-headset')
            iconType = 'audio-headphones';
        else if (icon === 'audio-card')
            iconType = 'audio-speakers';
        else if (icon === 'phone-apple-iphone' || icon === 'phone-samsung-galaxy-s' || icon === 'phone-google-nexus-one')
            iconType = 'phone';
        else
            iconType = icon;

        const iconName = `${iconType}-symbolic`;

        this._deviceIcon = new Gtk.Image({
            icon_name: iconName,
            valign: Gtk.Align.CENTER,
        });

        const list = new Gtk.StringList();
        list.append(_('Show all'));
        list.append(_('Hide all'));
        list.append(_('Hide indicator'));

        this._selector = new Gtk.DropDown({
            valign: Gtk.Align.CENTER,
            model: list,
            tooltip_text: _('Show all:\nShows Indicator icon and battery information in QuickSetting.\n\nHide all:\nHide battery information and Indicator icon in QuickSetting.\n\nHide indicator:\nHide only Indicator icon, Show battery information in QuickSetting.'),
        });

        this._updateSelection(batteryEnabled, indicatorEnabled);

        this._selector.connect('notify::selected', () => {
            const selected = this._selector.get_selected();
            const pairedDevice = settings.get_strv('paired-supported-device-list');
            const existingPathIndex = pairedDevice.findIndex(item => JSON.parse(item).path === path);
            const existingItem = JSON.parse(pairedDevice[existingPathIndex]);
            if (selected === 0) {
                existingItem['battery-enabled'] = true;
                existingItem['indicator-enabled'] = true;
            } else if (selected === 1) {
                existingItem['battery-enabled'] = false;
                existingItem['indicator-enabled'] = false;
            } else if (selected === 2) {
                existingItem['battery-enabled'] = true;
                existingItem['indicator-enabled'] = false;
            }
            pairedDevice[existingPathIndex] = JSON.stringify(existingItem);
            settings.set_strv('paired-supported-device-list', pairedDevice);
        });

        this._deleteButton = new Gtk.Button({
            icon_name: 'user-trash-symbolic',
            tooltip_text: _('Delete device information: The button is available after unpairing device'),
            css_classes: ['destructive-action'],
            valign: Gtk.Align.CENTER,
        });

        this._deleteButton.connect('clicked', () => {
            const pairedDevices = this._settings.get_strv('paired-supported-device-list');
            const existingPathIndex = pairedDevices.findIndex(entry => {
                const parsedEntry = JSON.parse(entry);
                return parsedEntry.path === path;
            });

            if (existingPathIndex !== -1) {
                pairedDevices.splice(existingPathIndex, 1);
                this._settings.set_strv('paired-supported-device-list', pairedDevices);
            }
            this.get_parent().remove(this);
            deviceItem.delete(path);
        });

        const box = new Gtk.Box({spacing: 16});
        box.append(this._selector);
        box.append(this._deleteButton);

        this.add_prefix(this._deviceIcon);
        this.add_suffix(box);
        this.updateProperites(alias, paired, batteryEnabled, indicatorEnabled);
    }

    _updateSelection(batteryEnabled, indicatorEnabled) {
        let currentModelIndex;
        if (batteryEnabled && indicatorEnabled)
            currentModelIndex = 0;
        else if (!batteryEnabled && !indicatorEnabled)
            currentModelIndex = 1;
        else if (batteryEnabled && !indicatorEnabled)
            currentModelIndex = 2;
        this._selector.set_selected(currentModelIndex);
    }

    updateProperites(alias, paired, batteryEnabled, indicatorEnabled) {
        const removedLabel = _('(Removed)');
        const pairedLabel = _('(Paired)');
        this._updateSelection(batteryEnabled, indicatorEnabled);
        this.title = alias;
        this.subtitle = paired ? `${this._macAddesss} ${pairedLabel}` : `${this._macAddesss} ${removedLabel}`;
        this._deleteButton.sensitive = !paired;
    }

    _pathToMacAddress(path) {
        const indexMacAddess = path.indexOf('dev_') + 4;
        const macAddress = path.substring(indexMacAddess);
        return macAddress.replace(/_/g, ':');
    }
});


var Device = GObject.registerClass({
    GTypeName: 'BBM_Device',
    Template: `file://${GLib.build_filenamev([Me.path, 'ui', 'device.ui'])}`,
    InternalChildren: [
        'device_group',
        'no_paired_row',
    ],
}, class Device extends Adw.PreferencesPage {
    constructor(settings) {
        super({});
        this._settings = settings;
        this._deviceItems = new Map();
        this._createDevices();
        this._settings.connect('changed::paired-supported-device-list', () => this._createDevices());
    }

    _createDevices() {
        const pathsString = this._settings.get_strv('paired-supported-device-list').map(JSON.parse);
        if (!pathsString || pathsString.length === 0) {
            this._no_paired_row.visible  = true;
            return;
        }
        this._no_paired_row.visible  = false;
        for (const pathInfo of pathsString) {
            const {path, icon, alias, paired, 'battery-enabled': batteryEnabled, 'indicator-enabled': indicatorEnabled} = pathInfo;
            if (this._deviceItems.has(path)) {
                const row = this._deviceItems.get(path);
                row.updateProperites(alias, paired, batteryEnabled, indicatorEnabled);
            } else {
                const deviceItem = new DeviceItem(this._settings, this._deviceItems, path, icon, alias, paired, batteryEnabled, indicatorEnabled);
                this._deviceItems.set(path, deviceItem);
                this._device_group.add(deviceItem);
            }
        }
    }
});

