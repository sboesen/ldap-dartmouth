class CronController < ApplicationController
  #I know this is bad practice; cron isn't rails-like, though, so not much I can do to improve.
  
  def update_groups
    LdapGroupWorker.perform_async('fetch_groups')
  end
  def search_and_email
    search_name = params[:search_name]
    return if search_name.blank?
    search = Search.find_by_name(search_name)
    #TODO email task
    search.run!
    done = false
    totalslept = 0
    while !done && totalslept < 20
      sleep(2)
      totalslept += 2
      done = search.reload.finished?
    end
    MailWorker.perform_async(search.id)
  end
end
