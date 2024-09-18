var init = (function (glib2, gvc1) {
    'use strict';

    let timeoutSourceIds = [];
    function delay(milliseconds) {
        return new Promise((resolve) => {
            const timeoutId = glib2.timeout_add(glib2.PRIORITY_DEFAULT, milliseconds, () => {
                removeFinishedTimeoutId(timeoutId);
                resolve(undefined);
                return glib2.SOURCE_REMOVE;
            });
            if (!timeoutSourceIds) {
                timeoutSourceIds = [];
            }
            timeoutSourceIds.push(timeoutId);
        });
    }
    function removeFinishedTimeoutId(timeoutId) {
        timeoutSourceIds?.splice(timeoutSourceIds.indexOf(timeoutId), 1);
    }
    function disposeDelayTimeouts() {
        timeoutSourceIds?.forEach((sourceId) => {
            glib2.Source.remove(sourceId);
        });
        timeoutSourceIds = null;
    }

    const Main = imports.ui.main;
    const QuickSettings = Main.panel.statusArea.quickSettings;
    class AudioPanel {
        getDisplayedDeviceIds(type) {
            const devices = type === "output"
                ? QuickSettings._volume._output._deviceItems
                : QuickSettings._volume._input._deviceItems;
            return Array.from(devices, ([id]) => id);
        }
        removeDevice(id, type) {
            if (type === "output") {
                QuickSettings._volume._output._removeDevice(id);
            }
            else {
                QuickSettings._volume._input._removeDevice(id);
            }
        }
        addDevice(id, type) {
            if (type === "output") {
                QuickSettings._volume._output._addDevice(id);
            }
            else {
                QuickSettings._volume._input._addDevice(id);
            }
        }
    }

    function range(amount) {
        return [...Array(amount).keys()];
    }

    /**
     * Display name format copied from
     * https://gitlab.gnome.org/GNOME/gnome-shell/-/blob/main/js/ui/status/volume.js#L132
     * The "-" is U+2013 on purpose
     * @param id
     * @param description
     * @param origin
     * @param type
     */
    function getAudioDevice(id, description, origin, type) {
        if (!description)
            description = "unknown device";
        return {
            id,
            displayName: origin ? `${description} – ${origin}` : description,
            type,
        };
    }

    class MixerWrapper {
        constructor(mixer, disposal) {
            this.mixer = mixer;
            this.disposal = disposal;
        }
        getAudioDevicesFromIds(ids, type = "output") {
            return ids.map((id) => {
                const lookup = type === "output"
                    ? this.mixer.lookup_output_id(id)
                    : this.mixer.lookup_input_id(id);
                return getAudioDevice(id, lookup?.get_description(), lookup?.get_origin(), type);
            });
        }
        /**
         * Uses a Dummy Device "trick" from
         * https://github.com/kgshank/gse-sound-output-device-chooser/blob/master/sound-output-device-chooser@kgshank.net/base.js#LL299C20-L299C20
         * @param displayNames display names
         * @param type
         * @returns A list of matching audio devices. If a given display name is not found,
         * undefined is returned in its place.
         */
        getAudioDevicesFromDisplayNames(displayNames, type) {
            const dummyDevice = new gvc1.MixerUIDevice();
            const devices = this.getAudioDevicesFromIds(range(dummyDevice.get_id()), type);
            return displayNames.map((name) => devices.find((device) => device.displayName === name));
        }
        subscribeToDeviceChanges(callback) {
            const addOutputId = this.mixer.connect("output-added", (_, deviceId) => callback({ deviceId, type: "output-added" }));
            const removeOutputId = this.mixer.connect("output-removed", (_, deviceId) => callback({ deviceId, type: "output-removed" }));
            const addInputId = this.mixer.connect("input-added", (_, deviceId) => callback({ deviceId, type: "input-added" }));
            const removeInputId = this.mixer.connect("input-removed", (_, deviceId) => callback({ deviceId, type: "input-removed" }));
            return { ids: [addOutputId, removeOutputId, addInputId, removeInputId] };
        }
        unsubscribe(subscription) {
            subscription.ids.forEach((id) => {
                this.mixer.disconnect(id);
            });
        }
        dispose() {
            this.disposal();
        }
    }

    async function waitForMixerToBeReady(mixer) {
        while (mixer.get_state() === gvc1.MixerControlState.CONNECTING) {
            await delay(200);
        }
        const state = mixer.get_state();
        if (state === gvc1.MixerControlState.FAILED) {
            throw new Error("MixerControl is in a failed state");
        }
        else if (state === gvc1.MixerControlState.CLOSED) {
            throw new Error("MixerControl is in a closed state");
        }
    }

    class AudioPanelMixerSource {
        async getMixer() {
            const Volume = imports.ui.status.volume;
            const mixer = Volume.getMixerControl();
            await waitForMixerToBeReady(mixer);
            await delay(200);
            return new MixerWrapper(mixer, () => { });
        }
    }

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

    imports.misc.extensionUtils;
    class Extension {
        constructor(uuid) {
            this._uuid = uuid;
        }
        enable() {
            log(`Enabling extension ${this._uuid}`);
            this._audioPanel = new AudioPanel();
            this._settings = new SettingsUtils();
            this._lastExcludedOutputDevices =
                this._settings.getExcludedOutputDeviceNames();
            this._lastExcludedInputDevices =
                this._settings.getExcludedInputDeviceNames();
            new AudioPanelMixerSource().getMixer().then((mixer) => {
                this._mixer = mixer;
                this.setAvailableDevicesInSettings();
                this.setupDeviceChangesSubscription();
                this.hideExcludedDevices();
                this.setupExcludedDevicesHandling();
            });
        }
        hideExcludedDevices() {
            const devices = this._mixer
                ?.getAudioDevicesFromDisplayNames(this._lastExcludedOutputDevices, "output")
                .concat(this._mixer?.getAudioDevicesFromDisplayNames(this._lastExcludedInputDevices, "input"));
            devices?.forEach((device) => {
                if (device) {
                    this._audioPanel?.removeDevice(device.id, device.type);
                }
            });
        }
        setupExcludedDevicesHandling() {
            const listenerFactory = (type) => {
                return () => {
                    const newExcludedDevices = type === "output"
                        ? this._settings?.getExcludedOutputDeviceNames()
                        : this._settings?.getExcludedInputDeviceNames();
                    if (!newExcludedDevices) {
                        return;
                    }
                    const devicesToShowIds = this.getDeviceIdsToShow(newExcludedDevices, type);
                    const devicesToHideIds = this.getDeviceIdsToHide(newExcludedDevices, type);
                    devicesToShowIds?.forEach((id) => this._audioPanel?.addDevice(id, type));
                    devicesToHideIds?.forEach((id) => this._audioPanel?.removeDevice(id, type));
                    if (type === "output") {
                        this._lastExcludedOutputDevices = newExcludedDevices ?? [];
                    }
                    else {
                        this._lastExcludedInputDevices = newExcludedDevices ?? [];
                    }
                };
            };
            this._inputSettingsSubscription = this._settings.connectToChanges(ExcludedInputNamesSetting, listenerFactory("input"));
            this._outputSettingsSubscription = this._settings.connectToChanges(ExcludedOutputNamesSetting, listenerFactory("output"));
        }
        getDeviceIdsToHide(newExcludedDevices, type) {
            const devicesToHide = newExcludedDevices.filter((current) => !(type === "output"
                ? this._lastExcludedOutputDevices
                : this._lastExcludedInputDevices).includes(current));
            return this._mixer
                ?.getAudioDevicesFromDisplayNames(devicesToHide, type)
                .filter((n) => n)
                .map((n) => n.id);
        }
        getDeviceIdsToShow(newExcludedDevices, type) {
            const devicesToShow = (type === "output"
                ? this._lastExcludedOutputDevices
                : this._lastExcludedInputDevices).filter((last) => !newExcludedDevices.includes(last));
            return this._mixer
                ?.getAudioDevicesFromDisplayNames(devicesToShow, type)
                .filter((n) => n)
                .map((n) => n.id);
        }
        setupDeviceChangesSubscription() {
            this._mixerSubscription =
                this._mixer?.subscribeToDeviceChanges((event) => {
                    this.updateAvailableDevicesInSettings(event);
                    if (event.type === "output-added") {
                        this.hideDeviceIfExcluded(event.deviceId, "output");
                    }
                    else if (event.type === "input-added") {
                        this.hideDeviceIfExcluded(event.deviceId, "input");
                    }
                }) ?? null;
        }
        hideDeviceIfExcluded(deviceId, type) {
            if (!this._mixer || !this._settings) {
                return;
            }
            const deviceName = this._mixer.getAudioDevicesFromIds([deviceId], type)[0]
                .displayName;
            const excludedDevices = type === "output"
                ? this._settings.getExcludedOutputDeviceNames()
                : this._settings.getExcludedInputDeviceNames();
            if (excludedDevices.includes(deviceName)) {
                delay(300).then(() => {
                    // delay due to potential race condition with Quick Setting panel's code
                    this._audioPanel?.removeDevice(deviceId, type);
                });
            }
        }
        setAvailableDevicesInSettings() {
            if (!this._audioPanel || !this._mixer || !this._settings) {
                return;
            }
            const allOutputIds = this._audioPanel.getDisplayedDeviceIds("output");
            const allOutputNames = this._mixer
                .getAudioDevicesFromIds(allOutputIds, "output")
                ?.map(({ displayName }) => displayName);
            if (allOutputNames) {
                this._settings.setAvailableOutputs(allOutputNames);
            }
            const allInputIds = this._audioPanel.getDisplayedDeviceIds("input");
            const allInputNames = this._mixer
                .getAudioDevicesFromIds(allInputIds, "input")
                ?.map(({ displayName }) => displayName);
            if (allInputNames) {
                this._settings.setAvailableInputs(allInputNames);
            }
        }
        updateAvailableDevicesInSettings(event) {
            if (!this._mixer || !this._settings) {
                return;
            }
            const deviceType = ["output-added", "output-removed"].includes(event.type)
                ? "output"
                : "input";
            const displayName = this._mixer.getAudioDevicesFromIds([event.deviceId], deviceType)[0].displayName;
            if (["output-added", "input-added"].includes(event.type)) {
                this._settings.addToAvailableDevices(displayName, deviceType);
            }
            else if (["output-removed", "input-removed"].includes(event.type)) {
                this._settings.removeFromAvailableDevices(displayName, deviceType);
            }
            else {
                log(`WARN: Received an unsupported MixerEvent: ${event.type}`);
            }
        }
        disable() {
            log(`Disabling extension ${this._uuid}`);
            if (this._mixerSubscription) {
                this._mixer?.unsubscribe(this._mixerSubscription);
            }
            this._mixer?.dispose();
            if (this._outputSettingsSubscription) {
                this._settings?.disconnect(this._outputSettingsSubscription);
                this._outputSettingsSubscription = null;
            }
            if (this._inputSettingsSubscription) {
                this._settings?.disconnect(this._inputSettingsSubscription);
                this._inputSettingsSubscription = null;
            }
            this.enableAllDevices();
            disposeDelayTimeouts();
            this._settings?.dispose();
            this._settings = null;
            this._audioPanel = null;
            this._lastExcludedOutputDevices = null;
            this._lastExcludedInputDevices = null;
            this._mixer = null;
            this._mixerSubscription = null;
        }
        enableAllDevices() {
            if (!this._settings || !this._mixer) {
                return;
            }
            const allOutputDevices = this._settings.getAvailableOutputs();
            const allInputDevices = this._settings.getAvailableInputs();
            this._mixer
                .getAudioDevicesFromDisplayNames(allOutputDevices, "output")
                .filter((n) => n)
                .map((n) => n.id)
                .forEach((id) => this._audioPanel?.addDevice(id, "output"));
            this._mixer
                .getAudioDevicesFromDisplayNames(allInputDevices, "input")
                .filter((n) => n)
                .map((n) => n.id)
                .forEach((id) => this._audioPanel?.addDevice(id, "input"));
        }
    }
    function extension (meta) {
        return new Extension(meta.uuid);
    }

    return extension;

})(imports.gi.GLib, imports.gi.Gvc);
