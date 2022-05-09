Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C1451FC3C
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiEIMMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 08:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiEIMMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 08:12:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6975984A0E;
        Mon,  9 May 2022 05:08:12 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249AMlG0019490;
        Mon, 9 May 2022 12:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/joKcMJqjLn1UfupxB2NYEbV+dPD5/1QLhXHcigNd/4=;
 b=YkoaPiOmmmx/uwtOKlod7RjNVsuPa3u5fqsH9OjPeQg7dDHvaxL/OBlcLnLkQJRMXgxj
 10FMoQtV5axdY3mkOUd8j6VwNp9SfSgu/2DXvfD4CMHFrO+pilWyqw7eO5Bk6Lu5CAaL
 yO3TxgcxXqMPJiv0g1gQEj2CuVwElFZPTSuGqUN53yeAWlVOqF0XWqIPx5Cya4axGoNI
 zmJyOFxyP8vUheMkTtXg1JnqIxxLHuDjJ7rlv+axqOV0aHDbf+zwOuDlBp42ADFYh0iB
 yS8nWS7iuHm2LixyF0SmmH/p16SC8gPUY0C3EIFx0MoirgOVMctVCS7yHvA+G6+OmtAd bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy15d9yym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:11 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249C6jes003653;
        Mon, 9 May 2022 12:08:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy15d9yxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249C30pk030081;
        Mon, 9 May 2022 12:08:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8tgm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 12:08:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249C86UF33030512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 12:08:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 424E75204E;
        Mon,  9 May 2022 12:08:06 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1444152054;
        Mon,  9 May 2022 12:08:06 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] lib: s390x: add header for CMM related defines
Date:   Mon,  9 May 2022 14:08:04 +0200
Message-Id: <20220509120805.437660-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220509120805.437660-1-nrb@linux.ibm.com>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KzqdFcBXGR7w9gW7r0cx1UMZ0sLbEee2
X-Proofpoint-GUID: eLRh8fEBrrrBgS5ZGgBtKL4UOSXccWSr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 impostorscore=0 bulkscore=0
 phishscore=0 mlxlogscore=867 lowpriorityscore=0 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we're going to need the definitions in an upcoming migration test for CMM,
add a header for CMM related defines. It is based on
arch/s390/include/asm/page-states.h from linux.

While at it, use the constants in existing calls to CMM related functions.

Also move essa() and test_availability() there to be able to use it outside
cmm.c.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/cmm.h | 50 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/cmm.c         | 25 +++--------------------
 2 files changed, 53 insertions(+), 22 deletions(-)
 create mode 100644 lib/s390x/asm/cmm.h

diff --git a/lib/s390x/asm/cmm.h b/lib/s390x/asm/cmm.h
new file mode 100644
index 000000000000..554a60031fbf
--- /dev/null
+++ b/lib/s390x/asm/cmm.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *    Copyright IBM Corp. 2017, 2022
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
+ *               Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <asm/interrupt.h>
+
+#ifndef PAGE_STATES_H
+#define PAGE_STATES_H
+
+#define ESSA_GET_STATE			0
+#define ESSA_SET_STABLE			1
+#define ESSA_SET_UNUSED			2
+#define ESSA_SET_VOLATILE		3
+#define ESSA_SET_POT_VOLATILE		4
+#define ESSA_SET_STABLE_RESIDENT	5
+#define ESSA_SET_STABLE_IF_RESIDENT	6
+#define ESSA_SET_STABLE_NODAT		7
+
+#define ESSA_MAX	ESSA_SET_STABLE_NODAT
+
+#define ESSA_USAGE_STABLE		0
+#define ESSA_USAGE_UNUSED		1
+#define ESSA_USAGE_POT_VOLATILE		2
+#define ESSA_USAGE_VOLATILE		3
+
+static unsigned long essa(uint8_t state, unsigned long paddr)
+{
+	uint64_t extr_state;
+
+	asm volatile(".insn rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0" \
+			: [extr_state] "=d" (extr_state) \
+			: [addr] "a" (paddr), [new_state] "i" (state));
+
+	return (unsigned long)extr_state;
+}
+
+/*
+ * Unfortunately the availability is not indicated by stfl bits, but
+ * we have to try to execute it and test for an operation exception.
+ */
+static inline bool check_essa_available(void)
+{
+	expect_pgm_int();
+	essa(ESSA_GET_STATE, 0);
+	return clear_pgm_int() == 0;
+}
+
+#endif
diff --git a/s390x/cmm.c b/s390x/cmm.c
index c3f0c931ae36..af852838851e 100644
--- a/s390x/cmm.c
+++ b/s390x/cmm.c
@@ -12,19 +12,10 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
+#include <asm/cmm.h>
 
 static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
-static unsigned long essa(uint8_t state, unsigned long paddr)
-{
-	uint64_t extr_state;
-
-	asm volatile(".insn rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0"
-			: [extr_state] "=d" (extr_state)
-			: [addr] "a" (paddr), [new_state] "i" (state));
-	return (unsigned long)extr_state;
-}
-
 static void test_params(void)
 {
 	report_prefix_push("invalid ORC 8");
@@ -39,24 +30,14 @@ static void test_priv(void)
 	report_prefix_push("privileged");
 	expect_pgm_int();
 	enter_pstate();
-	essa(0, (unsigned long)pagebuf);
+	essa(ESSA_GET_STATE, (unsigned long)pagebuf);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 }
 
-/* Unfortunately the availability is not indicated by stfl bits, but
- * we have to try to execute it and test for an operation exception.
- */
-static bool test_availability(void)
-{
-	expect_pgm_int();
-	essa(0, (unsigned long)pagebuf);
-	return clear_pgm_int() == 0;
-}
-
 int main(void)
 {
-	bool has_essa = test_availability();
+	bool has_essa = check_essa_available();
 
 	report_prefix_push("cmm");
 	if (!has_essa) {
-- 
2.31.1

