module Paperclip
    module Interpolations
        def session_id attachment, style_name
            66666.to_s
        end
    end

  class HasAttachedFile

    private

    def add_required_validations
      name = @name
      # @klass.validates_media_type_spoof_detection name, :if => ->{ send(name).dirty? }
    end
	end

end