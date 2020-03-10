Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD59917FC99
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgCJNWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 09:22:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730319AbgCJNBu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 09:01:50 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AD0HpS054854;
        Tue, 10 Mar 2020 09:01:49 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8g4j1w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02AD0XcJ056400;
        Tue, 10 Mar 2020 09:01:47 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8g4j1v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:47 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02ACtYuK004283;
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 2ym386semn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 13:01:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AD1kc434603396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF51D28065;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA5D628058;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/5] selftests: KVM: s390: test more register variants for the reset ioctl
Date:   Tue, 10 Mar 2020 09:01:41 -0400
Message-Id: <20200310130144.9921-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200310130144.9921-1-borntraeger@de.ibm.com>
References: <20200310130144.9921-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should not only test the oneregs or the get_(x)regs interfaces but
also the sync_regs. Those are usually the canonical place for register
content.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 50 ++++++++++++++++++----
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index cbb343ad5d42..c385842792b7 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -20,8 +20,8 @@ struct kvm_s390_irq buf[VCPU_ID + LOCAL_IRQS];
 
 struct kvm_vm *vm;
 struct kvm_run *run;
-struct kvm_sync_regs *regs;
-static uint64_t regs_null[16];
+struct kvm_sync_regs *sync_regs;
+static uint8_t regs_null[512];
 
 static void guest_code_initial(void)
 {
@@ -86,6 +86,16 @@ static void assert_clear(void)
 
 	vcpu_fpu_get(vm, VCPU_ID, &fpu);
 	TEST_ASSERT(!memcmp(&fpu.fprs, regs_null, sizeof(fpu.fprs)), "fprs == 0");
+
+	/* sync regs */
+	TEST_ASSERT(!memcmp(sync_regs->gprs, regs_null, sizeof(sync_regs->gprs)),
+		    "gprs0-15 == 0 (sync_regs)");
+
+	TEST_ASSERT(!memcmp(sync_regs->acrs, regs_null, sizeof(sync_regs->acrs)),
+		    "acrs0-15 == 0 (sync_regs)");
+
+	TEST_ASSERT(!memcmp(sync_regs->vrs, regs_null, sizeof(sync_regs->vrs)),
+		    "vrs0-15 == 0 (sync_regs)");
 }
 
 static void assert_initial(void)
@@ -93,12 +103,32 @@ static void assert_initial(void)
 	struct kvm_sregs sregs;
 	struct kvm_fpu fpu;
 
+	/* KVM_GET_SREGS */
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
-	TEST_ASSERT(sregs.crs[0] == 0xE0UL, "cr0 == 0xE0");
-	TEST_ASSERT(sregs.crs[14] == 0xC2000000UL, "cr14 == 0xC2000000");
+	TEST_ASSERT(sregs.crs[0] == 0xE0UL, "cr0 == 0xE0 (KVM_GET_SREGS)");
+	TEST_ASSERT(sregs.crs[14] == 0xC2000000UL,
+		    "cr14 == 0xC2000000 (KVM_GET_SREGS)");
 	TEST_ASSERT(!memcmp(&sregs.crs[1], regs_null, sizeof(sregs.crs[1]) * 12),
-		    "cr1-13 == 0");
-	TEST_ASSERT(sregs.crs[15] == 0, "cr15 == 0");
+		    "cr1-13 == 0 (KVM_GET_SREGS)");
+	TEST_ASSERT(sregs.crs[15] == 0, "cr15 == 0 (KVM_GET_SREGS)");
+
+	/* sync regs */
+	TEST_ASSERT(sync_regs->crs[0] == 0xE0UL, "cr0 == 0xE0 (sync_regs)");
+	TEST_ASSERT(sync_regs->crs[14] == 0xC2000000UL,
+		    "cr14 == 0xC2000000 (sync_regs)");
+	TEST_ASSERT(!memcmp(&sync_regs->crs[1], regs_null, 8 * 12),
+		    "cr1-13 == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->crs[15] == 0, "cr15 == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->fpc == 0, "fpc == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->todpr == 0, "todpr == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->cputm == 0, "cputm == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->ckc == 0, "ckc == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->pp == 0, "pp == 0 (sync_regs)");
+	TEST_ASSERT(sync_regs->gbea == 1, "gbea == 1 (sync_regs)");
+
+	/* kvm_run */
+	TEST_ASSERT(run->psw_addr == 0, "psw_addr == 0 (kvm_run)");
+	TEST_ASSERT(run->psw_mask == 0, "psw_mask == 0 (kvm_run)");
 
 	vcpu_fpu_get(vm, VCPU_ID, &fpu);
 	TEST_ASSERT(!fpu.fpc, "fpc == 0");
@@ -113,6 +143,8 @@ static void assert_initial(void)
 static void assert_normal(void)
 {
 	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
+	TEST_ASSERT(sync_regs->pft == KVM_S390_PFAULT_TOKEN_INVALID,
+			"pft == 0xff.....  (sync_regs)");
 	assert_noirq();
 }
 
@@ -137,7 +169,7 @@ static void test_normal(void)
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
-	regs = &run->s.regs;
+	sync_regs = &run->s.regs;
 
 	vcpu_run(vm, VCPU_ID);
 
@@ -153,7 +185,7 @@ static void test_initial(void)
 	printf("Testing initial reset\n");
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
-	regs = &run->s.regs;
+	sync_regs = &run->s.regs;
 
 	vcpu_run(vm, VCPU_ID);
 
@@ -170,7 +202,7 @@ static void test_clear(void)
 	printf("Testing clear reset\n");
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
-	regs = &run->s.regs;
+	sync_regs = &run->s.regs;
 
 	vcpu_run(vm, VCPU_ID);
 
-- 
2.25.0

