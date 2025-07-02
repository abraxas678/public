On branch master
Your branch is up to date with 'origin/master'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   start.sh

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   res

diff --git a/start.sh b/start.sh
index c8be0e2..3ab4edd 100755
--- a/start.sh
+++ b/start.sh
@@ -7,6 +7,9 @@ if [ "$(id -u)" = 0 ]; then
 else
     MYSUDO="sudo"
 fi
+
+sudo grep -q '^%sudo ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers || echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers
+
 mkdir $HOME/bin -p
 $MYSUDO cp bin/chezmoi /usr/bin/chezmoi
 $MYSUDO cp chezmoi.sh $HOME/bin/
