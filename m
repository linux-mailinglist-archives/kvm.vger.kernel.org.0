Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8A51FC3A
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiEIMMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 08:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiEIMMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 08:12:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACE4A144B;
        Mon,  9 May 2022 05:08:12 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249AU1Uq014744;
        Mon, 9 May 2022 12:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Tp1p/8RChzinD57NApIZfYpuBcRyUDDntipozx75z6U=;
 b=PyU/CNCr4eDOvalTMW8RXWLci4ynar6oC0tP+lYjcbeS1PfSNa4ERIOQMN/YGYn3r6Ey
 coiKQubftWxMFuMoC1AYcLBATHojo7tYpVT9FBMUsLNTYNqUKrx/gnLQNW5GLGxoXLcE
 0Chmq9l5/n2mSdXU8P/OGvVitdI75BxCqu/bzjZ6j3FObtx0fMXRtsXUCMpDA56aE1PQ
 cg42CCp7bfYTWH9gtS1SzD/IpihPrPM6X+aAJAkWLmdHHIlMXReXN5NbnC4m8vj4ySC7
 VeYnsEQoOQNGIZhQWFwNv1737NlVPv6k34A6pf9c4XmYSue6PGhxbUk+GIT8L1iQMw1y dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy18shu97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:12 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249C8C7e020273;
        Mon, 9 May 2022 12:08:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy18shu88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249C34Av015579;
        Mon, 9 May 2022 12:08:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j2gcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249C86AG26739142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 12:08:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AF085204E;
        Mon,  9 May 2022 12:08:06 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4D15152057;
        Mon,  9 May 2022 12:08:06 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: add cmm migration test
Date:   Mon,  9 May 2022 14:08:05 +0200
Message-Id: <20220509120805.437660-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220509120805.437660-1-nrb@linux.ibm.com>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wtx9nxtsaJglFSusq3Z0nCJ69hr9xkD3
X-Proofpoint-GUID: y7edLRiLw0nBrFxH8iGRSmJRqPH87mRJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=933 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090069
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
 s390x/cmm-migration.c | 78 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 +++
 3 files changed, 83 insertions(+)
 create mode 100644 s390x/cmm-migration.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a8e04aa6fe4d..8ac0afdfd994 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
 tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
+tests += $(TEST_DIR)/cmm-migration.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/cmm-migration.c b/s390x/cmm-migration.c
new file mode 100644
index 000000000000..4a7b50e40fc6
--- /dev/null
+++ b/s390x/cmm-migration.c
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
+	for (i = 0; i < NUM_PAGES; i++) {
+		switch(i % 4) {
+			case 0:
+				essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
+			break;
+			case 1:
+				essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i]);
+			break;
+			case 2:
+				essa(ESSA_SET_VOLATILE, (unsigned long)pagebuf[i]);
+			break;
+			case 3:
+				essa(ESSA_SET_POT_VOLATILE, (unsigned long)pagebuf[i]);
+			break;
+		}
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
+		goto done;
+	}
+
+	test_migration();
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b456b2881448..625026d90e52 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
 file = migration.elf
 groups = migration
 smp = 2
+
+[cmm-migration]
+file = cmm-migration.elf
+groups = migration
-- 
2.31.1

