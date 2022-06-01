Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAE853AA37
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355744AbiFAPhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355662AbiFAPhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:37:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA87B4AE;
        Wed,  1 Jun 2022 08:36:59 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251FRKMT026330;
        Wed, 1 Jun 2022 15:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pjpihLH1bTG7E5AsvwD67PSXsJ9gtVy0h30vPO5AFj8=;
 b=slLRDsGp2izFvdMDtnRBMhFdgRR2WWSYLPYBc9Hro7VgiR53dRaLbliZHiiJBfrImJ+/
 ZfZM+DST0oUIy3vPkZWrnbSKM9f1TW/lFHmjVZUUCGr4PpihQZmStrozWSj6jIZc0wq0
 7/Weo8vPztwka6r9I5H4r41kkDp1n26pVFnsWw/NfAoYNUy1ZKMa2DMd0tfMatZUcJD0
 0YueEweXDMUZHJeCe0r7tQVa7UlNz1z6P/EA4xnW6sCWSdhD5ic8Y68DitqzFuC2ny/c
 TP+Rryc08lDtVFGdFhGyw1371Jgts6mcw2k+uzDNf6hjjhsyKvviLfElj7R0SOCEUGaR pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geas58784-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:58 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FTxlQ001508;
        Wed, 1 Jun 2022 15:36:58 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geas58766-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FM4NU025451;
        Wed, 1 Jun 2022 15:36:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gdnetsfbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FaqLF50135376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A9DCAE051;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 477B0AE04D;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 0D215E028C; Wed,  1 Jun 2022 17:36:52 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 14/15] KVM: s390: selftests: Use TAP interface in the tprot test
Date:   Wed,  1 Jun 2022 17:36:45 +0200
Message-Id: <20220601153646.6791-15-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OD74kyG8guQ44t5S97OHRYQEC3uQfovj
X-Proofpoint-GUID: KAwy3NErpKLK4MMsYEv7rt5XSN2JJKd5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

The tprot test currently does not have any output (unless one of
the TEST_ASSERT statement fails), so it's hard to say for a user
whether a certain new sub-test has been included in the binary or
not. Let's make this a little bit more user-friendly and include
some TAP output via the kselftests.h interface.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220531101554.36844-4-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/tprot.c | 29 +++++++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
index c097b9db495e..14d74a9e7b3d 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -8,6 +8,7 @@
 #include <sys/mman.h>
 #include "test_util.h"
 #include "kvm_util.h"
+#include "kselftest.h"
 
 #define PAGE_SHIFT 12
 #define PAGE_SIZE (1 << PAGE_SHIFT)
@@ -63,12 +64,12 @@ static enum permission test_protection(void *addr, uint8_t key)
 }
 
 enum stage {
-	STAGE_END,
 	STAGE_INIT_SIMPLE,
 	TEST_SIMPLE,
 	STAGE_INIT_FETCH_PROT_OVERRIDE,
 	TEST_FETCH_PROT_OVERRIDE,
 	TEST_STORAGE_PROT_OVERRIDE,
+	STAGE_END	/* must be the last entry (it's the amount of tests) */
 };
 
 struct test {
@@ -182,7 +183,7 @@ static void guest_code(void)
 	GUEST_SYNC(perform_next_stage(&i, mapped_0));
 }
 
-#define HOST_SYNC(vmp, stage)							\
+#define HOST_SYNC_NO_TAP(vmp, stage)						\
 ({										\
 	struct kvm_vm *__vm = (vmp);						\
 	struct ucall uc;							\
@@ -198,12 +199,21 @@ static void guest_code(void)
 	ASSERT_EQ(uc.args[1], __stage);						\
 })
 
+#define HOST_SYNC(vmp, stage)			\
+({						\
+	HOST_SYNC_NO_TAP(vmp, stage);		\
+	ksft_test_result_pass("" #stage "\n");	\
+})
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	vm_vaddr_t guest_0_page;
 
+	ksft_print_header();
+	ksft_set_plan(STAGE_END);
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	run = vcpu_state(vm, VCPU_ID);
 
@@ -212,9 +222,14 @@ int main(int argc, char *argv[])
 	HOST_SYNC(vm, TEST_SIMPLE);
 
 	guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
-	if (guest_0_page != 0)
-		print_skip("Did not allocate page at 0 for fetch protection override tests");
-	HOST_SYNC(vm, STAGE_INIT_FETCH_PROT_OVERRIDE);
+	if (guest_0_page != 0) {
+		/* Use NO_TAP so we don't get a PASS print */
+		HOST_SYNC_NO_TAP(vm, STAGE_INIT_FETCH_PROT_OVERRIDE);
+		ksft_test_result_skip("STAGE_INIT_FETCH_PROT_OVERRIDE - "
+				      "Did not allocate page at 0\n");
+	} else {
+		HOST_SYNC(vm, STAGE_INIT_FETCH_PROT_OVERRIDE);
+	}
 	if (guest_0_page == 0)
 		mprotect(addr_gva2hva(vm, (vm_vaddr_t)0), PAGE_SIZE, PROT_READ);
 	run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
@@ -224,4 +239,8 @@ int main(int argc, char *argv[])
 	run->s.regs.crs[0] |= CR0_STORAGE_PROTECTION_OVERRIDE;
 	run->kvm_dirty_regs = KVM_SYNC_CRS;
 	HOST_SYNC(vm, TEST_STORAGE_PROT_OVERRIDE);
+
+	kvm_vm_free(vm);
+
+	ksft_finished();	/* Print results and exit() accordingly */
 }
-- 
2.35.1

