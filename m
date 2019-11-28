Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 516B810C8D5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 13:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfK1MqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 07:46:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbfK1MqT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 07:46:19 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASChLHc064776
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:18 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxssue5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:18 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 28 Nov 2019 12:46:15 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 12:46:12 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASCkBeo37290098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:46:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72286AE055;
        Thu, 28 Nov 2019 12:46:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 104A4AE058;
        Thu, 28 Nov 2019 12:46:11 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.185.119])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 12:46:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/9] s390x: export the clock get_clock_ms() utility
Date:   Thu, 28 Nov 2019 13:46:02 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19112812-0012-0000-0000-0000036D6302
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112812-0013-0000-0000-000021A90FEC
Message-Id: <1574945167-29677-5-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_03:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To serve multiple times, the function get_clock_ms() is moved
from intercept.c test to the new file asm/clock.h.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/clock.h | 25 +++++++++++++++++++++++++
 s390x/intercept.c     | 11 +----------
 2 files changed, 26 insertions(+), 10 deletions(-)
 create mode 100644 lib/s390x/asm/clock.h

diff --git a/lib/s390x/asm/clock.h b/lib/s390x/asm/clock.h
new file mode 100644
index 0000000..e293741
--- /dev/null
+++ b/lib/s390x/asm/clock.h
@@ -0,0 +1,25 @@
+/*
+ * Clock utilities for s390
+ *
+ * Authors:
+ *  Thomas Huth <thuth@redhat.com>
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef _ASM_S390X_CLOCK_H_
+#define _ASM_S390X_CLOCK_H_
+
+static inline uint64_t get_clock_ms(void)
+{
+	uint64_t clk;
+
+	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
+
+	/* Bit 51 is incrememented each microsecond */
+	return (clk >> (63 - 51)) / 1000;
+}
+
+
+#endif
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 404b4c6..ab08533 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
+#include <asm/clock.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -159,16 +160,6 @@ static void test_testblock(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
-static uint64_t get_clock_ms(void)
-{
-	uint64_t clk;
-
-	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
-
-	/* Bit 51 is incrememented each microsecond */
-	return (clk >> (63 - 51)) / 1000;
-}
-
 struct {
 	const char *name;
 	void (*func)(void);
-- 
2.17.0

