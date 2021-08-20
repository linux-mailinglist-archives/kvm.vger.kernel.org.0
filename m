Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FD83F2B66
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 13:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhHTLlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 07:41:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9460 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239990AbhHTLlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 07:41:15 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KBbNi9191178;
        Fri, 20 Aug 2021 07:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Sy2BvfbqKMjJgpL9VelbhUfkA55nv/eefA3RQjb9+hE=;
 b=Grzm/yzctGNHOdre2muVId8NButqvcc5d7EfSoMyHygmtRNHPw0G5vLGv0XfslRf4hQG
 xDUjcV2OgIa4/LJedol1DX8VBeUPWHDOx10aGpZ0aH8qr3eUONjNocDCVHWAXGgd3jev
 6yMHbmb7HZdBIdszRJddfNN1lfq6RQTpTPxkKXnYo4LcgPIfqxF4qZeJvh8s/E++wv6B
 /k4e6phv4NMSnto/45XyJ+f9QvJgT8sjuOjjOrGcMxjjyeyhZheC5e4SoA9wVeEtwF9q
 KxhJqCAqGNB7Gvdkakwfwx+wsi+jyGBtMDQB8Tgux11kTg39eKYDUluNkAx8bIStby+U Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahhqm9h3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:40:37 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17KBcv8i195014;
        Fri, 20 Aug 2021 07:40:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahhqm9h30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:40:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17KBbFx9001948;
        Fri, 20 Aug 2021 11:40:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8hqx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 11:40:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17KBeWmY46989634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 11:40:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65303AE10D;
        Fri, 20 Aug 2021 11:40:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BFD9AE059;
        Fri, 20 Aug 2021 11:40:32 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 11:40:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/3] lib: s390x: Control register constant cleanup
Date:   Fri, 20 Aug 2021 11:40:00 +0000
Message-Id: <20210820114000.166527-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210820114000.166527-1-frankja@linux.ibm.com>
References: <20210820114000.166527-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NCp68hUhXkKcpiDeKvSmN3EvMMdNKNRe
X-Proofpoint-ORIG-GUID: 2yAXzN5VwVEbhFMjnr8aCteAIFzpquwS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=985 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We had bits and masks defined and don't necessarily need both.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 28 ++++++++++++----------------
 lib/s390x/smp.c          |  3 ++-
 s390x/skrf.c             |  3 ++-
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index ab5a9043..aa80d840 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -55,10 +55,18 @@ struct psw {
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
+
+#define CTL2_GUARDED_STORAGE		(63 - 59)
 
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
@@ -240,18 +248,6 @@ static inline uint64_t stctg(int cr)
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
index 228fe667..da6d32f3 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -10,6 +10,7 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/arch_def.h>
 #include <asm/sigp.h>
 #include <asm/page.h>
@@ -204,7 +205,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
 	lc->restart_new_psw.mask = PSW_MASK_64;
 	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
-	lc->sw_int_crs[0] = 0x0000000000040000UL;
+	lc->sw_int_crs[0] = BIT_ULL(CTL0_AFP);
 
 	/* Start processing */
 	smp_cpu_restart_nolock(addr, NULL);
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 9488c32b..8ca7588c 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -8,6 +8,7 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
+#include <bitops.h>
 #include <asm/asm-offsets.h>
 #include <asm-generic/barrier.h>
 #include <asm/interrupt.h>
@@ -125,8 +126,8 @@ static void ecall_cleanup(void)
 {
 	struct lowcore *lc = (void *)0x0;
 
-	lc->sw_int_crs[0] = 0x0000000000040000;
 	lc->ext_new_psw.mask = PSW_MASK_64;
+	lc->sw_int_crs[0] = BIT_ULL(CTL0_AFP);
 
 	/*
 	 * PGM old contains the ext new PSW, we need to clean it up,
-- 
2.30.2

