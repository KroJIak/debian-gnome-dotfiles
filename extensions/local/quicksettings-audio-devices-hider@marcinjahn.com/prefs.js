var prefs = (function (adw1, gtk4) {
    'use strict';

    const ExtensionUtils = imports.misc.extensionUtils;
    const SettingsPath = "org.gnome.shell.extensions.quicksettings-audio-devices-hider";
    const ExcludedOutputNamesSetting = "excluded-output-names";
    const ExcludedInputNamesSetting = "excluded-input-names";
    const AvailableOutputNames = "available-output-names";
    const AvailableInputNames = "available-input-names";
    class SettingsUtils {
        constructor() {
            this.settings = null;
        }
        getSettings() {
            if (!this.settings) {
                this.settings = ExtensionUtils.getSettings(SettingsPath);
            }
            return this.settings;
        }
        getExcludedOutputDeviceNames() {
            const settings = this.getSettings();
            const ids = settings.get_strv(ExcludedOutputNamesSetting);
            return ids;
        }
        getExcludedInputDeviceNames() {
            const settings = this.getSettings();
            const ids = settings.get_strv(ExcludedInputNamesSetting);
            return ids;
        }
        setExcludedOutputDeviceNames(displayNames) {
            const settings = this.getSettings();
            settings.set_strv(ExcludedOutputNamesSetting, displayNames);
        }
        addToExcludedDeviceNames(displayName, deviceType) {
            const currentDevices = deviceType === "output"
                ? this.getExcludedOutputDeviceNames()
                : this.getExcludedInputDeviceNames();
            if (currentDevices.includes(displayName)) {
                return;
            }
            const newDevices = [...currentDevices, displayName];
            const setting = deviceType === "output"
                ? ExcludedOutputNamesSetting
                : ExcludedInputNamesSetting;
            const settings = this.getSettings();
            settings.set_strv(setting, newDevices);
        }
        removeFromExcludedDeviceNames(displayName, deviceType) {
            const devices = deviceType === "output"
                ? this.getExcludedOutputDeviceNames()
                : this.getExcludedInputDeviceNames();
            const index = devices.indexOf(displayName);
            if (index === -1) {
                return;
            }
            devices.splice(index, 1);
            const setting = deviceType === "output"
                ? ExcludedOutputNamesSetting
                : ExcludedInputNamesSetting;
            const settings = this.getSettings();
            settings.set_strv(setting, devices);
        }
        getAvailableOutputs() {
            const settings = this.getSettings();
            const ids = settings.get_strv(AvailableOutputNames);
            return ids;
        }
        getAvailableInputs() {
            const settings = this.getSettings();
            const ids = settings.get_strv(AvailableInputNames);
            return ids;
        }
        setAvailableOutputs(displayNames) {
            const settings = this.getSettings();
            settings.set_strv(AvailableOutputNames, displayNames.map((id) => id.toString()));
        }
        setAvailableInputs(displayNames) {
            const settings = this.getSettings();
            settings.set_strv(AvailableInputNames, displayNames.map((id) => id.toString()));
        }
        addToAvailableDevices(displayName, type) {
            const currentDevices = type === "output"
                ? this.getAvailableOutputs()
                : this.getAvailableInputs();
            if (currentDevices.includes(displayName)) {
                return;
            }
            const newAllDevices = [...currentDevices, displayName];
            const settings = this.getSettings();
            settings.set_strv(type === "output" ? AvailableOutputNames : AvailableInputNames, newAllDevices.map((id) => id.toString()));
        }
        removeFromAvailableDevices(displayName, type) {
            const devices = type === "output"
                ? this.getAvailableOutputs()
                : this.getAvailableInputs();
            const index = devices.indexOf(displayName);
            if (index === -1) {
                return;
            }
            devices.splice(index, 1);
            const settings = this.getSettings();
            settings.set_strv(type === "output" ? AvailableOutputNames : AvailableInputNames, devices.map((id) => id.toString()));
        }
        connectToChanges(settingName, func) {
            return this.getSettings().connect(`changed::${settingName}`, func);
        }
        disconnect(subscriptionId) {
            this.getSettings().disconnect(subscriptionId);
        }
        dispose() {
            this.settings = null;
        }
    }

    function init() { }
    function fillPreferencesWindow(window) {
        const settings = new SettingsUtils();
        window.add(createOutputsPage(settings));
        window.add(createInputsPage(settings));
    }
    function createOutputsPage(settings) {
        const page = new adw1.PreferencesPage({
            title: "Outputs",
            iconName: "audio-speakers-symbolic",
        });
        const allOutputDevices = settings.getAvailableOutputs();
        const hiddenOutputDevices = settings.getExcludedOutputDeviceNames();
        const visibleOutputDevices = allOutputDevices.filter((device) => !hiddenOutputDevices.includes(device));
        const outputs = new adw1.PreferencesGroup({
            title: "Output Audio Devices",
            description: "Choose which output devices should be visible in the Quick Setting panel",
        });
        page.add(outputs);
        visibleOutputDevices.forEach((device) => {
            outputs.add(createDeviceRow(device, true, settings, "output"));
        });
        hiddenOutputDevices.forEach((device) => {
            outputs.add(createDeviceRow(device, false, settings, "output"));
        });
        return page;
    }
    function createInputsPage(settings) {
        const page = new adw1.PreferencesPage({
            title: "Inputs",
            iconName: "audio-input-microphone-symbolic",
        });
        const allInputDevices = settings.getAvailableInputs();
        const hiddenInputDevices = settings.getExcludedInputDeviceNames();
        const visibleInputDevices = allInputDevices.filter((device) => !hiddenInputDevices.includes(device));
        const inputs = new adw1.PreferencesGroup({
            title: "Input Audio Devices",
            description: "Choose which input devices should be visible in the Quick Setting panel",
        });
        page.add(inputs);
        visibleInputDevices.forEach((device) => {
            inputs.add(createDeviceRow(device, true, settings, "input"));
        });
        hiddenInputDevices.forEach((device) => {
            inputs.add(createDeviceRow(device, false, settings, "input"));
        });
        return page;
    }
    function createDeviceRow(displayName, active, settings, type) {
        const row = new adw1.ActionRow({ title: displayName });
        const toggle = new gtk4.Switch({
            active,
            valign: gtk4.Align.CENTER,
        });
        toggle.connect("state-set", (_, state) => {
            if (state) {
                settings.removeFromExcludedDeviceNames(displayName, type);
            }
            else {
                settings.addToExcludedDeviceNames(displayName, type);
            }
            return false;
        });
        row.add_suffix(toggle);
        row.activatable_widget = toggle;
        return row;
    }
    var prefs = { init, fillPreferencesWindow };

    return prefs;

})(imports.gi.Adw, imports.gi.Gtk);
var init = prefs.init;
var fillPreferencesWindow = prefs.fillPreferencesWindow;
