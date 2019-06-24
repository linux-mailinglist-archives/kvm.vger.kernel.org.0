Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27D550DDF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfFXOZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:25:04 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:7287 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728535AbfFXOZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561386301; x=1592922301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=IiutmOqWx07Vhkhld9CusBzqI7cRQ/7MV7vdxiYNi+k=;
  b=uiXaY8P5CpYcMlx8hnxvZnENQpqVYQqrG14OEa21N7Wa1JaXU1vSylsR
   Eoq0WDVVCAW/jA0uN/r35CmdUxMXERc1G8t4h4wNg0Fh8nXHR8qPv5zKI
   eDbP7Xft+rJ6snZzHDM9qi3guFL24ksYLEMuww8zQVvG0QFgmb+xxz4ho
   k=;
X-IronPort-AV: E=Sophos;i="5.62,412,1554768000"; 
   d="scan'208";a="812308123"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 24 Jun 2019 14:25:00 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 4C660A1B7D;
        Mon, 24 Jun 2019 14:24:59 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:43 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:24:38 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v3 4/5] Added build and install scripts
Date:   Mon, 24 Jun 2019 16:24:13 +0200
Message-ID: <20190624142414.22096-5-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190624142414.22096-1-samcacc@amazon.de>
References: <20190624142414.22096-1-samcacc@amazon.de>
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

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/scripts/afl-many       | 31 +++++++++++++++++++++++
 tools/fuzz/x86ie/scripts/build.sh       | 33 +++++++++++++++++++++++++
 tools/fuzz/x86ie/scripts/install_afl.sh | 17 +++++++++++++
 tools/fuzz/x86ie/scripts/run.sh         | 10 ++++++++
 4 files changed, 91 insertions(+)
 create mode 100755 tools/fuzz/x86ie/scripts/afl-many
 create mode 100755 tools/fuzz/x86ie/scripts/build.sh
 create mode 100755 tools/fuzz/x86ie/scripts/install_afl.sh
 create mode 100755 tools/fuzz/x86ie/scripts/run.sh

diff --git a/tools/fuzz/x86ie/scripts/afl-many b/tools/fuzz/x86ie/scripts/afl-many
new file mode 100755
index 000000000000..e55ff115a777
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/afl-many
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# This is for running AFL over NPROC or `nproc` cores with normal AFL options ex:
+# ulimit -Sv $[21999999999 << 10]; ./tools/fuzz/x86ie/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@ 
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
+    taskset -c "$i" ./afl-fuzz -S "slave$i" $@ >/dev/null 2>&1 &
+done
+taskset -c 0 ./afl-fuzz -M master $@ >/dev/null 2>&1 &
+
+watch -n1 "echo \"Executing '$AFLPATH/afl-fuzz $@' on ${NPROC:-$(nproc)} cores.\" && $AFLPATH/afl-whatsup -s ${sync_dir}"
+pkill afl-fuzz
diff --git a/tools/fuzz/x86ie/scripts/build.sh b/tools/fuzz/x86ie/scripts/build.sh
new file mode 100755
index 000000000000..032762bf56ef
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/build.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Run from root of linux via `./tools/fuzz/x86ie/scripts/build.sh`
+
+kernel_objects="arch/x86/kvm/emulate.o arch/x86/lib/retpoline.o lib/find_bit.o"
+
+disable() { sed -i -r "/\b$1\b/c\# $1" .config; }
+enable() { sed -i -r "/\b$1\b/c\\$1=y" .config; }
+
+make ${CC:+ "CC=$CC"} ${DEBUG:+ "DEBUG=1"} defconfig
+
+enable "CONFIG_DEBUG_INFO"
+enable "CONFIG_STACKPROTECTOR"
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
index 000000000000..0571cd524c01
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
+screen bash -c "ulimit -Sv $[21999999999 << 10]; ./tools/fuzz/x86ie/scripts/afl-many -m 22000000000 -i $FUZZDIR/in -o $FUZZDIR/out tools/fuzz/x86ie/afl-harness @@"
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



