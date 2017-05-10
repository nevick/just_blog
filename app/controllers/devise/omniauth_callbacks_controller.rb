class Devise::OmniauthCallbacksController < DeviseController

  def facebook
    create_provider_session
  end

  def vkontakte
    create_provider_session
  end

  def create_provider_session
    @user = User.from_omniauth(auth_hash)
    @user.name = user_info[:name]
    @user.first_name = user_info[:first_name]
    @user.last_name = user_info[:last_name]
    @user.avatar = user_info[:image]

    redirect_to root_path, notice: "Welcome from #{auth_hash[:provider]}! You have signed up successfully."
    sign_in(@user)
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def user_info
    auth_hash[:info]
  end

  def failure
    redirect_to root_path, notice: 'Bad authentication, try again'
  end
end