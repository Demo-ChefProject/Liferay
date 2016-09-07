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

## On a more detail oriented scenario about how the code works (with the packages used and on the coding front)

Authors: TODO: List authors

