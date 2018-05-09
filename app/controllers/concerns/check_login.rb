def require_login
  if current_user.nil?
    redirect_to root_path
  end
end