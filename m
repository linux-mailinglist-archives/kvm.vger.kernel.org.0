Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8643C4E571A
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245660AbiCWRFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245630AbiCWRFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F93506F5;
        Wed, 23 Mar 2022 10:03:35 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxVfo022813;
        Wed, 23 Mar 2022 17:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UkqjHM3UWtQNNz8XAOJdt1dMao+EawYPSkChcrT1Shs=;
 b=ZcdQPXGFXao9jgp9U0kPn1oBase0M+mPpG2y8poVUZ1URumNWsDPczrX7R7Azs9/YMWb
 DVz5JmtrcK78eYRNhEM+ktuTPsJb2gS/P2d9YPM2V2kpw7sllzxYuHuKSZXFuIbA2CWy
 KccU6KjSG7Ez/WYhx2sRsiCSRmZCdVU5I7zhxk3IkhxD79UyiGUCm///pF91/y1Aiw51
 BJmrE4zNG+Y03tnkWUjOCbj3FpjeYvQE31yDNPytw9CxMMazmsQk6yaPqcU/d4x0aexD
 leBMrx6ea/TfMMbIEzM0fuTequO9QChBOQ9VivdadeES+zJi7PLijCbGjyYuGTC5F4W2 uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f05an3pmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:34 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGAHbO025294;
        Wed, 23 Mar 2022 17:03:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f05an3pky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxH6p026065;
        Wed, 23 Mar 2022 17:03:31 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t911s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3Wrx37093814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84A3B4C04A;
        Wed, 23 Mar 2022 17:03:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44F304C040;
        Wed, 23 Mar 2022 17:03:28 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 8/9] s390x: add TPROT tests
Date:   Wed, 23 Mar 2022 18:03:24 +0100
Message-Id: <20220323170325.220848-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x4fTzTWP1w11ORm6XekvxTlgjWJEEXDX
X-Proofpoint-GUID: qicdAXD61RDYkTtpB5J-EqDligYVQOLb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230091
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
index 843fd323bce9..bcf223cd7365 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -156,3 +156,6 @@ file = firq.elf
 timeout = 20
 extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
 accel = tcg
+
+[tprot]
+file = tprot.elf
-- 
2.31.1

