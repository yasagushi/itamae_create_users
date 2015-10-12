require "./login_users"

$USERS.each do |u, p|
  salt = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(2).join
  execute "create users" do
    command "sudo useradd #{u} -p `perl -e \"print(crypt(#{p}, salt));\"`"
    not_if "grep #{u} /etc/passwd"
  end

  execute "create user_key" do
    command "sudo su - #{u} -c \"ssh-keygen -t rsa -N #{p} -f /home/#{u}/.ssh/id_rsa\""
    not_if "sudo test -e /home/#{u}/.ssh/id_rsa.pub"
  end
end
