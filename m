Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1771786
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 13:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbfGWLya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 07:54:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387844AbfGWLy2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jul 2019 07:54:28 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NBpikT042584
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2019 07:54:26 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tx14shtnp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2019 07:54:26 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 23 Jul 2019 12:54:24 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 23 Jul 2019 12:54:22 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6NBsLFa38863164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 11:54:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB4DFAE057;
        Tue, 23 Jul 2019 11:54:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDF2DAE056;
        Tue, 23 Jul 2019 11:54:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 23 Jul 2019 11:54:20 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9FA48E020C; Tue, 23 Jul 2019 13:54:20 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [1/1] kvm-unit-tests: s390: test for gen15a/b cpu model dependencies
Date:   Tue, 23 Jul 2019 13:54:19 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723115419.153590-1-borntraeger@de.ibm.com>
References: <20190723115419.153590-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19072311-0028-0000-0000-0000038715CB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072311-0029-0000-0000-000024474DAC
Message-Id: <20190723115419.153590-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a test for the cpu model gen15a/b. The test check for
dependencies and proper subfunctions.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/gen15.c       | 191 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   4 +
 3 files changed, 196 insertions(+)
 create mode 100644 s390x/gen15.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1f21ddb9c943..bc7217e0357a 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
 tests += $(TEST_DIR)/vector.elf
 tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
