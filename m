Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD794D9D1A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349049AbiCOONM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349030AbiCOOM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93122546B5;
        Tue, 15 Mar 2022 07:11:45 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FD12mc030252;
        Tue, 15 Mar 2022 14:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6reW27b8peKc+iPmYYpFkz+i2kB2DjdsIbCcupx2b+o=;
 b=K0u1sCQS8FTVpcaRW6+jHLvgpUA42RsMEVS6cRRHSxWphDIjzyuWPQEll4PtoQYLHhcP
 kT6huJMZWs0eEn6cSQvfipM+vrai0/4idMkCr1i7P8VAImnnZHMpeSZSefR193UHfWF4
 mKXl3ln1mUN2KLlUotzTEc1x7T3KmwvYQwakeoBAEVrT90Wbpy0cNQ/BAPws7bbnvmdM
 wKhro6ekxL3tkh2pvqbB1gFNHZHAeAE9Vuj6VaOWoYTDkEpHSyYo+c4jkJpWtqe+a0PU
 Xp99by+1cXofVDaR7qoGKPeXfAFZ4363FPSoCYiF7F3ppB2qRIsvqUJuk0y0QjR/Palz tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajhquy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:44 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDObHB022639;
        Tue, 15 Mar 2022 14:11:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajhqub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE8xcN007656;
        Tue, 15 Mar 2022 14:11:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3et95wt42f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:42 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBdGF58196444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CF2CAE051;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BCB3AE045;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id DD5FFE11F3; Tue, 15 Mar 2022 15:11:38 +0100 (CET)
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
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 3/7] KVM: s390: selftests: Split memop tests
Date:   Tue, 15 Mar 2022 15:11:33 +0100
Message-Id: <20220315141137.357923-4-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -Akhs_Wb9qkJzTjrJ8IDGTxXhD6F0O9P
X-Proofpoint-GUID: oFFcuwG9qfNihz8IRRLxGAuE9BBtVgVZ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Split success case/copy test from error test, making them independent.
This means they do not share state and are easier to understand.
Also, new test can be added in the same manner without affecting the old
ones. In order to make that simpler, introduce functionality for the
setup of commonly used variables.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220308125841.3271721-2-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 139 +++++++++++++---------
 1 file changed, 83 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index d19c3ffdea3f..b9b673acb766 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -18,71 +18,82 @@
 static uint8_t mem1[65536];
 static uint8_t mem2[65536];
 
