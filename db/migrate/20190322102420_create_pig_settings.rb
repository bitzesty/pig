class CreatePigSettings < ActiveRecord::Migration
  def change
    create_table :pig_settings do |t|
      t.text :google_optimize
    end
  end
end
