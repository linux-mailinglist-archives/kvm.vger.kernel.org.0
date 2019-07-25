Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0D7523A
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 17:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388500AbfGYPLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 11:11:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388082AbfGYPLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jul 2019 11:11:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PF8NE5097096
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 11:11:32 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tyceypwx1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 11:11:32 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 25 Jul 2019 16:11:30 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 25 Jul 2019 16:11:27 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6PFBQ2O43123138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 15:11:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14B8A4203F;
        Thu, 25 Jul 2019 15:11:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01FB342042;
        Thu, 25 Jul 2019 15:11:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Jul 2019 15:11:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B8137E0261; Thu, 25 Jul 2019 17:11:25 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [ v2 1/1] kvm-unit-tests: s390: add cpu model checks
Date:   Thu, 25 Jul 2019 17:11:25 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725151125.145362-1-borntraeger@de.ibm.com>
References: <20190725151125.145362-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19072515-0008-0000-0000-00000300CCA1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072515-0009-0000-0000-0000226E61B8
Message-Id: <20190725151125.145362-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a check for documented stfle dependencies.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 s390x/Makefile      |  1 +
 s390x/cpumodel.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 +++
 3 files changed, 62 insertions(+)
 create mode 100644 s390x/cpumodel.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1f21ddb9c943..574a9a20824d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
 tests += $(TEST_DIR)/vector.elf
 tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
+tests += $(TEST_DIR)/cpumodel.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
new file mode 100644
index 000000000000..8ff61f7f6ec9
--- /dev/null
+++ b/s390x/cpumodel.c
@@ -0,0 +1,58 @@
+/*
+ * Test the known dependencies for facilities
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
+static int dep[][2] = {
+	/* from SA22-7832-11 4-98 facility indications */
+	{  4,   3},
+	{  5,   3},
+	{  5,   4},
+	{ 19,  18},
+	{ 37,  42},
+	{ 43,  42},
+	{ 73,  49},
+	{134, 129},
+	{139,  25},
+	{139,  28},
+	{146,  76},
+	/* indirectly documented in description */
+	{ 78,   8},  /* EDAT */
+	/* new dependencies from gen15 */
+	{ 61,  45},
+	{148, 129},
+	{148, 135},
+	{152, 129},
+	{152, 134},
+	{155,  76},
+	{155,  77},
+};
+
+int main(void)
+{
+	int i;
+
+	report_prefix_push("cpumodel");
+
+	report_prefix_push("dependency");
+	for (i = 0; i < ARRAY_SIZE(dep); i++) {
+		if (test_facility(dep[i][0])) {
+			report("%d implies %d",
+				!(test_facility(dep[i][0]) && !test_facility(dep[i][1])),
+				dep[i][0], dep[i][1]);
+		} else {
+			report_skip("facility %d not present", dep[i][0]);
+		}
+	}
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 546b1f281f8f..db58bad5a038 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -61,3 +61,6 @@ file = gs.elf
 
 [iep]
 file = iep.elf
+
+[cpumodel]
+file = cpumodel.elf
-- 
2.21.0

