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

    - name: Execute Source File
      shell: source ~/.bashrc
      args:
        executable: /bin/bash
      become: yes
      become_user: etp
      environment:
        PATH: "/usr/bin:{{ ansible_env.PATH }}"
        DOCKER_HOST: "unix:///run/user/{{ ansible_user_id }}/docker.sock"


    - name: Start Docker Service
      systemd:
        name: docker
        state: started
        enabled: yes

    - name: Enable Docker service to start on boot
      systemd:
        name: docker
        enabled: yes
