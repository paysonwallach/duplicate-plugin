/*
 * Copyright (c) 2021 Payson Wallach
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

namespace Marlin.Plugins {
    private class DuplicateMenuItem : Gtk.MenuItem {
        private unowned List<File> files;

        public DuplicateMenuItem (List<File> files) {
            this.files = files;
            this.label = "Duplicate";
        }

        private File get_duplicate_destination (File parent, string basename, int count = 1, int max_name_length = -2) {
            if (max_name_length == -2)
                max_name_length = PF.FileUtils.get_max_name_length (parent);

            var destination = File.new_build_filename (
                parent.get_path (),
                PF.FileUtils.get_duplicate_name (basename, count, max_name_length));

            if (destination.query_exists ())
                return get_duplicate_destination (parent, basename, ++count, max_name_length);
            else
                return destination;
        }

        public override void activate () {
            foreach (var file in files)
                file.copy (
                    get_duplicate_destination (
                        file.get_parent (), file.get_basename ()),
                    FileCopyFlags.NONE);
        }

    }

    public class Duplicate : Base {
        public override void context_menu (Gtk.Widget widget, List<GOF.File> gof_files) {
            if (gof_files == null)
                return;

            var files = new List<File>();
            foreach (unowned GOF.File file in gof_files)
                if (file.location != null)
                    if (file.location.get_uri_scheme () == "recent")
                        files.append (GLib.File.new_for_uri (file.get_display_target_uri ()));
                    else
                        files.append (file.location);

            var menu = widget as Gtk.Menu;
            var menu_item = new DuplicateMenuItem (files);

            plugins.menuitem_references.add (menu_item);
            menu.append (menu_item);
            menu.reorder_child (menu_item, (int) menu.get_children ().length () - 3);
            menu_item.show ();
        }

    }

}

public Marlin.Plugins.Base module_init () {
    return new Marlin.Plugins.Duplicate ();
}
