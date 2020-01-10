require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  include ChallengesHelper

  def setup
    create(:active_game)
    @challenge = create(:challenge, flag_count: 3)
  end

  test 'should get show' do
    sign_in create(:user_with_team)
    get :show, params: {
      id: @challenge
    }
    assert_response :success
  end

  test "submit any of the correct flags when on a team" do
    @user = create(:user_with_team)
    sign_in @user
    assert_difference 'SubmittedFlag.count', +1 do
      put :update, params: {
        id: @challenge,
        challenge: {
          submitted_flag: @challenge.flags.sample.flag
        }
      }
    end
    assert :success
    assert_equal flash[:notice], I18n.t('flag.accepted')
  end

  test 'submit incorrect flag when on team' do
    sign_in create(:user_with_team)
    assert_difference 'SubmittedFlag.count', +1 do
      put :update, params: {
        id: create(:challenge),
        challenge: {
          submitted_flag: "wrong"
        }
      }
    end
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no team' do
    sign_in create(:user)
    @challenge = create(:challenge)
    put :update, params: {
      id: @challenge,
      challenge: {
        submitted_flag: @challenge.flags.sample.flag
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no flag' do
    assert_no_difference 'SubmittedFlag.count' do
      sign_in create(:user_with_team)
      put :update, params: {
        id: create(:challenge)
      }
    end
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  test 'can not submit flag with no user' do
    put :update, params: {
      id: @challenge,
      challenge: {
        submitted_flag: @challenge.flags.sample.flag
      }
    }
    assert :success
    assert true, wrong_flag_messages.include?(flash[:notice])
  end

  # Private methods
  test 'should get find_challenge' do
  end

  test 'should find and log flag' do
  end
end
