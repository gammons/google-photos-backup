require "sqlite3"
require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "photos.db"
)

class DB
  def create!
    ActiveRecord::Schema.define do
      create_table :photos, force: true do |t|
        t.string :photo_id
        t.timestamps
        t.index :photo_id

      end
    end
  end
end
