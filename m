Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313C63E41D4
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbhHIItr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:49:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234057AbhHIIt1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 04:49:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798Xf7m125809;
        Mon, 9 Aug 2021 04:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=1amWH3ZtCJIaZPJ9kInFETzN6KlEGy7GYxiiGi+3fec=;
 b=XO6B7zfqLaj5FN4ZUDlXDMygq+yfufaVtOW9I2EEQC5A1ROfqxj4kzbSQ5zALeuhYWD8
 VKuZk1Bfa8eoN5r/OJ0XfEnERKzzYNiS8qm+ZIlRRpjUo9IZ1KdUogNzMKOdZUTA1Xri
 g8s7A8aekzro9x8hzwWQPIV/jT1aosOXcDB+4HLpIm95ECK/8sUzn6mMjsBKcswED1rr
 SXIl1zOSvt6p4bv0qeWKR75kZwfuzXhUDl/PswZDc0FQxpG3s68QW3nMFXs3+gA/dX1d
 +kUQgbrQbohO/jyNA8D3el7iJZIExc+pkpqMPsl8sQ63q8TCSy5unudT6AhdhaOvYj4o TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa74j2fdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:03 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1798XsrX126746;
        Mon, 9 Aug 2021 04:49:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aa74j2fd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798lQ4N010998;
        Mon, 9 Aug 2021 08:49:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8untb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:49:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798mvWC23986596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:48:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A471D42057;
        Mon,  9 Aug 2021 08:48:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A74C42045;
        Mon,  9 Aug 2021 08:48:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:48:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/4] s390x: topology: check the Perform Topology Function
Date:   Mon,  9 Aug 2021 10:48:53 +0200
Message-Id: <1628498934-20735-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U5-9dnRaObRegIeDnuphkfL3444_-lut
X-Proofpoint-GUID: _RAqKBP4ZSBtWwJoRAx9RvcD4fXefl-b
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We check the PTF instruction.

- We do not expect to support vertical polarization.

- We do not expect the Modified Topology Change Report to be
pending or not at the moment the first PTF instruction with
PTF_CHECK function code is done as some code already did run
a polarization change may have occur.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/Makefile      |  1 +
 s390x/topology.c    | 87 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 ++
 3 files changed, 91 insertions(+)
 create mode 100644 s390x/topology.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 6565561b..c82b7dbf 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
+tests += $(TEST_DIR)/topology.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/topology.c b/s390x/topology.c
new file mode 100644
index 00000000..4146189a
--- /dev/null
+++ b/s390x/topology.c
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * CPU Topology
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ */
+
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+#include <asm/interrupt.h>
+#include <asm/facility.h>
+#include <smp.h>
+#include <sclp.h>
+
+static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+int machine_level;
+int mnest;
+
+#define PTF_HORIZONTAL	0
+#define PTF_VERTICAL	1
+#define PTF_CHECK	2
+
+#define PTF_ERR_NO_REASON	0
+#define PTF_ERR_ALRDY_POLARIZED	1
+#define PTF_ERR_IN_PROGRESS	2
+
+static int ptf(unsigned long fc, unsigned long *rc)
+{
+	int cc;
+
+	asm volatile(
+		"       .insn   rre,0xb9a20000,%1,%1\n"
+		"       ipm     %0\n"
+		"       srl     %0,28\n"
+		: "=d" (cc), "+d" (fc)
+		: "d" (fc)
+		: "cc");
+
+	*rc = fc >> 8;
+	return cc;
+}
+
+static void test_ptf(void)
+{
+	unsigned long rc;
+	int cc;
+
+	report_prefix_push("Topology Report pending");
+	/*
+	 * At this moment the topology may already have changed
+	 * since the VM has been started.
+	 * However, we can test if a second PTF instruction
+	 * reports that the topology did not change since the
+	 * preceding PFT instruction.
+	 */
+	ptf(PTF_CHECK, &rc);
+	cc = ptf(PTF_CHECK, &rc);
+	report(cc == 0, "PTF check clear");
+	cc = ptf(PTF_HORIZONTAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
+	       "PTF horizontal already configured");
+	cc = ptf(PTF_VERTICAL, &rc);
+	report(cc == 2 && rc == PTF_ERR_NO_REASON,
+	       "PTF vertical non possible");
+
+	report_prefix_pop();
+}
+
+int main(int argc, char *argv[])
+{
+	report_prefix_push("stsi");
+
+	if (!test_facility(11)) {
+		report_skip("Topology facility not present");
+		goto end;
+	}
+
+	report_info("Machine level %ld", stsi_get_fc(pagebuf));
+
+	test_ptf();
+end:
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9e1802fd..0f84d279 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -109,3 +109,6 @@ file = edat.elf
 
 [mvpg-sie]
 file = mvpg-sie.elf
+
+[topology]
+file = topology.elf
-- 
2.25.1

