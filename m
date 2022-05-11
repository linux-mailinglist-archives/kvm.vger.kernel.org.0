Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95F522ED0
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 10:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbiEKI5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 04:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiEKI5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 04:57:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F1C37ABB;
        Wed, 11 May 2022 01:57:00 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B8U05c031027;
        Wed, 11 May 2022 08:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/joKcMJqjLn1UfupxB2NYEbV+dPD5/1QLhXHcigNd/4=;
 b=j7a/0z+YqEwrWvqlt6ZLLinWmoCReGlMxHBlIgoIS+IOTXX8+vXdnrOnbox8T1nOPbip
 Gau8cdyci+/Lo/l1GqsM6d390SrOVjgkZmAjTLzxN9P88vEyiddKPIwl7W0N2qv8XvWP
 2TEvk4XzgOeOiYf5CDu0xawdFkU+hUaYse+hyZd0ksQiDWnG52oGeIBQtIoX1XbiomZ2
 OUEeofxO21ykjj52I6OK4F2nPNW0pK9Ae3ahYmBGzsNJIKThENEmR9J7+nUblETSL22U
 jzhj5ajVN1RHMRNeEd271ED2obZqkFzaJgdKACCcJUH/WRQ2QsbpYU0TkVBW0XTo9eof 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g09pfrdtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:59 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24B8VHp3003037;
        Wed, 11 May 2022 08:56:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g09pfrdsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:59 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24B8qTwl002013;
        Wed, 11 May 2022 08:56:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3fwgd8v1w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 08:56:56 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24B8urlm21168614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 08:56:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 752735204F;
        Wed, 11 May 2022 08:56:53 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3F64A52051;
        Wed, 11 May 2022 08:56:53 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/2] lib: s390x: add header for CMM related defines
Date:   Wed, 11 May 2022 10:56:51 +0200
Message-Id: <20220511085652.823371-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220511085652.823371-1-nrb@linux.ibm.com>
References: <20220511085652.823371-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z6XEDkO10WugUfGVK8R2FNWqVl6IO0MA
X-Proofpoint-ORIG-GUID: jOXKQdfQn1RKRta-DFLTlKjsYlHK-W6s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_02,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=847 malwarescore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0
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

