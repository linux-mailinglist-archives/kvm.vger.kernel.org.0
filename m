Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C2A431948
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhJRMkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231466AbhJRMkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19I9q4JK017306;
        Mon, 18 Oct 2021 08:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wSkxNw80qPLNYyjOQtr103eF1Eod7stDnWfnv9Zsa4U=;
 b=YC9uCGJqM2Q60S2/oZXnbdJh2iRm3S68zoxaIE/iR3i3IZHjx9SAGJIcPvQOk8MpVV1z
 zDnlVlSV31UKtdiSpNyptgA1BtLazSeljSDjIk3Mecw+Zvnqu6AtSNaaY/gDNkQ08MnN
 Nk/3RBFUdqHMn0k4flsPCDpKeUMQuZ0Mc7CcYVelf4TQPQqTpKOcP2TWERDwAi6zGhr8
 aX0tAMwziGq/gRenpaw9VS7arUI6BXGJ3FbB01QhuXZe53IS6phEf3oOi1/9V/cOnPYl
 UpKcWXNOHGjbPnPxB7Tcwpks/285/qQw5K0RKIfBCaqjtAFsDVYn7MhW1ahElBIQRvQE GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs6np3brs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19I9rGcX019293;
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs6np3br7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbJoJ005206;
        Mon, 18 Oct 2021 12:38:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpc9cykp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICbx1U63701500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:37:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A49552050;
        Mon, 18 Oct 2021 12:37:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1845D52054;
        Mon, 18 Oct 2021 12:37:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 03/17] lib: s390x: Print addressing related exception information
Date:   Mon, 18 Oct 2021 14:26:21 +0200
Message-Id: <20211018122635.53614-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KUqA0g2eobDtqYe4l1CwQRSMUrc_3g6C
X-Proofpoint-ORIG-GUID: caoqCE6tQct9s303JpfYVDbc2mUBFmUm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we only get told the kind of program exception as well as
the PSW at the point where it happened.

For addressing exceptions the PSW is not always enough so let's print
the TEID which contains the failing address and flags that tell us
more about the kind of address exception.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h |  5 +++
 lib/s390x/fault.c        | 76 ++++++++++++++++++++++++++++++++++++++++
 lib/s390x/fault.h        | 44 +++++++++++++++++++++++
 lib/s390x/interrupt.c    | 27 ++++++++++++--
 s390x/Makefile           |  1 +
 5 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100644 lib/s390x/fault.c
 create mode 100644 lib/s390x/fault.h

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 24892bd8..aa80d840 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -41,6 +41,11 @@ struct psw {
 	uint64_t	addr;
 };
 
