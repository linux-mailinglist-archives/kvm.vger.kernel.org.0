Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5FB1D7DD7
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgERQHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:07:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728324AbgERQHm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 12:07:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IG3FQt052750;
        Mon, 18 May 2020 12:07:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c8n6dj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:41 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IG4e9t059785;
        Mon, 18 May 2020 12:07:41 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312c8n6dgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04IG00XX005557;
        Mon, 18 May 2020 16:07:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3127t5medj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 16:07:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IG7asH45482110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 16:07:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E28C11C05C;
        Mon, 18 May 2020 16:07:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 224FD11C05E;
        Mon, 18 May 2020 16:07:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 16:07:36 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration test
Date:   Mon, 18 May 2020 18:07:27 +0200
Message-Id: <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=1
 lowpriorityscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180136
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
 s390x/Makefile      |  1 +
 s390x/css.c         | 89 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 ++
 3 files changed, 94 insertions(+)
 create mode 100644 s390x/css.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 050c40b..baebf18 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -17,6 +17,7 @@ tests += $(TEST_DIR)/stsi.elf
 tests += $(TEST_DIR)/skrf.elf
 tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
+tests += $(TEST_DIR)/css.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/css.c b/s390x/css.c
new file mode 100644
index 0000000..d7989d8
--- /dev/null
+++ b/s390x/css.c
@@ -0,0 +1,89 @@
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
+		if (!test_device_sid)
+			test_device_sid = scn | SID_ONE;
+
+		dev_found++;
+	}
+
+out:
+	report(dev_found,
+	       "Tested subchannels: %d, I/O subchannels: %d, I/O devices: %d",
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
2.25.1

