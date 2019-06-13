defmodule WmDevForum.UserManagement do
  alias WmDevForum.UserManagementQueries

  def create_user(params) do
    UserManagementQueries.create_user(params)
  end

  def login_user(user_name, password) do
    user_uuid = UserManagementQueries.check_if_user_is_authentic(user_name, password)

    if user_uuid == "" || user_uuid == nil do
      False
    else
      True
    end
  end
end
