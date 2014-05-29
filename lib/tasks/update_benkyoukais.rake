desc "This task is called by the Heroku cron add-on"

task :update_benkyoukais => :environment do
  Benkyoukai.update_all
end
