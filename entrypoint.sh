if [[ "$runAsHostUser" == "true" ]]; then
  echo "Running as host user"

  # Stop on error if we can't set up the user
  set -e

  # Get host user/group info so we create files with the correct ownership
  USERNAME=$(stat -c '%U' "$fullProjectPath")
  USERID=$(stat -c '%u' "$fullProjectPath")
  GROUPNAME=$(stat -c '%G' "$fullProjectPath")
  GROUPID=$(stat -c '%g' "$fullProjectPath")

  groupadd -g $GROUPID $GROUPNAME
  useradd -u $USERID -g $GROUPID $USERNAME
  usermod -aG $GROUPNAME $USERNAME
  mkdir -p "/home/$USERNAME"
  chown $USERNAME:$GROUPNAME "/home/$USERNAME"

  # Normally need root permissions to access when using su
  chmod 777 /dev/stdout
  chmod 777 /dev/stderr

  # Don't stop on error when running our scripts as error handling is baked in
  set +e

  # Switch to the host user so we can create files with the correct ownership
  su $USERNAME -c "$SHELL -c 'steam_deploy.sh'"
else
  echo "Running as root"

  # Run as root
  source steam_deploy.sh
fi