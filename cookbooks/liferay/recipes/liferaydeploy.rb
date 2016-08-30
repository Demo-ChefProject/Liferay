
remote_file 'C:\NC4\liferay-base-install-6.1.30.zip' do
  source ''
  action :create
  notifies :run, 'powershell_script[Unzip Apache package]', :immediately
end

powershell_script 'Unzip Apache package' do
  guard_interpreter :powershell_script
  code <<-EOH
    powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory(C:\NC4\liferay-base-install-6.1.30.zip, C:\NC4)}"
  EOH
  notifies :run, 'powershell_script[Remove logs]', :immediately
end

powershell_script 'Remove logs' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item C:NC4/MC3/logs/* -recurse
  EOH
  #only_if do Dir.exist? C:NC4/MC3/logs
  notifies :run, 'powershell_script[Remove log,error,temp in tomcat]', :immediately
end

powershell_script 'Remove log,work,temp in tomcat' do
  guard_interpreter :powershell_script
  code <<-EOH
    Remove-Item C:NC4/MC3/Tomcat/logs* -recurse
    Remove-Item C:NC4/MC3/Tomcat/work* -recurse
    Remove-Item C:NC4/MC3/Tomcat/temp* -recurse
  EOH
end