-static void guest_code(void)
-{
-	int i;
+struct test_default {
+	struct kvm_vm *kvm_vm;
+	struct kvm_run *run;
+	int size;
+};
 
-	for (;;) {
-		for (i = 0; i < sizeof(mem2); i++)
-			mem2[i] = mem1[i];
-		GUEST_SYNC(0);
-	}
+static struct test_default test_default_init(void *guest_code)
+{
+	struct test_default t;
+
+	t.size = min((size_t)kvm_check_cap(KVM_CAP_S390_MEM_OP), sizeof(mem1));
+	t.kvm_vm = vm_create_default(VCPU_ID, 0, guest_code);
+	t.run = vcpu_state(t.kvm_vm, VCPU_ID);
+	return t;
 }
 
-int main(int argc, char *argv[])
+static void guest_copy(void)
 {
-	struct kvm_vm *vm;
-	struct kvm_run *run;
+	memcpy(&mem2, &mem1, sizeof(mem2));
+	GUEST_SYNC(0);
+}
+
+static void test_copy(void)
+{
+	struct test_default t = test_default_init(guest_copy);
 	struct kvm_s390_mem_op ksmo;
-	int rv, i, maxsize;
-
-	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
-
-	maxsize = kvm_check_cap(KVM_CAP_S390_MEM_OP);
-	if (!maxsize) {
-		print_skip("CAP_S390_MEM_OP not supported");
-		exit(KSFT_SKIP);
-	}
-	if (maxsize > sizeof(mem1))
-		maxsize = sizeof(mem1);
-
-	/* Create VM */
-	vm = vm_create_default(VCPU_ID, 0, guest_code);
-	run = vcpu_state(vm, VCPU_ID);
+	int i;
 
 	for (i = 0; i < sizeof(mem1); i++)
 		mem1[i] = i * i + i;
 
 	/* Set the first array */
-	ksmo.gaddr = addr_gva2gpa(vm, (uintptr_t)mem1);
+	ksmo.gaddr = addr_gva2gpa(t.kvm_vm, (uintptr_t)mem1);
 	ksmo.flags = 0;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 0;
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 
 	/* Let the guest code copy the first array to the second */
-	vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
+	vcpu_run(t.kvm_vm, VCPU_ID);
+	TEST_ASSERT(t.run->exit_reason == KVM_EXIT_S390_SIEIC,
 		    "Unexpected exit reason: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+		    t.run->exit_reason,
+		    exit_reason_str(t.run->exit_reason));
 
 	memset(mem2, 0xaa, sizeof(mem2));
 
 	/* Get the second array */
 	ksmo.gaddr = (uintptr_t)mem2;
 	ksmo.flags = 0;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
 	ksmo.buf = (uintptr_t)mem2;
 	ksmo.ar = 0;
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 
-	TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+	TEST_ASSERT(!memcmp(mem1, mem2, t.size),
 		    "Memory contents do not match!");
 
+	kvm_vm_free(t.kvm_vm);
+}
+
+static void guest_idle(void)
+{
+	for (;;)
+		GUEST_SYNC(0);
+}
+
+static void test_errors(void)
+{
+	struct test_default t = test_default_init(guest_idle);
+	struct kvm_s390_mem_op ksmo;
+	int rv;
+
 	/* Check error conditions - first bad size: */
 	ksmo.gaddr = (uintptr_t)mem1;
 	ksmo.flags = 0;
@@ -90,7 +101,7 @@ int main(int argc, char *argv[])
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
 
 	/* Zero size: */
@@ -100,65 +111,65 @@ int main(int argc, char *argv[])
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
 		    "ioctl allows 0 as size");
 
 	/* Bad flags: */
 	ksmo.gaddr = (uintptr_t)mem1;
 	ksmo.flags = -1;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
 
 	/* Bad operation: */
 	ksmo.gaddr = (uintptr_t)mem1;
 	ksmo.flags = 0;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = -1;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows bad operations");
 
 	/* Bad guest address: */
 	ksmo.gaddr = ~0xfffUL;
 	ksmo.flags = KVM_S390_MEMOP_F_CHECK_ONLY;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
 
 	/* Bad host address: */
 	ksmo.gaddr = (uintptr_t)mem1;
 	ksmo.flags = 0;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = 0;
 	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EFAULT,
 		    "ioctl does not report bad host memory address");
 
 	/* Bad access register: */
-	run->psw_mask &= ~(3UL << (63 - 17));
-	run->psw_mask |= 1UL << (63 - 17);  /* Enable AR mode */
-	vcpu_run(vm, VCPU_ID);              /* To sync new state to SIE block */
+	t.run->psw_mask &= ~(3UL << (63 - 17));
+	t.run->psw_mask |= 1UL << (63 - 17);  /* Enable AR mode */
+	vcpu_run(t.kvm_vm, VCPU_ID);              /* To sync new state to SIE block */
 	ksmo.gaddr = (uintptr_t)mem1;
 	ksmo.flags = 0;
-	ksmo.size = maxsize;
+	ksmo.size = t.size;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.ar = 17;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows ARs > 15");
-	run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
-	vcpu_run(vm, VCPU_ID);                  /* Run to sync new state */
+	t.run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
+	vcpu_run(t.kvm_vm, VCPU_ID);                  /* Run to sync new state */
 
 	/* Check that the SIDA calls are rejected for non-protected guests */
 	ksmo.gaddr = 0;
@@ -167,15 +178,31 @@ int main(int argc, char *argv[])
 	ksmo.op = KVM_S390_MEMOP_SIDA_READ;
 	ksmo.buf = (uintptr_t)mem1;
 	ksmo.sida_offset = 0x1c0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EINVAL,
 		    "ioctl does not reject SIDA_READ in non-protected mode");
 	ksmo.op = KVM_S390_MEMOP_SIDA_WRITE;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EINVAL,
 		    "ioctl does not reject SIDA_WRITE in non-protected mode");
 
-	kvm_vm_free(vm);
+	kvm_vm_free(t.kvm_vm);
+}
+
+int main(int argc, char *argv[])
+{
+	int memop_cap;
+
+	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
+
+	memop_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP);
+	if (!memop_cap) {
+		print_skip("CAP_S390_MEM_OP not supported");
+		exit(KSFT_SKIP);
+	}
+
+	test_copy();
+	test_errors();
 
 	return 0;
 }
-- 
2.35.1

