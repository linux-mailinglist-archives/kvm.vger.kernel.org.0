Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6063EB1A3
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbhHMHiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239513AbhHMHiE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:04 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7WvgA010839;
        Fri, 13 Aug 2021 03:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=A/ph5QR+bUbPyXl7CPFyDqrcVFxCuzJjnqmTmMpIlg8=;
 b=XQ5CUbquGtDoc9dh/s8NBcH+5kIUlBfq0mrzHamcLPWIe4JkMBPQ6fwLVdsnGQ4sP4fk
 /oxVW1L7yReDF8swy6OzAbOHuKC7/0TEpavGTr8b3R883qVzdt4uYETYJJ+hWROAYoSj
 l/5iDskeOk8LArBSTyuwAX/MJuBvDxb2cTAK+sMlnU+nq94wDs6MF4ZCCfPau1suc1V2
 Gc2LCN/Gqkkyear8V72LvQXzsrUr1y9+ZkP57qUT0w7wtyV3km2gmF8GtmrldMo+uz9c
 lw2TYgaNtLvES35f4RBL76K8WbIdwvvRn1mwdCaBI+MHdZzg15Udk7mOoq/+oCLhN2mk +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstpk5e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:38 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7Wxkg011084;
        Fri, 13 Aug 2021 03:37:37 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acstpk5d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:37 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7MMCA028629;
        Fri, 13 Aug 2021 07:37:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3a9ht925gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bWYU52167004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:32 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99F3742042;
        Fri, 13 Aug 2021 07:37:32 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F0D442041;
        Fri, 13 Aug 2021 07:37:32 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 6/8] lib: s390x: Add PSW_MASK_64
Date:   Fri, 13 Aug 2021 07:36:13 +0000
Message-Id: <20210813073615.32837-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZdwnVUsI_uaEOX9B1y5Ph3iP_BEJ6owE
X-Proofpoint-ORIG-GUID: UEAJ0hBB8SJ1ANoGD2qRxKIm5SoHD-4h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's replace the magic 0x0000000180000000ULL numeric constants with
PSW_MASK_64 as it's used more often since the introduction of smp and
sie.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 3 +++
 lib/s390x/smp.c          | 2 +-
 s390x/mvpg-sie.c         | 2 +-
 s390x/sie.c              | 2 +-
 s390x/skrf.c             | 6 +++---
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 39c5ba99..245453c3 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -50,6 +50,9 @@ struct psw {
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_WAIT			0x0002000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
+#define PSW_MASK_EA			0x0000000100000000UL
+#define PSW_MASK_BA			0x0000000080000000UL
+#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
 
 #define CR0_EXTM_SCLP			0x0000000000000200UL
 #define CR0_EXTM_EXTC			0x0000000000002000UL
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index ee68d676..228fe667 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -202,7 +202,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	cpu->lowcore->sw_int_psw.addr = psw.addr;
 	cpu->lowcore->sw_int_grs[14] = psw.addr;
 	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
-	lc->restart_new_psw.mask = 0x0000000180000000UL;
+	lc->restart_new_psw.mask = PSW_MASK_64;
 	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
 	lc->sw_int_crs[0] = 0x0000000000040000UL;
 
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 70d2fcfa..ccc273b4 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -100,7 +100,7 @@ static void setup_guest(void)
 	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 
 	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
-	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+	vm.sblk->gpsw.mask = PSW_MASK_64;
 	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
 	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
 	vm.sblk->eca = ECA_MVPGI;
diff --git a/s390x/sie.c b/s390x/sie.c
index ed2c3263..87575b29 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -27,7 +27,7 @@ static struct vm vm;
 static void test_diag(u32 instr)
 {
 	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
-	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+	vm.sblk->gpsw.mask = PSW_MASK_64;
 
 	memset(guest_instr, 0, PAGE_SIZE);
 	memcpy(guest_instr, &instr, 4);
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 94e906a6..9488c32b 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -125,15 +125,15 @@ static void ecall_cleanup(void)
 {
 	struct lowcore *lc = (void *)0x0;
 
-	lc->ext_new_psw.mask = 0x0000000180000000UL;
 	lc->sw_int_crs[0] = 0x0000000000040000;
+	lc->ext_new_psw.mask = PSW_MASK_64;
 
 	/*
 	 * PGM old contains the ext new PSW, we need to clean it up,
 	 * so we don't get a special operation exception on the lpswe
 	 * of pgm old.
 	 */
-	lc->pgm_old_psw.mask = 0x0000000180000000UL;
+	lc->pgm_old_psw.mask = PSW_MASK_64;
 
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 	set_flag(1);
@@ -148,7 +148,7 @@ static void ecall_setup(void)
 	register_pgm_cleanup_func(ecall_cleanup);
 	expect_pgm_int();
 	/* Put a skey into the ext new psw */
-	lc->ext_new_psw.mask = 0x00F0000180000000UL;
+	lc->ext_new_psw.mask = 0x00F0000000000000UL | PSW_MASK_64;
 	/* Open up ext masks */
 	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
 	mask = extract_psw_mask();
-- 
2.30.2

