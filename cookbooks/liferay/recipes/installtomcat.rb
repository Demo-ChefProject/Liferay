#Changes made in portal-exe.properties

liferay_install_loc = node['nc4']['liferay']['install_location']
liferay_work_dir = "#{liferay_install_loc}/MC3"
liferay_tomcat_dir = "#{liferay_work_dir}/tomcat/conf  


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
liferay_pswd_lowercase = node['nc4']['pswd_lowercase']


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
    :pswd_lowercase => liferay_pswd_lowercase,
    :work_dir => liferay_work_dir
    })
  action :create
end

#check if password complexity exists
powershell_script 'check if password complexity exists' do
  guard_interpreter :powershell_script
  code <<-EOH
$line1 = "passwords.passwordpolicytoolkit.charset.lowercase=abcdefghijklmnopqrstuvwxyz"
$line2 = "passwords.passwordpolicytoolkit.charset.numbers=0123456789"
$line3 = "passwords.passwordpolicytoolkit.charset.symbols=_.!@$*=-?"
$line4 = "passwords.passwordpolicytoolkit.charset.uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$successmsg = 'Password complexity exits'
If ($line1  -eq "passwords.passwordpolicytoolkit.charset.lowercase=abcdefghijklmnopqrstuvwxyz" -AND $line2 -eq "passwords.passwordpolicytoolkit.charset.numbers=0123456789" -AND $line3 -eq "passwords.passwordpolicytoolkit.charset.symbols=_.!@$*=-?" -AND $line4 -eq "passwords.passwordpolicytoolkit.charset.uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 
{
  Write-Host "successmsg: $successmsg"
  }
  ELSE
{
 Write-Host $line1
 Write-Host $line2
 Write-Host $line3
 Write-Host $line4
  }
EOH
notifies :run, 'powershell_script[Delete Tomcat Service if exists]', :immediately
end

#Satvinder didn't want separate prod and pre-prod as previous discussions with Rajesh
#Changes inside context.xml
#template "#{liferay_tomcat_dir}/context.xml.prod" do
#  source 'context.xml.prod.erb'
#  variables({
#    :work_dir => liferay_tomcat_dir
#    })
#  action :create
#end


powershell_script 'Delete Tomcat Service if exists' do
  guard_interpreter :powershell_script
  code <<-EOH
      $serviceName = "Apache-Tomcat-MC3"
       if ($Service = Get-Service -Name Apache-Tomcat-MC3 -ErrorAction SilentlyContinue)
       {
          $serviceToRemove = Get-WmiObject -Class Win32_Service -Filter "name='$serviceName'"
          $serviceToRemove.delete()
          "service removed"
       }
       else
       {
          "service does not exists"
       }
  EOH
   notifies :run, 'powershell_script[install Tomcat Service]', :immediately
end

powershell_script 'install Tomcat Service' do
  guard_interpreter :powershell_script
  code <<-EOH
   $Service = Get-Service -Name Apache-Tomcat-MC3 -ErrorAction SilentlyContinue
     if (! $Service) {
           sc create Apache-Tomcat-MC3 binPath= \"#{liferay_work_dir}/tomcat/bin\" start= auto DisplayName= \"Apache-Tomcat-MC3\"
     }
     EOH
end
