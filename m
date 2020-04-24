Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD601B7261
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgDXKqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 06:46:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726888AbgDXKqD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 06:46:03 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OAY9pm026097
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:46:02 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5tb6qt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:46:01 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 24 Apr 2020 11:45:09 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Apr 2020 11:45:05 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OAjtSv57802940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 10:45:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10FF8A404D;
        Fri, 24 Apr 2020 10:45:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA00FA4051;
        Fri, 24 Apr 2020 10:45:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.79.138])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 10:45:54 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v6 02/10] s390x: Use PSW bits definitions in cstart
Date:   Fri, 24 Apr 2020 12:45:44 +0200
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20042410-0016-0000-0000-0000030A3169
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042410-0017-0000-0000-0000336E579F
Message-Id: <1587725152-25569-3-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_04:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 suspectscore=1 impostorscore=0 malwarescore=0
 mlxlogscore=834 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240082
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
 lib/s390x/asm/arch_def.h | 16 ++++++++++++----
 s390x/cstart64.S         | 15 ++++++++-------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15a4d49..c54409a 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -10,15 +10,22 @@
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
+#define PSW_RESET_MASK		(PSW_EXCEPTION_MASK | PSW_MASK_SHORT_PSW)
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
@@ -297,4 +304,5 @@ static inline uint32_t get_prefix(void)
 	return current_prefix;
 }
 
+#endif /* __ASSEMBLER */
 #endif
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index ba2e67c..e394b3a 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -12,6 +12,7 @@
  */
 #include <asm/asm-offsets.h>
 #include <asm/sigp.h>
+#include <asm/arch_def.h>
 
 .section .init
 
@@ -225,19 +226,19 @@ svc_int:
 
 	.align	8
 reset_psw:
-	.quad	0x0008000180000000
+	.quad	PSW_RESET_MASK
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

