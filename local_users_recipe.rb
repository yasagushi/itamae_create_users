node['users'].length.times do |i|
  salt = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(2).join
  user_name = node['users'][i]['user_name']
  user_password = node['users'][i]['user_password']

  execute "create users" do
    command "sudo useradd -p `perl -e \"print(crypt(\'#{user_password}\', salt));\"` #{user_name}"
    not_if "grep #{user_name} /etc/passwd"
  end

  execute "create user_key" do
    command "sudo su - #{user_name} -c \"ssh-keygen -t rsa -N #{user_password} -f /home/#{user_name}/.ssh/id_rsa\""
    not_if "sudo test -e /home/#{user_name}/.ssh/id_rsa.pub"
  end
end
