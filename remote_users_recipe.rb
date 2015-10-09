require "./login_users"

$USERS.each do |u, p|
  user u do
    action :create
    password p
  end

  SSH_KEY = %x(sudo cat "/home/#{u}/.ssh/id_rsa.pub")

  directory "/home/#{u}/.ssh" do
    user u
    owner u
    group u
    mode "700"
  end

  file "/home/#{u}/.ssh/authorized_keys" do
    content SSH_KEY
    owner u
    group u
    mode "600"
  end

  execute "add user to wheel group" do
    command "usermod -G wheel #{u}"
    not_if "groups #{u} | grep 'wheel'"
  end
end
