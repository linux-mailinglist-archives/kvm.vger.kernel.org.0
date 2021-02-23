Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37DE322BF6
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhBWOI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:08:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231410AbhBWOIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:08:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NE2XT2093781;
        Tue, 23 Feb 2021 09:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rQJIUD8UdjMFcq/jji/c+oXDBTOSJRCyUWkqtQhD/aM=;
 b=ZXJpSQdKVFwvAllLwnidvDeZ6p0YDUBR5Kx4PW1haWHE92LWqnbeISfsYPZGWD1uAEvw
 E27O/uEfFz3kF1DQ3OWeA0FB+eTlg2cLXJkBNNF0VTTrpV+BLTcw8updIKMmP6j1B6Ep
 7li1lp2RRvlvyw/lmJDNasIM9bN9jxD/EbSbW6jrVwz6t2vxpwlPVUFux81uLOST2wo/
 0QA3UQn8eRcRZGzVleH4knBmOz3zCWk5b8IU91J4n0xzVZpevexgH+qXrvmnLUDBWA8o
 ycGoSJaAVjBtVtxI3rtC62yiLanjk6h8nJjAG9wPzZvRAn9Kv4mU6vkt84zXP7Fpjj6Q ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkn1ax8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:08 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NE2cB5094262;
        Tue, 23 Feb 2021 09:08:07 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkn1ax6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:07 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NE86TV017818;
        Tue, 23 Feb 2021 14:08:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph2num-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:08:05 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NE83k334079226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:08:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0598AA407E;
        Tue, 23 Feb 2021 14:08:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99448A4080;
        Tue, 23 Feb 2021 14:08:02 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:08:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/5] s390x: edat test
Date:   Tue, 23 Feb 2021 15:07:59 +0100
Message-Id: <20210223140759.255670-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223140759.255670-1-imbrenda@linux.ibm.com>
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simple EDAT test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/edat.c        | 285 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 289 insertions(+)
 create mode 100644 s390x/edat.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 08d85c9f..fc885150 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -20,6 +20,7 @@ tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
 tests += $(TEST_DIR)/sie.elf
