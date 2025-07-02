On branch master
Your branch is up to date with 'origin/master'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   del
	new file:   pcopy_0.6.1_amd64.deb.3
	modified:   res
	modified:   start.sh

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   res

diff --git a/del b/del
index 4179703..95756b3 100644
--- a/del
+++ b/del
@@ -1,5 +1,15 @@
-github.com
-  ✓ Logged in to github.com as abraxas678 (/home/abrax/.config/gh/hosts.yml)
-  ✓ Git operations for github.com configured to use ssh protocol.
-  ✓ Token: gho_************************************
-  ✓ Token scopes: admin:public_key, gist, read:org, repo
+*   Trying 34.160.111.145:80...
+* Connected to ifconfig.me (34.160.111.145) port 80 (#0)
+> GET / HTTP/1.1
+> Host: ifconfig.me
+> User-Agent: curl/7.88.1
+> Accept: */*
+> 
+< HTTP/1.1 200 OK
+< Content-Length: 12
+< access-control-allow-origin: *
+< content-type: text/plain
+< date: Wed, 02 Jul 2025 06:10:48 GMT
+< via: 1.1 google
+< 
+* Connection #0 to host ifconfig.me left intact
diff --git a/pcopy_0.6.1_amd64.deb.3 b/pcopy_0.6.1_amd64.deb.3
new file mode 100644
index 0000000..d42f042
Binary files /dev/null and b/pcopy_0.6.1_amd64.deb.3 differ
diff --git a/res b/res
index d1dced8..85b97a0 100644
--- a/res
+++ b/res
@@ -1,29 +1 @@
-On branch master
-Your branch is up to date with 'origin/master'.
-
-Changes to be committed:
-  (use "git restore --staged <file>..." to unstage)
-	modified:   start.sh
-
-Changes not staged for commit:
-  (use "git add <file>..." to update what will be committed)
-  (use "git restore <file>..." to discard changes in working directory)
-	modified:   res
-
-diff --git a/start.sh b/start.sh
-index aecdc8f..2c5c928 100755
---- a/start.sh
-+++ b/start.sh
-@@ -304,3 +304,12 @@ echo rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ign
- echo
- read -p "B to start" me
- rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ignore-existing -PL --fast-list
-+echo
-+echo atuin sync --force
-+read -p "B to start" me
-+atuin sync --force
-+echo
-+echo rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
-+read -p "B to start" me
-+rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
-+echo
+https://github.com/binwiederhier/pcopy/releases/download/v0.6.1/pcopy_0.6.1_amd64.deb
diff --git a/start.sh b/start.sh
index 2c5c928..c8be0e2 100755
--- a/start.sh
+++ b/start.sh
@@ -68,10 +68,12 @@ mkdir -p ~/.config/chezmoi
 instme fd-find
 instme gron
 instme fzf
-instgit binwiederhier pcopy
-echo
-pcopy join --force https://p.xxxyzzz.xyz
-echo
+if [[ ! -f /usr/bin/pcopy ]]; then
+  instgit binwiederhier pcopy
+  echo
+  pcopy join --force https://p.xxxyzzz.xyz
+  echo
+fi
 
 cd ~/.config/chezmoi
 #if [[ ! -f ~/.ssh/bws.dat ]]; then
@@ -302,14 +304,17 @@ cd /mnt/restic/snapshots/latest/home/abrax/.config
 echo
 echo rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ignore-existing -PL --fast-list
 echo
-read -p "B to start" me
-rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ignore-existing -PL --fast-list
+unset me
+read -p "[y] to start" me
+[[ $me = y ]] && rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ignore-existing -PL --fast-list
 echo
 echo atuin sync --force
-read -p "B to start" me
-atuin sync --force
+unset me
+read -p "[y] to start" me
+[[ $me = y ]] && atuin sync --force
 echo
 echo rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
-read -p "B to start" me
-rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
+unset me
+read -p "[y] to start" me
+[[ $me = y ]] && rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
 echo
