Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1913AFF22
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFVIYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:24:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230409AbhFVIXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:55 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M84j19186641;
        Tue, 22 Jun 2021 04:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UguGSuackUq1ddI7nszFID1pnGVrW6KOAa6WLVgo0m4=;
 b=K5xWN8YtsIp/EzZm7s9DlBms7X6LzfSSnRzXmI9TxlAqjxknzTjC0bjPSKvHUmEPJ94b
 ZhANW1yvDQbO2gLYRs3mAc2qdLQ3caeFrSgKEAIAB3VAYsjUPIWaxwe4Ve7iaZanaceP
 wdQkUePmE/l8ekF8TLgumvfcwirYRxY1amlC80DQhgnqs1OGpe1gyrx3tNMXLcTkizBW
 iD7rvyKQIPwhhKA6HCboY1zsViKX+WS0Hw8f80cMB3ugdDQeeolvVNMJ5PP5tVvFUriJ
 pmKlqau2N2/pcah+kGRv23RfmmYBv9e9lW+TXCeIf0sd4MEFsO2DugEe+0R3AuPxu44v 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39b87nx6gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:39 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M850sN188320;
        Tue, 22 Jun 2021 04:21:39 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39b87nx6g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:39 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8BxTI010120;
        Tue, 22 Jun 2021 08:21:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 399878rqgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8LY8715860196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48ACEAE058;
        Tue, 22 Jun 2021 08:21:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF0B2AE051;
        Tue, 22 Jun 2021 08:21:33 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 06/12] s390x: lib: add and use macros for control register bits
Date:   Tue, 22 Jun 2021 10:20:36 +0200
Message-Id: <20210622082042.13831-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Rp9pyikg04zGZZy_FFrFxLC3LsUqxcXD
X-Proofpoint-GUID: QA-es1aa-jkdhwFcFlTPFiOAHLqc2SyI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add CTL0_* and CTL2_* macros for specific control register bits.

Replace all hardcoded values in the library and in the existing testcases so
that they use the new macros.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210611140705.553307-2-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h  | 12 ++++++++++++
 lib/s390x/asm/float.h     |  4 ++--
 lib/s390x/asm/interrupt.h |  4 ++--
 lib/s390x/sclp.c          |  4 ++--
 s390x/diag288.c           |  2 +-
 s390x/gs.c                |  2 +-
 s390x/iep.c               |  4 ++--
 s390x/skrf.c              |  2 +-
 s390x/smp.c               |  8 ++++----
 s390x/vector.c            |  2 +-
 10 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 76f9e386..3aa5da9c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -229,6 +229,18 @@ static inline uint64_t stctg(int cr)
 	return value;
 }
 
