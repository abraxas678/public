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
index aecdc8f..2c5c928 100755
--- a/start.sh
+++ b/start.sh
@@ -304,3 +304,12 @@ echo rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ign
 echo
 read -p "B to start" me
 rclone copy /mnt/restic/snapshots/latest/home/abrax/.config ~/.config --ignore-existing -PL --fast-list
+echo
+echo atuin sync --force
+read -p "B to start" me
+atuin sync --force
+echo
+echo rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
+read -p "B to start" me
+rclone copy /mnt/restic/snapshots/latest/home/abrax/bin ~/bin --ignore-existing -PL --fast-list
+echo
