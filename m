Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47F53AFF2B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhFVIYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:24:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230503AbhFVIYA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:24:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8Epqm023643;
        Tue, 22 Jun 2021 04:21:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=n1yjs9Odiq28YRk/MzSWSbGdVE7KrlteniojPryE4rY=;
 b=rpmkpmNY91obY8tbHoJw+QvniupR9VTwWTUSPL1jq1hpTTWO3AoBSNoIO+YENttcNXAw
 2/z6RKu/uFkCsUCT/1DA6Tma/EKdmi4p9jtSNfNe1mwXreYStCIM2dbXWhivaV4tbPdW
 tHelBmEHLnS00aR+cRF3OPyJAC/gNnhPhMPxJNjyKGwpnkogMDVBB9YqrSfglUWWwnKh
 pDAm1Lz5wxcDPpdnSpqLNKz32QPEcxiHiFcFuQRrTxHnjjSXABHNciNhooEn7lxWvnOH
 z6N4w33q/Uc+NlraIJuPws4C/6Dt71jotN5ckMFYLZ5aUr28D8gWzGG+QMsdkVeHtmjv xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bc6ar5t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:45 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M8F3pd024878;
        Tue, 22 Jun 2021 04:21:44 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bc6ar5s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:44 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8EBDU031960;
        Tue, 22 Jun 2021 08:21:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3998788q3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8Lc1U32244028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C6C8AE053;
        Tue, 22 Jun 2021 08:21:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2FD6AE04D;
        Tue, 22 Jun 2021 08:21:37 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 12/12] s390x: edat test
Date:   Tue, 22 Jun 2021 10:20:42 +0200
Message-Id: <20210622082042.13831-13-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KxOG93nzaHKJJ7LhlZm4nxUuS01LZfL1
X-Proofpoint-ORIG-GUID: Ly6h-yFt5lkZ9irp1MMT96lbe43VNoBO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Simple EDAT test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210611140705.553307-8-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/edat.c        | 274 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 3 files changed, 278 insertions(+)
 create mode 100644 s390x/edat.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 8de926ab..8820e998 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -22,6 +22,7 @@ tests += $(TEST_DIR)/uv-guest.elf
 tests += $(TEST_DIR)/sie.elf
 tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
+tests += $(TEST_DIR)/edat.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/edat.c b/s390x/edat.c
new file mode 100644
index 00000000..c3bee0c8
--- /dev/null
+++ b/s390x/edat.c
@@ -0,0 +1,274 @@
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
+#define LC_SIZE	(2 * PAGE_SIZE)
+#define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
+
+static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
+static unsigned int tmp[1024] __attribute__((aligned(PAGE_SIZE)));
+static void *root, *mem, *m;
+static struct lowcore *lc;
+volatile unsigned int *p;
+
+/*
+ * Check if a non-access-list protection exception happened for the given
+ * address, in the primary address space.
+ */
+static bool check_pgm_prot(void *ptr)
+{
+	union teid teid;
+
+	if (lc->pgm_int_code != PGM_INT_CODE_PROTECTION)
+		return false;
+
+	teid.val = lc->trans_exc_id;
+
+	/*
+	 * depending on the presence of the ESOP feature, the rest of the
+	 * field might or might not be meaningful when the m field is 0.
+	 */
+	if (!teid.m)
+		return true;
+	return (!teid.acc_list_prot && !teid.asce_id &&
+		(teid.addr == ((unsigned long)ptr >> PAGE_SHIFT)));
+}
+
+static void test_dat(void)
+{
+	report_prefix_push("edat off");
+	/* disable EDAT */
+	ctl_clear_bit(0, CTL0_EDAT);
+
+	/* Check some basics */
+	p[0] = 42;
+	report(p[0] == 42, "pte, r/w");
+	p[0] = 0;
+
+	/* Write protect the page and try to write, expect a fault */
+	protect_page(m, PAGE_ENTRY_P);
+	expect_pgm_int();
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
+	protect_dat_entry(m, SEGMENT_ENTRY_FC, pgtable_level_pmd);
+	report(p[0] == 42, "pmd, fc=1, r/w");
+	unprotect_dat_entry(m, SEGMENT_ENTRY_FC, pgtable_level_pmd);
+	p[0] = 0;
+
+	/*
+	 * Segment protection should work even with EDAT off, try to write
+	 * anyway and expect a fault
+	 */
+	protect_dat_entry(m, SEGMENT_ENTRY_P, pgtable_level_pmd);
+	expect_pgm_int();
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pmd, ro");
+	unprotect_dat_entry(m, SEGMENT_ENTRY_P, pgtable_level_pmd);
+
+	/* The FC bit should be ignored because EDAT is off, like above */
+	p[0] = 42;
+	protect_dat_entry(m, REGION3_ENTRY_FC, pgtable_level_pud);
+	report(p[0] == 42, "pud, fc=1, r/w");
+	unprotect_dat_entry(m, REGION3_ENTRY_FC, pgtable_level_pud);
+	p[0] = 0;
+
+	/*
+	 * Region1/2/3 protection should not work, because EDAT is off.
+	 * Protect the various region1/2/3 entries and write, expect the
+	 * write to be successful.
+	 */
+	protect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pud);
+	p[0] = 42;
+	report(p[0] == 42, "pud, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pud);
+	p[0] = 0;
+
+	protect_dat_entry(m, REGION_ENTRY_P, pgtable_level_p4d);
+	p[0] = 42;
+	report(p[0] == 42, "p4d, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, pgtable_level_p4d);
+	p[0] = 0;
+
+	protect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pgd);
+	p[0] = 42;
+	report(p[0] == 42, "pgd, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pgd);
+	p[0] = 0;
+
+	report_prefix_pop();
+}
+
+static void test_edat1(void)
+{
+	report_prefix_push("edat1");
+	/* Enable EDAT */
+	ctl_set_bit(0, CTL0_EDAT);
+	p[0] = 0;
+
+	/*
+	 * Segment protection should work normally, try to write and expect
+	 * a fault.
+	 */
+	expect_pgm_int();
+	protect_dat_entry(m, SEGMENT_ENTRY_P, pgtable_level_pmd);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pmd, ro");
+	unprotect_dat_entry(m, SEGMENT_ENTRY_P, pgtable_level_pmd);
+
+	/*
+	 * Region1/2/3 protection should work now, because EDAT is on. Try
+	 * to write anyway and expect a fault.
+	 */
+	expect_pgm_int();
+	protect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pud);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pud, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pud);
+
+	expect_pgm_int();
+	protect_dat_entry(m, REGION_ENTRY_P, pgtable_level_p4d);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "p4d, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, pgtable_level_p4d);
+
+	expect_pgm_int();
+	protect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pgd);
+	p[0] = 42;
+	report(!p[0] && check_pgm_prot(m), "pgd, ro");
+	unprotect_dat_entry(m, REGION_ENTRY_P, pgtable_level_pgd);
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
index 9f81a608..a0ec8864 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -103,3 +103,6 @@ file = sie.elf
 [mvpg]
 file = mvpg.elf
 timeout = 10
+
+[edat]
+file = edat.elf
-- 
2.31.1

