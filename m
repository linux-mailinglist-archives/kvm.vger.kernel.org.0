Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325703ED6D9
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbhHPNYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:24:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62948 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239326AbhHPNVu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD2eoq062779;
        Mon, 16 Aug 2021 09:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g51lMvdFqBbtOeqBFrizMbY5Lp00ziMBdLBCpuaq5Lc=;
 b=Gr0cMNAWQcqo7bhaIVeJXWK3VC9pqtS0UWMP14Wu5/viiY2mIj6nGQHiOwaQQNz5fdOO
 KdkEud8z9HGlU5UW4Cx50Snyazw40BHx0y5fePcw46meU6xLhosmxf4GhS+qNjEIfPjb
 UZ77MGgWt/DoejyFAH8ZIBBq7HCe00C2rt9ua6xorKGsfz1cc37cWsdvlh6BgKUkCaIR
 Zn41PzMxyqAF8LqrTvtq5gAoIC0PIaVKyeRaejRk/zZumz97N7iAJVk9GB3ePOBX7qhE
 MZwY8UpDWTr4tKt+BUTszcL+rJCrzPr7y2x40RGmdsi1mI1RTZHw3SaJaVG2GynZxynF Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeu9yyp6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:18 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD31pf064911;
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeu9yyp5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCatS013765;
        Mon, 16 Aug 2021 13:21:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8awqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDLCc849742240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA2DB11C052;
        Mon, 16 Aug 2021 13:21:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C6B511C058;
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
Subject: [kvm-unit-tests GIT PULL 06/11] s390x: lib: sie: Add struct vm (de)initialization functions
Date:   Mon, 16 Aug 2021 15:20:49 +0200
Message-Id: <20210816132054.60078-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7xjAS-i4DKX6N2YYhfQu3dzKNn2XOJfG
X-Proofpoint-ORIG-GUID: I670RE2X3FA_Vs6zg6DcYVg0aKIYk4xi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before I start copying the same code over and over lets move this into
the library.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.c  | 30 ++++++++++++++++++++++++++++++
 lib/s390x/sie.h  |  3 +++
 s390x/mvpg-sie.c | 18 ++----------------
 s390x/sie.c      | 19 +++----------------
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 15ba407c..1a93e518 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -11,6 +11,9 @@
 #include <asm/barrier.h>
 #include <libcflat.h>
 #include <sie.h>
+#include <asm/page.h>
+#include <libcflat.h>
+#include <alloc_page.h>
 
 static bool validity_expected;
 static uint16_t vir;		/* Validity interception reason */
@@ -38,3 +41,30 @@ void sie_handle_validity(struct vm *vm)
 		report_abort("VALIDITY: %x", vir);
 	validity_expected = false;
 }
+
+/* Initializes the struct vm members like the SIE control block. */
+void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
+{
+	vm->sblk = alloc_page();
+	memset(vm->sblk, 0, PAGE_SIZE);
+	vm->sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm->sblk->ihcpu = 0xffff;
+	vm->sblk->prefix = 0;
+
+	/* Guest memory chunks are always 1MB */
+	assert(!(guest_mem_len & ~HPAGE_MASK));
+	/* Currently MSO/MSL is the easiest option */
+	vm->sblk->mso = (uint64_t)guest_mem;
+	vm->sblk->msl = (uint64_t)guest_mem + ((guest_mem_len - 1) & HPAGE_MASK);
+
+	/* CRYCB needs to be in the first 2GB */
+	vm->crycb = alloc_pages_flags(0, AREA_DMA31);
+	vm->sblk->crycbd = (uint32_t)(uintptr_t)vm->crycb;
+}
+
+/* Frees the memory that was gathered on initialization */
+void sie_guest_destroy(struct vm *vm)
+{
+	free_page(vm->crycb);
+	free_page(vm->sblk);
+}
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 7ff98d2d..946bd164 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -190,6 +190,7 @@ struct vm_save_area {
 struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
+	uint8_t *crycb;				/* Crypto Control Block */
 	/* Ptr to first guest page */
 	uint8_t *guest_mem;
 };
@@ -200,5 +201,7 @@ extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_ar
 void sie_expect_validity(void);
 void sie_check_validity(uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
+void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
+void sie_guest_destroy(struct vm *vm);
 
 #endif /* _S390X_SIE_H_ */
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 2ac91eec..71ae4f88 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -110,22 +110,7 @@ static void setup_guest(void)
 	/* The first two pages are the lowcore */
 	guest_instr = guest + PAGE_SIZE * 2;
 
-	vm.sblk = alloc_page();
-
-	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
-	vm.sblk->prefix = 0;
-	/*
-	 * Pageable guest with the same ASCE as the test programm, but
-	 * the guest memory 0x0 is offset to start at the allocated
-	 * guest pages and end after 1MB.
-	 *
-	 * It's not pretty but faster and easier than managing guest ASCEs.
-	 */
-	vm.sblk->mso = (u64)guest;
-	vm.sblk->msl = (u64)guest;
-	vm.sblk->ihcpu = 0xffff;
-
-	vm.sblk->crycbd = (uint64_t)alloc_page();
+	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 
 	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
 	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
@@ -150,6 +135,7 @@ int main(void)
 	setup_guest();
 	test_mvpg();
 	test_mvpg_pei();
+	sie_guest_destroy(&vm);
 
 done:
 	report_prefix_pop();
diff --git a/s390x/sie.c b/s390x/sie.c
index 5c798a9e..9cb9b055 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -84,22 +84,7 @@ static void setup_guest(void)
 	/* The first two pages are the lowcore */
 	guest_instr = guest + PAGE_SIZE * 2;
 
-	vm.sblk = alloc_page();
-
-	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
-	vm.sblk->prefix = 0;
-	/*
-	 * Pageable guest with the same ASCE as the test programm, but
-	 * the guest memory 0x0 is offset to start at the allocated
-	 * guest pages and end after 1MB.
-	 *
-	 * It's not pretty but faster and easier than managing guest ASCEs.
-	 */
-	vm.sblk->mso = (u64)guest;
-	vm.sblk->msl = (u64)guest;
-	vm.sblk->ihcpu = 0xffff;
-
-	vm.sblk->crycbd = (uint64_t)alloc_page();
+	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 }
 
 int main(void)
@@ -112,6 +97,8 @@ int main(void)
 
 	setup_guest();
 	test_diags();
+	sie_guest_destroy(&vm);
+
 done:
 	report_prefix_pop();
 	return report_summary();
-- 
2.31.1

