'use strict';
const {Adw, Gio, GLib, GObject} = imports.gi;
const ExtensionUtils = imports.misc.extensionUtils;
const Me = ExtensionUtils.getCurrentExtension();

const gettextDomain = Me.metadata['gettext-domain'];
const Gettext = imports.gettext.domain(gettextDomain);
const _ = Gettext.gettext;

var About = GObject.registerClass({
    GTypeName: 'BBM_About',
    Template: `file://${GLib.build_filenamev([Me.path, 'ui', 'about.ui'])}`,
    InternalChildren: [
        'stack',
        'extension_icon_image',
        'extension_name_label',
        'developer_name_label',
        'extension_version',
        'license_content',
        'copyright_content',
        'row_readme',
        'row_bug_report',
        'row_translation',
        'row_sources',
        'row_license',
        'row_crowdin',
        'row_translation_guide',
        'button_back_translation',
        'button_back_legal',
        'box_legal',
        'box_translation',
        'label_translation',
        'label_legal',
    ],
}, class About extends Adw.PreferencesPage {
    constructor(extensionObject) {
        super({});

        const extensionIcon = 'bbm-logo';
        const developerName = 'maniacx@github.com';
        const copyrightYear = '2024';
        const licenseName = _('GNU General Public License, version 3 or later');
        const licenseLink = 'https://www.gnu.org/licenses/gpl-3.0.html';

        this._extension_icon_image.icon_name = extensionIcon;
        this._extension_name_label.label = extensionObject.metadata.name;
        this._extension_version.label = extensionObject.metadata.version.toString();
        this._developer_name_label.label = developerName;
        this._copyright_content.label = _('© %s %s').format(copyrightYear, developerName);
        this._license_content.label = _('This application comes with absolutely no warranty. See the <a href="%s">%s</a> for details.').format(licenseLink, licenseName);

        this._linkPage('activated', this._row_translation, 'page_translation');
        this._linkPage('activated', this._row_license, 'page_legal');
        this._linkPage('clicked', this._button_back_translation, 'page_main');
        this._linkPage('clicked', this._button_back_legal, 'page_main');

        this._assignURL(this._row_readme, 'https://maniacx.github.io/Bluetooth-Battery-Meter');
        this._assignURL(this._row_bug_report, 'https://github.com/maniacx/Bluetooth-Battery-Meter/issues');
        this._assignURL(this._row_sources, 'https://github.com/maniacx/Bluetooth-Battery-Meter/');
        this._assignURL(this._row_crowdin, 'https://crowdin.com/project/bluetooth-battery-meter');
        this._assignURL(this._row_translation_guide, 'https://maniacx.github.io/Bluetooth-Battery-Meter/translation');
    }

    _linkPage(signal, widget, page) {
        widget.connect(signal, () => {
            this._stack.set_visible_child_name(page);
        });
    }

    _assignURL(row, link) {
        row.set_tooltip_text(link);
        row.connect('activated', () => {
            Gio.AppInfo.launch_default_for_uri_async(link, null, null, null);
        });
    }
});
