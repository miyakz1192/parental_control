class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :mac
      t.string :status

      t.timestamps
    end
  end
end
