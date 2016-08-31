
remote_file 'C:\liferay\liferay-base-install-6.1.30.zip' do
  source 'http://ec2-54-175-158-124.compute-1.amazonaws.com/repository/Rigil/liferay-base-install-6.1.30.zip'
  action :create
  notifies :run, 'powershell_script[Unzip Liferay package]', :immediately
end


powershell_script 'Unzip Liferay package' do
  guard_interpreter :powershell_script
  code <<-EOH
    powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:\liferay\liferay-base-install-6.1.30.zip', 'C:\liferay')}"
  EOH
  notifies :run, 'powershell_script[Remove logs]', :immediately
end

powershell_script 'Remove logs' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item C:\liferay\MC3\logs\* -recurse
  EOH
  #only_if do Dir.exist? C:NC4/MC3/logs
  #notifies :run, 'powershell_script[Remove log,error,temp in tomcat]', :immediately
end
=begin
powershell_script 'Remove log,error,temp in tomcat' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item C:NC4/MC3/Tomcat/logs* -recurse
    Remove-Item C:NC4/MC3/Tomcat/work* -recurse
    Remove-Item C:NC4/MC3/Tomcat/temp* -recurse
  EOH
end
=end
