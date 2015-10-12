require "./packages_list"
require "./services_on_list"
require "./services_off_list"

$packages.each do |pkg|
  package pkg
end

$on_services.each do |svc|
  service svc do
    action [:start, :enable]
  end
end

$off_services.each do |svc|
  service svc do
    action [:stop, :disable]
  end
end
