require_dependency 'mailer'
require_dependency 'issue'

    module IssueIdMethods
        def self.included(base)
            base.class_eval do
                unloadable
            end
        end

        def id
            if project_key.present?
                IssueID.new(super, project_key, issue_number)
            else
                super
            end
        end
    end

module IssueMailerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
            unloadable
        end
    end

    module ClassMethods

        def issue_add(issue, to_users, cc_users)
            issue = issue.clone()
            issue.extend(IssueIdMethods)
            super
        end

        def issue_edit(journal, to_users, cc_users)
            new_journal = journal.clone()
            issue = journal.journalized.clone()
            issue.issue_number = journal.journalized.issue_number
            issue.extend(IssueIdMethods)
            new_journal.journalized = issue
            journal = new_journal
            super
        end

    end


end
