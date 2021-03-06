# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    transient do
      additional_member_count { 0 }
      compete_for_prizes { false }
    end
    team_name { Faker::Team.unique.name }
    affiliation { Faker::Educator.university }
    division { Game.instance.divisions.first }

    after(:build) do |team, evaluator|
      team.team_captain = create(:user, compete_for_prizes: evaluator.compete_for_prizes) unless team.team_captain
    end

    after(:create) do |team, evaluator|
      evaluator.additional_member_count.times do
        team.users << create(:user)
      end
    end

    factory :team_in_top_ten_standard_challenges do
      after(:create) do |team|
        create(:standard_solved_challenge, team: team)
      end
    end

    factory :team_with_pentest_flags do
      after(:create) do |team|
        PentestChallenge.all.each do |challenge|
          create(:defense_flag, team: team, challenge: challenge)
        end
      end
    end

    factory :team_in_top_ten_pentest_challenges do
      after(:create) do |team|
        create(:pentest_solved_challenge, team: team)
      end
    end
  end
end
