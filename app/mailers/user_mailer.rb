# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def invite_user(user_invite)
    @invite = user_invite
    @team = @invite.team
    mail(to: @invite.email, subject: "MITRE CTF: Invite to join team #{@team.team_name}")
  end

  def user_request(user_request)
    @team = user_request.team
    @captain = @team.team_captain
    @user = user_request.user
    mail(to: @captain.email, subject: "MITRE CTF: Request from #{@user.full_name} to join #{@team.team_name}")
  end

  def competition_reminder(user)
    @user = user
    @game = Game.instance
    mail(to: @user.email, subject: 'MITRE CTF: Competition Reminder')
  end

  # Assumes user is on a team
  def ranking(user)
    @user = user
    @div = user.team.division
    @rank = 1 + (@div.ordered_teams.index user.team)
    mail(to: @user.email, subject: 'MITRE CTF: Competition Ranking')
  end

  # Assumes user is in top ten
  def resume(user)
    @user = user
    @first = user.team.division.ordered_teams[0].eql? user.team
    @end_time = Game.instance.stop + 2.weeks
    mail(to: @user.email, subject: 'MITRE CTF: Resume Request')
  end
end
