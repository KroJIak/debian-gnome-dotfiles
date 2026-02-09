import { ExtensionPreferences } from 'resource:///org/gnome/Shell/Extensions/js/extensions/prefs.js';
import Adw from 'gi://Adw';
import Gtk from 'gi://Gtk';

const SettingsPath = "org.gnome.shell.extensions.quicksettings-audio-devices-hider";
const ExcludedOutputNamesSetting = "excluded-output-names";
const ExcludedInputNamesSetting = "excluded-input-names";
const AvailableOutputNames = "available-output-names";
const AvailableInputNames = "available-input-names";

class SettingsUtils {
    constructor(settings) {
        this.settings = settings;
    }

    getExcludedOutputDeviceNames() {
        const ids = this.settings.get_strv(ExcludedOutputNamesSetting);

        return ids;
    }

    getExcludedInputDeviceNames() {
        const ids = this.settings.get_strv(ExcludedInputNamesSetting);

        return ids;
    }

    setExcludedOutputDeviceNames(displayNames) {
        this.settings.set_strv(ExcludedOutputNamesSetting, displayNames);
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
        this.settings.set_strv(setting, newDevices);
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
        this.settings.set_strv(setting, devices);
    }

    getAvailableOutputs() {
        const ids = this.settings.get_strv(AvailableOutputNames);

        return ids;
    }

    getAvailableInputs() {
        const ids = this.settings.get_strv(AvailableInputNames);

        return ids;
    }

    setAvailableOutputs(displayNames) {
        this.settings.set_strv(AvailableOutputNames, displayNames.map((id) => id.toString()));
    }

    setAvailableInputs(displayNames) {
        this.settings.set_strv(AvailableInputNames, displayNames.map((id) => id.toString()));
    }

    addToAvailableDevices(displayName, type) {
        const currentDevices = type === "output"
            ? this.getAvailableOutputs()
            : this.getAvailableInputs();
        if (currentDevices.includes(displayName)) {
            return;
        }
        const newAllDevices = [...currentDevices, displayName];
        this.settings.set_strv(type === "output" ? AvailableOutputNames : AvailableInputNames, newAllDevices.map((id) => id.toString()));
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
        this.settings.set_strv(type === "output" ? AvailableOutputNames : AvailableInputNames, devices.map((id) => id.toString()));
    }

    connectToChanges(settingName, func) {
        return this.settings.connect(`changed::${settingName}`, func);
    }

    disconnect(subscriptionId) {
        this.settings.disconnect(subscriptionId);
    }
}

class Preferences extends ExtensionPreferences {
    fillPreferencesWindow(window) {
        const settings = new SettingsUtils(this.getSettings(SettingsPath));
        window.add(this.createOutputsPage(settings));
        window.add(this.createInputsPage(settings));
    }

    createOutputsPage(settings) {
        const page = new Adw.PreferencesPage({
            title: "Outputs",
            iconName: "audio-speakers-symbolic",
        });
        const allOutputDevices = settings.getAvailableOutputs();
        const hiddenOutputDevices = settings.getExcludedOutputDeviceNames();
        const visibleOutputDevices = allOutputDevices.filter((device) => !hiddenOutputDevices.includes(device));
        const outputs = new Adw.PreferencesGroup({
            title: "Output Audio Devices",
            description: "Choose which output devices should be visible in the Quick Setting panel",
        });
        page.add(outputs);
        visibleOutputDevices.forEach((device) => {
            outputs.add(this.createDeviceRow(device, true, settings, "output"));
        });
        hiddenOutputDevices.forEach((device) => {
            outputs.add(this.createDeviceRow(device, false, settings, "output"));
        });

        return page;
    }

    createInputsPage(settings) {
        const page = new Adw.PreferencesPage({
            title: "Inputs",
            iconName: "audio-input-microphone-symbolic",
        });
        const allInputDevices = settings.getAvailableInputs();
        const hiddenInputDevices = settings.getExcludedInputDeviceNames();
        const visibleInputDevices = allInputDevices.filter((device) => !hiddenInputDevices.includes(device));
        const inputs = new Adw.PreferencesGroup({
            title: "Input Audio Devices",
            description: "Choose which input devices should be visible in the Quick Setting panel",
        });
        page.add(inputs);
        visibleInputDevices.forEach((device) => {
            inputs.add(this.createDeviceRow(device, true, settings, "input"));
        });
        hiddenInputDevices.forEach((device) => {
            inputs.add(this.createDeviceRow(device, false, settings, "input"));
        });

        return page;
    }

    createDeviceRow(displayName, active, settings, type) {
        const row = new Adw.ActionRow({ title: displayName });
        const toggle = new Gtk.Switch({
            active,
            valign: Gtk.Align.CENTER,
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
}

export { Preferences as default };
