Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BAB3ED6CC
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhHPNYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:24:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10906 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239381AbhHPNVv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD5hQw056860;
        Mon, 16 Aug 2021 09:21:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w+QZ4+IZDVKDY43qIA5Wss4Wq4Xn/xons8Y3npi6oPs=;
 b=tcNdjDpw9sh7GlofWsZF/QluG4HOLLT0RNMiUGOtq9Z577yRsNYnspO9DYX1tVrX6GzW
 /iqbhALCWPzfTQmepfjgEqEH5bvrCJvtCv3H3/j7YfdasH4DuzYXRMcTShiV7ZVAOaGn
 ozb+ou2aveW8y470wB722tUwH99BKWS0kZTvAFURy8J1C8S7g6QqntiMawCXup/q6dfW
 9pBEGzzDcdyXztJaLtMP+qnxvnZBMuvmzuU4WR3TLnG6eYTzpsLWXhge4fcFBoXLVj9r
 eJ/Wrf9J/hMzXE2jMTGxwKR34nM3J7Mi/hJ3pW0rq6XnDdbZu7Mggj6dD45QPK8RDNwR rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeud8ffvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:19 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GDKlDS121032;
        Mon, 16 Aug 2021 09:21:18 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeud8ffve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:18 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDC9wD001551;
        Mon, 16 Aug 2021 13:21:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3ae5f8aws2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDLDA253936450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7242811C069;
        Mon, 16 Aug 2021 13:21:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAFBE11C05E;
        Mon, 16 Aug 2021 13:21:12 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 07/11] lib: s390x: sie: Move sie function into library
Date:   Mon, 16 Aug 2021 15:20:50 +0200
Message-Id: <20210816132054.60078-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H-S7OE8hFnFOLNnjEV8TYpJGU6MbnOBd
X-Proofpoint-ORIG-GUID: o7Rpmxi6cu75vXExHqH10Nao3FJIExbU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Time to deduplicate more code.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.c  | 15 ++++++++++++++-
 lib/s390x/sie.h  |  1 +
 s390x/mvpg-sie.c | 13 -------------
 s390x/sie.c      | 17 -----------------
 4 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 1a93e518..b965b314 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Virtualization library that speeds up managing guests.
+ * Library for managing various aspects of guests
  *
  * Copyright (c) 2021 IBM Corp
  *
@@ -42,6 +42,19 @@ void sie_handle_validity(struct vm *vm)
 	validity_expected = false;
 }
 
+void sie(struct vm *vm)
+{
+	/* Reset icptcode so we don't trip over it below */
+	vm->sblk->icptcode = 0;
+
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		sie_handle_validity(vm);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
 /* Initializes the struct vm members like the SIE control block. */
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 {
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 946bd164..ca514ef3 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -198,6 +198,7 @@ struct vm {
 extern void sie_entry(void);
 extern void sie_exit(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
+void sie(struct vm *vm);
 void sie_expect_validity(void);
 void sie_check_validity(uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 71ae4f88..70d2fcfa 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -32,19 +32,6 @@ extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
 extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
 int binary_size;
 
-static void sie(struct vm *vm)
-{
-	/* Reset icptcode so we don't trip over it below */
-	vm->sblk->icptcode = 0;
-
-	while (vm->sblk->icptcode == 0) {
-		sie64a(vm->sblk, &vm->save_area);
-		sie_handle_validity(vm);
-	}
-	vm->save_area.guest.grs[14] = vm->sblk->gg14;
-	vm->save_area.guest.grs[15] = vm->sblk->gg15;
-}
-
 static void test_mvpg_pei(void)
 {
 	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
diff --git a/s390x/sie.c b/s390x/sie.c
index 9cb9b055..ed2c3263 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -24,22 +24,6 @@ static u8 *guest;
 static u8 *guest_instr;
 static struct vm vm;
 
-
-static void sie(struct vm *vm)
-{
-	while (vm->sblk->icptcode == 0) {
-		sie64a(vm->sblk, &vm->save_area);
-		sie_handle_validity(vm);
-	}
-	vm->save_area.guest.grs[14] = vm->sblk->gg14;
-	vm->save_area.guest.grs[15] = vm->sblk->gg15;
-}
-
-static void sblk_cleanup(struct vm *vm)
-{
-	vm->sblk->icptcode = 0;
-}
-
 static void test_diag(u32 instr)
 {
 	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
@@ -51,7 +35,6 @@ static void test_diag(u32 instr)
 	report(vm.sblk->icptcode == ICPT_INST &&
 	       vm.sblk->ipa == instr >> 16 && vm.sblk->ipb == instr << 16,
 	       "Intercept data");
-	sblk_cleanup(&vm);
 }
 
 static struct {
-- 
2.31.1

