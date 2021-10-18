Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC7E43194C
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhJRMkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26230 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231528AbhJRMkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IAovqT007165;
        Mon, 18 Oct 2021 08:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=asOVZumR+HRQ9BuyhWufPwpk1Ta4HHQQAd+cUEAqqoQ=;
 b=KPICAwmw+EiHMc/32RWWoA3iQINw9+VIn+4fOoFOohf2js0pSYdBXbUZhAQtHKB2W7cU
 hQE7CRQFu9+3Gj2+LGYH41POkM/TEmSm8CkFOuaqX27KOqBypgDJjAd/XiC5K+qoWGig
 I1z5ddvMjJu9Vfeij7yWcUHi24Zq2+O7YMljMsIJGLom7+RA+EigdUnoM5aKbQBK5SFC
 1dKxhc6xrYiroygUa6a4V0UK4+nLPnjHtcfNI0O9+WUX+5XrGc5FXR3P46OjaL+yoOpu
 kbuvmnWYd1wtd2C9Q0IAeUljV53R7YVNefWEPjXHGxAgr7WqPOoAzzhDmXpwzL2QSgvb 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs1u59e78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:05 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IC0EYH012451;
        Mon, 18 Oct 2021 08:38:04 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs1u59e6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:04 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICWI5R026247;
        Mon, 18 Oct 2021 12:38:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3bqpc9myns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICbxXh56820218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:37:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E6A85205F;
        Mon, 18 Oct 2021 12:37:59 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9575C52065;
        Mon, 18 Oct 2021 12:37:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 02/17] lib: s390x: Control register constant cleanup
Date:   Mon, 18 Oct 2021 14:26:20 +0200
Message-Id: <20211018122635.53614-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pai-PblpJ57a3EwNyMvyfXkPpTsEcX50
X-Proofpoint-ORIG-GUID: i9JGrDlwfKsivIQ3Rw62TRAwwV8n7Y7C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 clxscore=1015
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We had bits and masks defined and don't necessarily need both.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 28 ++++++++++++----------------
 lib/s390x/smp.c          |  3 ++-
 s390x/skrf.c             |  3 ++-
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 302ef1ff..24892bd8 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -50,10 +50,18 @@ struct psw {
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
@@ -235,18 +243,6 @@ static inline uint64_t stctg(int cr)
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
2.31.1

