# coding: utf-8
require 'spec_helper'

describe 'ActiveRecord::Validations::GlobalizedUniquenessValidator' do

  before(:each) do
    [Untranslated, Topic, Reply].each do |k|
      k.reset_callbacks(:validate)
    end
  end

  it "should validate uniqueness on an untranslated model" do
    Untranslated.validates_uniqueness_of(:name)

    u = Untranslated.new("name" => "I'm uniqué!")
    u.save.should be_true

    u.content = "Remaining unique"
    u.save.should be_true

    u2 = Untranslated.new("name" => "I'm uniqué!")
    u2.valid?.should be_false
    u2.errors[:name].should == ["has already been taken"]
    u2.save.should be_false

    u2.name = "Now Im really also unique"
    u2.save.should be_true
  end

  # FIXME This test fails with the uniqueness validator patch used by globalize 4 (tested with 4.0.2)
  #       Reason: the way the patch is built, uniqueness is ALWAYS scoped by :locale.
  it "should validate uniqueness" do
    Topic.validates_uniqueness_of(:title)
    title = "I'm uniqué!"

    t = Topic.new("title" => title)
    t.save.should be_true

    t.content = "Remaining unique"
    t.save.should be_true

    t2 = Topic.new("title" => title)
    t2.valid?.should be_false
    t2.errors[:title].should == ["has already been taken"]
    t2.save.should be_false

    Globalize.with_locale(:de) do
      t2.title = title
      t2.valid?.should be_false
      t2.errors[:title].should == ["has already been taken"]
      t2.save.should be_false
    end

    t2.title = "Now Im really also unique"
    t2.save.should be_true
  end

  it "should validate uniqueness with :locale scope" do
    Topic.validates_uniqueness_of(:title)
    title = "I'm uniqué!"

    t = Topic.new("title" => title)
    t.save.should be_true

    t.content = "Remaining unique"
    t.save.should be_true

    t2 = Topic.new("title" => title)
    t2.valid?.should be_false
    t2.errors[:title].should == ["has already been taken"]
    t2.save.should be_false

    Globalize.with_locale(:de) do
      t2.title = title
      t2.valid?.should be_true
      t2.save.should be_true

      t3 = Topic.new("title" => title)
      t3.valid?.should be_false
      t3.errors[:title].should == ["has already been taken"]
    end

    t2.title = "Now Im really also unique"
    t2.save.should be_true
  end

  it "should validate uniqueness with validates" do
    Topic.validates :title, :uniqueness => true
    Topic.create!('title' => 'abc')

    t2 = Topic.new('title' => 'abc')
    t2.valid?.should be_false
    t2.errors[:title].should be_true
  end

  it "should validate uniqueness with multiple translated attributes in scope" do
    Topic.validates_uniqueness_of(:content, :scope => [:title])
    title = "I'm uniqué!"
    content = "hello world"

    t = Topic.new("title" => title, :content => content)
    t.save.should be_true

    t2 = Topic.new("title" => title, :content => content)
    t2.valid?.should be_false
    t2.errors[:content].should == ["has already been taken"]
    t2.save.should be_false

    Globalize.with_locale(:de) do
      t2.title = title
      t2.content = content
      t2.valid?.should be_true
      t2.save.should be_true

      t3 = Topic.new("title" => title, "content" => content)
      t3.valid?.should be_false
      t3.errors[:content].should == ["has already been taken"]
    end

    t2.title = "Now Im really also unique"
    t2.content = content
    t2.save.should be_true

    Topic.new("title" => title, :content => "foo").save.should be_true
  end

  it "should validate uniqueness with both translated and untranslated attributes in scope" do
    Reply.validates_uniqueness_of(:content, :scope => ["parent_id"])
    content = "hello world"

    t = Topic.create("title" => "I'm unique!")

    r1 = t.replies.create "title" => "r1", "content" => content
    r1.valid?.should be_true

    r2 = t.replies.create "title" => "r2", "content" => content
    r2.valid?.should be_false

    Globalize.with_locale(:de) do
      r2.content = content
      r2.save.should be_true
    end

    r2.content = "something else"
    r2.save.should be_true

    t2 = Topic.create("title" => "I'm unique too!")
    r3 = t2.replies.create "title" => "r3", "content" => content
    r3.valid?.should be_true
  end

  it "should validate case sensitive uniqueness" do
    Topic.validates_uniqueness_of(:title, :case_sensitive => true, :allow_nil => true)

    t = Topic.new("title" => "I'm unique!")
    t.save.should be_true

    t.content = "Remaining unique"
    t.save.should be_true

    t2 = Topic.new("title" => "I'M UNIQUE!")
    t2.valid?.should be_true
    t2.save.should be_true

    t3 = Topic.new("title" => "I'M uNiQUe!")
    t3.valid?.should be_true
    t3.save.should be_true

    t4 = Topic.new("title" => "I'M uNiQUe!")
    t4.valid?.should be_false
    t4.save.should be_false
    t4.errors[:title].should == ["has already been taken"]
  end

  it "should validate case insensitive uniqueness" do
    Topic.validates_uniqueness_of(:title, :case_sensitive => false, :allow_nil => true)

    t = Topic.new("title" => "I'm unique!")
    t.save.should be_true

    t2 = Topic.new("title" => "I'M UNIQUE!")
    t2.valid?.should be_false
    t2.save.should be_false
    t2.errors[:title].should == ["has already been taken"]
  end

  it "should validate uniqueness with a translated serialized attribute"

end