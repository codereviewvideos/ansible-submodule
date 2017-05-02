An alternative approach to including other people's ansible roles through the use of git submodules. 

The aim - to not have to manually keep other people's ansible roles in sync with local ansible installations. Let git do the hard work, so you don't have too. 

This is currently only working on Debian / Ubuntu based systems. 

## Installation Instructions

1. `git clone git@github.com:codereviewvideos/ansible-submodules.git && cd $_`

2. `git submodule update --init --recursive`

3. Follow sshknownhosts instructions: 

https://github.com/bfmartin/ansible-sshknownhosts#sshknownhosts

From ansible master:

```
cd roles/sshknownhosts
sudo install -m 444 sshknownhosts $ANSIBLE_LIBRARY/sshknownhosts
```

## Examples

Examples of a standard setup are included in the `_examples` folder. Copy these as required:

* `_examples/hosts` to `hosts` at same level as `ansible.cfg` (project root)
* `_examples/group_vars` to `group_vars`

## Generating a User Password

If unsure how to generate the hashed password for your individual Users, see [this tutorial][1]

## Generating SSH Keys

If unsure how to generate SSH keys, see [this tutorial][2]


[1]: https://codereviewvideos.com/course/ansible-tutorial/video/how-to-manage-users-with-ansible
[2]: https://help.github.com/articles/generating-ssh-keys/
