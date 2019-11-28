Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230DE10C8D0
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 13:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfK1MqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 07:46:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726252AbfK1MqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 07:46:17 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASCh3HZ150405
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:16 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2whcxqkj1s-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 07:46:15 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 28 Nov 2019 12:46:14 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 12:46:11 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASCkAt050200656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:46:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81BBDAE055;
        Thu, 28 Nov 2019 12:46:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F837AE051;
        Thu, 28 Nov 2019 12:46:10 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.185.119])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 12:46:10 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/9] s390x: Define the PSW bits
Date:   Thu, 28 Nov 2019 13:46:00 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19112812-0008-0000-0000-00000339617D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112812-0009-0000-0000-00004A586DA1
Message-Id: <1574945167-29677-3-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_03:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 suspectscore=1 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=863 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911280112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's define the PSW bits  explicitly, it will clarify their
usage.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/arch_bits.h | 20 ++++++++++++++++++++
 lib/s390x/asm/arch_def.h  |  6 ++----
 s390x/cstart64.S          | 13 +++++++------
 3 files changed, 29 insertions(+), 10 deletions(-)
 create mode 100644 lib/s390x/asm/arch_bits.h

diff --git a/lib/s390x/asm/arch_bits.h b/lib/s390x/asm/arch_bits.h
new file mode 100644
index 0000000..a77489a
--- /dev/null
+++ b/lib/s390x/asm/arch_bits.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2019 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef _ASM_S390X_ARCH_BITS_H_
+#define _ASM_S390X_ARCH_BITS_H_
+
+#define PSW_MASK_IO		0x0200000000000000
+#define PSW_MASK_EXT		0x0100000000000000
+#define PSW_MASK_EA		0x0000000100000000
+#define PSW_MASK_BA		0x0000000080000000
+
+#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
+
+#endif
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index cf6e1ca..ee7ace2 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -10,15 +10,13 @@
 #ifndef _ASM_S390X_ARCH_DEF_H_
 #define _ASM_S390X_ARCH_DEF_H_
 
+#include <asm/arch_bits.h>
+
 struct psw {
 	uint64_t	mask;
 	uint64_t	addr;
 };
 
-#define PSW_MASK_EXT			0x0100000000000000UL
-#define PSW_MASK_DAT			0x0400000000000000UL
-#define PSW_MASK_PSTATE			0x0001000000000000UL
-
 #define CR0_EXTM_SCLP			0X0000000000000200UL
 #define CR0_EXTM_EXTC			0X0000000000002000UL
 #define CR0_EXTM_EMGC			0X0000000000004000UL
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 525c464..44caf7a 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -11,6 +11,7 @@
  * under the terms of the GNU Library General Public License version 2.
  */
 #include <asm/asm-offsets.h>
+#include <asm/arch_bits.h>
 #include <asm/sigp.h>
 
 .section .init
@@ -216,17 +217,17 @@ svc_int:
 reset_psw:
 	.quad	0x0008000180000000
 initial_psw:
-	.quad	0x0000000180000000, clear_bss_start
+	.quad	PSW_EXCEPTION_MASK, clear_bss_start
 pgm_int_psw:
-	.quad	0x0000000180000000, pgm_int
+	.quad	PSW_EXCEPTION_MASK, pgm_int
 ext_int_psw:
-	.quad	0x0000000180000000, ext_int
+	.quad	PSW_EXCEPTION_MASK, ext_int
 mcck_int_psw:
-	.quad	0x0000000180000000, mcck_int
+	.quad	PSW_EXCEPTION_MASK, mcck_int
 io_int_psw:
-	.quad	0x0000000180000000, io_int
+	.quad	PSW_EXCEPTION_MASK, io_int
 svc_int_psw:
-	.quad	0x0000000180000000, svc_int
+	.quad	PSW_EXCEPTION_MASK, svc_int
 initial_cr0:
 	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
 	.quad	0x0000000000040000
-- 
2.17.0

