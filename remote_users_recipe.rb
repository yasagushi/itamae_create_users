node['users'].times do |i|
  salt = ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(2).join
  user_name = node['users'][i]['user_name']
  user_password = node['users'][i]['user_password']

  execute "create users" do
    command "sudo useradd #{user_name} -p `perl -e \"print(crypt(#{user_password}, salt));\"`"
    not_if "grep #{user_name} /etc/passwd"
  end

  SSH_KEY = %x(sudo cat "/home/#{user_name}/.ssh/id_rsa.pub")

  directory "/home/#{user_name}/.ssh" do
    user u
    owner u
    group u
    mode "700"
  end

  file "/home/#{user_name}/.ssh/authorized_keys" do
    content SSH_KEY
    owner u
    group u
    mode "600"
  end

  execute "add user to wheel group" do
    command "usermod -G wheel #{user_name}"
    not_if "groups #{user_name} | grep 'wheel'"
  end
end
