supercollider Cookbook
======================
Opscode Chef cookbook for supercollider on Ubuntu.

Requirements
------------
#### operating system
- Ubuntu

#### cookbook
- apt

Usage
-----
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
3. Restart the node with GUI and AUDIO.


License
-------
MIT
http://opensource.org/licenses/mit-license.php

Author
-------------------
Kenichi Kanai
