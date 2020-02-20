Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65A0165D20
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 13:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBTMBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 07:01:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbgBTMAx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 07:00:53 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KC0kQC019569
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 07:00:52 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y9sbu8tb3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 07:00:52 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 20 Feb 2020 12:00:49 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 12:00:47 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KC0kcl37486944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 12:00:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C591AE05F;
        Thu, 20 Feb 2020 12:00:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10218AE05A;
        Thu, 20 Feb 2020 12:00:46 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 12:00:45 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 07/10] s390x: css: stsch, enumeration test
Date:   Thu, 20 Feb 2020 13:00:40 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022012-0012-0000-0000-000003889715
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022012-0013-0000-0000-000021C52DA3
Message-Id: <1582200043-21760-8-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_03:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200091
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
 s390x/Makefile      |  2 +
 s390x/css.c         | 91 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 ++
 4 files changed, 98 insertions(+)
 create mode 100644 s390x/css.c

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 8144a21..448e597 100644
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
index ddb4b48..baebf18 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -17,6 +17,7 @@ tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
+tests += $(TEST_DIR)/css.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
@@ -51,6 +52,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/css_dump.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/css.c b/s390x/css.c
new file mode 100644
index 0000000..cb33e00
--- /dev/null
+++ b/s390x/css.c
@@ -0,0 +1,91 @@
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
+	int dev_found = 0;
+
+	for (scn = 0; scn < 0xffff; scn++) {
+		cc = stsch(scn|SID_ONE, &schib);
+		switch (cc) {
+		case 0:		/* 0 means SCHIB stored */
+			break;
+		case 3:		/* 3 means no more channels */
+			goto out;
+		default:	/* 1 or 2 should never happened for STSCH */
+			report(0, "Unexpected cc=%d on subchannel number 0x%x",
+			       cc, scn);
+			return;
+		}
+		/* We currently only support type 0, a.k.a. I/O channels */
+		if (PMCW_CHANNEL_TYPE(pmcw) != 0)
+			continue;
+		/* We ignore I/O channels without valid devices */
+		scn_found++;
+		if (!(pmcw->flags & PMCW_DNV))
+			continue;
+		/* We keep track of the first device as our test device */
+		if (!test_device_sid)
+			test_device_sid = scn|SID_ONE;
+		dev_found++;
+	}
+out:
+	if (!dev_found) {
+		report(0, "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
+		       scn, scn_found, dev_found);
+		return;
+	}
+	report(1, "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
+	       scn, scn_found, dev_found);
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
index 07013b2..a436ec0 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -83,3 +83,7 @@ extra_params = -m 1G
 [sclp-3g]
 file = sclp.elf
 extra_params = -m 3G
+
+[css]
+file = css.elf
+extra_params =-device ccw-pong
-- 
2.17.0

