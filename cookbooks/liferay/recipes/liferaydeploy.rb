liferay_install_loc = node['nc4']['liferay']['install_location']
liferay_package_name = node['nc4']['liferay']['package']

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
  source 'http://ec2-54-175-158-124.compute-1.amazonaws.com/repository/Rigil/liferay-base-install-6.1.30.zip'
  action :create
  notifies :run, 'powershell_script[Unzip Liferay package]', :immediately
end

#Backup the current install
powershell_script 'backup current install' do
  guard_interpreter :powershell_script
  code <<-EOH
    Rename-Item -path "C:\\liferay\\MC3" -newName "backup"
  EOH
  not_if do Dir.exist?("C:\\liferay\\MC3") end
  notifies :run, 'powershell_script[Unzip Liferay package]', :immediately
end

powershell_script 'Unzip Liferay package' do
  guard_interpreter :powershell_script
  code <<-EOH
  trap
{
    write-output $_
      powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('#{liferay_install_loc}/#{liferay_package_name}', '#{liferay_install_loc}');}"
  exit 1
}
   EOH
  notifies :run, 'powershell_script[Remove logs]', :immediately
end

powershell_script 'Remove logs' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item C:\\liferay\\MC3\\logs\\* -recurse
  EOH
  #only_if do Dir.exist? 'C://liferay//MC3//logs'
  #notifies :run, 'powershell_script[Remove log,error,temp in tomcat]', :immediately
end

powershell_script 'Remove log,error,temp in tomcat' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item C:\\liferay\\MC3\\tomcat\logs\\* -recurse
    Remove-Item C:\\liferay\\MC3\\tomcat\\work\\* -recurse
    Remove-Item C:\\liferay\\MC3\\tomcat\\temp\\* -recurse
  EOH
end
