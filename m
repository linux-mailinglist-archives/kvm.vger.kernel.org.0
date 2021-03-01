Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B46328C0C
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 19:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbhCASoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 13:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbhCASlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 13:41:24 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435BAC06178A
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 10:40:29 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id e2so13516992ljo.7
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 10:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVzUhQp6eXREgIfc0wMPWIfpm6zGqEG1kwboLqi5P7c=;
        b=NW1m2PMF3tWGdvQJFfkz0NbP8LDG0wWxUAUvUpOzM2KM2pm16Zo1TWnJmOqTahjNM2
         rPZTMUE1NPEw90skwzhOeKGtIsQVOvRok0P06LvuNP8oQ+imRTWCxmxNCVmZdTUXNecj
         i+C8YeSqVw/4MjkkbqUTHuJGLQGCGz3iVibgjqvmSCSF6CZAK5aAdW86QI4XqVa4kG8k
         XEGWswaWIliQ/q99Q6cMu9/dzIKlILZfO/Z+b5hV1MVBXTXdY2CZIHCR+zoQaaKt2Pg8
         gu+Ob5TufGrus73LW8wUNqwy+qE9ixG+qQuvj29S85I2ZhnS1JuPbbOOceM6D2tY1QR8
         gzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVzUhQp6eXREgIfc0wMPWIfpm6zGqEG1kwboLqi5P7c=;
        b=hdyU8WKlZ4E0bSg0e6RMunksrtz7ZFa6756v+j9OtGRnYMaxuyUso9pIthp2VFX/YI
         ubOqeqwgz91Gf296k7OukSivDn3CjrhlWV05ucAS+S3pYOVg/ZZdgN9QRMDr7l+EE2Sz
         Hctfb2bYsqd3N2BQtMRC+t6U5qnBoPKSa7I92sIhBqNRm4Zcr+EM5THtJUpNmqjxczOP
         xR870FK5kVXXn8Gz02YG/8bx7uk7uf6BtYLBhPjqfRQx7iwyTYABdC/PgRXlpYvAKArh
         fIIuvAHaesa8BuKA4fnV2VDsze/3/czdOxfOOXtfq+dgBfks1qBbjmPOaoOOBzpdMKnL
         YHow==
X-Gm-Message-State: AOAM533t4yTPOu7ecWeE7gc/RKTblzCKxjlsVF7WXszUbRQJ6YxZtY9/
        AA71S41QsjPq0rUg+kiUh+Ev5XydNGqnAQ==
X-Google-Smtp-Source: ABdhPJxTNI1yJNRkzV+13Iwf3XYo1/XECSScrRGpTqqLCJ3K8GTks5BNo1rPpTZetpC07+C0kCojwg==
X-Received: by 2002:a2e:b888:: with SMTP id r8mr9661635ljp.505.1614624027037;
        Mon, 01 Mar 2021 10:40:27 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id w12sm2209410lft.281.2021.03.01.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:40:26 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC PATCH kvm-unit-tests] x86: add ioregionfd fast PIO test
Date:   Mon,  1 Mar 2021 21:33:19 +0300
Message-Id: <20210301183319.12370-1-eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
 scripts/common.bash   | 12 +++++--
 scripts/runtime.bash  |  9 +++++
 x86/Makefile.common   |  5 ++-
 x86/Makefile.x86_64   |  2 ++
 x86/ioregionfd-test.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 x86/ioregionfd_pio.c  | 24 +++++++++++++
 x86/unittests.cfg     |  7 ++++
 7 files changed, 140 insertions(+), 3 deletions(-)
 create mode 100644 x86/ioregionfd-test.c
 create mode 100644 x86/ioregionfd_pio.c

diff --git a/scripts/common.bash b/scripts/common.bash
index 7b983f7..d9f8556 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -14,6 +14,8 @@ function for_each_unittest()
 	local accel
 	local timeout
 	local rematch
+	local helper_cmd
+	local fifo
 
 	exec {fd}<"$unittests"
 
@@ -21,7 +23,7 @@ function for_each_unittest()
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			rematch=${BASH_REMATCH[1]}
 			if [ -n "${testname}" ]; then
-				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout" "$helper_cmd" "$fifo"
 			fi
 			testname=$rematch
 			smp=1
@@ -32,6 +34,8 @@ function for_each_unittest()
 			check=""
 			accel=""
 			timeout=""
+			helper_cmd=""
+			fifo=""
 		elif [[ $line =~ ^file\ *=\ *(.*)$ ]]; then
 			kernel=$TEST_DIR/${BASH_REMATCH[1]}
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
@@ -48,10 +52,14 @@ function for_each_unittest()
 			accel=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^timeout\ *=\ *(.*)$ ]]; then
 			timeout=${BASH_REMATCH[1]}
+		elif [[ $line =~ ^helper_cmd\ *=\ *(.*)$ ]]; then
+			helper_cmd=$TEST_DIR/${BASH_REMATCH[1]}
+		elif [[ $line =~ ^fifo\ *=\ *(.*)$ ]]; then
+			fifo=${BASH_REMATCH[1]}
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout" "$helper_cmd" "$fifo"
 	fi
 	exec {fd}<&-
 }
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 132389c..ba94ee5 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -81,6 +81,8 @@ function run()
     local check="${CHECK:-$7}"
     local accel="$8"
     local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
