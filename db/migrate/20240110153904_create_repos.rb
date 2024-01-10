class CreateRepos < ActiveRecord::Migration[7.1]
  def change
    create_table :repos do |t|
      t.belongs_to :github_user
      t.string :name
      t.integer :stars
      t.string :language

      t.timestamps
    end
  end
end
