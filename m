Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4021F522ECF
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbiEKI5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 04:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiEKI5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 04:57:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B4937A83;
        Wed, 11 May 2022 01:57:00 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B5e98h001126;
        Wed, 11 May 2022 08:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d7XadRbnBYSrfmtK0xVSQgmYD7fGV931O1Vhd+NiUt0=;
 b=S0BPmsdw8q7gvqNMzlW++zZQT//KaiF4OL0iGsIi4twrBo0rdHySXQZObYXUNP9HmZ8e
 1rjlm1zL3Ah79kF9bF3LROKlzlThclpg+Pq7CRHKCph8im8BX2pWT6JXT+LolMXWykMg
 sBum3J8PR39UyAyZZhLTu+GmyGqizX1QQTfmB1j8VEcCr3bn4BcQPmhNjaRz7wjzvEVI
 WOl52c3oIycjhPdHZHqPhf5zsRqZ8ylBQiaYhPOXipjthQSsLOwilCG16JYfuw2UHmig
 tun1vnMexZCtrRvRLwJPSMVgcAW4gYWxGfNKln/fGiedIdD5IFUw2YzIl5AnGoN3FUtf rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g054jn1gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24B8VZRs004888;
        Wed, 11 May 2022 08:56:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g054jn1g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24B8qVCu021020;
        Wed, 11 May 2022 08:56:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8w6tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24B8urdM52167090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 08:56:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB9885204F;
        Wed, 11 May 2022 08:56:53 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 75FE152050;
        Wed, 11 May 2022 08:56:53 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: add cmm migration test
Date:   Wed, 11 May 2022 10:56:52 +0200
Message-Id: <20220511085652.823371-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220511085652.823371-1-nrb@linux.ibm.com>
References: <20220511085652.823371-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TN1AL86M5EwM3n3Q6_nFRJyEGC37MJ6l
X-Proofpoint-GUID: rWWt-VDyvSzl86JUp_ZFohi3s0PGqDd6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_02,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 spamscore=0 mlxlogscore=915 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205110037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a VM is migrated, we expect the page states to be preserved. Add a test
which checks for that.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile        |  1 +
 s390x/migration-cmm.c | 78 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 +++
 3 files changed, 83 insertions(+)
 create mode 100644 s390x/migration-cmm.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a8e04aa6fe4d..1877c8a6e86e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
 tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
+tests += $(TEST_DIR)/migration-cmm.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-cmm.c b/s390x/migration-cmm.c
new file mode 100644
index 000000000000..97bba138bcf9
--- /dev/null
+++ b/s390x/migration-cmm.c
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CMM migration tests (ESSA)
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <asm/cmm.h>
+#include <bitops.h>
+
+#define NUM_PAGES 128
+static uint8_t pagebuf[NUM_PAGES][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
+static void test_migration(void)
+{
+	int i, state_mask, actual_state;
+	/*
+	 * Maps ESSA actions to states the page is allowed to be in after the
+	 * respective action was executed.
+	 */
+	int allowed_essa_state_masks[4] = {
+		BIT(ESSA_USAGE_STABLE),					/* ESSA_SET_STABLE */
+		BIT(ESSA_USAGE_UNUSED),					/* ESSA_SET_UNUSED */
+		BIT(ESSA_USAGE_VOLATILE),				/* ESSA_SET_VOLATILE */
+		BIT(ESSA_USAGE_VOLATILE) | BIT(ESSA_USAGE_POT_VOLATILE) /* ESSA_SET_POT_VOLATILE */
+	};
+
+	assert(NUM_PAGES % 4 == 0);
+	for (i = 0; i < NUM_PAGES; i += 4) {
+		essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
+		essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i + 1]);
+		essa(ESSA_SET_VOLATILE, (unsigned long)pagebuf[i + 2]);
+		essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i + 3]);
+	}
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		actual_state = essa(ESSA_GET_STATE, (unsigned long)pagebuf[i]);
+		/* extract the usage state in bits 60 and 61 */
+		actual_state = (actual_state >> 2) & 0x3;
+		state_mask = allowed_essa_state_masks[i % ARRAY_SIZE(allowed_essa_state_masks)];
+		report(BIT(actual_state) & state_mask, "page %d state: expected_mask=0x%x actual_mask=0x%lx", i, state_mask, BIT(actual_state));
+	}
+}
+
+int main(void)
+{
+	bool has_essa = check_essa_available();
+
+	report_prefix_push("cmm-migration");
+	if (!has_essa) {
+		report_skip("ESSA is not available");
+
+		/*
+		 * If we just exit and don't ask migrate_cmd to migrate us, it
+		 * will just hang forever. Hence, also ask for migration when we
+		 * skip this test alltogether.
+		 */
+		puts("Please migrate me, then press return\n");
+		(void)getchar();
+
+		goto done;
+	}
+
+	test_migration();
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b456b2881448..9b97d0471bcf 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
 file = migration.elf
 groups = migration
 smp = 2
+
+[migration-cmm]
+file = migration-cmm.elf
+groups = migration
-- 
2.31.1

