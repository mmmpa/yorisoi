class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :text
      t.string :password
      t.string :textarea
      t.string :select
      t.string :radio
      t.string :checkbox

      t.timestamps null: false
    end
  end
end
