Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A53BA9D4B
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbfIEIks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:40:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731814AbfIEIkl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 04:40:41 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x858bZIP032767
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 04:40:40 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2usu18k54n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 04:40:39 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 09:40:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 09:40:33 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x858eXqg57278490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 08:40:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D58E2A404D;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C25CA4065;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Sep 2019 08:40:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, frankja@linux.vnet.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [GIT PULL 2/8] KVM: selftests: Implement ucall() for s390x
Date:   Thu,  5 Sep 2019 10:40:03 +0200
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190905084009.26106-1-frankja@linux.ibm.com>
References: <20190905084009.26106-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19090508-0008-0000-0000-00000311593C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090508-0009-0000-0000-00004A2FB1A2
Message-Id: <20190905084009.26106-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=701 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

On s390x, we can neither exit via PIO nor MMIO, but have to use an
instruction like DIAGNOSE. Now that ucall() is implemented, we can
use it in the sync_reg_test on s390x, too.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20190731151525.17156-3-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c | 56 +++++++++++++++++++
 .../selftests/kvm/s390x/sync_regs_test.c      |  6 +-
 3 files changed, 61 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/ucall.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a51e3b83df40..75ea1ecbf85a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -10,7 +10,7 @@ UNAME_M := $(shell uname -m)
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c
 LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/ucall.c
 LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
-LIBKVM_s390x = lib/s390x/processor.c
+LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
new file mode 100644
index 000000000000..fd589dc9bfab
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucall support. A ucall is a "hypercall to userspace".
+ *
+ * Copyright (C) 2019 Red Hat, Inc.
+ */
+#include "kvm_util.h"
+
+void ucall_init(struct kvm_vm *vm, void *arg)
+{
+}
+
+void ucall_uninit(struct kvm_vm *vm)
+{
+}
+
+void ucall(uint64_t cmd, int nargs, ...)
+{
+	struct ucall uc = {
+		.cmd = cmd,
+	};
+	va_list va;
+	int i;
+
+	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
+
+	va_start(va, nargs);
+	for (i = 0; i < nargs; ++i)
+		uc.args[i] = va_arg(va, uint64_t);
+	va_end(va);
+
+	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
+	asm volatile ("diag 0,%0,0x501" : : "a"(&uc) : "memory");
+}
+
+uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
+{
+	struct kvm_run *run = vcpu_state(vm, vcpu_id);
+	struct ucall ucall = {};
+
+	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
+	    run->s390_sieic.icptcode == 4 &&
+	    (run->s390_sieic.ipa >> 8) == 0x83 &&    /* 0x83 means DIAGNOSE */
+	    (run->s390_sieic.ipb >> 16) == 0x501) {
+		int reg = run->s390_sieic.ipa & 0xf;
+
+		memcpy(&ucall, addr_gva2hva(vm, run->s.regs.gprs[reg]),
+		       sizeof(ucall));
+
+		vcpu_run_complete_io(vm, vcpu_id);
+		if (uc)
+			memcpy(uc, &ucall, sizeof(ucall));
+	}
+
+	return ucall.cmd;
+}
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index e85ff0d69548..bbc93094519b 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -25,9 +25,11 @@
 
 static void guest_code(void)
 {
+	register u64 stage asm("11") = 0;
+
 	for (;;) {
-		asm volatile ("diag 0,0,0x501");
-		asm volatile ("ahi 11,1");
+		GUEST_SYNC(0);
+		asm volatile ("ahi %0,1" : : "r"(stage));
 	}
 }
 
-- 
2.20.1

