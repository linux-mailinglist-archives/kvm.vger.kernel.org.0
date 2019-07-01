Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2A5BC42
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 14:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfGAM7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 08:59:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727827AbfGAM67 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 08:58:59 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61CuwHA019758
        for <kvm@vger.kernel.org>; Mon, 1 Jul 2019 08:58:57 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tfgnmy8ak-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Jul 2019 08:58:57 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 1 Jul 2019 13:58:55 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 13:58:51 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61Cwo9r46530586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 12:58:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D45DD42045;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC37B42042;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 12:58:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 81AB6E0506; Mon,  1 Jul 2019 14:58:50 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [GIT PULL 5/7] KVM: selftests: Add the sync_regs test for s390x
Date:   Mon,  1 Jul 2019 14:58:46 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701125848.276133-1-borntraeger@de.ibm.com>
References: <20190701125848.276133-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070112-0028-0000-0000-0000037F5786
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070112-0029-0000-0000-0000243F8D3B
Message-Id: <20190701125848.276133-6-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=859 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

The test is an adaption of the same test for x86. Note that there
are some differences in the way how s390x deals with the kvm_valid_regs
in struct kvm_run, so some of the tests had to be removed. Also this
test is not using the ucall() interface on s390x yet (which would need
some work to be usable on s390x), so it simply drops out of the VM with
a diag 0x501 breakpoint instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20190523164309.13345-8-thuth@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/kvm/Makefile          |   2 +
 .../selftests/kvm/s390x/sync_regs_test.c      | 151 ++++++++++++++++++
 3 files changed, 154 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/sync_regs_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 68ce91fffeaf9..c8264e9723640 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8674,6 +8674,7 @@ F:	arch/s390/include/asm/gmap.h
 F:	arch/s390/include/asm/kvm*
 F:	arch/s390/kvm/
 F:	arch/s390/mm/gmap.c
+F:	tools/testing/selftests/kvm/s390x/
 F:	tools/testing/selftests/kvm/*/s390x/
 
 KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b4a07cd0b48e8..ed8eb6007566b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -30,6 +30,8 @@ TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 
+TEST_GEN_PROGS_s390x += s390x/sync_regs_test
+
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
 
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
new file mode 100644
index 0000000000000..e85ff0d695489
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test for s390x KVM_CAP_SYNC_REGS
+ *
+ * Based on the same test for x86:
+ * Copyright (C) 2018, Google LLC.
+ *
+ * Adaptions for s390x:
+ * Copyright (C) 2019, Red Hat, Inc.
+ *
+ * Test expected behavior of the KVM_CAP_SYNC_REGS functionality.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+
+#define VCPU_ID 5
+
+static void guest_code(void)
+{
+	for (;;) {
+		asm volatile ("diag 0,0,0x501");
+		asm volatile ("ahi 11,1");
+	}
+}
+
+#define REG_COMPARE(reg) \
+	TEST_ASSERT(left->reg == right->reg, \
+		    "Register " #reg \
+		    " values did not match: 0x%llx, 0x%llx\n", \
+		    left->reg, right->reg)
+
+static void compare_regs(struct kvm_regs *left, struct kvm_sync_regs *right)
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		REG_COMPARE(gprs[i]);
+}
+
+static void compare_sregs(struct kvm_sregs *left, struct kvm_sync_regs *right)
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		REG_COMPARE(acrs[i]);
+
+	for (i = 0; i < 16; i++)
+		REG_COMPARE(crs[i]);
+}
+
+#undef REG_COMPARE
+
+#define TEST_SYNC_FIELDS   (KVM_SYNC_GPRS|KVM_SYNC_ACRS|KVM_SYNC_CRS)
+#define INVALID_SYNC_FIELD 0x80000000
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	int rv, cap;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	cap = kvm_check_cap(KVM_CAP_SYNC_REGS);
+	if (!cap) {
+		fprintf(stderr, "CAP_SYNC_REGS not supported, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	/* Request and verify all valid register sets. */
+	run->kvm_valid_regs = TEST_SYNC_FIELDS;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
+		    "Unexpected exit reason: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->s390_sieic.icptcode == 4 &&
+		    (run->s390_sieic.ipa >> 8) == 0x83 &&
+		    (run->s390_sieic.ipb >> 16) == 0x501,
+		    "Unexpected interception code: ic=%u, ipa=0x%x, ipb=0x%x\n",
+		    run->s390_sieic.icptcode, run->s390_sieic.ipa,
+		    run->s390_sieic.ipb);
+
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	compare_regs(&regs, &run->s.regs);
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	compare_sregs(&sregs, &run->s.regs);
+
+	/* Set and verify various register values */
+	run->s.regs.gprs[11] = 0xBAD1DEA;
+	run->s.regs.acrs[0] = 1 << 11;
+
+	run->kvm_valid_regs = TEST_SYNC_FIELDS;
+	run->kvm_dirty_regs = KVM_SYNC_GPRS | KVM_SYNC_ACRS;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
+		    "Unexpected exit reason: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->s.regs.gprs[11] == 0xBAD1DEA + 1,
+		    "r11 sync regs value incorrect 0x%llx.",
+		    run->s.regs.gprs[11]);
+	TEST_ASSERT(run->s.regs.acrs[0]  == 1 << 11,
+		    "acr0 sync regs value incorrect 0x%llx.",
+		    run->s.regs.acrs[0]);
+
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	compare_regs(&regs, &run->s.regs);
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	compare_sregs(&sregs, &run->s.regs);
+
+	/* Clear kvm_dirty_regs bits, verify new s.regs values are
+	 * overwritten with existing guest values.
+	 */
+	run->kvm_valid_regs = TEST_SYNC_FIELDS;
+	run->kvm_dirty_regs = 0;
+	run->s.regs.gprs[11] = 0xDEADBEEF;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv == 0, "vcpu_run failed: %d\n", rv);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
+		    "Unexpected exit reason: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->s.regs.gprs[11] != 0xDEADBEEF,
+		    "r11 sync regs value incorrect 0x%llx.",
+		    run->s.regs.gprs[11]);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.21.0

