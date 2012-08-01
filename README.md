Basically this is a rails app (requires sidekiq, redis, etc) that enumerates LDAP groups and lists users that inherit permissions from them. Uses searching to perform this goal.

one thing to note: in the mailer, you _NEED_ to change the URL from http://localhost:3000 to something real. localhost:3000 works for development only. localhost will probably work fine for production, though. Only needs to be accessible from the server.
