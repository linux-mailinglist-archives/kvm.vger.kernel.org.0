Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1530D4D9D1C
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241113AbiCOONN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349044AbiCOONA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:13:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B5C54BD1;
        Tue, 15 Mar 2022 07:11:47 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FDTXfn001163;
        Tue, 15 Mar 2022 14:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=lgUcleidPgeSbZdOb4sTvjU1fm+T1hemCinHIHwKwXU=;
 b=BIyzRLoxCEgFrpnQuWKJGbqJk5BzqrjN+3TXys0jnrMGIhzFbzhnRR9sCxLRWnkdk7tj
 zz+xFW1iVM9unsBNJvsi1QIAtoV8Nwr0orjtucciGMLLhMACKK5r62T4rlppGdCl9TQv
 LUIZHAZdb8HqpbZhkvfXDPRM4/dWliMRBDOR+NFNH0atx/Qf7HTppuF/y4LusF83gdn/
 lFSenAx4gYbDhD4YVc1JwRXp3dtfYnxEUiUkQYu8Nx0scWhc5b6VMnoY3Q0zw8rfmUMA
 nxCiJHQ3lE2RZurJbcogyrB7P5NjcJIksJ9rIblK31RONgFtF4mggCkLsqzZYNeOywAK jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etuqvs1pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:46 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDpkpH022474;
        Tue, 15 Mar 2022 14:11:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etuqvs1p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:45 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE9JJF013277;
        Tue, 15 Mar 2022 14:11:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3erk58xsw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBe8156295826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8F994C044;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 875884C040;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 42584E11F3; Tue, 15 Mar 2022 15:11:40 +0100 (CET)
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
Subject: [GIT PULL 7/7] KVM: s390: selftests: Add error memop tests
Date:   Tue, 15 Mar 2022 15:11:37 +0100
Message-Id: <20220315141137.357923-8-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LwtSvwYXdTKwdnKmmwyekFDbq0lzS9HH
X-Proofpoint-ORIG-GUID: 7Jot3k7dfHkPD_S3HnthXZp2ipbTmDPW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203150092
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

Test that errors occur if key protection disallows access, including
tests for storage and fetch protection override. Perform tests for both
logical vcpu and absolute vm ioctls.
Also extend the existing tests to the vm ioctl.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220308125841.3271721-6-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 153 +++++++++++++++++++---
 1 file changed, 132 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 42282663b38b..b04c2c1b3c30 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -422,6 +422,46 @@ static void test_copy_key_fetch_prot(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+#define ERR_PROT_MOP(...)							\
+({										\
+	int rv;									\
+										\
+	rv = ERR_MOP(__VA_ARGS__);						\
+	TEST_ASSERT(rv == 4, "Should result in protection exception");		\
+})
+
+static void test_errors_key(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vm/vcpu, mismatching keys, fetch protection in effect */
+	CHECK_N_DO(ERR_PROT_MOP, t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1), KEY(2));
+	CHECK_N_DO(ERR_PROT_MOP, t.vcpu, LOGICAL, READ, mem2, t.size, GADDR_V(mem2), KEY(2));
+	CHECK_N_DO(ERR_PROT_MOP, t.vm, ABSOLUTE, WRITE, mem1, t.size, GADDR_V(mem1), KEY(2));
+	CHECK_N_DO(ERR_PROT_MOP, t.vm, ABSOLUTE, READ, mem2, t.size, GADDR_V(mem2), KEY(2));
+
+	kvm_vm_free(t.kvm_vm);
+}
+
+static void test_errors_key_storage_prot_override(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	t.run->s.regs.crs[0] |= CR0_STORAGE_PROTECTION_OVERRIDE;
+	t.run->kvm_dirty_regs = KVM_SYNC_CRS;
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vm, mismatching keys, storage protection override not applicable to vm */
+	CHECK_N_DO(ERR_PROT_MOP, t.vm, ABSOLUTE, WRITE, mem1, t.size, GADDR_V(mem1), KEY(2));
+	CHECK_N_DO(ERR_PROT_MOP, t.vm, ABSOLUTE, READ, mem2, t.size, GADDR_V(mem2), KEY(2));
+
+	kvm_vm_free(t.kvm_vm);
+}
+
 const uint64_t last_page_addr = -PAGE_SIZE;
 
 static void guest_copy_key_fetch_prot_override(void)
