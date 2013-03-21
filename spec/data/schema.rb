ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do

  create_table :untranslateds, :force => true do |t|
    t.string :name
    t.text :content
  end

  create_table :topics, :force => true do |t|
    t.integer  :parent_id
    t.timestamps
  end

  create_table :topic_translations, :force => true do |t|
    t.string     :locale
    t.references :topic
    t.string     :title
    t.text       :content
  end

end
