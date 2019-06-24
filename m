Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE62950DE1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfFXOZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:25:13 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:55786 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbfFXOZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561386311; x=1592922311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=yaQAXworocGm7R2TINDI0hGKhCHD7XX0PtX7y1HukTE=;
  b=eBk2MYpPoKE1KhMDxpIVZaGlc8oIryuZCvb3kqg9sG/IaAAc3bI4hBCn
   CZR+nFvGRtR81hlrNeY6FkcXPEKdOTl5pa2nYRLqTJg3vHVyhM7JXazG7
   iBgt/kioMa1xyPjVKvOxOMN/qlWCvsvP73fegR2gdknJd5DVehdZvPLgj
   E=;
X-IronPort-AV: E=Sophos;i="5.62,412,1554768000"; 
   d="scan'208";a="771743168"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Jun 2019 14:25:11 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 17D01A2719;
        Mon, 24 Jun 2019 14:25:06 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:50 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:48 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:24:43 +0000
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
Subject: [PATCH v3 5/5] Development scripts for crash triage and deploy
Date:   Mon, 24 Jun 2019 16:24:14 +0200
Message-ID: <20190624142414.22096-6-samcacc@amazon.de>
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

Not meant for upstream consumption.

---

v2 -> v3:
 - Introduced this patch as a place for non-essential dev scripts

Signed-off-by: Sam Caccavale <samcacc@amazon.de>
---
 tools/fuzz/x86ie/scripts/bin.sh               | 49 +++++++++++++++++++
 tools/fuzz/x86ie/scripts/coalesce.sh          |  5 ++
 tools/fuzz/x86ie/scripts/deploy.sh            |  9 ++++
 tools/fuzz/x86ie/scripts/deploy_remote.sh     |  9 ++++
 tools/fuzz/x86ie/scripts/gen_output.sh        | 11 +++++
 .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |  5 ++
 tools/fuzz/x86ie/scripts/rebuild.sh           |  6 +++
 tools/fuzz/x86ie/scripts/summarize.sh         |  9 ++++
 8 files changed, 103 insertions(+)
 create mode 100755 tools/fuzz/x86ie/scripts/bin.sh
 create mode 100755 tools/fuzz/x86ie/scripts/coalesce.sh
 create mode 100644 tools/fuzz/x86ie/scripts/deploy.sh
 create mode 100755 tools/fuzz/x86ie/scripts/deploy_remote.sh
 create mode 100755 tools/fuzz/x86ie/scripts/gen_output.sh
 create mode 100755 tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
 create mode 100755 tools/fuzz/x86ie/scripts/rebuild.sh
 create mode 100755 tools/fuzz/x86ie/scripts/summarize.sh