+#define AS_PRIM				0
+#define AS_ACCR				1
+#define AS_SECN				2
+#define AS_HOME				3
+
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_DAT			0x0400000000000000UL
diff --git a/lib/s390x/fault.c b/lib/s390x/fault.c
new file mode 100644
index 00000000..d3ef00e4
--- /dev/null
+++ b/lib/s390x/fault.c
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Library to decode addressing related exceptions
+ *
+ * Copyright 2021 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <libcflat.h>
+#include <bitops.h>
+#include <asm/arch_def.h>
+#include <asm/page.h>
+#include <fault.h>
+
+static struct lowcore *lc = (struct lowcore *)0x0;
+
+/* Decodes the protection exceptions we'll most likely see */
+static void print_decode_pgm_prot(uint64_t teid)
+{
+	if (prot_is_lap(teid)) {
+		printf("Type: LAP\n");
+		return;
+	}
+
+	if (prot_is_iep(teid)) {
+		printf("Type: IEP\n");
+		return;
+	}
+
+	if (prot_is_datp(teid)) {
+		printf("Type: DAT\n");
+		return;
+	}
+}
+
+void print_decode_teid(uint64_t teid)
+{
+	int asce_id = teid & 3;
+	bool dat = lc->pgm_old_psw.mask & PSW_MASK_DAT;
+
+	printf("Memory exception information:\n");
+	printf("DAT: %s\n", dat ? "on" : "off");
+
+	printf("AS: ");
+	switch (asce_id) {
+	case AS_PRIM:
+		printf("Primary\n");
+		break;
+	case AS_ACCR:
+		printf("Access Register\n");
+		break;
+	case AS_SECN:
+		printf("Secondary\n");
+		break;
+	case AS_HOME:
+		printf("Home\n");
+		break;
+	}
+
+	if (lc->pgm_int_code == PGM_INT_CODE_PROTECTION)
+		print_decode_pgm_prot(teid);
+
+	/*
+	 * If teid bit 61 is off for these two exception the reported
+	 * address is unpredictable.
+	 */
+	if ((lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
+	     lc->pgm_int_code == PGM_INT_CODE_SECURE_STOR_VIOLATION) &&
+	    !test_bit_inv(61, &teid)) {
+		printf("Address: %lx, unpredictable\n ", teid & PAGE_MASK);
+		return;
+	}
+	printf("TEID: %lx\n", teid);
+	printf("Address: %lx\n\n", teid & PAGE_MASK);
+}
diff --git a/lib/s390x/fault.h b/lib/s390x/fault.h
new file mode 100644
index 00000000..726da2f0
--- /dev/null
+++ b/lib/s390x/fault.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Headers for fault.c
+ *
+ * Copyright 2021 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
+#ifndef _S390X_FAULT_H_
+#define _S390X_FAULT_H_
+
+#include <bitops.h>
+
+/* Instruction execution prevention, i.e. no-execute, 101 */
+static inline bool prot_is_iep(uint64_t teid)
+{
+	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
+		return true;
+
+	return false;
+}
+
+/* Standard DAT exception, 001 */
+static inline bool prot_is_datp(uint64_t teid)
+{
+	if (!test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && test_bit_inv(61, &teid))
+		return true;
+
+	return false;
+}
+
+/* Low-address protection exception, 100 */
+static inline bool prot_is_lap(uint64_t teid)
+{
+	if (test_bit_inv(56, &teid) && !test_bit_inv(60, &teid) && !test_bit_inv(61, &teid))
+		return true;
+
+	return false;
+}
+
+void print_decode_teid(uint64_t teid);
+
+#endif /* _S390X_FAULT_H_ */
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 01ded49d..126d4c0a 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -12,6 +12,8 @@
 #include <sclp.h>
 #include <interrupt.h>
 #include <sie.h>
+#include <fault.h>
+#include <asm/page.h>
 
 static bool pgm_int_expected;
 static bool ext_int_expected;
@@ -76,8 +78,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 		break;
 	case PGM_INT_CODE_PROTECTION:
 		/* Handling for iep.c test case. */
-		if (lc->trans_exc_id & 0x80UL && lc->trans_exc_id & 0x04UL &&
-		    !(lc->trans_exc_id & 0x08UL))
+		if (prot_is_iep(lc->trans_exc_id))
 			/*
 			 * We branched to the instruction that caused
 			 * the exception so we can use the return
@@ -126,6 +127,24 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
+static void print_storage_exception_information(void)
+{
+	switch (lc->pgm_int_code) {
+	case PGM_INT_CODE_PROTECTION:
+	case PGM_INT_CODE_PAGE_TRANSLATION:
+	case PGM_INT_CODE_SEGMENT_TRANSLATION:
+	case PGM_INT_CODE_ASCE_TYPE:
+	case PGM_INT_CODE_REGION_FIRST_TRANS:
+	case PGM_INT_CODE_REGION_SECOND_TRANS:
+	case PGM_INT_CODE_REGION_THIRD_TRANS:
+	case PGM_INT_CODE_SECURE_STOR_ACCESS:
+	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
+	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
+		print_decode_teid(lc->trans_exc_id);
+		break;
+	}
+}
+
 static void print_int_regs(struct stack_frame_int *stack)
 {
 	printf("\n");
@@ -155,6 +174,10 @@ static void print_pgm_info(struct stack_frame_int *stack)
 	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
 	print_int_regs(stack);
 	dump_stack();
+
+	/* Dump stack doesn't end with a \n so we add it here instead */
+	printf("\n");
+	print_storage_exception_information();
 	report_summary();
 	abort();
 }
diff --git a/s390x/Makefile b/s390x/Makefile
index ef8041a6..5d1a33a0 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -72,6 +72,7 @@ cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
+cflatobjs += lib/s390x/fault.o
 
 OBJDIRS += lib/s390x
 
-- 
2.31.1

