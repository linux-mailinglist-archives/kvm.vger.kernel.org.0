Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DD7222361
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 15:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgGPNCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 09:02:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbgGPNCy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jul 2020 09:02:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GD2hNi165498;
        Thu, 16 Jul 2020 09:02:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afv0e4u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 09:02:52 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06GD2qoF166561;
        Thu, 16 Jul 2020 09:02:52 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32afv0e4pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 09:02:52 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06GCxu0n017145;
        Thu, 16 Jul 2020 13:02:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 329nmyhu75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 13:02:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06GD2d1h2425312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 13:02:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9FE04C046;
        Thu, 16 Jul 2020 13:02:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25F984C04A;
        Thu, 16 Jul 2020 13:02:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.61.186])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 13:02:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
Subject: [PATCH v14 7/9] s390x: css: stsch, enumeration test
Date:   Thu, 16 Jul 2020 15:02:30 +0200
Message-Id: <1594904550-32273-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594904550-32273-1-git-send-email-pmorel@linux.ibm.com>
References: <7eda888a-88e9-98fe-96ac-d6c7ee1160bf@linux.ibm.com>
 <1594904550-32273-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_06:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 suspectscore=1
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First step for testing the channel subsystem is to enumerate the css and
retrieve the css devices.

We currently don't enable multiple subchannel sets and therefore only
look in subchannel set 0

This tests the success of STSCH I/O instruction, we do not test the
reaction of the VM for an instruction with wrong parameters.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css_lib.c | 70 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/Makefile      |  2 ++
 s390x/css.c         | 55 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 +++
 4 files changed, 131 insertions(+)
 create mode 100644 lib/s390x/css_lib.c
 create mode 100644 s390x/css.c

diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
new file mode 100644
index 0000000..fd087ce
--- /dev/null
+++ b/lib/s390x/css_lib.c
@@ -0,0 +1,70 @@
+/*
+ * Channel Subsystem tests library
+ *
+ * Copyright (c) 2020 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#include <libcflat.h>
+#include <alloc_phys.h>
+#include <asm/page.h>
+#include <string.h>
+#include <interrupt.h>
+#include <asm/arch_def.h>
+
+#include <css.h>
+
+static struct schib schib;
+
+/*
+ * css_enumerate:
+ * On success return the first subchannel ID found.
+ * On error return an invalid subchannel ID containing cc
+ */
+int css_enumerate(void)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int scn_found = 0;
+	int dev_found = 0;
+	int schid = 0;
+	int cc;
+	int scn;
+
+	for (scn = 0; scn < 0xffff; scn++) {
+		cc = stsch(scn | SCHID_ONE, &schib);
+		switch (cc) {
+		case 0:		/* 0 means SCHIB stored */
+			break;
+		case 3:		/* 3 means no more channels */
+			goto out;
+		default:	/* 1 or 2 should never happen for STSCH */
+			report_abort("Unexpected error %d on subchannel %08x",
+				     cc, scn | SCHID_ONE);
+			return cc;
+		}
+
+		/* We currently only support type 0, a.k.a. I/O channels */
+		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
+			continue;
+
+		/* We ignore I/O channels without valid devices */
+		scn_found++;
+		if (!(pmcw->flags & PMCW_DNV))
+			continue;
+
+		/* We keep track of the first device as our test device */
+		if (!schid)
+			schid = scn | SCHID_ONE;
+		report_info("Found subchannel %08x", scn | SCHID_ONE);
+		dev_found++;
+	}
+
+out:
+	report_info("Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
+		    scn, scn_found, dev_found);
+	return schid;
+}
diff --git a/s390x/Makefile b/s390x/Makefile
index 07d3c4b..0f54bf4 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -17,6 +17,7 @@ tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
+tests += $(TEST_DIR)/css.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
@@ -53,6 +54,7 @@ cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
+cflatobjs += lib/s390x/css_lib.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/css.c b/s390x/css.c
new file mode 100644
index 0000000..e19ffc8
--- /dev/null
+++ b/s390x/css.c
@@ -0,0 +1,55 @@
+/*
+ * Channel Subsystem tests
+ *
+ * Copyright (c) 2020 IBM Corp
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
+
+#include <css.h>
+
+static int test_device_sid;
+
+static void test_enumerate(void)
+{
+	test_device_sid = css_enumerate();
+	if (test_device_sid & SCHID_ONE) {
+		report(1, "Schid of first I/O device: 0x%08x", test_device_sid);
+		return;
+	}
+	report(0, "No I/O device found");
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
+	report_prefix_push("Channel Subsystem");
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
index b307329..0f156af 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -84,3 +84,7 @@ extra_params = -m 1G
 [sclp-3g]
 file = sclp.elf
 extra_params = -m 3G
+
+[css]
+file = css.elf
+extra_params = -device virtio-net-ccw
-- 
2.25.1

