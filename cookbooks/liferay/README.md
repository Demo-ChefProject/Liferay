# liferay Cookbook

This cookbook installs and configures liferay for Mission Ceter project.


## Requirements


### Platforms

- Windows

### Chef

- Chef 12.0 or later

### Cookbooks

- `liferay` - liferay cookbook to install for Mission Center.

## Attributes

check attribites folder for all the defined variables.



## Usage

### liferay::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `liferay` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[liferay]"
  ]
}
```

## What does this cookbook do?

```
 - Copy Liferay to target node from Nexus repo 
 - Check if the install location exists
 - Download the zip file
 - Take backup of the current install
 - Unzip Liferay zip in target location
 - Remove the Logs/* files
 - Inside tomcat remove the logs/* files
 - Inside tomcat remove the work/* files
 - Inside tomcat remove the temp/* files
```

## Further details about how the code works (with the packages used and on the coding front)

## For checking if install location exists
 A powershell script is used for this purpose. What this piece of code typically does is, it checks if the install location exists else exit the location.
 
## Then the Liferay zip file is downloaded into that location.
 `remote_file` (chef code) is used for this purpose

## What it does?
 A remote_file resource block manages files by using files that exist remotely.

- SYNTAX of remote_file
```
remote_file '/var/www/customers/public_html/index.php' do
  source 'http://somesite.com/index.php'
  owner 'web_admin'
  group 'web_admin'
  mode '0755'
  action :create
end
```
- Link to learn more on this topic of remote_file - https://docs.chef.io/resource_remote_file.html

## Backup the current install
 A powershell script is used for this purpose.
 
## To unzip Liferay zip into the target location
 We use 7 zip for this purpose.

## In order to remove the Logs/* files
 For the removal of the Log files we make use of `Remove-Item` in powershell

## What it does?
 The Remove-Item cmdlet does exactly what the name implies: it enables you to get rid of things once and for all.

- SYNTAX of Remove_Item
```
Remove-Item File_Path\* -recurse
```
- Link to learn more on Remove_Item - https://technet.microsoft.com/en-us/library/ee176938.aspx

## In order to remove log, error, temp in tomcat
 Again we make use of `Remove-Item` in powershell for this purpose.