@@ -481,6 +521,58 @@ static void test_copy_key_fetch_prot_override(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+static void test_errors_key_fetch_prot_override_not_enabled(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
+	vm_vaddr_t guest_0_page, guest_last_page;
+
+	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
+		print_skip("did not allocate guest pages at required positions");
+		goto out;
+	}
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vcpu, mismatching keys on fetch, fetch protection override not enabled */
+	CHECK_N_DO(ERR_PROT_MOP, t.vcpu, LOGICAL, READ, mem2, 2048, GADDR_V(0), KEY(2));
+
+out:
+	kvm_vm_free(t.kvm_vm);
+}
+
+static void test_errors_key_fetch_prot_override_enabled(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
+	vm_vaddr_t guest_0_page, guest_last_page;
+
+	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
+		print_skip("did not allocate guest pages at required positions");
+		goto out;
+	}
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	t.run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
+	t.run->kvm_dirty_regs = KVM_SYNC_CRS;
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/*
+	 * vcpu, mismatching keys on fetch,
+	 * fetch protection override does not apply because memory range acceeded
+	 */
+	CHECK_N_DO(ERR_PROT_MOP, t.vcpu, LOGICAL, READ, mem2, 2048 + 1, GADDR_V(0), KEY(2));
+	CHECK_N_DO(ERR_PROT_MOP, t.vcpu, LOGICAL, READ, mem2, PAGE_SIZE + 2048 + 1,
+		   GADDR_V(guest_last_page), KEY(2));
+	/* vm, fetch protected override does not apply */
+	CHECK_N_DO(ERR_PROT_MOP, t.vm, ABSOLUTE, READ, mem2, 2048, GADDR(0), KEY(2));
+	CHECK_N_DO(ERR_PROT_MOP, t.vm, ABSOLUTE, READ, mem2, 2048, GADDR_V(guest_0_page), KEY(2));
+
+out:
+	kvm_vm_free(t.kvm_vm);
+}
+
 static void guest_idle(void)
 {
 	GUEST_SYNC(STAGE_INITED); /* for consistency's sake */
@@ -488,6 +580,37 @@ static void guest_idle(void)
 		GUEST_SYNC(STAGE_IDLED);
 }
 
+static void _test_errors_common(struct test_vcpu vcpu, enum mop_target target, int size)
+{
+	int rv;
+
+	/* Bad size: */
+	rv = ERR_MOP(vcpu, target, WRITE, mem1, -1, GADDR_V(mem1));
+	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
+
+	/* Zero size: */
+	rv = ERR_MOP(vcpu, target, WRITE, mem1, 0, GADDR_V(mem1));
+	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
+		    "ioctl allows 0 as size");
+
+	/* Bad flags: */
+	rv = ERR_MOP(vcpu, target, WRITE, mem1, size, GADDR_V(mem1), SET_FLAGS(-1));
+	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
+
+	/* Bad guest address: */
+	rv = ERR_MOP(vcpu, target, WRITE, mem1, size, GADDR((void *)~0xfffUL), CHECK_ONLY);
+	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
+
+	/* Bad host address: */
+	rv = ERR_MOP(vcpu, target, WRITE, 0, size, GADDR_V(mem1));
+	TEST_ASSERT(rv == -1 && errno == EFAULT,
+		    "ioctl does not report bad host memory address");
+
+	/* Bad key: */
+	rv = ERR_MOP(vcpu, target, WRITE, mem1, size, GADDR_V(mem1), KEY(17));
+	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows invalid key");
+}
+
 static void test_errors(void)
 {
 	struct test_default t = test_default_init(guest_idle);
@@ -495,31 +618,15 @@ static void test_errors(void)
 
 	HOST_SYNC(t.vcpu, STAGE_INITED);
 
-	/* Bad size: */
-	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, -1, GADDR_V(mem1));
-	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
-
-	/* Zero size: */
-	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, 0, GADDR_V(mem1));
-	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
-		    "ioctl allows 0 as size");
-
-	/* Bad flags: */
-	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1), SET_FLAGS(-1));
-	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
+	_test_errors_common(t.vcpu, LOGICAL, t.size);
+	_test_errors_common(t.vm, ABSOLUTE, t.size);
 
 	/* Bad operation: */
 	rv = ERR_MOP(t.vcpu, INVALID, WRITE, mem1, t.size, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows bad operations");
-
-	/* Bad guest address: */
-	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR((void *)~0xfffUL), CHECK_ONLY);
-	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
-
-	/* Bad host address: */
-	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, 0, t.size, GADDR_V(mem1));
-	TEST_ASSERT(rv == -1 && errno == EFAULT,
-		    "ioctl does not report bad host memory address");
+	/* virtual addresses are not translated when passing INVALID */
+	rv = ERR_MOP(t.vm, INVALID, WRITE, mem1, PAGE_SIZE, GADDR(0));
+	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows bad operations");
 
 	/* Bad access register: */
 	t.run->psw_mask &= ~(3UL << (63 - 17));
@@ -560,6 +667,10 @@ int main(int argc, char *argv[])
 		test_copy_key_storage_prot_override();
 		test_copy_key_fetch_prot();
 		test_copy_key_fetch_prot_override();
+		test_errors_key();
+		test_errors_key_storage_prot_override();
+		test_errors_key_fetch_prot_override_not_enabled();
+		test_errors_key_fetch_prot_override_enabled();
 	} else {
 		print_skip("storage key memop extension not supported");
 	}
-- 
2.35.1

