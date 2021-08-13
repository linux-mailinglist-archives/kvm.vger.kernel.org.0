Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F223EB1A4
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbhHMHiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239514AbhHMHiF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:05 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7Yebc069272;
        Fri, 13 Aug 2021 03:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7ZS//SnT4vnLEuH/or7zhxc2S4dFk27IL4g0CTpN7pk=;
 b=CJjfw6nPIWhZSRgqYHCOZtbFeDJZVQW7C682+RlaHS6fv2I+9gO407DDCBfx5VfkFxnR
 HvegCHDev2Ea542mzpGHUeD6VJpOqSJ0XcaD6I+MRkJMcHzvnwywBRTKWFF2sT6rZhL8
 cO25WZQ+7bBLuHtZRDyvYGBvEvuVWfmNWrmrDjcUVuWa+Qna2kgrmpQhtzj8o09tdB4i
 deGXfRkHf+ph3kimv92MYhRmxowwHT3wVBt+T3w2ndt2g29+FPq+QCcAGnj2GWMPOZ2y
 QFTbd07khj7QJsUhOZ8hXA3lWloRsYSLj4s86GChKF5xKAX/EcfULUTNJlEJzI6fidvO Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1kxx0gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:38 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7Z3TO071704;
        Fri, 13 Aug 2021 03:37:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1kxx0g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7PCAY015857;
        Fri, 13 Aug 2021 07:37:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3acn76b6p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bXPW50004308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04C5742049;
        Fri, 13 Aug 2021 07:37:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA48242041;
        Fri, 13 Aug 2021 07:37:32 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 7/8] lib: s390x: Control register constant cleanup
Date:   Fri, 13 Aug 2021 07:36:14 +0000
Message-Id: <20210813073615.32837-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ca487WlxaN7hZmT5IPzWFBetcjBm9OsN
X-Proofpoint-ORIG-GUID: 8hcOMRIeddNW7ERsXJXNepRYnrcm8wgW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We had bits and masks defined and don't necessarily need both.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 29 +++++++++++++----------------
 lib/s390x/smp.c          |  2 +-
 s390x/skrf.c             |  2 +-
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 245453c3..4574a166 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -54,10 +54,19 @@ struct psw {
 #define PSW_MASK_BA			0x0000000080000000UL
 #define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
 
-#define CR0_EXTM_SCLP			0x0000000000000200UL
-#define CR0_EXTM_EXTC			0x0000000000002000UL
-#define CR0_EXTM_EMGC			0x0000000000004000UL
-#define CR0_EXTM_MASK			0x0000000000006200UL
+#define CTL0_LOW_ADDR_PROT		(63 - 35)
+#define CTL0_EDAT			(63 - 40)
+#define CTL0_IEP			(63 - 43)
+#define CTL0_AFP			(63 - 45)
+#define CTL0_VECTOR			(63 - 46)
+#define CTL0_EMERGENCY_SIGNAL		(63 - 49)
+#define CTL0_EXTERNAL_CALL		(63 - 50)
+#define CTL0_CLOCK_COMPARATOR		(63 - 52)
+#define CTL0_SERVICE_SIGNAL		(63 - 54)
+#define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
+#define BIT_TO_MASK64(x)		1UL << x
+
+#define CTL2_GUARDED_STORAGE		(63 - 59)
 
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
@@ -239,18 +248,6 @@ static inline uint64_t stctg(int cr)
 	return value;
 }
 
-#define CTL0_LOW_ADDR_PROT	(63 - 35)
-#define CTL0_EDAT		(63 - 40)
-#define CTL0_IEP		(63 - 43)
-#define CTL0_AFP		(63 - 45)
-#define CTL0_VECTOR		(63 - 46)
-#define CTL0_EMERGENCY_SIGNAL	(63 - 49)
-#define CTL0_EXTERNAL_CALL	(63 - 50)
-#define CTL0_CLOCK_COMPARATOR	(63 - 52)
-#define CTL0_SERVICE_SIGNAL	(63 - 54)
-
-#define CTL2_GUARDED_STORAGE	(63 - 59)
-
 static inline void ctl_set_bit(int cr, unsigned int bit)
 {
         uint64_t reg;
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 228fe667..c2c6ffec 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -204,7 +204,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
 	lc->restart_new_psw.mask = PSW_MASK_64;
 	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
-	lc->sw_int_crs[0] = 0x0000000000040000UL;
+	lc->sw_int_crs[0] = BIT_TO_MASK64(CTL0_AFP);
 
 	/* Start processing */
 	smp_cpu_restart_nolock(addr, NULL);
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 9488c32b..a350ada6 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -125,8 +125,8 @@ static void ecall_cleanup(void)
 {
 	struct lowcore *lc = (void *)0x0;
 
-	lc->sw_int_crs[0] = 0x0000000000040000;
 	lc->ext_new_psw.mask = PSW_MASK_64;
+	lc->sw_int_crs[0] = BIT_TO_MASK64(CTL0_AFP);
 
 	/*
 	 * PGM old contains the ext new PSW, we need to clean it up,
-- 
2.30.2

