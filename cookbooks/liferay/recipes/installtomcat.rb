#Changes made in portal-exe.properties

liferay_work_dir = "#{liferay_install_loc}/MC3"
liferay_portal_dir = "#{liferay_install_loc}/MC3/portal-exe.propertiestomcat"
liferay_max_size = node['nc4']['max_size']

=begin
template "#{apache_httpd_conf}/httpd-vhost.conf" do
  source 'httpd-vhosts.conf.erb'
  variables( :server_name => apache_server_name )
  action :create
end
=end

template "liferay_portal_dir" do
  source 'portal-ext.properties.erb'
  variables({
    :max_size => -1,
  #  :work_dir => apache_work_dir
    })
  action :create
end
