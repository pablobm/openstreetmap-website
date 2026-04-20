# frozen_string_literal: true

require "factory_bot_rails"

class UserMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Wraps the preview in a transaction, so that no changes
  # are persisted to the development db
  def self.call(...)
    preview = nil
    ActiveRecord::Base.transaction do
      preview = super(...)
      raise ActiveRecord::Rollback
    end
    preview
  end

  def signup_confirm
    user = create(:user, :languages => [I18n.locale])
    token = "token-123456"
    referer = "the-referer"

    UserMailer.with(:user => user, :token => token, :referer => referer).signup_confirm
  end

  def email_confirm
    user = create(:user, :languages => [I18n.locale], :new_email => "newemail@example.com")
    token = "token-123456"
    UserMailer.with(:user => user, :token => token).email_confirm
  end

  def lost_password
    user = create(:user, :languages => [I18n.locale])
    token = "token-123456"
    UserMailer.with(:user => user, :token => token).lost_password
  end

  def gpx_success
    user = create(:user, :languages => [I18n.locale])
    trace = create(:trace, :user => user, :tags => build_list(:tracetag, 2))
    UserMailer.with(:record => trace, :possible_points => trace.size + 2, :recipient => trace.user).gpx_success
  end

  def gpx_failure
    user = create(:user, :languages => [I18n.locale])
    trace = build(:trace, :user => user, :tags => build_list(:tracetag, 2))
    error = begin
      LibXML::XML::Parser.string("<gpx>").parse
    rescue LibXML::XML::Error => e
      e.message
    end
    UserMailer.with(
      :trace_name => trace.name,
      :trace_description => trace.description,
      :trace_tags => trace.tags.map(&:tag),
      :error => error,
      :recipient => trace.user
    ).gpx_failure
  end

  def message_notification
    recipient = create(:user, :languages => [I18n.locale])
    message = create(:message, :recipient => recipient)
    UserMailer.with(:record => message, :recipient => recipient).message_notification
  end

  def diary_comment_notification
    recipient = create(:user, :languages => [I18n.locale])
    diary_entry = create(:diary_entry)
    diary_comment = create(:diary_comment, :diary_entry => diary_entry)
    UserMailer.with(:record => diary_comment, :recipient => recipient).diary_comment_notification
  end

  def follow_notification
    following = create(:user, :languages => [I18n.locale])
    follow = create(:follow, :following => following)
    UserMailer.with(:record => follow, :recipient => following).follow_notification
  end

  def note_comment_notification
    recipient = create(:user, :languages => [I18n.locale])
    commenter = create(:user)
    comment = create(:note_comment, :author => commenter)
    UserMailer.with(:record => comment, :recipient => recipient).note_comment_notification
  end

  def changeset_comment_notification
    recipient = create(:user, :languages => [I18n.locale])

    changeset_description_text = <<~TEXT
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vel vehicula leo. In felis metus, faucibus quis iaculis at, pulvinar ac lacus.Morbi mollis mattis lacus, eu ultricies libero fermentum eget.
    TEXT
    changeset_description_tag = create(:changeset_tag, :k => "comment", :v => changeset_description_text)

    comment_text = <<~TEXT
      Sed ut est laoreet leo blandit vestibulum ut in lorem. Pellentesque ut turpis pellentesque, tincidunt ipsum non, iaculis quam. Maecenas varius, lorem et maximus bibendum, lacus urna pharetra arcu, eget vestibulum sapien massa eget augue.

      Aenean maximus mollis diam, sit amet sodales ipsum ultrices sed. Duis quis sapien mattis, commodo eros eget, condimentum sapien. Donec cursus risus id diam facilisis venenatis. Duis hendrerit eget massa non dictum. Vivamus sed purus sit amet neque laoreet gravida. Integer mi mauris, dictum rutrum lorem at, euismod placerat eros. Duis lorem odio, porta vitae vestibulum ut, faucibus eget quam. Proin feugiat dui vel lacus tristique rutrum.

      Nulla eu tellus in nunc vehicula vehicula at at erat.
    TEXT
    comment = create(:changeset_comment, :changeset => changeset_description_tag.changeset, :body => comment_text)

    UserMailer.with(:record => comment, :recipient => recipient).changeset_comment_notification
  end
end