+tests += $(TEST_DIR)/edat.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/edat.c b/s390x/edat.c
new file mode 100644
index 00000000..0bd16efc
--- /dev/null
+++ b/s390x/edat.c
@@ -0,0 +1,285 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * EDAT test.
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *	Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <vmalloc.h>
+#include <asm/facility.h>
+#include <asm/interrupt.h>
+#include <mmu.h>
+#include <asm/pgtable.h>
+#include <asm-generic/barrier.h>
+
+#define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
+
+#define TEID_ADDR	PAGE_MASK
+#define TEID_AI		0x003
+#define TEID_M		0x004
+#define TEID_A		0x008
+#define TEID_FS		0xc00
+
+#define LC_SIZE	(2 * PAGE_SIZE)
+#define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
+
+static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
+static unsigned int tmp[1024] __attribute__((aligned(PAGE_SIZE)));
+static void *root, *mem, *m;
+static struct lowcore *lc;
+volatile unsigned int *p;
+
+/* Expect a program interrupt, and clear the TEID */
+static void expect_dat_fault(void)
+{
+	expect_pgm_int();
+	lc->trans_exc_id = 0;
+}
+
+/*
+ * Check if a non-access-list protection exception happened for the given
+ * address, in the primary address space.
+ */
+static bool check_pgm_prot(void *ptr)
+{
+	unsigned long teid = lc->trans_exc_id;
+
+	if (lc->pgm_int_code != PGM_INT_CODE_PROTECTION)
+		return false;
+	/*
+	 * if for any reason TEID_M is not present, the rest of the field is
+	 * not meaningful, so no point in checking it
+	 */
+	if (~teid & TEID_M)
+		return true;
+	return (~teid & TEID_A) &&
+		((teid & TEID_ADDR) == ((uint64_t)ptr & PAGE_MASK)) &&
+		!(teid & TEID_AI);
+}
+
+static void test_dat(void)
+{
+	report_prefix_push("edat off");
+	/* disable EDAT */
+	ctl_clear_bit(0, 23);
+
+	/* Check some basics */
+	p[0] = 42;
+	report(p[0] == 42, "pte, r/w");
+	p[0] = 0;
+
+	/* Write protect the page and try to write, expect a fault */
+	protect_page(m, PAGE_ENTRY_P);
+	expect_dat_fault();
+	p[0] = 42;
+	unprotect_page(m, PAGE_ENTRY_P);
+	report(!p[0] && check_pgm_prot(m), "pte, ro");
+
+	/*
+	 * The FC bit (for large pages) should be ignored because EDAT is
+	 * off. We set a value and then we try to read it back again after
+	 * setting the FC bit. This way we can check if large pages were
+	 * erroneously enabled despite EDAT being off.
+	 */
+	p[0] = 42;
+	protect_dat_entry(m, SEGMENT_ENTRY_FC, 4);
+	report(p[0] == 42, "pmd, fc=1, r/w");
+	unprotect_dat_entry(m, SEGMENT_ENTRY_FC, 4);
+	p[0] = 0;
+
+	/*
+	 * Segment protection should work even with EDAT off, try to write
+	 * anyway and expect a fault
+	 */
+	protect_dat_entry(m, SEGMENT_ENTRY_P, 4);
+	expect_dat_fault();
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pmd, ro");
+	unprotect_dat_entry(m, SEGMENT_ENTRY_P, 4);
+
+	/* The FC bit should be ignored because EDAT is off, like above */
+	p[0] = 42;
+	protect_dat_entry(m, REGION3_ENTRY_FC, 3);
+	report(p[0] == 42, "pud, fc=1, r/w");
+	unprotect_dat_entry(m, REGION3_ENTRY_FC, 3);
+	p[0] = 0;
+
+	/*
+	 * Region1/2/3 protection should not work, because EDAT is off.
+	 * Protect the various region1/2/3 entries and write, expect the
+	 * write to be successful.
+	 */
+	protect_dat_entry(m, REGION_ENTRY_P, 3);
+	p[0] = 42;
+	report(p[0] == 42, "pud, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, 3);
+	p[0] = 0;
+
+	protect_dat_entry(m, REGION_ENTRY_P, 2);
+	p[0] = 42;
+	report(p[0] == 42, "p4d, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, 2);
+	p[0] = 0;
+
+	protect_dat_entry(m, REGION_ENTRY_P, 1);
+	p[0] = 42;
+	report(p[0] == 42, "pgd, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, 1);
+	p[0] = 0;
+
+	report_prefix_pop();
+}
+
+static void test_edat1(void)
+{
+	report_prefix_push("edat1");
+	/* Enable EDAT */
+	ctl_set_bit(0, 23);
+	p[0] = 0;
+
+	/*
+	 * Segment protection should work normally, try to write and expect
+	 * a fault.
+	 */
+	expect_dat_fault();
+	protect_dat_entry(m, SEGMENT_ENTRY_P, 4);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pmd, ro");
+	unprotect_dat_entry(m, SEGMENT_ENTRY_P, 4);
+
+	/*
+	 * Region1/2/3 protection should work now, because EDAT is on. Try
+	 * to write anyway and expect a fault.
+	 */
+	expect_dat_fault();
+	protect_dat_entry(m, REGION_ENTRY_P, 3);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pud, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, 3);
+
+	expect_dat_fault();
+	protect_dat_entry(m, REGION_ENTRY_P, 2);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "p4d, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, 2);
+
+	expect_dat_fault();
+	protect_dat_entry(m, REGION_ENTRY_P, 1);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pgd, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, 1);
+
+	/* Large pages should work */
+	p[0] = 42;
+	install_large_page(root, 0, mem);
+	report(p[0] == 42, "pmd, large");
+
+	/*
+	 * Prefixing should not work with large pages. Since the lower
+	 * addresses are mapped with small pages, which are subject to
+	 * prefixing, and the pages mapped with large pages are not subject
+	 * to prefixing, this is the resulting scenario:
+	 *
+	 * virtual 0 = real 0 -> absolute prefix_buf
+	 * virtual prefix_buf = real prefix_buf -> absolute 0
+	 * VIRT(0) -> absolute 0
+	 * VIRT(prefix_buf) -> absolute prefix_buf
+	 *
+	 * The testcase checks if the memory at virtual 0 has the same
+	 * content as the memory at VIRT(prefix_buf) and the memory at
+	 * VIRT(0) has the same content as the memory at virtual prefix_buf.
+	 * If prefixing is erroneously applied for large pages, the testcase
+	 * will therefore fail.
+	 */
+	report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
+		!memcmp(prefix_buf, VIRT(0), LC_SIZE),
+		"pmd, large, prefixing");
+
+	report_prefix_pop();
+}
+
+static void test_edat2(void)
+{
+	report_prefix_push("edat2");
+	p[0] = 42;
+
+	/* Huge pages should work */
+	install_huge_page(root, 0, mem);
+	report(p[0] == 42, "pud, huge");
+
+	/* Prefixing should not work with huge pages, just like large pages */
+	report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
+		!memcmp(prefix_buf, VIRT(0), LC_SIZE),
+		"pmd, large, prefixing");
+
+	report_prefix_pop();
+}
+
+static unsigned int setup(void)
+{
+	bool has_edat1 = test_facility(8);
+	bool has_edat2 = test_facility(78);
+	unsigned long pa, va;
+
+	if (has_edat2 && !has_edat1)
+		report_abort("EDAT2 available, but EDAT1 not available");
+
+	/* Setup DAT 1:1 mapping and memory management */
+	setup_vm();
+	root = (void *)(stctg(1) & PAGE_MASK);
+
+	/*
+	 * Get a pgd worth of virtual memory, so we can test things later
+	 * without interfering with the test code or the interrupt handler
+	 */
+	mem = alloc_vpages_aligned(BIT_ULL(PGD_PAGE_SHIFT), PGD_PAGE_SHIFT);
+	assert(mem);
+	va = (unsigned long)mem;
+
+	/* Map the first 1GB of real memory */
+	for (pa = 0; pa < SZ_1G; pa += PAGE_SIZE, va += PAGE_SIZE)
+		install_page(root, pa, (void *)va);
+
+	/*
+	 * Move the lowcore to a known non-zero location. This is needed
+	 * later to check whether prefixing is working with large pages.
+	 */
+	assert((unsigned long)&prefix_buf < SZ_2G);
+	memcpy(prefix_buf, 0, LC_SIZE);
+	set_prefix((uint32_t)(uintptr_t)prefix_buf);
+	/* Clear the old copy */
+	memset(prefix_buf, 0, LC_SIZE);
+
+	/* m will point to tmp through the new virtual mapping */
+	m = VIRT(&tmp);
+	/* p is the same as m but volatile */
+	p = (volatile unsigned int *)m;
+
+	return has_edat1 + has_edat2;
+}
+
+int main(void)
+{
+	unsigned int edat;
+
+	report_prefix_push("edat");
+	edat = setup();
+
+	test_dat();
+
+	if (edat)
+		test_edat1();
+	else
+		report_skip("EDAT not available");
+
+	if (edat >= 2)
+		test_edat2();
+	else
+		report_skip("EDAT2 not available");
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 2298be6c..8da4a0a3 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -99,3 +99,6 @@ file = uv-guest.elf
 
 [sie]
 file = sie.elf
+
+[edat]
+file = edat.elf
-- 
2.26.2

