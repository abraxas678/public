On branch master
Your branch is up to date with 'origin/master'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   res
	new file:   start.kdbx

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   res

diff --git a/res b/res
new file mode 100644
index 0000000..fc7d17a
--- /dev/null
+++ b/res
@@ -0,0 +1,62 @@
+On branch master
+Your branch is up to date with 'origin/master'.
+
+Changes to be committed:
+  (use "git restore --staged <file>..." to unstage)
+	deleted:    del
+	deleted:    maeschen.tar
+	deleted:    myres
+	deleted:    res
+
+Untracked files:
+  (use "git add <file>..." to include in what will be committed)
+	res
+
+diff --git a/del b/del
+deleted file mode 100644
+index 95756b3..0000000
+--- a/del
++++ /dev/null
+@@ -1,15 +0,0 @@
+-*   Trying 34.160.111.145:80...
+-* Connected to ifconfig.me (34.160.111.145) port 80 (#0)
+-> GET / HTTP/1.1
+-> Host: ifconfig.me
+-> User-Agent: curl/7.88.1
+-> Accept: */*
+-> 
+-< HTTP/1.1 200 OK
+-< Content-Length: 12
+-< access-control-allow-origin: *
+-< content-type: text/plain
+-< date: Wed, 02 Jul 2025 06:10:48 GMT
+-< via: 1.1 google
+-< 
+-* Connection #0 to host ifconfig.me left intact
+diff --git a/maeschen.tar b/maeschen.tar
+deleted file mode 100644
+index 4a94ca4..0000000
+Binary files a/maeschen.tar and /dev/null differ
+diff --git a/myres b/myres
+deleted file mode 100644
+index 9e1533f..0000000
+--- a/myres
++++ /dev/null
+@@ -1,2 +0,0 @@
+-thisvid hypno
+-h4g hypnosis for guys
+diff --git a/res b/res
+deleted file mode 100644
+index 16d1ee1..0000000
+--- a/res
++++ /dev/null
+@@ -1,9 +0,0 @@
+-On branch master
+-Your branch is up to date with 'origin/master'.
+-
+-Changes not staged for commit:
+-  (use "git add <file>..." to update what will be committed)
+-  (use "git restore <file>..." to discard changes in working directory)
+-	modified:   res
+-
+-no changes added to commit (use "git add" and/or "git commit -a")
diff --git a/start.kdbx b/start.kdbx
new file mode 100644
index 0000000..f28d15a
Binary files /dev/null and b/start.kdbx differ
