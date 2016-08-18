# Umm..., url_helper function can't be overwritten since rail 4.x ...
# Please see add_route() method in actionpack-4.x.x/lib/action_dispatch/routing/route_set.rb.
#
# You should delete the following default 'quoted_issue' routing configuration in
# redmine-3.x.x/config/routes.rb:
#       -----------
#       match '/issues/:id/quoted', :to => 'journals#new', :id => /\d+/, :via => :post, :as => 'quoted_issue'
#       -----------
Rails.application.routes.draw do 

    match '/issues/:id', :to => 'journals#new', :id => %r{(?:[A-Z0-9]+-)?[0-9]+}i, :via => :post, :as => 'quoted_issue'
end
