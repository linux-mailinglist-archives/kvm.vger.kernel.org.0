Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3354EEC36
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiDALSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345440AbiDALSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E90C186FAA
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:41 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2318Jx3h005513
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f26zNlyJJ3F4gbGkbKYOgaKIYlyS1r0jTQDHaVkVL9g=;
 b=OxTXpexMF2hzkSLe+gZ1BgRtRuqNfKRfc8rrMSOK1OBUcbU+wT8lYdoYElqR0PioFF/9
 aEEDNReriK1WCR/c8wLbXu77AIn1h8ZnGUPzphiFQd1vVyoUbpVh3dFDEmL1C4+aLEX3
 1yWbYbNHhmV0iwSr5p0+ZzmkoBiqXAFXbV3AyDgMD5wmSmAxn7dmUSqmnANDwSWXWaSK
 KBdvNL4nBX9qCHCsmGdHZx615keaykggu/HBAn+rvSQH/OmZwGToCWc9dYJyER4r+RtG
 vIJf0YZxIGM6Wvu3LsbZZMj2sJEKaJedl9BcOYmXZe5TCcIg6DIRvQd6p0BeYi7ek4Pq 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wsq3bhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:41 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231B8HTD011507
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wsq3bgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B8w0m020878;
        Fri, 1 Apr 2022 11:16:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3j2xv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGY6k45613336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A41A4C062;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 195D14C084;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 20/27] s390x: add TPROT tests
Date:   Fri,  1 Apr 2022 13:16:13 +0200
Message-Id: <20220401111620.366435-21-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 06o4ng6Vdf8DExn7r45dKacw9ZezSAmd
X-Proofpoint-ORIG-GUID: vMznzXxSlKMlKzpeQSBa3I61soiFfqFN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxlogscore=982 spamscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

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
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/tprot.c       | 108 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 112 insertions(+)
 create mode 100644 s390x/tprot.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 25449708..93475972 100644
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
index 00000000..460a0db7
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
index aeb82246..743013b2 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -143,3 +143,6 @@ file = sck.elf
 [epsw]
 file = epsw.elf
 extra_params = -device virtio-net-ccw
+
+[tprot]
+file = tprot.elf
-- 
2.34.1

