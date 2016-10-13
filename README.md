# issue-id
This is the fork of Andriy Lesyuk's issue-id Redmine plugin.
Original project is hosted at http://projects.andriylesyuk.com/project/redmine/issue-id

In addtion, this issue-id is base on anothr fork of Jett's issue-id plugin.
Also Jett's project is hostd at github https://github.com/jett/issue-id

This plugin was tested with only Redmine 3.3 and Rails 4.2.6.

HOW TO INSTALLATION
====================
STEP1. Installs this plugin to plugins/redmine_issue_id.

STEP2. Please modify "config/routes" of the original redmine.

       $ vi redmine/config/routes
         --------------------------
         match '/issues/:id/quoted', :to => 'journals#new', :id => /\d+/, :via => :post, :as => 'quoted_issue'
         --------------------------
             |
             V
         --------------------------
         #NOTE: commentd out for redmine issue-id plugin.
         #match '/issues/:id/quoted', :to => 'journals#new', :id => /\d+/, :via => :post, :as => 'quoted_issue'
         --------------------------

STEP3. Corrects the issue edit page title of the original redmine.

       $ vi app/views/issues/edit.html.erb
         --------------------------
         <h2><%= "#{@issue.tracker_was} ##{@issue.id}" %></h2>
         --------------------------
             |
             V
         --------------------------
         <h2><%= issue_heading(@issue) %></h2>
         --------------------------

       NOTE: this may be redmine bug, because another issues/edit.html.erb
             is correct.

STEP4. Migrates the DB

       $ RAILS_ENV=production NAME=redmine_issue_id rake redmine:plugins:migrate
