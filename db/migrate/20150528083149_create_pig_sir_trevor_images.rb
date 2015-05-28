class CreatePigSirTrevorImages < ActiveRecord::Migration

  def change
    create_table :pig_sir_trevor_images do |t|
      t.text :image_uid
      t.text    :sir_trevor_uid
      t.text    :filename
      t.belongs_to :content_package
    end
  end

end
