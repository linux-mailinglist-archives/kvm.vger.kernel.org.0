Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF65F17E2FA
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCIPBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:01:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbgCIPBX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 11:01:23 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029ExHr7093615;
        Mon, 9 Mar 2020 11:01:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym7t6ux8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:01:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 029F0dWG104608;
        Mon, 9 Mar 2020 11:00:39 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym7t6ux5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 11:00:39 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 029F0PSL004766;
        Mon, 9 Mar 2020 15:00:36 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2ym386fvvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Mar 2020 15:00:36 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 029F0ZTL43974952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 15:00:35 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF65528075;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7F9628065;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  9 Mar 2020 15:00:34 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH 2/4] selftests: KVM: s390: test more register variants for the reset ioctl
Date:   Mon,  9 Mar 2020 11:00:24 -0400
Message-Id: <20200309150026.4329-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200309150026.4329-1-borntraeger@de.ibm.com>
References: <20200309150026.4329-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090104
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

