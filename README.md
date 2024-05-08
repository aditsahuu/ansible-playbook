# ansible-playbook
This Ansible Playbook is used for Installation of Docker with Rootless access.
Also we have used custom Inventory file.

Command to Execute the Playbook:-

ansible-plabook playbookname -i inventoryname --ask-become-pass

--ask-become-pass is used to Provide the root access because in the Playbook become: true is defined. When executed the playbook provide the Root Password.

Different Task in Playbooks:
1. Update the Apt Packages
2. Install Required Packages for Docker Rootless Installation.
3. Download Docker executable File and Provide Executable access.
4. Execute the Dowloaded Docker Script.
5. Download Docker Rootless Installation script and Provide Executable access.
6. Execute the Dowloaded Rootless Script.
7. Setting PATH environment variable (export PATH=/usr/bin:$PATH)
8. Setting DOCKER_HOST environment variable (export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock)
9. Reload .bashrc file.
10. Start Docker Service.
11. Enable Docker service to start on boot.