class CreateBenkyoukais < ActiveRecord::Migration
  def change
    create_table :benkyoukais do |t|
      t.string :prefecture
      t.string :site
      t.text :ics
      t.string :title
      t.string :source_url

      t.timestamps
    end
    add_index :benkyoukais, [:title, :site], name: :index_bankyoukais
    add_index :benkyoukais, :prefecture
  end
end
