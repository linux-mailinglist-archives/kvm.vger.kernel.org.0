Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFCD2343A0
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbgGaJq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:46:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49414 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732293AbgGaJq0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:46:26 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V9VnP0075820;
        Fri, 31 Jul 2020 05:46:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mgkhgj69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:26 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V9VrG4076251;
        Fri, 31 Jul 2020 05:46:25 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mgkhgj5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V9jLAb004116;
        Fri, 31 Jul 2020 09:46:23 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 32gcqk4bdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 09:46:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V9ispM48300344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 09:44:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23F16AE053;
        Fri, 31 Jul 2020 09:46:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8065AE04D;
        Fri, 31 Jul 2020 09:46:19 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.62.184])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 09:46:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 01/11] s390x/cpumodel: The missing DFP facility on TCG is expected
Date:   Fri, 31 Jul 2020 11:45:57 +0200
Message-Id: <20200731094607.15204-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200731094607.15204-1-frankja@linux.ibm.com>
References: <20200731094607.15204-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=709
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

When running the kvm-unit-tests with TCG on s390x, the cpumodel test
always reports the error about the missing DFP (decimal floating point)
facility. This is kind of expected, since DFP is not required for
running Linux and thus nobody is really interested in implementing
this facility in TCG. Thus let's mark this as an expected error instead,
so that we can run the kvm-unit-tests also with TCG without getting
test failures that we do not care about.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200708150025.20631-1-thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/vm.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/vm.h   | 14 ++++++++++++++
 s390x/Makefile   |  1 +
 s390x/cpumodel.c | 19 +++++++++++++------
 4 files changed, 74 insertions(+), 6 deletions(-)
 create mode 100644 lib/s390x/vm.c
 create mode 100644 lib/s390x/vm.h

diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
new file mode 100644
index 0000000..c852713
--- /dev/null
+++ b/lib/s390x/vm.c
@@ -0,0 +1,46 @@
+/*
+ * Functions to retrieve VM-specific information
+ *
+ * Copyright (c) 2020 Red Hat Inc
+ *
+ * Authors:
+ *  Thomas Huth <thuth@redhat.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/arch_def.h>
+#include "vm.h"
+
+/**
+ * Detect whether we are running with TCG (instead of KVM)
+ */
+bool vm_is_tcg(void)
+{
+	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
+	static bool initialized = false;
+	static bool is_tcg = false;
+	uint8_t *buf;
+
+	if (initialized)
+		return is_tcg;
+
+	buf = alloc_page();
+	if (!buf)
+		return false;
+
+	if (stsi(buf, 1, 1, 1))
+		goto out;
+
+	/*
+	 * If the manufacturer string is "QEMU" in EBCDIC, then we
+	 * are on TCG (otherwise the string is "IBM" in EBCDIC)
+	 */
+	is_tcg = !memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic));
+	initialized = true;
+out:
+	free_page(buf);
+	return is_tcg;
+}
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
new file mode 100644
index 0000000..33008d8
--- /dev/null
+++ b/lib/s390x/vm.h
@@ -0,0 +1,14 @@
+/*
+ * Functions to retrieve VM-specific information
+ *
+ * Copyright (c) 2020 Red Hat Inc
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#ifndef S390X_VM_H
+#define S390X_VM_H
+
+bool vm_is_tcg(void);
+
+#endif  /* S390X_VM_H */
diff --git a/s390x/Makefile b/s390x/Makefile
index ddb4b48..98ac29e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/vm.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 5d232c6..116a966 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -11,14 +11,19 @@
  */
 
 #include <asm/facility.h>
+#include <vm.h>
 
-static int dep[][2] = {
+static struct {
+	int facility;
+	int implied;
+	bool expected_tcg_fail;
+} dep[] = {
 	/* from SA22-7832-11 4-98 facility indications */
 	{   4,   3 },
 	{   5,   3 },
 	{   5,   4 },
 	{  19,  18 },
-	{  37,  42 },
+	{  37,  42, true },  /* TCG does not have DFP and won't get it soon */
 	{  43,  42 },
 	{  73,  49 },
 	{ 134, 129 },
@@ -46,11 +51,13 @@ int main(void)
 
 	report_prefix_push("dependency");
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
-		if (test_facility(dep[i][0])) {
-			report(test_facility(dep[i][1]), "%d implies %d",
-				dep[i][0], dep[i][1]);
+		if (test_facility(dep[i].facility)) {
+			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
+				     test_facility(dep[i].implied),
+				     "%d implies %d",
+				     dep[i].facility, dep[i].implied);
 		} else {
-			report_skip("facility %d not present", dep[i][0]);
+			report_skip("facility %d not present", dep[i].facility);
 		}
 	}
 	report_prefix_pop();
-- 
2.25.4

