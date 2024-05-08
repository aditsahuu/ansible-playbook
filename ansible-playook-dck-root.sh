- hosts: edge
  become: yes
  tasks:
    - name: Update system packages
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install Packages
      apt:
        name:
          - uidmap
          - curl
        state: latest

    - name: Download and Install Docker
      get_url:
        url: https://get.docker.com
        dest: /tmp/get-docker.sh
        mode: '0755'

    - name: Install Docker
      command: /tmp/get-docker.sh

    - name: Download Docker Rootless install script
      become: no
      get_url:
        url: https://get.docker.com/rootless
        dest: /tmp/get-docker-rootless.sh
        mode: '0755'

    - name: Install Docker Rootless
      become: no
      command: /tmp/get-docker-rootless.sh
    - name: Setting PATH environment variable
      lineinfile:
        dest: ~/.bashrc
        line: "export PATH=/usr/bin:$PATH"
        state: present
        create: yes
      become_user: "{{ ansible_user }}"

    - name: Setting DOCKER_HOST environment variable
      lineinfile:
        dest: ~/.bashrc
        line: "export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock"
        state: present
        create: yes
      become_user: "{{ ansible_user }}"

    - name: Reload .bashrc file
      shell: source ~/.bashrc
      args:
        executable: /bin/bash
      become_user: "{{ ansible_user }}"


    - name: Start Docker Service
      systemd:
        name: docker
        state: started
        enabled: yes

    - name: Enable Docker service to start on boot
      systemd:
        name: docker
        enabled: yes
