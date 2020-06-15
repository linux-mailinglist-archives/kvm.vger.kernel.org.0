Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC8C1F937E
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgFOJcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:32:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29432 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729148AbgFOJcM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:32:12 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F84K0D045142;
        Mon, 15 Jun 2020 05:32:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n0j7jmba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:11 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05F8h5bt195393;
        Mon, 15 Jun 2020 05:32:11 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n0j7jma9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:10 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05F9K9ZT025211;
        Mon, 15 Jun 2020 09:32:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 31mpe89aw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 09:32:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05F9W6a053805440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 09:32:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DAD55204E;
        Mon, 15 Jun 2020 09:32:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ECF6952065;
        Mon, 15 Jun 2020 09:32:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v9 08/12] s390x: retrieve decimal and hexadecimal kernel parameters
Date:   Mon, 15 Jun 2020 11:31:57 +0200
Message-Id: <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_01:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 suspectscore=1 malwarescore=0 cotscore=-2147483648
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 mlxscore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006150066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We often need to retrieve hexadecimal kernel parameters.
Let's implement a shared utility to do it.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
 lib/s390x/kernel-args.h | 18 +++++++++++++
 s390x/Makefile          |  1 +
 3 files changed, 79 insertions(+)
 create mode 100644 lib/s390x/kernel-args.c
 create mode 100644 lib/s390x/kernel-args.h

diff --git a/lib/s390x/kernel-args.c b/lib/s390x/kernel-args.c
new file mode 100644
index 0000000..2d3b2c2
--- /dev/null
+++ b/lib/s390x/kernel-args.c
@@ -0,0 +1,60 @@
+/*
+ * Retrieving kernel arguments
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
+#include <string.h>
+#include <asm/arch_def.h>
+#include <kernel-args.h>
+
+static const char *hex_digit = "0123456789abcdef";
+
+static unsigned long htol(char *s)
+{
+	unsigned long v = 0, shift = 0, value = 0;
+	int i, digit, len = strlen(s);
+
+	for (shift = 0, i = len - 1; i >= 0; i--, shift += 4) {
+		digit = s[i] | 0x20;	/* Set lowercase */
+		if (!strchr(hex_digit, digit))
+			return 0;	/* this is not a digit ! */
+
+		if (digit <= '9')
+			v = digit - '0';
+		else
+			v = digit - 'a' + 10;
+		value += (v << shift);
+	}
+
+	return value;
+}
+
+int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val)
+{
+	int i, ret;
+	char *p, *q;
+
+	for (i = 0; i < argc; i++) {
+		ret = strncmp(argv[i], str, strlen(str));
+		if (ret)
+			continue;
+		p = strchr(argv[i], '=');
+		if (!p)
+			return -1;
+		q = strchr(p, 'x');
+		if (!q)
+			*val = atol(p + 1);
+		else
+			*val = htol(q + 1);
+		return 0;
+	}
+	return -2;
+}
diff --git a/lib/s390x/kernel-args.h b/lib/s390x/kernel-args.h
new file mode 100644
index 0000000..a88e34e
--- /dev/null
+++ b/lib/s390x/kernel-args.h
@@ -0,0 +1,18 @@
+/*
+ * Kernel argument
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
+#ifndef KERNEL_ARGS_H
+#define KERNEL_ARGS_H
+
+int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val);
+
+#endif
diff --git a/s390x/Makefile b/s390x/Makefile
index ddb4b48..47a94cc 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/kernel-args.o
 
 OBJDIRS += lib/s390x
 
-- 
2.25.1

