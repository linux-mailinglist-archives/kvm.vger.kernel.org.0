Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B3543127
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbiFHNNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbiFHNNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:13:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CA120EE8B;
        Wed,  8 Jun 2022 06:13:35 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258BrCDl005807;
        Wed, 8 Jun 2022 13:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5szdYVGGzu9ogUKniT0NOcZ7tMOc2nrywishGwUJzS8=;
 b=G5r5Wa4T5GQdpGLhZ9aDWbu9ayTuS11H0ynwJZu9y8X8lsGeDftEbk5kUHMDh/xj5rEk
 ckBwIL7vQRPuRcKs6XkAcqT1Yqhh+VRfnPdCBr15jBDjnTF8/aeex8/KzFg+GbdM6diK
 wPORDWhWx+VaGHt2ue0jRPPksSOl3bYBk+5vKfgqgyI6BZcniT0R2sEzkxsMUIBZbovG
 6Y4hHVxHLqGYp1IvBE+7v/uyAe+J0+wD5p2wVq/ZGR4Ez3WwteJhsteAiMbj0ZdUPX+D
 qclF4HE4p8DYNNL3HaqzwGz+rU7DJ4Y2ga2xJoSQwGMncdn3UMBcqxj2GxKTlExp30nO Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjsmbux6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:13:34 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DBC0k015771;
        Wed, 8 Jun 2022 13:13:34 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjsmbux6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:13:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258D5M8n006966;
        Wed, 8 Jun 2022 13:13:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gfy18v4xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:13:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DDViP24576430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:13:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47AE25204F;
        Wed,  8 Jun 2022 13:13:29 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 145F052057;
        Wed,  8 Jun 2022 13:13:29 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 1/1] s390x: add migration test for storage keys
Date:   Wed,  8 Jun 2022 15:13:28 +0200
Message-Id: <20220608131328.6519-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608131328.6519-1-nrb@linux.ibm.com>
References: <20220608131328.6519-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SoaeKnzzRnVD2GmrMAtiHs4KqeQ9E-uW
X-Proofpoint-GUID: 66isviZoMHbOQU1_tAVVTOJKOLUe1qM6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon migration, we expect storage keys set by the guest to be preserved, so add
a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
that they can be read back and match the value originally set.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 73 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 78 insertions(+)
 create mode 100644 s390x/migration-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 25802428fa13..94fc5c1a3527 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -33,6 +33,7 @@ tests += $(TEST_DIR)/adtl-status.elf
 tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
+tests += $(TEST_DIR)/migration-skey.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
new file mode 100644
index 000000000000..323aa83202bb
--- /dev/null
+++ b/s390x/migration-skey.c
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Storage Key migration tests
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/facility.h>
+#include <asm/page.h>
+#include <asm/mem.h>
+#include <asm/interrupt.h>
+#include <hardware.h>
+
+#define NUM_PAGES 128
+static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static void test_migration(void)
+{
+	union skey expected_key, actual_key;
+	int i, key_to_set;
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		/*
+		 * Storage keys are 7 bit, lowest bit is always returned as zero
+		 * by iske
+		 */
+		key_to_set = i * 2;
+		set_storage_key(pagebuf[i], key_to_set, 1);
+	}
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		report_prefix_pushf("page %d", i);
+
+		actual_key.val = get_storage_key(pagebuf[i]);
+		expected_key.val = i * 2;
+
+		/* ignore reference bit */
+		actual_key.str.rf = 0;
+		expected_key.str.rf = 0;
+
+		report(actual_key.val == expected_key.val, "expected_key=0x%x actual_key=0x%x", expected_key.val, actual_key.val);
+
+		report_prefix_pop();
+	}
+}
+
+int main(void)
+{
+	report_prefix_push("migration-skey");
+	if (test_facility(169)) {
+		report_skip("storage key removal facility is active");
+
+		/*
+		 * If we just exit and don't ask migrate_cmd to migrate us, it
+		 * will just hang forever. Hence, also ask for migration when we
+		 * skip this test altogether.
+		 */
+		puts("Please migrate me, then press return\n");
+		(void)getchar();
+	} else {
+		test_migration();
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9b97d0471bcf..8e52f560bb1e 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -180,3 +180,7 @@ smp = 2
 [migration-cmm]
 file = migration-cmm.elf
 groups = migration
+
+[migration-skey]
+file = migration-skey.elf
+groups = migration
-- 
2.36.1

