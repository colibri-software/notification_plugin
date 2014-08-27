require 'spec_helper'

module HbirdNotification
  describe HbirdNotification do
    describe 'Content Entry patching' do
      before :each do
        @type = FactoryGirl.build(:content_type)
        @type.entries_custom_fields.build(label: 'name', type: 'string')
        @type.save
        @site = @type.site
        Locomotive::Plugins.use_site(@site)
      end
      it 'should run the notification callback' do
        Locomotive::ContentEntry.any_instance.expects(:notification_callback).times(4)
        entry = @type.entries.create(name: 'Thing') #2 callbacks, :create and :save
        entry.save
        entry.destroy
      end
      describe 'on a disabled plugin' do
        it 'should not continue if the plugin is not enabled' do
          Config.expects(:hash).never
          entry = @type.entries.create(name: 'Thing') #2 callbacks, :create and :save
        end
      end
      describe 'on an enabled plugin' do
        before :each do
          @data = FactoryGirl.create(:plugin_data,
            :plugin_id => 'hbird_notification',
            :enabled => true,
            :site => @site)
        end
        it 'should not continue if the mail script is nil' do
          HbirdNotification.any_instance.expects(:js3_context).never
          entry = @type.entries.create(name: 'Thing') #2 callbacks, :create and :save
        end
        it 'should setup the context and evaluate the script' do
          @data.config = {
            mail_generation_script: "Script"
          }
          @data.save
          entry = @type.entries.build(name: 'Thing')
          context = mock()
          HbirdNotification.any_instance.expects(:js3_context).returns(context).twice
          context.expects(:[]=).with('document', entry.as_document).twice
          context.expects(:[]=).with('content_type', entry.content_type).twice
          context.expects(:[]=).with('action', 'save')
          context.expects(:[]=).with('action', 'create')
          context.expects(:[]=).with('email_user', instance_of(Proc)).twice
          context.expects(:eval).with("Script").twice
          entry.save
        end
        it 'should be able to notify a user from javascript' do
          @data.config = {
            mail_generation_script: "email_user('user@example.com', 'Subject', 'Body')"
          }
          @data.save
          mailer = mock()
          mailer.expects(:deliver).twice
          NotificationMailer.expects(:notify_user).with('user@example.com',
            'Subject', 'Body').returns(mailer).twice
          entry = @type.entries.create(name: 'Thing')
        end
      end
    end

    it 'should provide a tempalte file' do
      plugin = HbirdNotification.new()
      plugin.config_template_file.should_not be nil
    end

    it 'should set the config after setup' do
      plugin = HbirdNotification.new()
      plugin.config = {a: "a", b: "b"}
      plugin.run_callbacks(:plugin_setup)
      Config.hash[:a].should eq "a"
      Config.hash[:b].should eq "b"
    end
  end
end
