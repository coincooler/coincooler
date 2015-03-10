namespace :db do
	desc "clear stale uploaded files"
	task clean: :environment do 
		clear_uploads
	end

	def clear_uploads
		Upload.delete_all
	end
end

namespace :cache do
  desc "Expire the pk cache fragment"
  task :clear_pk => :environment do
    ActionController::Base.new.expire_fragment('pk')
    Rails.logger.info("pk cache swept")
  end
end

namespace :clear do
  # desc "Clears all files and directories in files/cache"
  task :uploads do
    FileUtils.rm_rf(Dir['files/uploads/[^.]*'])
  end
  task cold_files: :environment do 
		include PathHelper		
		FileUtils.rm_rf(Dir["#{coldstorage_directory}/**/*.csv*"])
    Rails.logger.info("cold files cleaned up")
   	# FileUtils.rm_rf(Dir["#{public_directory_path}*.csv*"])
  	# FileUtils.rm_rf(Dir["#{private_directory_path}*.csv*"])
  	# FileUtils.rm_rf(Dir["#{encrypted_directory_path}*.csv*"])
  	# FileUtils.rm_rf(Dir["#{unencrypted_directory_path}*.csv*"])
  end  
end