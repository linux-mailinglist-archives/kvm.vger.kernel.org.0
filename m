Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921BF2C664A
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgK0NGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:06:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729913AbgK0NGn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:06:43 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCWU4g077744;
        Fri, 27 Nov 2020 08:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TZb3+25OYPpC7CLJUMjw3gAGF4D7izfHewrWqwJu1Yg=;
 b=qUILGXGfk9m+tD7n+KpY2Wt0XLdfwcdpwg38v+C0qrRzZ76JPJ5Uau68x9g8i04GaMu/
 ZBHeZCrPcOpIU0IKcZKQS3wQEcDPhvKMedL8pH60g31W75EkXiIu8Jf/Mzl6hZL3T9Ny
 ZJLiatVg39P03/qa4tKXxcz4MbKr/As8r+01v7PsjfsRyX6WtG+cbG3uU0GQEF8i+653
 s/zzyaZYQ0gkWrY3wbp0KqyaJ+iF5W9L4w7e0GRBzOV5oRUyVHrrYHw4Wbr6csW3lztk
 JjyvbdKUYgvqiMCdfYq6oq6zJYIO/A9cvrqPqHhcwPseRwuJhS1av4fHQKOce3TqJSai 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352y6ud17u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:06:43 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARCXqkJ082005;
        Fri, 27 Nov 2020 08:06:42 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 352y6ud172-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:06:42 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCRJXv028518;
        Fri, 27 Nov 2020 13:06:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 352kgk8mq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:06:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARD6bQB39518700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 13:06:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B260D4C046;
        Fri, 27 Nov 2020 13:06:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE2984C071;
        Fri, 27 Nov 2020 13:06:36 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 13:06:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 5/7] s390x: sie: Add first SIE test
Date:   Fri, 27 Nov 2020 08:06:27 -0500
Message-Id: <20201127130629.120469-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127130629.120469-1-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_06:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get the correct interception data on a few
diags. This commit is more of an addition of boilerplate code than a
real test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/sie.c         | 125 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 129 insertions(+)
 create mode 100644 s390x/sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index b079a26..7a95092 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -19,6 +19,7 @@ tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
+tests += $(TEST_DIR)/sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/sie.c b/s390x/sie.c
new file mode 100644
index 0000000..41b429a
--- /dev/null
+++ b/s390x/sie.c
@@ -0,0 +1,125 @@
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/arch_def.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <alloc_page.h>
+#include <vmalloc.h>
+#include <asm/facility.h>
+#include <mmu.h>
+#include <sclp.h>
+#include <sie.h>
+
+static u8 *guest;
+static u8 *guest_instr;
+static struct vm vm;
+
+static void handle_validity(struct vm *vm)
+{
+	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
+}
+
+static void sie(struct vm *vm)
+{
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		if (vm->sblk->icptcode == 32)
+		    handle_validity(vm);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
+static void sblk_cleanup(struct vm *vm)
+{
+	vm->sblk->icptcode = 0;
+}
+
+static void intercept_diag_10(void)
+{
+	u32 instr = 0x83020010;
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x100000,
+	       "Diag 10 intercept");
+	sblk_cleanup(&vm);
+}
+
+static void intercept_diag_44(void)
+{
+	u32 instr = 0x83020044;
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x440000,
+	       "Diag 44 intercept");
+	sblk_cleanup(&vm);
+}
+
+static void intercept_diag_9c(void)
+{
+	u32 instr = 0x8302009c;
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x9c0000,
+	       "Diag 9c intercept");
+	sblk_cleanup(&vm);
+}
+
+static void setup_guest(void)
+{
+	setup_vm();
+
+	/* Allocate 1MB as guest memory */
+	guest = alloc_pages(8);
+	/* The first two pages are the lowcore */
+	guest_instr = guest + PAGE_SIZE * 2;
+
+	vm.sblk = alloc_page();
+
+	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm.sblk->prefix = 0;
+	/*
+	 * Pageable guest with the same ASCE as the test programm, but
+	 * the guest memory 0x0 is offset to start at the allocated
+	 * guest pages and end after 1MB.
+	 *
+	 * It's not pretty but faster and easier than managing guest ASCEs.
+	 */
+	vm.sblk->mso = (u64)guest;
+	vm.sblk->msl = (u64)guest;
+	vm.sblk->ihcpu = 0xffff;
+
+	vm.sblk->crycbd = (uint64_t)alloc_page();
+}
+
+int main(void)
+{
+	report_prefix_push("sie");
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+
+	setup_guest();
+	intercept_diag_10();
+	intercept_diag_44();
+	intercept_diag_9c();
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3feb8bc..2298be6 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -96,3 +96,6 @@ smp = 2
 
 [uv-guest]
 file = uv-guest.elf
+
+[sie]
+file = sie.elf
-- 
2.25.1

