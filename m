Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED69856574C
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiGDNcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 09:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiGDNcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 09:32:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEE412AB7;
        Mon,  4 Jul 2022 06:30:12 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264DJedD016647;
        Mon, 4 Jul 2022 13:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hKSlHsgDMVdcqtZW8z47t7KRFmQPf3tQo7jZeyve4qM=;
 b=Bx1eq2YoKmRr27DfDQ1crR+WKKQAKedFR9xPo7rhF699yqow+ZE7SZMmUCjFCDkdXm2U
 yZOjrvwigm64DPcs+DDcVu9AAsUPph4Z1JP/2ZdpVCw4q97u3YtDOlYdQnuJhSD2RWBu
 r4ZA723Y90dU6XK881/aILkaV3bzQ/AxZSDmrFxU+tm8eBH7Qfe+zQq2KJPDVELO8l9N
 xtXdKZzZmQ02HZbc5+R7fwltejYFlD4NufrenKGaUkR1b6weNOP6XNH6E5magEjuIHfF
 /Oct+mKO8pwMz4eU7PaYmVJRD24AJtNRSVwWoafdLKa2MXUkSt1OWbpWdA8vfztixk0/ +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h410a88cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:30:11 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 264DLZFL022343;
        Mon, 4 Jul 2022 13:30:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h410a88a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:30:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 264DLJ0w015056;
        Mon, 4 Jul 2022 13:30:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3h2dn92rkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Jul 2022 13:30:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 264DU3ua14549344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Jul 2022 13:30:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F3CE11C04C;
        Mon,  4 Jul 2022 13:30:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C32B711C054;
        Mon,  4 Jul 2022 13:30:02 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Jul 2022 13:30:02 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [PATCH] s390x: split migration test into vector and gs test
Date:   Mon,  4 Jul 2022 15:30:02 +0200
Message-Id: <20220704133002.791395-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DwfCYu8KGuASXrjj_RO4E8tOJOwExmsU
X-Proofpoint-ORIG-GUID: alq8Jr-lFCfYWKjAWDUp9yq2uFKHPtWh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_11,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we now have a few more migration tests, let's split migration.c
into two files for vector and gs facilities. Since guarded-storage and vector
facilities can be en-/disabled independant of each other, this simplifies the
code a bit and makes it clear what the scope of the tests is.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                         |   3 +-
 s390x/migration-gs.c                   | 122 +++++++++++++++++++++++++
 s390x/{migration.c => migration-vec.c} |  54 +----------
 s390x/unittests.cfg                    |  15 ++-
 4 files changed, 136 insertions(+), 58 deletions(-)
 create mode 100644 s390x/migration-gs.c
 rename s390x/{migration.c => migration-vec.c} (77%)

diff --git a/s390x/Makefile b/s390x/Makefile
index efd5e0c13102..90df45285b0b 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -30,10 +30,11 @@ tests += $(TEST_DIR)/spec_ex-sie.elf
 tests += $(TEST_DIR)/firq.elf
 tests += $(TEST_DIR)/epsw.elf
 tests += $(TEST_DIR)/adtl-status.elf
-tests += $(TEST_DIR)/migration.elf
 tests += $(TEST_DIR)/pv-attest.elf
 tests += $(TEST_DIR)/migration-cmm.elf
 tests += $(TEST_DIR)/migration-skey.elf
+tests += $(TEST_DIR)/migration-gs.elf
+tests += $(TEST_DIR)/migration-vec.elf
 
 pv-tests += $(TEST_DIR)/pv-diags.elf
 
