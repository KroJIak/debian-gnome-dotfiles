'use strict';
const {Clutter, Gio, GObject, St} = imports.gi;
const Main = imports.ui.main;
const Config = imports.misc.config;

const [major] = Config.PACKAGE_VERSION.split('.');
const shellVersion42 = Number.parseInt(major) === 42;

const PanelMenu = shellVersion42 ? imports.ui.panelMenu : imports.ui.quickSettings;
const PanelItems = shellVersion42 ? Main.panel.statusArea.aggregateMenu : Main.panel.statusArea.quickSettings;

var BluetoothIndicator = GObject.registerClass(
class BluetoothIndicator extends PanelMenu.SystemIndicator {
    constructor(settings, device, extensionPath) {
        super();
        this._settings = settings;
        this._extensionPath = extensionPath;
        this._device = device;
        this._indicator = this._addIndicator();
        this._indicator.visible = false;
        PanelItems._indicators.insert_child_at_index(this, 0);

        this._device.bind_property_full('battery_percentage',
            this._indicator, 'visible',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, !(source <= 0)], null);

        this._device.bind_property_full('battery_percentage',
            this._indicator, 'gicon',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, this._getGicon(source)], null);

        this._percentageLabel = new St.Label({
            y_expand: true,
            y_align: Clutter.ActorAlign.CENTER,
        });
        this.add_child(this._percentageLabel);
        this.add_style_class_name('power-status');
        const formatter = new Intl.NumberFormat(undefined, {style: 'percent'});
        this._percentageLabel.visible = false;
        this._percentageLabelVisible = this._settings.get_boolean('enable-battery-indicator-text');

        this._device.bind_property_full('battery_percentage',
            this._percentageLabel, 'text',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, formatter.format(source / 100)], null);

        this._device.bind_property_full('battery_percentage',
            this._percentageLabel, 'visible',
            GObject.BindingFlags.SYNC_CREATE,
            (bind, source) => [true, (source > 0) && this._percentageLabelVisible], null);

        this._settings.connectObject('changed::enable-battery-indicator-text', () => {
            this._percentageLabelVisible = this._settings.get_boolean('enable-battery-indicator-text');
            this._percentageLabel.visible = this._percentageLabelVisible && this._device.battery_percentage > 0;
        }, this);
    }

    _getGicon(percent) {
        let iconPrefix = '';
        if (percent > 85)
            iconPrefix = '100';
        else if (percent <= 85 && percent > 60)
            iconPrefix = '75';
        else if (percent <= 60 && percent > 35)
            iconPrefix = '50';
        else if (percent <= 35 && percent > 20)
            iconPrefix = '25';
        else if (percent <= 20 && percent > 10)
            iconPrefix = '20';
        else if (percent <= 10 && percent >= 0)
            iconPrefix = '10';

        let iconType;
        if (this._device.icon === 'audio-headset')
            iconType = 'audio-headphones';
        else if (this._device.icon === 'audio-card')
            iconType = 'audio-speakers';
        else if (this._device.icon === 'phone-apple-iphone' || this._device.icon === 'phone-samsung-galaxy-s' || this._device.icon === 'phone-google-nexus-one')
            iconType = 'phone';
        else
            iconType = this._device.icon;

        return Gio.icon_new_for_string(
            `${this._extensionPath}/icons/hicolor/scalable/actions/bbm-${iconPrefix}-${iconType}-symbolic.svg`);
    }
});
