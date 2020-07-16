Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED9221E31
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 10:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGPIXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 04:23:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14036 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727045AbgGPIXj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 04:23:39 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G82xAi145934;
        Thu, 16 Jul 2020 04:23:38 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32a7hnarv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:23:37 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06G83XTE148912;
        Thu, 16 Jul 2020 04:23:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32a7hnarud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:23:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06G8Jutk011471;
        Thu, 16 Jul 2020 08:23:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 329nmyhk0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 08:23:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06G8NXbU64094294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 08:23:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66E6C4C04E;
        Thu, 16 Jul 2020 08:23:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD9D94C046;
        Thu, 16 Jul 2020 08:23:32 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.61.186])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 08:23:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v13 3/9] s390x: export the clock get_clock_ms() utility
Date:   Thu, 16 Jul 2020 10:23:23 +0200
Message-Id: <1594887809-10521-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
References: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_04:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=1
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To serve multiple times, the function get_clock_ms() is moved
from intercept.c test to the new file asm/time.h.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/asm/time.h | 26 ++++++++++++++++++++++++++
 s390x/intercept.c    | 11 +----------
 2 files changed, 27 insertions(+), 10 deletions(-)
 create mode 100644 lib/s390x/asm/time.h

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
new file mode 100644
index 0000000..1791380
--- /dev/null
+++ b/lib/s390x/asm/time.h
@@ -0,0 +1,26 @@
+/*
+ * Clock utilities for s390
+ *
+ * Authors:
+ *  Thomas Huth <thuth@redhat.com>
+ *
+ * Copied from the s390/intercept test by:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef ASM_S390X_TIME_H
+#define ASM_S390X_TIME_H
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
+#endif
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 5f46b82..2e38257 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -14,6 +14,7 @@
 #include <asm/interrupt.h>
 #include <asm/page.h>
 #include <asm/facility.h>
+#include <asm/time.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -153,16 +154,6 @@ static void test_testblock(void)
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
2.25.1