+#define CTL0_LOW_ADDR_PROT	(63 - 35)
+#define CTL0_EDAT		(63 - 40)
+#define CTL0_IEP		(63 - 43)
+#define CTL0_AFP		(63 - 45)
+#define CTL0_VECTOR		(63 - 46)
+#define CTL0_EMERGENCY_SIGNAL	(63 - 49)
+#define CTL0_EXTERNAL_CALL	(63 - 50)
+#define CTL0_CLOCK_COMPARATOR	(63 - 52)
+#define CTL0_SERVICE_SIGNAL	(63 - 54)
+
+#define CTL2_GUARDED_STORAGE	(63 - 59)
+
 static inline void ctl_set_bit(int cr, unsigned int bit)
 {
         uint64_t reg;
diff --git a/lib/s390x/asm/float.h b/lib/s390x/asm/float.h
index eb752050..73c642d4 100644
--- a/lib/s390x/asm/float.h
+++ b/lib/s390x/asm/float.h
@@ -38,12 +38,12 @@ static inline void set_fpc_dxc(uint8_t dxc)
 
 static inline void afp_enable(void)
 {
-	ctl_set_bit(0, 63 - 45);
+	ctl_set_bit(0, CTL0_AFP);
 }
 
 static inline void afp_disable(void)
 {
-	ctl_clear_bit(0, 63 - 45);
+	ctl_clear_bit(0, CTL0_AFP);
 }
 
 #endif
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 31e4766d..bf0eb40d 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -27,13 +27,13 @@ void check_pgm_int_code(uint16_t code);
 /* Activate low-address protection */
 static inline void low_prot_enable(void)
 {
-	ctl_set_bit(0, 63 - 35);
+	ctl_set_bit(0, CTL0_LOW_ADDR_PROT);
 }
 
 /* Disable low-address protection */
 static inline void low_prot_disable(void)
 {
-	ctl_clear_bit(0, 63 - 35);
+	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
 }
 
 #endif
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 291924b0..9502d161 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -50,7 +50,7 @@ void sclp_setup_int(void)
 {
 	uint64_t mask;
 
-	ctl_set_bit(0, 9);
+	ctl_set_bit(0, CTL0_SERVICE_SIGNAL);
 
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
@@ -59,7 +59,7 @@ void sclp_setup_int(void)
 
 void sclp_handle_ext(void)
 {
-	ctl_clear_bit(0, 9);
+	ctl_clear_bit(0, CTL0_SERVICE_SIGNAL);
 	spin_lock(&sclp_lock);
 	sclp_busy = false;
 	spin_unlock(&sclp_lock);
diff --git a/s390x/diag288.c b/s390x/diag288.c
index e132ff04..82b6ec17 100644
--- a/s390x/diag288.c
+++ b/s390x/diag288.c
@@ -86,7 +86,7 @@ static void test_bite(void)
 	asm volatile("stck %0" : "=Q" (time) : : "cc");
 	time += (uint64_t)(16000 * 1000) << 12;
 	asm volatile("sckc %0" : : "Q" (time));
-	ctl_set_bit(0, 11);
+	ctl_set_bit(0, CTL0_CLOCK_COMPARATOR);
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
 	load_psw_mask(mask);
diff --git a/s390x/gs.c b/s390x/gs.c
index 1376d0e6..a017a97d 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -145,7 +145,7 @@ static void test_special(void)
 static void init(void)
 {
 	/* Enable control bit for gs */
-	ctl_set_bit(2, 4);
+	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
 
 	/* Setup gs registers to guard the gs_area */
 	gs_cb.gsd = gs_area | 25;
diff --git a/s390x/iep.c b/s390x/iep.c
index fe167ef0..906c77b3 100644
--- a/s390x/iep.c
+++ b/s390x/iep.c
@@ -22,7 +22,7 @@ static void test_iep(void)
 	void (*fn)(void);
 
 	/* Enable IEP */
-	ctl_set_bit(0, 20);
+	ctl_set_bit(0, CTL0_IEP);
 
 	/* Get and protect a page with the IEP bit */
 	iepbuf = alloc_page();
@@ -40,7 +40,7 @@ static void test_iep(void)
 	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
 	report_prefix_pop();
 	unprotect_page(iepbuf, PAGE_ENTRY_IEP);
-	ctl_clear_bit(0, 20);
+	ctl_clear_bit(0, CTL0_IEP);
 	free_page(iepbuf);
 }
 
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 57524ba8..94e906a6 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -150,7 +150,7 @@ static void ecall_setup(void)
 	/* Put a skey into the ext new psw */
 	lc->ext_new_psw.mask = 0x00F0000180000000UL;
 	/* Open up ext masks */
-	ctl_set_bit(0, 13);
+	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
 	load_psw_mask(mask);
diff --git a/s390x/smp.c b/s390x/smp.c
index b0ece491..f25ec769 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -154,7 +154,7 @@ static void ecall(void)
 	struct lowcore *lc = (void *)0x0;
 
 	expect_ext_int();
-	ctl_set_bit(0, 13);
+	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
 	load_psw_mask(mask);
@@ -188,7 +188,7 @@ static void emcall(void)
 	struct lowcore *lc = (void *)0x0;
 
 	expect_ext_int();
-	ctl_set_bit(0, 14);
+	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
 	load_psw_mask(mask);
@@ -283,8 +283,8 @@ static void test_local_ints(void)
 	unsigned long mask;
 
 	/* Open masks for ecall and emcall */
-	ctl_set_bit(0, 13);
-	ctl_set_bit(0, 14);
+	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
+	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
 	load_psw_mask(mask);
diff --git a/s390x/vector.c b/s390x/vector.c
index b052de55..fdb0eee2 100644
--- a/s390x/vector.c
+++ b/s390x/vector.c
@@ -106,7 +106,7 @@ static void test_bcd_add(void)
 static void init(void)
 {
 	/* Enable vector instructions */
-	ctl_set_bit(0, 17);
+	ctl_set_bit(0, CTL0_VECTOR);
 
 	/* Preset vector registers to 0xff */
 	memset(pagebuf, 0xff, PAGE_SIZE);
-- 
2.31.1

