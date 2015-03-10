module CacheHelper
	
	def clear_cache(fragment_name='')
		if fragment_name.blank?
			Rails.cache.clear
		else
			expire_fragment(fragment_name)			
		end
	end

	def clear_pk
		clear_cache('pk')
	end

end