#Changes made in portal-exe.properties

liferay_install_loc = node['nc4']['liferay']['install_location']
liferay_work_dir = "#{liferay_install_loc}/MC3"

liferay_max_size = node['nc4']['max_size']
liferay_ip_home = node['nc4']['ip_home']
liferay_ip_internal = node['nc4']['ip_internal']
liferay_session_timeout = node['nc4']['session_timeout']
liferay_comp_name = node['nc4']['comp_name']
liferay_comp_webid = node['nc4']['comp_webid']
liferay_comp_url =node['nc4']['comp_url']
liferay_default_landingpath = node['nc4']['default_landingpath']
liferay_form_name = node['nc4']['form_name']
liferay_form_address = node['nc4']['form_address']



template "#{liferay_work_dir}/portal-exe.properties" do
  source 'portal-ext.properties.erb'
  variables({
    :max_size => liferay_max_size,
    :ip_home => liferay_ip_home,
    :ip_internal => liferay_ip_internal,
    :session_timeout => liferay_session_timeout,
    :comp_name => liferay_comp_name,
    :comp_webid => liferay_comp_webid,
    :comp_url => liferay_comp_url,
    :default_landingpath => liferay_default_landingpath,
    :form_name => liferay_form_name,
    :form_address => liferay_form_address,
    :work_dir => liferay_work_dir
    })
  action :create
end

