Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5620511B429
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 16:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbfLKPqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 10:46:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388754AbfLKPqU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 10:46:20 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBFhlla084232
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:18 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wrt13h5x0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:46:18 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 11 Dec 2019 15:46:16 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 15:46:13 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBFkCLu60227618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 15:46:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A72594C046;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F8454C04A;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 15:46:12 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 6/9] s390x: css: stsch, enumeration test
Date:   Wed, 11 Dec 2019 16:46:07 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121115-0028-0000-0000-000003C79767
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121115-0029-0000-0000-0000248ACD3C
Message-Id: <1576079170-7244-7-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_04:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 suspectscore=1 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110132
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First step for testing the channel subsystem is to enumerate the css and
retrieve the css devices.

This tests the success of STSCH I/O instruction, we do not test the
reaction of the VM for an instruction with wrong parameters.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     |  1 +
 s390x/Makefile      |  2 ++
 s390x/css.c         | 88 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 +++
 4 files changed, 95 insertions(+)
 create mode 100644 s390x/css.c

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index fd086aa..06f048b 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -82,6 +82,7 @@ struct pmcw {
 	uint8_t  chpid[8];
 	uint32_t flags2;
 };
+#define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
 
 struct schib {
 	struct pmcw pmcw;
diff --git a/s390x/Makefile b/s390x/Makefile
index 3744372..9ebbb84 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
 tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
+tests += $(TEST_DIR)/css.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
@@ -50,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/css_dump.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/css.c b/s390x/css.c
new file mode 100644
index 0000000..dfab35f
--- /dev/null
+++ b/s390x/css.c
@@ -0,0 +1,88 @@
+/*
+ * Channel Subsystem tests
+ *
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+
+#include <libcflat.h>
+#include <alloc_phys.h>
+#include <asm/page.h>
+#include <string.h>
+#include <interrupt.h>
+#include <asm/arch_def.h>
+#include <asm/time.h>
+
+#include <css.h>
+
+#define SID_ONE		0x00010000
+
+static struct schib schib;
+static int test_device_sid;
+
+static void test_enumerate(void)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+	int scn;
+	int scn_found = 0;
+
+	for (scn = 0; scn < 0xffff; scn++) {
+		cc = stsch(scn|SID_ONE, &schib);
+		switch (cc) {
+		case 0:		/* 0 means SCHIB stored */
+			break;
+		case 3:		/* 3 means no more channels */
+			goto out;
+		default:	/* 1 or 2 should never happened for STSCH */
+			report(0, "Unexpected cc=%d on scn 0x%x", cc, scn);
+			return;
+		}
+		if (cc)
+			break;
+		/* We silently only support type 0, a.k.a. I/O channels */
+		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
+			continue;
+		/* We ignore I/O channels without valid devices */
+		if (!(pmcw->flags & PMCW_DNV))
+			continue;
+		/* We keep track of the first device as our test device */
+		if (!test_device_sid)
+			test_device_sid = scn|SID_ONE;
+		scn_found++;
+	}
+out:
+	if (!scn_found) {
+		report(0, "Devices, Tested: %d, no I/O type found", scn);
+		return;
+	}
+	report(1, "Devices, tested: %d, I/O type: %d", scn, scn_found);
+}
+
+static struct {
+	const char *name;
+	void (*func)(void);
+} tests[] = {
+	{ "enumerate (stsch)", test_enumerate },
+	{ NULL, NULL }
+};
+
+int main(int argc, char *argv[])
+{
+	int i;
+
+	report_prefix_push("Channel Sub-System");
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		tests[i].func();
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f1b07cd..1755d9e 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -75,3 +75,7 @@ file = stsi.elf
 [smp]
 file = smp.elf
 extra_params =-smp 2
+
+[css]
+file = css.elf
+extra_params =-device ccw-pong
-- 
2.17.0

