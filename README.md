supercollider Cookbook
======================
[Opscode Chef](http://www.opscode.com/chef/) cookbook for supercollider on Ubuntu.

Requirements
------------
#### operating system
- Ubuntu

#### cookbook
- [apt](http://community.opscode.com/cookbooks/apt)

Usage
-----
#### supercollider::default
1. Include `supercollider` in your node's `run_list`:
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[supercollider]"
  ]
}
```

2. Cook your node with the runlist.
3. Restart the node with GUI and AUDIO (otherwise staring scsynth will not success).
4. Login as 'supercollider' with password 'supercollider'.


License
-------
MIT
http://opensource.org/licenses/mit-license.php

Author
------
Kenichi Kanai
