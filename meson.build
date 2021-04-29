project(
  'com.paysonwallach.duplicate-plugin',
  'vala',
  'c',
  meson_version : '>= 0.46',
  version: '0.1.0'
)

vala = meson.get_compiler('vala')

prefix = get_option('prefix')
lib_dir = get_option('libdir')
files_plugin_dir = join_paths(prefix, lib_dir, 'io.elementary.files', 'plugins')

gee_dep = dependency('gee-0.8')
glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
granite_dep = dependency('granite')
gtk_dep = dependency('gtk+-3.0')
pantheon_files_core_dep = dependency('pantheon-files-core')
posix_dep = vala.find_library('posix')

add_project_arguments([
    '-DG_LOG_DOMAIN="@0@"'.format(meson.project_name()),
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
  ],
  language:'c'
)

subdir('data')
subdir('src')