diff --git a/tools/fuzz/x86ie/scripts/bin.sh b/tools/fuzz/x86ie/scripts/bin.sh
new file mode 100755
index 000000000000..6383a883ff33
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/bin.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+if [ "$#" -lt 3 ]; then
+  echo "Usage: './bin path/to/afl-harness path/to/afl_crash [path/to/linux/src/root]'"
+  exit
+fi
+
+export AFL_HARNESS="$1"
+export LINUX_SRC="$3"
+
+diagnose_segfault() {
+  SOURCE=$(gdb -batch -ex r -ex 'bt 2' --args $@ 2>&1 | grep -Po '#1.* \K([^ ]+:[0-9]+)');
+  IFS=: read FILE LINE <<< "$SOURCE"
+
+  OP="$(sed -n "${LINE}p" "$LINUX_SRC/$FILE" 2>/dev/null)"
+  if [ $? -ne 0 ]; then
+    OP="$(sed -n "${LINE}p" "$LINUX_SRC/tools/fuzz/x86_instruction_emulation/$FILE" 2>/dev/null)"
+  fi
+
+  OP="$(echo $OP | grep -Po 'ops->\K([^(]+)')"
+  if [ -z "$OP" ]; then
+    echo "SEGV: unknown, in $FILE:$LINE"
+  else
+    echo "Expected: segfaulting on emulator->$OP"
+  fi
+}
+export -f diagnose_segfault
+
+bin() {
+  OUTPUT=$(bash -c "timeout 1s $AFL_HARNESS $1 2>&1" 2>&1)
+  RETVAL=$?
+
+  echo "$OUTPUT"
+  if [ $RETVAL -eq 0 ]; then
+    echo "Terminated successfully"
+  elif [ $RETVAL -eq 124 ]; then
+    echo "Unknown: killed due to timeout.  Loop likely."
+  elif echo "$OUTPUT" | grep -q "SEGV"; then
+    echo "$(diagnose_segfault $AFL_HARNESS $1)"
+  elif echo "$OUTPUT" | grep -q "FPE"; then
+    echo "Expected: floating point exception."
+  else
+    echo "Unknown cause of crash."
+  fi
+}
+export -f bin
+
+echo "$(bin $2 2>&1)"
diff --git a/tools/fuzz/x86ie/scripts/coalesce.sh b/tools/fuzz/x86ie/scripts/coalesce.sh
new file mode 100755
index 000000000000..b15d583c2c32
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/coalesce.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+mkdir -p all
+rm -rf all/*
+find . -type f -wholename '*crashes/id*' | parallel 'cp {} ./all/$(basename $(dirname {//})):{/}'
diff --git a/tools/fuzz/x86ie/scripts/deploy.sh b/tools/fuzz/x86ie/scripts/deploy.sh
new file mode 100644
index 000000000000..f95c3aa2b5b5
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/deploy.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+REMOTE=$1
+DSTDIR=/dev/shm
+
+rsync -av $(pwd) $REMOTE:$DSTDIR
+
+ssh $REMOTE "cd $DSTDIR/$(basename $(pwd)); bash -s tools/fuzz/x86_instruction_emulation/scripts/deploy_remote.sh"
diff --git a/tools/fuzz/x86ie/scripts/deploy_remote.sh b/tools/fuzz/x86ie/scripts/deploy_remote.sh
new file mode 100755
index 000000000000..1279ad6eadb2
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/deploy_remote.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+SCRIPTDIR=$(pwd)/tools/fuzz/x86ie/scripts
+
+$SCRIPTDIR/install_deps_ubuntu.sh
+source $SCRIPTDIR/install_afl.sh
+CC=$AFLPATH/afl-gcc $SCRIPTDIR/build.sh
+FUZZDIR="${FUZZDIR:-$(pwd)/fuzz}" $SCRIPTDIR/run.sh
diff --git a/tools/fuzz/x86ie/scripts/gen_output.sh b/tools/fuzz/x86ie/scripts/gen_output.sh
new file mode 100755
index 000000000000..6c0707eb6d08
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/gen_output.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+if [ "$#" -lt 3 ]; then
+  echo "Usage: '$0 path/to/afl-harness path/to/afl_crash_dir path/to/linux/src/root'"
+  exit
+fi
+
+mkdir -p output
+rm -rf output/*
+find $2 -type f | parallel ./bin.sh $1 {} $3 '>' ./output/{/}.out
diff --git a/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh b/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
new file mode 100755
index 000000000000..5525bc8b659c
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+sudo apt update
+sudo apt install -y make gcc wget screen build-essential libssh-dev flex bison libelf-dev bc
diff --git a/tools/fuzz/x86ie/scripts/rebuild.sh b/tools/fuzz/x86ie/scripts/rebuild.sh
new file mode 100755
index 000000000000..809a4551cb0c
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/rebuild.sh
@@ -0,0 +1,6 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+make clean
+make tools/fuzz_clean
+FUZZDIR="./fuzz" ./tools/fuzz/x86ie/scripts/build.sh
diff --git a/tools/fuzz/x86ie/scripts/summarize.sh b/tools/fuzz/x86ie/scripts/summarize.sh
new file mode 100755
index 000000000000..27761f283ee3
--- /dev/null
+++ b/tools/fuzz/x86ie/scripts/summarize.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+
+if [ "$#" -lt 1 ]; then
+  echo "Usage: '$0 path/to/output/dir'"
+  exit
+fi
+
+time bash -c "find $1 -type f -exec tail -n 1 {} \; | sort | uniq -c | sort -rn"
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



