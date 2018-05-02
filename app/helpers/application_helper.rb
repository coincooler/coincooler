module ApplicationHelper
  def self.osx?
    /darwin/ =~ RUBY_PLATFORM
  end

  def self.pi?
    return false if osx?
    test = `cat /etc/rpi-issue` =~ /Raspberry Pi/ || `cat /etc/os-release` =~ /Raspbian/
    !test&.negative?
  end
end
