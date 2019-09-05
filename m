Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522E7A9D49
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732783AbfIEIkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:40:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35168 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732775AbfIEIkn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Sep 2019 04:40:43 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x858bZSu089195
        for <kvm@vger.kernel.org>; Thu, 5 Sep 2019 04:40:42 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ut0m7h5kq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 04:40:41 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 5 Sep 2019 09:40:39 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Sep 2019 09:40:35 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x858eAFF30671282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Sep 2019 08:40:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B6E9A405E;
        Thu,  5 Sep 2019 08:40:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21CE6A4053;
        Thu,  5 Sep 2019 08:40:34 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Sep 2019 08:40:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, frankja@linux.vnet.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [GIT PULL 6/8] KVM: selftests: Add a test for the KVM_S390_MEM_OP ioctl
Date:   Thu,  5 Sep 2019 10:40:07 +0200
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190905084009.26106-1-frankja@linux.ibm.com>
References: <20190905084009.26106-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19090508-0008-0000-0000-00000311593D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19090508-0009-0000-0000-00004A2FB1A3
Message-Id: <20190905084009.26106-7-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-05_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=677 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909050089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Check that we can write and read the guest memory with this s390x
ioctl, and that some error cases are handled correctly.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lkml.kernel.org/r/20190829130732.580-1-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/memop.c | 166 ++++++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/memop.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1b48a94b4350..62c591f87dab 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -32,6 +32,7 @@ TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 
+TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
new file mode 100644
index 000000000000..9edaa9a134ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test for s390x KVM_S390_MEM_OP
+ *
+ * Copyright (C) 2019, Red Hat, Inc.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+
+#define VCPU_ID 1
+
+static uint8_t mem1[65536];
+static uint8_t mem2[65536];
+
+static void guest_code(void)
+{
+	int i;
+
+	for (;;) {
+		for (i = 0; i < sizeof(mem2); i++)
+			mem2[i] = mem1[i];
+		GUEST_SYNC(0);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct kvm_s390_mem_op ksmo;
+	int rv, i, maxsize;
+
+	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
+
+	maxsize = kvm_check_cap(KVM_CAP_S390_MEM_OP);
+	if (!maxsize) {
+		fprintf(stderr, "CAP_S390_MEM_OP not supported -> skip test\n");
+		exit(KSFT_SKIP);
+	}
+	if (maxsize > sizeof(mem1))
+		maxsize = sizeof(mem1);
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	run = vcpu_state(vm, VCPU_ID);
+
+	for (i = 0; i < sizeof(mem1); i++)
+		mem1[i] = i * i + i;
+
+	/* Set the first array */
+	ksmo.gaddr = addr_gva2gpa(vm, (uintptr_t)mem1);
+	ksmo.flags = 0;
+	ksmo.size = maxsize;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 0;
+	vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+
+	/* Let the guest code copy the first array to the second */
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
+		    "Unexpected exit reason: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	memset(mem2, 0xaa, sizeof(mem2));
+
+	/* Get the second array */
+	ksmo.gaddr = (uintptr_t)mem2;
+	ksmo.flags = 0;
+	ksmo.size = maxsize;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
+	ksmo.buf = (uintptr_t)mem2;
+	ksmo.ar = 0;
+	vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+
+	TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+		    "Memory contents do not match!");
+
+	/* Check error conditions - first bad size: */
+	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.flags = 0;
+	ksmo.size = -1;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 0;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
+
+	/* Zero size: */
+	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.flags = 0;
+	ksmo.size = 0;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 0;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
+		    "ioctl allows 0 as size");
+
+	/* Bad flags: */
+	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.flags = -1;
+	ksmo.size = maxsize;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 0;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
+
+	/* Bad operation: */
+	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.flags = 0;
+	ksmo.size = maxsize;
+	ksmo.op = -1;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 0;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows bad operations");
+
+	/* Bad guest address: */
+	ksmo.gaddr = ~0xfffUL;
+	ksmo.flags = KVM_S390_MEMOP_F_CHECK_ONLY;
+	ksmo.size = maxsize;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 0;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
+
+	/* Bad host address: */
+	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.flags = 0;
+	ksmo.size = maxsize;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = 0;
+	ksmo.ar = 0;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv == -1 && errno == EFAULT,
+		    "ioctl does not report bad host memory address");
+
+	/* Bad access register: */
+	run->psw_mask &= ~(3UL << (63 - 17));
+	run->psw_mask |= 1UL << (63 - 17);  /* Enable AR mode */
+	vcpu_run(vm, VCPU_ID);              /* To sync new state to SIE block */
+	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.flags = 0;
+	ksmo.size = maxsize;
+	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+	ksmo.buf = (uintptr_t)mem1;
+	ksmo.ar = 17;
+	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows ARs > 15");
+	run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
+	vcpu_run(vm, VCPU_ID);                  /* Run to sync new state */
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.20.1

