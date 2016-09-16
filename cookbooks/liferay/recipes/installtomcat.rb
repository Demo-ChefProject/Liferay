#Changes made in portal-exe.properties

liferay_install_loc = node['nc4']['liferay']['install_location']
liferay_work_dir = "#{liferay_install_loc}/MC3"

liferay_max_size = node['nc4']['max_size']
liferay_ip_home = node['nc4']['ip_home']
liferay_ip_internal = node['nc4']['ip_internal']
liferay_session_timeout = node['nc4']['session_timeout']


=begin
template "#{apache_httpd_conf}/httpd-vhost.conf" do
  source 'httpd-vhosts.conf.erb'
  variables( :server_name => apache_server_name )
  action :create
end
=end

template "#{liferay_work_dir}/portal-exe.properties" do
  source 'portal-ext.properties.erb'
  variables({
    :max_size => liferay_max_size,
    :ip_home => liferay_ip_home,
    :ip_internal => liferay_ip_internal,
    :session_timeout => liferay_session_timeout,
    :work_dir => liferay_work_dir
    })
  action :create
end

