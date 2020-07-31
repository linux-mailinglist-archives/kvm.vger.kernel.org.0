Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B15234397
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732433AbgGaJqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:46:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37602 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732397AbgGaJqc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:46:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V9VTSc009454;
        Fri, 31 Jul 2020 05:46:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mdjsdh43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:30 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06V9VXV0009833;
        Fri, 31 Jul 2020 05:46:30 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mdjsdh3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 05:46:30 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V9jLdY031643;
        Fri, 31 Jul 2020 09:46:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 32gcr0mbe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 09:46:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V9kPj145809748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 09:46:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EC83AE059;
        Fri, 31 Jul 2020 09:46:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18B4AAE055;
        Fri, 31 Jul 2020 09:46:25 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.62.184])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 09:46:25 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 11/11] s390x: fix inline asm on gcc10
Date:   Fri, 31 Jul 2020 11:46:07 +0200
Message-Id: <20200731094607.15204-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200731094607.15204-1-frankja@linux.ibm.com>
References: <20200731094607.15204-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 suspectscore=1 phishscore=0 mlxscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Fix compilation issues on 390x with gcc 10.

Simply mark the inline functions that lead to a .insn with a variable
opcode as __always_inline, to make gcc 10 happy.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20200727102643.15439-1-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/cpacf.h |  5 +++--
 s390x/emulator.c      | 25 +++++++++++++------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index ae2ec53..2146a01 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -11,6 +11,7 @@
 #define _ASM_S390_CPACF_H
 
 #include <asm/facility.h>
+#include <linux/compiler.h>
 
 /*
  * Instruction opcodes for the CPACF instructions
@@ -145,7 +146,7 @@ typedef struct { unsigned char bytes[16]; } cpacf_mask_t;
  *
  * Returns 1 if @func is available for @opcode, 0 otherwise
  */
-static inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
+static __always_inline void __cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
 	register unsigned long r0 asm("0") = 0;	/* query function */
 	register unsigned long r1 asm("1") = (unsigned long) mask;
@@ -183,7 +184,7 @@ static inline int __cpacf_check_opcode(unsigned int opcode)
 	}
 }
 
-static inline int cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
+static __always_inline int cpacf_query(unsigned int opcode, cpacf_mask_t *mask)
 {
 	if (__cpacf_check_opcode(opcode)) {
 		__cpacf_query(opcode, mask);
diff --git a/s390x/emulator.c b/s390x/emulator.c
index 1ee0df5..70ef51a 100644
--- a/s390x/emulator.c
+++ b/s390x/emulator.c
@@ -14,6 +14,7 @@
 #include <asm/cpacf.h>
 #include <asm/interrupt.h>
 #include <asm/float.h>
+#include <linux/compiler.h>
 
 struct lowcore *lc = NULL;
 
@@ -46,7 +47,7 @@ static void test_spm_ipm(void)
 	__test_spm_ipm(0, 0);
 }
 
-static inline void __test_cpacf(unsigned int opcode, unsigned long func,
+static __always_inline void __test_cpacf(unsigned int opcode, unsigned long func,
 				unsigned int r1, unsigned int r2,
 				unsigned int r3)
 {
@@ -59,7 +60,7 @@ static inline void __test_cpacf(unsigned int opcode, unsigned long func,
 		         [r1] "i" (r1), [r2] "i" (r2), [r3] "i" (r3));
 }
 
-static inline void __test_cpacf_r1_odd(unsigned int opcode)
+static __always_inline void __test_cpacf_r1_odd(unsigned int opcode)
 {
 	report_prefix_push("r1 odd");
 	expect_pgm_int();
@@ -68,7 +69,7 @@ static inline void __test_cpacf_r1_odd(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r1_null(unsigned int opcode)
+static __always_inline void __test_cpacf_r1_null(unsigned int opcode)
 {
 	report_prefix_push("r1 null");
 	expect_pgm_int();
@@ -77,7 +78,7 @@ static inline void __test_cpacf_r1_null(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r2_odd(unsigned int opcode)
+static __always_inline void __test_cpacf_r2_odd(unsigned int opcode)
 {
 	report_prefix_push("r2 odd");
 	expect_pgm_int();
@@ -86,7 +87,7 @@ static inline void __test_cpacf_r2_odd(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r2_null(unsigned int opcode)
+static __always_inline void __test_cpacf_r2_null(unsigned int opcode)
 {
 	report_prefix_push("r2 null");
 	expect_pgm_int();
@@ -95,7 +96,7 @@ static inline void __test_cpacf_r2_null(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r3_odd(unsigned int opcode)
+static __always_inline void __test_cpacf_r3_odd(unsigned int opcode)
 {
 	report_prefix_push("r3 odd");
 	expect_pgm_int();
@@ -104,7 +105,7 @@ static inline void __test_cpacf_r3_odd(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_r3_null(unsigned int opcode)
+static __always_inline void __test_cpacf_r3_null(unsigned int opcode)
 {
 	report_prefix_push("r3 null");
 	expect_pgm_int();
@@ -113,7 +114,7 @@ static inline void __test_cpacf_r3_null(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_mod_bit(unsigned int opcode)
+static __always_inline void __test_cpacf_mod_bit(unsigned int opcode)
 {
 	report_prefix_push("mod bit");
 	expect_pgm_int();
@@ -122,7 +123,7 @@ static inline void __test_cpacf_mod_bit(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_invalid_func(unsigned int opcode)
+static __always_inline void __test_cpacf_invalid_func(unsigned int opcode)
 {
 	report_prefix_push("invalid subfunction");
 	expect_pgm_int();
@@ -137,7 +138,7 @@ static inline void __test_cpacf_invalid_func(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_invalid_parm(unsigned int opcode)
+static __always_inline void __test_cpacf_invalid_parm(unsigned int opcode)
 {
 	report_prefix_push("invalid parm address");
 	expect_pgm_int();
@@ -146,7 +147,7 @@ static inline void __test_cpacf_invalid_parm(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_cpacf_protected_parm(unsigned int opcode)
+static __always_inline void __test_cpacf_protected_parm(unsigned int opcode)
 {
 	report_prefix_push("protected parm address");
 	expect_pgm_int();
@@ -157,7 +158,7 @@ static inline void __test_cpacf_protected_parm(unsigned int opcode)
 	report_prefix_pop();
 }
 
-static inline void __test_basic_cpacf_opcode(unsigned int opcode)
+static __always_inline void __test_basic_cpacf_opcode(unsigned int opcode)
 {
 	bool mod_bit_allowed = false;
 
-- 
2.25.4

