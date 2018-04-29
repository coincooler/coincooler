module ApplicationHelper
  def osx?
    /darwin/ =~ RUBY_PLATFORM
  end
end
