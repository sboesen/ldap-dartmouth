Basically this is a rails app (requires sidekiq, redis, etc) that enumerates LDAP groups and lists users that inherit permissions from them. Uses searching to perform this goal.

one thing to note: in the mailer, you _NEED_ to change the URL from http://localhost:3000 to something real. localhost:3000 works for development only. localhost will probably work fine for production, though. Only needs to be accessible from the server.


For cron jobs:

All cron jobs are triggered through the URL. This is relatively quick because they all pass the jobs to sidekiq asynchronously. 

An example:

    */10 * * * * /usr/bin/curl -q -O update_groups.log http://localhost/cron/update_groups

    Update groups is cron/update_groups.
    Search and email is cron/search_and_email/SEARCH_NAME - NOTE: if a search does not have a name, you can't send an email for it. The name is used as an identifier, but it's optional for searches that you don't plan on emailing.


