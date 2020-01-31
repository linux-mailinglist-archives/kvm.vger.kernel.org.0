Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84B014EF16
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgAaPEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:04:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729188AbgAaPEZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:04:25 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VExanq021212
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:04:23 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xv7deqygh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:04:22 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:03:54 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:03:52 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF3p2q27656200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:03:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5038152052;
        Fri, 31 Jan 2020 15:03:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 429015205A;
        Fri, 31 Jan 2020 15:03:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 028FEE0378; Fri, 31 Jan 2020 16:03:51 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 6/7] selftests: KVM: s390x: Add reset tests
Date:   Fri, 31 Jan 2020 16:03:47 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150348.73360-1-borntraeger@de.ibm.com>
References: <20200131150348.73360-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20013115-0020-0000-0000-000003A5DF14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0021-0000-0000-000021FD997C
Message-Id: <20200131150348.73360-7-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 5 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Test if the registers end up having the correct values after a normal,
initial and clear reset.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20200131100205.74720-6-frankja@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/Makefile       |   1 +
 tools/testing/selftests/kvm/s390x/resets.c | 155 +++++++++++++++++++++
 2 files changed, 156 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/resets.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 3138a916574a..fe1ea294730c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -36,6 +36,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
+TEST_GEN_PROGS_s390x += s390x/resets
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
new file mode 100644
index 000000000000..fb8e976943a9
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test for s390x CPU resets
+ *
+ * Copyright (C) 2020, IBM
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
+#define VCPU_ID 3
+
+struct kvm_vm *vm;
+struct kvm_run *run;
+struct kvm_sync_regs *regs;
+static uint64_t regs_null[16];
+
+static uint64_t crs[16] = { 0x40000ULL,
+			    0x42000ULL,
+			    0, 0, 0, 0, 0,
+			    0x43000ULL,
+			    0, 0, 0, 0, 0,
+			    0x44000ULL,
+			    0, 0
+};
+
+static void guest_code_initial(void)
+{
+	/* Round toward 0 */
+	uint32_t fpc = 0x11;
+
+	/* Dirty registers */
+	asm volatile (
+		"	lctlg	0,15,%0\n"
+		"	sfpc	%1\n"
+		: : "Q" (crs), "d" (fpc));
+	GUEST_SYNC(0);
+}
+
+static void test_one_reg(uint64_t id, uint64_t value)
+{
+	struct kvm_one_reg reg;
+	uint64_t eval_reg;
+
+	reg.addr = (uintptr_t)&eval_reg;
+	reg.id = id;
+	vcpu_get_reg(vm, VCPU_ID, &reg);
+	TEST_ASSERT(eval_reg == value, "value == %s", value);
+}
+
+static void assert_clear(void)
+{
+	struct kvm_sregs sregs;
+	struct kvm_regs regs;
+	struct kvm_fpu fpu;
+
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	TEST_ASSERT(!memcmp(&regs.gprs, regs_null, sizeof(regs.gprs)), "grs == 0");
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(!memcmp(&sregs.acrs, regs_null, sizeof(sregs.acrs)), "acrs == 0");
+
+	vcpu_fpu_get(vm, VCPU_ID, &fpu);
+	TEST_ASSERT(!memcmp(&fpu.fprs, regs_null, sizeof(fpu.fprs)), "fprs == 0");
+}
+
+static void assert_initial(void)
+{
+	struct kvm_sregs sregs;
+	struct kvm_fpu fpu;
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(sregs.crs[0] == 0xE0UL, "cr0 == 0xE0");
+	TEST_ASSERT(sregs.crs[14] == 0xC2000000UL, "cr14 == 0xC2000000");
+	TEST_ASSERT(!memcmp(&sregs.crs[1], regs_null, sizeof(sregs.crs[1]) * 12),
+		    "cr1-13 == 0");
+	TEST_ASSERT(sregs.crs[15] == 0, "cr15 == 0");
+
+	vcpu_fpu_get(vm, VCPU_ID, &fpu);
+	TEST_ASSERT(!fpu.fpc, "fpc == 0");
+
+	test_one_reg(KVM_REG_S390_GBEA, 1);
+	test_one_reg(KVM_REG_S390_PP, 0);
+	test_one_reg(KVM_REG_S390_TODPR, 0);
+	test_one_reg(KVM_REG_S390_CPU_TIMER, 0);
+	test_one_reg(KVM_REG_S390_CLOCK_COMP, 0);
+}
+
+static void assert_normal(void)
+{
+	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
+}
+
+static void test_normal(void)
+{
+	printf("Testing normal reset\n");
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
+	run = vcpu_state(vm, VCPU_ID);
+	regs = &run->s.regs;
+
+	vcpu_run(vm, VCPU_ID);
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
+	assert_normal();
+	kvm_vm_free(vm);
+}
+
+static void test_initial(void)
+{
+	printf("Testing initial reset\n");
+	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
+	run = vcpu_state(vm, VCPU_ID);
+	regs = &run->s.regs;
+
+	vcpu_run(vm, VCPU_ID);
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
+	assert_normal();
+	assert_initial();
+	kvm_vm_free(vm);
+}
+
+static void test_clear(void)
+{
+	printf("Testing clear reset\n");
+	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
+	run = vcpu_state(vm, VCPU_ID);
+	regs = &run->s.regs;
+
+	vcpu_run(vm, VCPU_ID);
+
+	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
+	assert_normal();
+	assert_initial();
+	assert_clear();
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
+
+	test_initial();
+	if (kvm_check_cap(KVM_CAP_S390_VCPU_RESETS)) {
+		test_normal();
+		test_clear();
+	}
+	return 0;
+}
-- 
2.21.0

