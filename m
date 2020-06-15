Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697561F9381
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgFOJcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:32:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45266 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729352AbgFOJcS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:32:18 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F9BogK014198;
        Mon, 15 Jun 2020 05:32:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31p5eu9mn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:14 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05F8RA6l061226;
        Mon, 15 Jun 2020 05:32:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31p5eu9mju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:32:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05F9Lae9012944;
        Mon, 15 Jun 2020 09:32:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 31mpe7u8w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 09:32:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05F9W3GT3211662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 09:32:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B08152075;
        Mon, 15 Jun 2020 09:32:03 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1FF3152073;
        Mon, 15 Jun 2020 09:32:03 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v9 01/12] s390x: Use PSW bits definitions in cstart
Date:   Mon, 15 Jun 2020 11:31:50 +0200
Message-Id: <1592213521-19390-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_01:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 adultscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=1 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006150066
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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 15 +++++++++++----
 s390x/cstart64.S         | 15 ++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 1b3bb0c..b5d7aca 100644
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
+#define PSW_MASK_ON_EXCEPTION	(PSW_MASK_EA | PSW_MASK_BA)
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
 #define CR0_EXTM_SCLP			0x0000000000000200UL
 #define CR0_EXTM_EXTC			0x0000000000002000UL
 #define CR0_EXTM_EMGC			0x0000000000004000UL
@@ -297,4 +303,5 @@ static inline uint32_t get_prefix(void)
 	return current_prefix;
 }
 
+#endif /* __ASSEMBLER */
 #endif
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index e084f13..d386f35 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -12,6 +12,7 @@
  */
 #include <asm/asm-offsets.h>
 #include <asm/sigp.h>
+#include <asm/arch_def.h>
 
 .section .init
 
@@ -198,19 +199,19 @@ svc_int:
 
 	.align	8
 reset_psw:
-	.quad	0x0008000180000000
+	.quad	PSW_MASK_ON_EXCEPTION | PSW_MASK_SHORT_PSW
 initial_psw:
-	.quad	0x0000000180000000, clear_bss_start
+	.quad	PSW_MASK_ON_EXCEPTION, clear_bss_start
 pgm_int_psw:
-	.quad	0x0000000180000000, pgm_int
+	.quad	PSW_MASK_ON_EXCEPTION, pgm_int
 ext_int_psw:
-	.quad	0x0000000180000000, ext_int
+	.quad	PSW_MASK_ON_EXCEPTION, ext_int
 mcck_int_psw:
-	.quad	0x0000000180000000, mcck_int
+	.quad	PSW_MASK_ON_EXCEPTION, mcck_int
 io_int_psw:
-	.quad	0x0000000180000000, io_int
+	.quad	PSW_MASK_ON_EXCEPTION, io_int
 svc_int_psw:
-	.quad	0x0000000180000000, svc_int
+	.quad	PSW_MASK_ON_EXCEPTION, svc_int
 initial_cr0:
 	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
 	.quad	0x0000000000040000
-- 
2.25.1

