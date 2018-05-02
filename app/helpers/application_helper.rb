module ApplicationHelper
  def self.osx?
    /darwin/ =~ RUBY_PLATFORM
  end

  def self.pi?
    begin
      system("cat /etc/rpi-issue", err: File::NULL) =~ /Raspberry Pi/ ||
      system("cat /etc/os-release", err: File::NULL) =~ /Raspbian/ ? true : false
    rescue => e
      Rails.logger.debug "got #{e.message} when tried to check if PI"
      false
    end
  end
end