diff --git a/s390x/migration-gs.c b/s390x/migration-gs.c
new file mode 100644
index 000000000000..c702d7493635
--- /dev/null
+++ b/s390x/migration-gs.c
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * s390x Migration Test for Guarded-Storage Extension
+ *
+ * Copyright IBM Corp. 2022
+ *
+ * Authors:
+ *  Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <asm/arch_def.h>
+#include <asm/barrier.h>
+#include <asm/facility.h>
+#include <gs.h>
+#include <bitops.h>
+#include <smp.h>
+
+static struct gs_cb gs_cb;
+static struct gs_epl gs_epl;
+
+/* set by CPU1 to signal it has completed */
+static int flag_thread_complete;
+/* set by CPU0 to signal migration has completed */
+static int flag_migration_complete;
+
+static void write_gs_regs(void)
+{
+	const unsigned long gs_area = 0x2000000;
+	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
+
+	gs_cb.gsd = gs_area | gsc;
+	gs_cb.gssm = 0xfeedc0ffe;
+	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
+
+	load_gs_cb(&gs_cb);
+}
+
+static void check_gs_regs(void)
+{
+	struct gs_cb gs_cb_after_migration;
+
+	store_gs_cb(&gs_cb_after_migration);
+
+	report_prefix_push("guarded-storage registers");
+
+	report(gs_cb_after_migration.gsd == gs_cb.gsd, "gsd matches");
+	report(gs_cb_after_migration.gssm == gs_cb.gssm, "gssm matches");
+	report(gs_cb_after_migration.gs_epl_a == gs_cb.gs_epl_a, "gs_epl_a matches");
+
+	report_prefix_pop();
+}
+
+static bool have_guarded_storage_facility(void)
+{
+	return test_facility(133);
+}
+
+static void test_func(void)
+{
+	if (have_guarded_storage_facility()) {
+		ctl_set_bit(2, CTL2_GUARDED_STORAGE);
+
+		write_gs_regs();
+	}
+
+	flag_thread_complete = 1;
+	while(!flag_migration_complete)
+		mb();
+
+	report_pass("Migrated");
+
+	if (have_guarded_storage_facility()) {
+		check_gs_regs();
+
+		report(stctg(2) & BIT(CTL2_GUARDED_STORAGE), "ctl2 guarded-storage bit set");
+
+		ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
+	}
+
+	flag_thread_complete = 1;
+}
+
+int main(void)
+{
+	struct psw psw;
+
+	/* don't say migrate here otherwise we will migrate right away */
+	report_prefix_push("migration-gs");
+
+	if (smp_query_num_cpus() == 1) {
+		report_skip("need at least 2 cpus for this test");
+		goto done;
+	}
+
+	/* Second CPU does the actual tests */
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+	smp_cpu_setup(1, psw);
+
+	/* wait for thread setup */
+	while(!flag_thread_complete)
+		mb();
+	flag_thread_complete = 0;
+
+	/* ask migrate_cmd to migrate (it listens for 'migrate') */
+	puts("Please migrate me, then press return\n");
+
+	/* wait for migration to finish, we will read a newline */
+	(void)getchar();
+
+	flag_migration_complete = 1;
+
+	/* wait for thread to complete assertions */
+	while(!flag_thread_complete)
+		mb();
+
+	smp_cpu_destroy(1);
+
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/migration.c b/s390x/migration-vec.c
similarity index 77%
rename from s390x/migration.c
rename to s390x/migration-vec.c
index a45296374cd8..2aab540f781b 100644
--- a/s390x/migration.c
+++ b/s390x/migration-vec.c
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Migration Test for s390x
+ * s390x Migration Test for Vector Extensions
  *
  * Copyright IBM Corp. 2022
  *
@@ -12,55 +12,19 @@
 #include <asm/vector.h>
 #include <asm/barrier.h>
 #include <asm/facility.h>
-#include <gs.h>
 #include <bitops.h>
 #include <smp.h>
 
-static struct gs_cb gs_cb;
-static struct gs_epl gs_epl;
-
 /* set by CPU1 to signal it has completed */
 static int flag_thread_complete;
 /* set by CPU0 to signal migration has completed */
 static int flag_migration_complete;
 
-static void write_gs_regs(void)
-{
-	const unsigned long gs_area = 0x2000000;
-	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
-
-	gs_cb.gsd = gs_area | gsc;
-	gs_cb.gssm = 0xfeedc0ffe;
-	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
-
-	load_gs_cb(&gs_cb);
-}
-
-static void check_gs_regs(void)
-{
-	struct gs_cb gs_cb_after_migration;
-
-	store_gs_cb(&gs_cb_after_migration);
-
-	report_prefix_push("guarded-storage registers");
-
-	report(gs_cb_after_migration.gsd == gs_cb.gsd, "gsd matches");
-	report(gs_cb_after_migration.gssm == gs_cb.gssm, "gssm matches");
-	report(gs_cb_after_migration.gs_epl_a == gs_cb.gs_epl_a, "gs_epl_a matches");
-
-	report_prefix_pop();
-}
-
 static bool have_vector_facility(void)
 {
 	return test_facility(129);
 }
 
-static bool have_guarded_storage_facility(void)
-{
-	return test_facility(133);
-}
-
 static void test_func(void)
 {
 	uint8_t expected_vec_contents[VEC_REGISTER_NUM][VEC_REGISTER_SIZE];
@@ -69,12 +33,6 @@ static void test_func(void)
 	int i;
 	int vec_result = 0;
 
-	if (have_guarded_storage_facility()) {
-		ctl_set_bit(2, CTL2_GUARDED_STORAGE);
-
-		write_gs_regs();
-	}
-
 	if (have_vector_facility()) {
 		for (i = 0; i < VEC_REGISTER_NUM; i++) {
 			vec_reg = &expected_vec_contents[i][0];
@@ -145,14 +103,6 @@ static void test_func(void)
 
 	report_pass("Migrated");
 
-	if (have_guarded_storage_facility()) {
-		check_gs_regs();
-
-		report(stctg(2) & BIT(CTL2_GUARDED_STORAGE), "ctl2 guarded-storage bit set");
-
-		ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
-	}
-
 	flag_thread_complete = 1;
 }
 
@@ -161,7 +111,7 @@ int main(void)
 	struct psw psw;
 
 	/* don't say migrate here otherwise we will migrate right away */
-	report_prefix_push("migration");
+	report_prefix_push("migration-vec");
 
 	if (smp_query_num_cpus() == 1) {
 		report_skip("need at least 2 cpus for this test");
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 8e52f560bb1e..04d9f0761a1f 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -172,11 +172,6 @@ smp = 2
 accel = tcg
 extra_params = -cpu qemu,gs=off,vx=off
 
-[migration]
-file = migration.elf
-groups = migration
-smp = 2
-
 [migration-cmm]
 file = migration-cmm.elf
 groups = migration
@@ -184,3 +179,13 @@ groups = migration
 [migration-skey]
 file = migration-skey.elf
 groups = migration
+
+[migration-gs]
+file = migration-gs.elf
+groups = migration
+smp = 2
+
+[migration-vec]
+file = migration-vec.elf
+groups = migration
+smp = 2
-- 
2.36.1

