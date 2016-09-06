liferay_download_from = "#{node['nc4']['nexus']['url']}/#{node['nc4']['liferay1']['version']}/#{node['nc4']['liferay']['package']}"
liferay_install_loc = node['nc4']['liferay']['install_location']
liferay_package_name = node['nc4']['liferay']['package']
liferay_work_dir = "#{liferay_install_loc}/MC3"
liferay_backup_touch = node['ohai_time']
liferay_tomcatwork_dir = "#{liferay_install_loc}/MC3/tomcat"

#Check if install location exists
powershell_script 'Create Install Location' do
  guard_interpreter :powershell_script
  code <<-EOH
    New-Item -ItemType Directory -Path #{liferay_install_loc}
  EOH
  not_if do Dir.exist?("#{liferay_install_loc}") end
end

#Download the Liferay zip file
remote_file "#{liferay_install_loc}/#{liferay_package_name}" do
  #source 'http://54.175.158.124:8081/repository/Rigil/liferay-base-install-6.1.30.zip'
  source liferay_download_from
  action :create
  notifies :run, 'powershell_script[backup current install]', :immediately
end

#Backup the current install
powershell_script 'backup current install' do
  guard_interpreter :powershell_script
  code <<-EOH
#    Rename-Item -path #{liferay_work_dir} -newName "#{liferay_work_dir}-#{liferay_backup_touch}"
  EOH
#  only_if do Dir.exist?("#{liferay_work_dir}") end
#  not_if do Dir.exist?("#{liferay_work_dir}-#{liferay_backup_touch}") end
#  notifies :run, 'powershell_script[Unzip Liferay package]', :immediately
end

powershell_script 'Unzip Liferay package' do
  guard_interpreter :powershell_script
  code <<-EOH
    Rename-Item -path #{liferay_work_dir} -newName "#{liferay_work_dir}-#{liferay_backup_touch}"
    powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('#{liferay_install_loc}/#{liferay_package_name}', '#{liferay_install_loc}'); }"
 EOH
  notifies :run, 'powershell_script[Remove logs]', :immediately
end

powershell_script 'Remove logs' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item #{liferay_work_dir}/logs/* -recurse
  EOH
  #only_if do Dir.exist?("#{liferay_work_dir}/logs")
  #notifies :run, 'powershell_script[Remove log,error,temp in tomcat]', :immediately
end

powershell_script 'Remove log,error,temp in tomcat' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item #{liferay_tomcatwork_dir}/logs/* -recurse
    Remove-Item #{liferay_tomcatwork_dir}/work/* -recurse
    Remove-Item #{liferay_tomcatwork_dir}/temp/* -recurse
  EOH
end
