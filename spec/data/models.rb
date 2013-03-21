class Topic < ActiveRecord::Base
  has_many :replies, :dependent => :destroy, :foreign_key => "parent_id"
  translates :title, :content
end

class Reply < Topic
  belongs_to :topic, :foreign_key => "parent_id"
end

class Untranslated < ActiveRecord::Base
end

