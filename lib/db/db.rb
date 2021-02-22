require "sqlite3"
require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/photos.db",
  pool: 50
)

class DB
  def create!
    ActiveRecord::Schema.define do
      create_table :media_items, force: true do |t|
        t.string :photo_id
        t.string :url
        t.string :mime_type
        t.string :created_at
        t.integer :width
        t.integer :height

        t.index :photo_id
      end
    end
  end
end
