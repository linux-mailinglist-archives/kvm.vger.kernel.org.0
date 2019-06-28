Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1630259771
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfF1J1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:27:13 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:59219 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfF1J1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561714032; x=1593250032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=y7MIzBG9QlQhw1NfeA9/7uvyxrNCor5lUPeZCXeQMbI=;
  b=N2d6PHJLXKgJaUErZLUP54Zh+p5hRlimLL+DV5C27Oo5uMvJmzRb2v2q
   n5p165Hi5b4E1gliNXlJPWoxIRnl4LnbSctEM5l6Z6w6bwvL3FIoQsLRB
   pvJiWIegxcthFs7FtHOxHlPWe3N64lJJV0fogPIQQ2ioVyklGmBfN3xMO
   M=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="739581296"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 28 Jun 2019 09:27:12 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 86B46281F2A;
        Fri, 28 Jun 2019 09:27:08 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:48 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 09:26:44 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v4 4/5] Added build and install scripts
Date:   Fri, 28 Jun 2019 11:26:20 +0200
Message-ID: <20190628092621.17823-5-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628092621.17823-1-samcacc@amazon.de>
References: <20190628092621.17823-1-samcacc@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

install_afl.sh installs AFL locally and emits AFLPATH,
build.sh, and run.sh build and run respectively

---

v1 -> v2:
 - Introduced this patch

v2 -> v3:
 - Moved non-essential development scripts to a later patch

v3 -> v4:
 - Building checks for existing .config and no longer overwrites it
 - Removed extraneous forcing of some config options
 - Renamed afl-many to afl-many.sh
 - Added a timeout option to afl-many.sh
 - Fixed an incorrect path in afl-many.sh

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/scripts/afl-many.sh    | 31 ++++++++++++++++++++++
 tools/fuzz/x86ie/scripts/build.sh       | 34 +++++++++++++++++++++++++
 tools/fuzz/x86ie/scripts/install_afl.sh | 17 +++++++++++++
 tools/fuzz/x86ie/scripts/run.sh         | 10 ++++++++
 4 files changed, 92 insertions(+)
 create mode 100755 tools/fuzz/x86ie/scripts/afl-many.sh
 create mode 100755 tools/fuzz/x86ie/scripts/build.sh
 create mode 100755 tools/fuzz/x86ie/scripts/install_afl.sh
 create mode 100755 tools/fuzz/x86ie/scripts/run.sh

diff --git a/tools/fuzz/x86ie/scripts/afl-many.sh b/tools/fuzz/x86ie/scripts/afl-many.sh
new file mode 100755
index 000000000000..e56923ae16ff
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/afl-many.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# This is for running AFL over NPROC or `nproc` cores with normal AFL options ex:
+# ./tools/fuzz/x86ie/scripts/afl-many.sh -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@
+
+export AFL_NO_AFFINITY=1
+
+while [ -z "$sync_dir" ]; do
+  while getopts ":o:" opt; do
+    case "${opt}" in
+      o)
+        sync_dir="${OPTARG}"
+        ;;
+      *)
+        ;;
+    esac
+  done
+  ((OPTIND++))
+  [ $OPTIND -gt $# ] && break
+done
+
+# AFL/linux do some weird stuff with core affinity and will often run
+# N processes over < N virtual cores.  In order to avoid that, we taskset
+# each process to its own core.
+for i in $(seq 1 $(( ${NPROC:-$(nproc)} - 1)) ); do
+    taskset -c "$i" $AFLPATH/afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
+done
+taskset -c 0 $AFLPATH/afl-fuzz -M master $@ >/dev/null 2>&1 &
+
+${TIMEOUT:+timeout -sKILL $TIMEOUT} watch -n1 "echo \"Executing '$AFLPATH/afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && $AFLPATH/afl-whatsup -s ${sync_dir}"
+pkill afl-fuzz
diff --git a/tools/fuzz/x86ie/scripts/build.sh b/tools/fuzz/x86ie/scripts/build.sh
new file mode 100755
index 000000000000..5e0eab8ad721
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/build.sh
@@ -0,0 +1,34 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Run from root of linux via `./tools/fuzz/x86ie/scripts/build.sh`
+
+kernel_objects="arch/x86/kvm/emulate.o arch/x86/lib/retpoline.o lib/find_bit.o"
+
+disable() { sed -i -r "/\b$1\b/c\# $1" .config; }
+enable() { sed -i -r "/\b$1\b/c\\$1=y" .config; }
+
+if [ ! -f .config ]; then
+  make ${CC:+ "CC=$CC"} defconfig
+fi
+
+# enable "CONFIG_DEBUG_INFO"
+
+yes ' ' | make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} $kernel_objects
+
+omit_arg () { args=$(echo "$args" | sed "s/ $1//g"); }
+add_arg () { args+=" $1"; }
+
+rebuild () {
+  args="$(head -1 $(dirname $1)/.$(basename $1).cmd | sed -e 's/.*:= //g')"
+  omit_arg "-mcmodel=kernel"
+  omit_arg "-mpreferred-stack-boundary=3"
+  add_arg "-fsanitize=address"
+  echo -e "Rebuilding $1 with \n$args"
+  eval "$args"
+}
+
+for object in $kernel_objects; do
+  rebuild $object
+done
+
+make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} tools/fuzz
diff --git a/tools/fuzz/x86ie/scripts/install_afl.sh b/tools/fuzz/x86ie/scripts/install_afl.sh
new file mode 100755
index 000000000000..3bdbdf2a040b
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/install_afl.sh
@@ -0,0 +1,17 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Can be run where ever, but usually run from linux root:
+# `source ./tools/fuzz/x86ie/scripts/install_afl.sh`
+# (must be sourced to get the AFLPATH envvar, otherwise set manually)
+
+wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
+mkdir -p afl
+tar xzf afl-latest.tgz -C afl --strip-components 1
+
+pushd afl
+set AFL_USE_ASAN
+make clean all
+export AFLPATH="$(pwd)"
+popd
+
+sudo bash -c "echo core >/proc/sys/kernel/core_pattern"
diff --git a/tools/fuzz/x86ie/scripts/run.sh b/tools/fuzz/x86ie/scripts/run.sh
new file mode 100755
index 000000000000..348c9c41021a
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/run.sh
@@ -0,0 +1,10 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}"
+
+mkdir -p $FUZZDIR/in
+cp tools/fuzz/x86ie/rand_sample.bin $FUZZDIR/in
+mkdir -p $FUZZDIR/out
+
+screen bash -c "ulimit -Sv $[21999999999 << 10]; ${TIMEOUT:+TIMEOUT=$TIMEOUT} ./tools/fuzz/x86ie/scripts/afl-many.sh -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@; exit \$?;"
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



