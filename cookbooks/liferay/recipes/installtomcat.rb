liferay_install_loc = node['nc4']['liferay']['install_location']
liferay_work_dir = "#{liferay_install_loc}/MC3"
liferay_tomcat_dir = "#{liferay_work_dir}/tomcat/conf"  


liferay_max_size = node['nc4']['max_size']
liferay_ip_home = node['nc4']['ip_home']
liferay_ip_internal = node['nc4']['ip_internal']
liferay_session_timeout = node['nc4']['session_timeout']
liferay_comp_name = node['nc4']['comp_name']
liferay_comp_webid = node['nc4']['comp_webid']
liferay_comp_url =node['nc4']['comp_url']
liferay_default_landingpath = node['nc4']['default_landingpath']
liferay_from_name = node['nc4']['from_name']
liferay_from_address = node['nc4']['from_address']
liferay_email_to_address = node['nc4']['email_to_address']
liferay_rsa_domain = node['nc4']['rsa_domain'] 
liferay_rsa_pin_type = node['nc4']['rsa_pin_type']
liferay_rsa_twofactor_mode = node['nc4']['rsa_twofactor_mode']
liferay_rsa_twofactor_enabled = node['nc4']['rsa_twofactor_enabled']
liferay_jdbc_url = node['nc4']['jdbc_url']


template "#{liferay_work_dir}/portal-ext.properties" do
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
    :from_name => liferay_from_name,
    :from_address => liferay_from_address,
    :email_to_address => liferay_email_to_address, 
    :rsa_domain => liferay_rsa_domain,
    :rsa_pin_type => liferay_rsa_pin_type,
    :rsa_twofactor_mode => liferay_rsa_twofactor_mode,
    :rsa_twofactor_enabled => liferay_rsa_twofactor_enabled,
    :work_dir => liferay_work_dir
    })
  action :create
end

template "#{liferay_tomcat_dir}/context.xml" do
  source 'context.xml.erb'
  variables({
    :jdbc_url => liferay_jdbc_url,
    :work_dir => liferay_tomcat_dir
    })
  action :create
end

powershell_script 'check if password complexity exists' do
  guard_interpreter :powershell_script
  code <<-EOH
$line1 = "passwords.passwordpolicytoolkit.charset.lowercase=abcdefghijklmnopqrstuvwxyz"
$TSProfile_exist = test-path "C:\\NC4\\MC3\\portal-ext.properties"
$filepath = Get-Content C:\\NC4\\MC3\\portal-ext.properties 
#echo $filepath
echo $compare = Compare-Object filepath$ line1$
If ($filepath -ccontains "passwords.passwordpolicytoolkit.charset.lowercase=abcdefghijklmnopqrstuvwxyz" -AND $filepath -ccontains "passwords.passwordpolicytoolkit.charset.numbers=0123456789" -AND $filepath -ccontains "passwords.passwordpolicytoolkit.charset.symbols=_.!@$*=-?" -AND $filepath -ccontains "passwords.passwordpolicytoolkit.charset.uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ")
{
Write-Host "Yippee, pswd comp exists"
}
ELSE {
add-content C:\\NC4\\MC3\\portal-ext.properties "`n##Password Complexity change Demo 303149"
add-content C:\\NC4\\MC3\\portal-ext.properties "`npasswords.passwordpolicytoolkit.charset.lowercase=abcdefghijklmnopqrstuvwxyz"
add-content C:\\NC4\\MC3\\portal-ext.properties "`npasswords.passwordpolicytoolkit.charset.numbers=0123456789"
add-content C:\\NC4\\MC3\\portal-ext.properties "`npasswords.passwordpolicytoolkit.charset.symbols=_.!@$*=-?"
add-content C:\\NC4\\MC3\\portal-ext.properties "`npasswords.passwordpolicytoolkit.charset.uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}
EOH
 #notifies :run, 'execute[delete if tomcat service exist]', :immediately
end


powershell_script 'delete if tomcat service exist' do
   code <<-EOH
    $Service = Get-Service -Name Apache-Tomcat-MC3 -ErrorAction SilentlyContinue
     if (! $Service) {
          Invoke-Expression "cmd /c C:/NC4/MC3/tomcat/bin/service.bat uninstall Apache Tomcat MC3" 
     }
  EOH
#  notifies :run, 'execute[install Tomcat Service]', :immediately
end

powershell_script 'install Tomcat Service' do
  code <<-EOH
     $Service = Get-Service -Name Apache-Tomcat-MC3 -ErrorAction SilentlyContinue
     if (! $Service) {
           Invoke-Expression "cmd /c C:/NC4/MC3/tomcat/bin/service.bat install MC3" 
     }
  EOH
end


