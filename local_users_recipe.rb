require "./login_users"

$USERS.each do |u, p|
  user u do
    action :create
    password p
  end

  execute "create user_key" do
    command "sudo su - #{u} -c \"ssh-keygen -t rsa -N #{p} -f ~/.ssh/id_rsa\""
    not_if "test -e /home/#{u}/.ssh/id_rsa.pub"
  end
end