+    local helper_cmd="${10}"
+    local fifo="${11}"
 
     if [ -z "$testname" ]; then
         return
@@ -139,6 +141,11 @@ function run()
         echo $cmdline
     fi
 
+    if [ -n "${helper_cmd}" ] && [ -n "${fifo}" ]; then
+        mkfifo $fifo
+        $helper_cmd $fifo &
+    fi
+
     # extra_params in the config file may contain backticks that need to be
     # expanded, so use eval to start qemu.  Use "> >(foo)" instead of a pipe to
     # preserve the exit status.
@@ -159,6 +166,8 @@ function run()
         print_result "FAIL" $testname "$summary"
     fi
 
+    [ -n "${fifo}" ] && rm -rf $fifo
+
     return $ret
 }
 
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 55f7f28..a5cd1d2 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -82,6 +82,9 @@ $(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
 
 $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
 
+$(TEST_DIR)/ioregionfd-test:
+	$(CC) -o $@ $(TEST_DIR)/ioregionfd-test.c
+
 arch_clean:
-	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
+	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf $(TEST_DIR)/ioregionfd-test \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8134952..1a7a6b1 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -24,6 +24,8 @@ tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
 tests += $(TEST_DIR)/pks.flat
 tests += $(TEST_DIR)/pmu_lbr.flat
+tests += $(TEST_DIR)/ioregionfd_pio.flat
+tests += $(TEST_DIR)/ioregionfd-test
 
 ifneq ($(fcf_protection_full),)
 tests += $(TEST_DIR)/cet.flat
diff --git a/x86/ioregionfd-test.c b/x86/ioregionfd-test.c
new file mode 100644
index 0000000..5ea5e57
--- /dev/null
+++ b/x86/ioregionfd-test.c
@@ -0,0 +1,84 @@
+#include <linux/ioregion.h>
+#include <string.h>
+#include <poll.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+void err_exit(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	struct ioregionfd_cmd cmd;
+	struct ioregionfd_resp resp;
+	struct pollfd pollfd;
+	int read_fd, write_fd = -1;
+	unsigned long cdata = 0;
+	int ret;
+
+	if (argc < 2)
+		err_exit("Usage: %s <read_fifo> <write_fifo>\n", argv[0]);
+
+	read_fd = open(argv[1], O_RDONLY);
+	if (read_fd < 0)
+		err_exit("failed to open read fifo %s\n", argv[1]);
+
+	if (argc == 3) {
+		write_fd = open(argv[2], O_WRONLY);
+		if (write_fd < 0) {
+			close(read_fd);
+			err_exit("failed to open write fifo %s\n", argv[2]);
+		}
+	}
+
+	pollfd.fd = read_fd;
+	pollfd.events = POLLIN;
+
+	for (;;) {
+		ret = poll(&pollfd, 1, -1);
+		if (ret < 0) {
+			close(read_fd);
+			if (write_fd > 0)
+				close(write_fd);
+			err_exit("poll\n");
+		}
+
+		if (pollfd.revents & POLLIN) {
+			ret = read(read_fd, &cmd, sizeof(cmd));
+
+			switch (cmd.cmd) {
+			case IOREGIONFD_CMD_READ:
+				memset(&resp, 0, sizeof(resp));
+				memcpy(&resp.data, &cdata, 1 << cmd.size_exponent);
+				ret = write(write_fd, &resp, sizeof(resp));
+				break;
+			case IOREGIONFD_CMD_WRITE:
+				memcpy(&cdata, &cmd.data, 1 << cmd.size_exponent);
+				if (cmd.resp) {
+					memset(&resp, 0, sizeof(resp));
+					ret = write(write_fd, &resp, sizeof(resp));
+				}
+				break;
+			default:
+				break;
+			}
+		} else
+			break;
+	}
+
+	close(read_fd);
+	if (write_fd > 0)
+		close(write_fd);
+
+	return 0;
+}
diff --git a/x86/ioregionfd_pio.c b/x86/ioregionfd_pio.c
new file mode 100644
index 0000000..eaf8aad
--- /dev/null
+++ b/x86/ioregionfd_pio.c
@@ -0,0 +1,24 @@
+#include "x86/vm.h"
+
+int main(int ac, char **av)
+{
+	u32 expected = 0x11223344;
+	u32 val = 0;
+	u32 write_addr = 0x1234;
+	u32 read_addr = 0x1238;
+
+	outb(expected, write_addr);
+	val = inb(read_addr);
+	report(val == (u8)expected, "%x\n", val);
+
+	outw(expected, write_addr);
+	val = inw(read_addr);
+	report(val == (u16)expected, "%x\n", val);
+
+	outl(expected, write_addr);
+	val = inl(read_addr);
+	report(val == expected, "%x\n", val);
+
+	return report_summary();
+}
+
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 0698d15..8001808 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -389,3 +389,10 @@ file = cet.flat
 arch = x86_64
 smp = 2
 extra_params = -enable-kvm -m 2048 -cpu host
+
+[ioregion-pio]
+file = ioregionfd_pio.flat
+helper_cmd = ioregionfd-test
+fifo = /tmp/test1 /tmp/test2
+extra_params = -device pc-testdev,addr=0x1234,size=8,rfifo=/tmp/test2,wfifo=/tmp/test1,pio=true
+arch = x86_64
-- 
2.25.1

