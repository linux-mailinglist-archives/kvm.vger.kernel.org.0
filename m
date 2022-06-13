Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275554846B
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 12:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbiFMKPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 06:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241534AbiFMKP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 06:15:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C74B1E0;
        Mon, 13 Jun 2022 03:14:46 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25D8uToX029055;
        Mon, 13 Jun 2022 10:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WqQX4gZN1wlNT57RJA8mJ52WwcVtji3VJg5ApeO8dzY=;
 b=A2QfD2GsttJJNXvmncBp4BkP+b5sTCYO4J7Q3bA37ZYOmaQjDnwMmplySVaLcgz1HKDP
 dZTD6kpGhA/9HVqrF0cg9RDO3hiZjm5m1P4VZFeBkNLWkMo/bWftHgIlXliYYbrz105E
 Sz5938nDxtol1HYSKP2Tyc3L8nOwBcypqlcYYSL2Xnj9I6tmmXBu3l+xE4cvNmmgfCq3
 ETC1ru7Aiimo3qIpTXimSK1O/7bQV7XnQlye84PKQgwx6Tx55NvDv51+TakgBHvW9AfV
 y6ljT37C23UdntKBkwgUUpLSgdiV7l1V/p6faTvowzN6e3ewLvvmH3W8jaAb3yW/q8yk Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn5484tdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:14:45 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25DA7Lak010748;
        Mon, 13 Jun 2022 10:14:45 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn5484tdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:14:44 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25DA7AON011912;
        Mon, 13 Jun 2022 10:14:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3gmjp8syeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:14:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25DAEd4221102888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 10:14:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5D395204F;
        Mon, 13 Jun 2022 10:14:39 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9651652057;
        Mon, 13 Jun 2022 10:14:39 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 1/1] s390x: add migration test for storage keys
Date:   Mon, 13 Jun 2022 12:14:39 +0200
Message-Id: <20220613101439.557174-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613101439.557174-1-nrb@linux.ibm.com>
References: <20220613101439.557174-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0NtjODS-m9oD8RPPET1bjBRegJIs6k3P
X-Proofpoint-ORIG-GUID: VjrNl2g-WhL7wartsuYlPnglk9y7a5JQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_03,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130046
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
 s390x/migration-skey.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 83 insertions(+)
 create mode 100644 s390x/migration-skey.c

diff --git a/s390x/Makefile b/s390x/Makefile
index a8e04aa6fe4d..f8ea594b641d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -32,6 +32,7 @@ tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
 tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
+tests += $(TEST_DIR)/migration-skey.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
new file mode 100644
index 000000000000..f7082937e3a9
--- /dev/null
+++ b/s390x/migration-skey.c
@@ -0,0 +1,78 @@
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
+	int i, key_to_set, key_mismatches = 0;
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		/*
+		 * Storage keys are 7 bit, lowest bit is always returned as zero
+		 * by iske.
+		 * This loop will set all 7 bits which means we set fetch
+		 * protection as well as reference and change indication for
+		 * some keys.
+		 */
+		key_to_set = i * 2;
+		set_storage_key(pagebuf[i], key_to_set, 1);
+	}
+
+	puts("Please migrate me, then press return\n");
+	(void)getchar();
+
+	for (i = 0; i < NUM_PAGES; i++) {
+		actual_key.val = get_storage_key(pagebuf[i]);
+		expected_key.val = i * 2;
+
+		/* ignore reference bit */
+		actual_key.str.rf = 0;
+		expected_key.str.rf = 0;
+
+		/* don't log anything when key matches to avoid spamming the log */
+		if (actual_key.val != expected_key.val) {
+			key_mismatches++;
+			report_fail("page %d expected_key=0x%x actual_key=0x%x", i, expected_key.val, actual_key.val);
+		}
+	}
+
+	report(!key_mismatches, "skeys after migration match");
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
index b456b2881448..1e851d8e3dd8 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -176,3 +176,7 @@ extra_params = -cpu qemu,gs=off,vx=off
 file = migration.elf
 groups = migration
 smp = 2
+
+[migration-skey]
+file = migration-skey.elf
+groups = migration
-- 
2.36.1

