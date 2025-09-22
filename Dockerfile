FROM steamcmd/steamcmd:ubuntu-22
COPY steam_deploy.sh /root/steam_deploy.sh
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
