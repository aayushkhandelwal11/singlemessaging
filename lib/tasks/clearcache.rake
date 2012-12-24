desc "Deleting old cache"
task :clear_cache  do
   Rake::Task["cache:clear"].execute
end 
