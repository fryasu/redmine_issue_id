require 'redmine'

require_dependency 'issue_id_hook'
require_dependency 'issue_mailer_patch'

Rails.logger.info 'Starting ISSUE-id Plugin for Redmine'

issue_query = (IssueQuery rescue Query)

issue_query.add_available_column(QueryColumn.new(:legacy_id,
                                                 :sortable => "#{Issue.table_name}.id",
                                                 :caption => :label_legacy_id))

Rails.configuration.to_prepare do
    unless ApplicationHelper.included_modules.include?(IssueApplicationHelperPatch)
        ApplicationHelper.send(:include, IssueApplicationHelperPatch)
    end
    unless IssuesController.included_modules.include?(IssueIdsControllerPatch)
        IssuesController.send(:include, IssueIdsControllerPatch)
    end
    unless IssueRelationsController.included_modules.include?(IssueIdsRelationsControllerPatch)
        IssueRelationsController.send(:include, IssueIdsRelationsControllerPatch)
    end
    unless PreviewsController.included_modules.include?(IssueIdsPreviewsControllerPatch)
        PreviewsController.send(:include, IssueIdsPreviewsControllerPatch)
    end
    unless AutoCompletesController.included_modules.include?(IssueAutoCompletesControllerPatch)
        AutoCompletesController.send(:include, IssueAutoCompletesControllerPatch)
    end
    unless IssuesHelper.included_modules.include?(IssueIdsHelperPatch)
        IssuesHelper.send(:include, IssueIdsHelperPatch)
    end
    if defined?(IssueQuery)
        unless QueriesHelper.included_modules.include?(IssueQueriesHelperPatch)
            QueriesHelper.send(:include, IssueQueriesHelperPatch)
        end
        unless IssueQuery.included_modules.include?(IssueQueryPatch)
            IssueQuery.send(:include, IssueQueryPatch)
        end
    else
        unless Query.included_modules.include?(IssueQueryPatch)
            Query.send(:include, IssueQueryPatch)
        end
    end
    unless Project.included_modules.include?(IssueProjectPatch)
        Project.send(:include, IssueProjectPatch)
    end
    unless Issue.included_modules.include?(IssueIdPatch)
        Issue.send(:include, IssueIdPatch)
    end
    unless Changeset.included_modules.include?(IssueChangesetPatch)
        Changeset.send(:include, IssueChangesetPatch)
    end
    unless Mailer.included_modules.include?(IssueMailerPatch)
        Mailer.send(:include, IssueMailerPatch)
    end

    Issue.event_options[:title] = Proc.new do |issue|
        "#{issue.tracker.name} ##{issue.to_param} (#{issue.status}): #{issue.subject}"
    end
    Issue.event_options[:url] = Proc.new do |issue|
        { :controller => 'issues', :action => 'show', :id => issue }
    end

    Journal.event_options[:title] = Proc.new do |journal|
        status = ((new_status = journal.new_status) ? " (#{new_status})" : nil)
        "#{journal.issue.tracker} ##{journal.issue.to_param}#{status}: #{journal.issue.subject}"
    end
    Journal.event_options[:url] = Proc.new do |journal|
        { :controller => 'issues', :action => 'show', :id => journal.issue, :anchor => "change-#{journal.id}" }
    end
end

Redmine::Plugin.register :redmine_issue_id do
    name 'Redmine ISSUE-id'
    author 'fryasu'
    author_url 'https://github.com/fryasu/'
    description 'Adds support for issue ids in format: CODE-number. This is the fork of original Andriy Lesyuk\'s'
    url 'https://github.com/fryasu/redmine_issue_id'
    version '0.1.0'

    settings :default => {
        :issue_key_sharing => false
    }, :partial => 'settings/issue_id'
end
