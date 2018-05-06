require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
}

Shrine.plugin :activerecord # or :activerecord
Shrine.plugin :cached_attachment_data # for forms
# Shrine.plugin :rack_file # for non-Rails apps