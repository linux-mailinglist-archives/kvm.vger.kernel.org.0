Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D8B1D7DD0
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgERQHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:07:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbgERQHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 12:07:39 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IG1naC046194;
        Mon, 18 May 2020 12:07:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312cayexph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:38 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IG1ol3046319;
        Mon, 18 May 2020 12:07:38 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312cayexne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04IG6iQl014048;
        Mon, 18 May 2020 16:07:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 313wey8079-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 16:07:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IG7XaJ62128564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 16:07:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C597111C04A;
        Mon, 18 May 2020 16:07:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68A0E11C052;
        Mon, 18 May 2020 16:07:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 16:07:33 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v7 02/12] s390x: Use PSW bits definitions in cstart
Date:   Mon, 18 May 2020 18:07:21 +0200
Message-Id: <1589818051-20549-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 malwarescore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=947
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch defines the PSW bits EA/BA used to initialize the PSW masks
for exceptions.

Since some PSW mask definitions exist already in arch_def.h we add these
definitions there.
We move all PSW definitions together and protect assembler code against
C syntax.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 15 +++++++++++----
 s390x/cstart64.S         | 15 ++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15a4d49..820af93 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -10,15 +10,21 @@
 #ifndef _ASM_S390X_ARCH_DEF_H_
 #define _ASM_S390X_ARCH_DEF_H_
 
+#define PSW_MASK_EXT			0x0100000000000000UL
+#define PSW_MASK_DAT			0x0400000000000000UL
+#define PSW_MASK_SHORT_PSW		0x0008000000000000UL
+#define PSW_MASK_PSTATE			0x0001000000000000UL
+#define PSW_MASK_BA			0x0000000080000000UL
+#define PSW_MASK_EA			0x0000000100000000UL
+
+#define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
+
+#ifndef __ASSEMBLER__
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
@@ -297,4 +303,5 @@ static inline uint32_t get_prefix(void)
 	return current_prefix;
 }
 
+#endif /* __ASSEMBLER */
 #endif
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 3c7d8a9..e890568 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -12,6 +12,7 @@
  */
 #include <asm/asm-offsets.h>
 #include <asm/sigp.h>
+#include <asm/arch_def.h>
 
 .section .init
 
@@ -232,19 +233,19 @@ svc_int:
 
 	.align	8
 reset_psw:
-	.quad	0x0008000180000000
+	.quad	PSW_EXCEPTION_MASK | PSW_MASK_SHORT_PSW
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
2.25.1