+tests += $(TEST_DIR)/gen15.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/gen15.c b/s390x/gen15.c
new file mode 100644
index 000000000000..c0bfe3ddb5fd
--- /dev/null
+++ b/s390x/gen15.c
@@ -0,0 +1,191 @@
+/*
+ * Test the facilities and subfunctions of the new gen15 cpu model
+ * Unless fully implemented this will only work with kvm as we check
+ * for all subfunctions
+ *
+ * Copyright 2019 IBM Corp.
+ *
+ * Authors:
+ *    Christian Borntraeger <borntraeger@de.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+
+#include <asm/facility.h>
+
+static void test_minste3(void)
+{
+
+	report_prefix_push("minste");
+
+	/* Dependency */
+	report("facility 45 available", test_facility(45));
+
+	report_prefix_pop();
+}
+
+static void test_vxeh2(void)
+{
+
+	report_prefix_push("vxeh2");
+
+	/* Dependencies */
+	report("facility 129 available", test_facility(129));
+	report("facility 135 available", test_facility(135));
+
+	report_prefix_pop();
+}
+
+static void query_opcode(unsigned int opcode, unsigned long query[4])
+{
+        register unsigned long r0 asm("0") = 0; /* query function */
+        register unsigned long r1 asm("1") = (unsigned long) query;
+
+        asm volatile(
+                /* Parameter regs are ignored */
+                "       .insn   rrf,%[opc] << 16,2,4,6,0\n"
+                : "=m" (*query)
+                : "d" (r0), "a" (r1), [opc] "i" (opcode)
+                : "cc");
+}
+
+static void query_cpuid(struct cpuid *id)
+{
+	asm volatile ("stidp %0\n" : "+Q"(*id));
+}
+
+/* Big Endian BIT macro that uses the bit value within a 64bit value */
+#define BIT(a) (1UL << (63-(a % 64)))
+#define DEFLTCC_GEN15 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(4))
+#define DEFLTCC_GEN15_F (BIT(0))
+static void test_deflate(void)
+{
+	unsigned long query[4];
+	struct cpuid id = {};
+
+	report_prefix_push("deflate");
+
+	query_opcode(0xb939, query);
+	query_cpuid(&id);
+
+	/* check for the correct bits depending on cpu */
+	switch(id.type) {
+	case 0x8561:
+	case 0x8562:
+		report ("only functions 0,1,2,4", query[0] == DEFLTCC_GEN15 &&
+						  query[1] == 0);
+		report ("reserved == 0", query[2] == 0);
+		report ("only format0", query[3] == DEFLTCC_GEN15_F);
+		break;
+	default:
+		report_skip("Unknown CPU type");
+		break;
+	}
+
+	report_prefix_pop();
+}
+
+static void test_vxpdeh(void)
+{
+	report_prefix_push("vxpdeh");
+
+	/* Dependencies */
+	report("facility 129 available", test_facility(129));
+	report("facility 134 available", test_facility(134));
+
+	report_prefix_pop();
+}
+
+
+#define KDSA_GEN15 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(3)  | BIT(9)  | \
+		    BIT(10) | BIT(11) | BIT(17) | BIT(18) | BIT(19) | \
+		    BIT(32) | BIT(36) | BIT(40) | BIT(44) | BIT(48) | \
+		    BIT(52))
+#define PCC_GEN15_0 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(3)  | BIT(9)  | \
+		    BIT(10) | BIT(11) | BIT(18) | BIT(19) | BIT(20) | \
+		    BIT(26) | BIT(27) | BIT(28) | BIT(50) | BIT(52) | \
+		    BIT(58) | BIT(60))
+#define PCC_GEN15_1 (BIT(64) | BIT(65) | BIT(66) | BIT(72) | \
+		    BIT(73) | BIT(80) | BIT(81))
+
+static void test_msa9(void)
+{
+	unsigned long query_kdsa[4];
+	unsigned long query_pcc[4];
+	struct cpuid id = {};
+
+	report_prefix_push("msa9");
+
+	/* Dependencies */
+	report("facility 76 available", test_facility(76));
+	report("facility 77 available", test_facility(77));
+
+	query_opcode(0xb92c, query_pcc);
+	query_opcode(0xb93a, query_kdsa);
+	query_cpuid(&id);
+	/* check for the correct bits depending on cpu */
+	switch(id.type) {
+	case 0x8561:
+	case 0x8562:
+		report ("kdsa functions 0,1,2,3,9,10,11,17,18,19,32,36,40,44,48",
+			query_kdsa[0] == KDSA_GEN15 &&  query_kdsa[1] == 0);
+		report ("pcc functions 0,1,2,3,9,10,11,18,19,20,26,27,28,50,52,58,60",
+			query_pcc[0] == PCC_GEN15_0);
+		report ("pcc functions 64,65,66,72,73,80,81",
+			query_pcc[1] == PCC_GEN15_1);
+		break;
+	default:
+		report_skip("Unknown CPU type");
+		break;
+	}
+
+	report_prefix_pop();
+}
+
+static void test_etoken(void)
+{
+	report_prefix_push("etoken");
+	/* Dependencies */
+	report("facility 49 or 81 available",
+		test_facility(49) || test_facility(81));
+}
+
+int main(void)
+{
+	report_prefix_push("gen15 cpu model");
+
+	if (test_facility(61)) {
+		test_minste3();
+	} else {
+		report_skip("Miscellaneous-Instruction-Extensions Facility 3 is not available");
+	}
+	if (test_facility(148)) {
+		test_vxeh2();
+	} else {
+		report_skip("Vector Enhancements facility 2 not available");
+	}
+	if (test_facility(151)) {
+		test_deflate();
+	} else {
+		report_skip("Deflate-Conversion-Facility not available");
+	}
+	if (test_facility(152)) {
+		test_vxpdeh();
+	} else {
+		report_skip("Vector-Packed-Decimal-Enhancement Facility");
+	}
+	if (test_facility(155)) {
+		test_msa9();
+	} else {
+		report_skip("Message-Security-Assist-Extenstion-9-Facility 1 not available");
+	}
+	if (test_facility(156)) {
+		test_etoken();
+	} else {
+		report_skip("Etoken-Facility not available");
+	}
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 546b1f281f8f..d12797036930 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -61,3 +61,7 @@ file = gs.elf
 
 [iep]
 file = iep.elf
+
+[gen15]
+file = gen15.elf
+accel = kvm
-- 
2.21.0

