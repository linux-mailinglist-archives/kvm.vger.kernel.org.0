Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49444E2435
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbiCUKUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346263AbiCUKUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E470F2CE2A;
        Mon, 21 Mar 2022 03:19:15 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LAC3uE017443;
        Mon, 21 Mar 2022 10:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EjMC+y1VFmFr0lzNcT329swwbIgPh0I+Rm30oTAR+SI=;
 b=lbZ1ECfRaXmFSCagANDjlkaPLX0rfDiv+/bCUXmPCE8O0YsrsfK8NFceLGEqEKEENjyh
 pN/ZondPM5m9R2atZoz7/5d+UvYoRc4bRXpYEvfJozYAg8cCCU6kGQHpQGBHZfpUpQSx
 CIaDxj+CZIhl8agFyD/U9YIPxGTL3l5zUSJH3VoKYGD6mVpB6sXq4KWO+3wcTPkWx44c
 A1tlnHiCP7DOrG7ceaajxWvGnzxu6bt0PNJZ8wGZsKdnvJUKzLDR269sf63TmZ/RNAOy
 wrlz7sJsbtu1g5kwNMPI/kjC+E1J+huIWIsEpveV8XIH/lDhayV88yNrvg1+GVagprke Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exqd3r4nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:15 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LABxU0017185;
        Mon, 21 Mar 2022 10:19:14 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exqd3r4m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:14 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LADsD1031555;
        Mon, 21 Mar 2022 10:19:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8k3rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ7HD40567068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D10A211C050;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BFA411C054;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 8/9] s390x: add TPROT tests
Date:   Mon, 21 Mar 2022 11:19:03 +0100
Message-Id: <20220321101904.387640-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GZhRNeDiXgwwPyv9i_piBSsgeA3rEGGf
X-Proofpoint-GUID: BzxsT79_XkAUGyDr5sp0sqsYQTAp1RT5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for TEST PROTECTION. We cover the following cases:
- page is read/write
- page is readonly
- lowcore protection
- page is not present
- translation specification exception

We don't cover storage keys and the case where the page can be neither read nor
written right now.

This test mainly applies to the TCG case.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/tprot.c       | 108 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 112 insertions(+)
 create mode 100644 s390x/tprot.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 53b0fe044fe7..92c1ce4648dd 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -3,6 +3,7 @@ tests += $(TEST_DIR)/intercept.elf
 tests += $(TEST_DIR)/emulator.elf
 tests += $(TEST_DIR)/sieve.elf
 tests += $(TEST_DIR)/sthyi.elf
+tests += $(TEST_DIR)/tprot.elf
 tests += $(TEST_DIR)/skey.elf
 tests += $(TEST_DIR)/diag10.elf
 tests += $(TEST_DIR)/diag308.elf
diff --git a/s390x/tprot.c b/s390x/tprot.c
new file mode 100644
index 000000000000..460a0db7ffcf
--- /dev/null
+++ b/s390x/tprot.c
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * TEST PROTECTION tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <bitops.h>
+#include <asm/pgtable.h>
+#include <asm/interrupt.h>
+#include "mmu.h"
+#include <vmalloc.h>
+#include <sclp.h>
+
+static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static void test_tprot_rw(void)
+{
+	int cc;
+
+	report_prefix_push("Page read/writeable");
+
+	cc = tprot((unsigned long)pagebuf, 0);
+	report(cc == 0, "CC = 0");
+
+	report_prefix_pop();
+}
+
+static void test_tprot_ro(void)
+{
+	int cc;
+
+	report_prefix_push("Page readonly");
+
+	protect_dat_entry(pagebuf, PAGE_ENTRY_P, 5);
+
+	cc = tprot((unsigned long)pagebuf, 0);
+	report(cc == 1, "CC = 1");
+
+	unprotect_dat_entry(pagebuf, PAGE_ENTRY_P, 5);
+
+	report_prefix_pop();
+}
+
+static void test_tprot_low_addr_prot(void)
+{
+	int cc;
+
+	report_prefix_push("low-address protection");
+
+	low_prot_enable();
+	cc = tprot(0, 0);
+	low_prot_disable();
+	report(cc == 1, "CC = 1");
+
+	report_prefix_pop();
+}
+
+static void test_tprot_transl_unavail(void)
+{
+	int cc;
+
+	report_prefix_push("Page translation unavailable");
+
+	protect_dat_entry(pagebuf, PAGE_ENTRY_I, 5);
+
+	cc = tprot((unsigned long)pagebuf, 0);
+	report(cc == 3, "CC = 3");
+
+	unprotect_dat_entry(pagebuf, PAGE_ENTRY_I, 5);
+
+	report_prefix_pop();
+}
+
+static void test_tprot_transl_pte_bit52_set(void)
+{
+	report_prefix_push("PTE Bit 52 set");
+
+	protect_dat_entry(pagebuf, BIT(63 - 52), 5);
+
+	expect_pgm_int();
+	tprot((unsigned long)pagebuf, 0);
+	check_pgm_int_code(PGM_INT_CODE_TRANSLATION_SPEC);
+
+	unprotect_dat_entry(pagebuf, BIT(63 - 52), 5);
+
+	report_prefix_pop();
+}
+
+int main(void)
+{
+	report_prefix_push("tprot");
+
+	setup_vm();
+
+	test_tprot_rw();
+	test_tprot_ro();
+	test_tprot_low_addr_prot();
+	test_tprot_transl_unavail();
+	test_tprot_transl_pte_bit52_set();
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 2d0adc503917..6227cd3ba1d0 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -142,3 +142,6 @@ file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
 accel = tcg
+
+[tprot]
+file = tprot.elf
-- 
2.31.1

