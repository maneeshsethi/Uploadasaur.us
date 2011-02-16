class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.column :title, :string
      t.column :ufile_file_name, :string
      t.column :ufile_content_type, :string
      t.column :ufile_file_size, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
