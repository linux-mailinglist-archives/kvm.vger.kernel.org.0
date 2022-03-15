Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E34D9D1B
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349057AbiCOONO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349039AbiCOOM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5637054BCE;
        Tue, 15 Mar 2022 07:11:46 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FDCnln009278;
        Tue, 15 Mar 2022 14:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=aEvSLMRIYlzAlHbiUvOq6136GDR7Udpl5RLN+SYTLA0=;
 b=dstsL2TXfnaXTj25Zsw7doFqtsXaYOFhmZBL4LTrxPJeDvI/sUOjg5tfmW3CnG0FcqKB
 zwRv+0ubzxt+EkIAoyAF8h4J+DGVCbPi0FqZ6IUp9r65Mqtd6pS4soERMIDdXpdU74SM
 u1qxR/c/MDKOQ20Giwv6dGNM+lIvWppTfGOShmqj2AVymrItUcJ7wcUTuxLo0QzSVcXv
 G/ew2cKyfm8YzNJNa0M13mofwFzeFMKGZIr3qzOZGR6nhooPqsN1ds4STFjNoLMNUyOf
 4Z3xmEy0nMNGfoaL8YZiAQ9N9NAf0rqzfFXqbZ+CtgVQa5Hpw4d+WP4Ie+HBSIgr/JG4 Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etufuhew4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:45 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDGfRR023400;
        Tue, 15 Mar 2022 14:11:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etufuhevg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE8xcO007656;
        Tue, 15 Mar 2022 14:11:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3et95wt42g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBfph44761344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6C904203F;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A9B442042;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 474B0E11F3; Tue, 15 Mar 2022 15:11:39 +0100 (CET)
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
Subject: [GIT PULL 4/7] KVM: s390: selftests: Add macro as abstraction for MEM_OP
Date:   Tue, 15 Mar 2022 15:11:34 +0100
Message-Id: <20220315141137.357923-5-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: v4e6hNPlFQ-CB0XY1ErNQv9kspzZwOaz
X-Proofpoint-GUID: bfh1Lb3TRlcihIoei3mw2G7W4JPXtL8Q
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150092
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

In order to achieve good test coverage we need to be able to invoke the
MEM_OP ioctl with all possible parametrizations.
However, for a given test, we want to be concise and not specify a long
list of default values for parameters not relevant for the test, so the
readers attention is not needlessly diverted.
Add a macro that enables this and convert the existing test to use it.
The macro emulates named arguments and hides some of the ioctl's
redundancy, e.g. sets the key flag if an access key is specified.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220308125841.3271721-3-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 272 ++++++++++++++++------
 1 file changed, 197 insertions(+), 75 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index b9b673acb766..e2ad3d70bae4 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -13,6 +13,188 @@
 #include "test_util.h"
 #include "kvm_util.h"
 
+enum mop_target {
+	LOGICAL,
+	SIDA,
+	ABSOLUTE,
+	INVALID,
+};
+
+enum mop_access_mode {
+	READ,
+	WRITE,
+};
+
+struct mop_desc {
+	uintptr_t gaddr;
+	uintptr_t gaddr_v;
+	uint64_t set_flags;
+	unsigned int f_check : 1;
+	unsigned int f_inject : 1;
+	unsigned int f_key : 1;
+	unsigned int _gaddr_v : 1;
+	unsigned int _set_flags : 1;
+	unsigned int _sida_offset : 1;
+	unsigned int _ar : 1;
+	uint32_t size;
+	enum mop_target target;
+	enum mop_access_mode mode;
+	void *buf;
+	uint32_t sida_offset;
+	uint8_t ar;
+	uint8_t key;
+};
+
+static struct kvm_s390_mem_op ksmo_from_desc(struct mop_desc desc)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = (uintptr_t)desc.gaddr,
+		.size = desc.size,
+		.buf = ((uintptr_t)desc.buf),
+		.reserved = "ignored_ignored_ignored_ignored"
+	};
+
+	switch (desc.target) {
+	case LOGICAL:
+		if (desc.mode == READ)
+			ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
+		if (desc.mode == WRITE)
+			ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
+		break;
+	case SIDA:
+		if (desc.mode == READ)
+			ksmo.op = KVM_S390_MEMOP_SIDA_READ;
+		if (desc.mode == WRITE)
+			ksmo.op = KVM_S390_MEMOP_SIDA_WRITE;
+		break;
+	case ABSOLUTE:
+		if (desc.mode == READ)
+			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_READ;
+		if (desc.mode == WRITE)
+			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
+		break;
+	case INVALID:
+		ksmo.op = -1;
+	}
+	if (desc.f_check)
+		ksmo.flags |= KVM_S390_MEMOP_F_CHECK_ONLY;
+	if (desc.f_inject)
+		ksmo.flags |= KVM_S390_MEMOP_F_INJECT_EXCEPTION;
+	if (desc._set_flags)
+		ksmo.flags = desc.set_flags;
+	if (desc.f_key) {
+		ksmo.flags |= KVM_S390_MEMOP_F_SKEY_PROTECTION;
+		ksmo.key = desc.key;
+	}
+	if (desc._ar)
+		ksmo.ar = desc.ar;
+	else
+		ksmo.ar = 0;
+	if (desc._sida_offset)
+		ksmo.sida_offset = desc.sida_offset;
+
+	return ksmo;
+}
+
+/* vcpu dummy id signifying that vm instead of vcpu ioctl is to occur */
+const uint32_t VM_VCPU_ID = (uint32_t)-1;
+
+struct test_vcpu {
+	struct kvm_vm *vm;
+	uint32_t id;
+};
+
+#define PRINT_MEMOP false
+static void print_memop(uint32_t vcpu_id, const struct kvm_s390_mem_op *ksmo)
+{
+	if (!PRINT_MEMOP)
+		return;
+
+	if (vcpu_id == VM_VCPU_ID)
+		printf("vm memop(");
+	else
+		printf("vcpu memop(");
+	switch (ksmo->op) {
+	case KVM_S390_MEMOP_LOGICAL_READ:
+		printf("LOGICAL, READ, ");
+		break;
+	case KVM_S390_MEMOP_LOGICAL_WRITE:
+		printf("LOGICAL, WRITE, ");
+		break;
+	case KVM_S390_MEMOP_SIDA_READ:
+		printf("SIDA, READ, ");
+		break;
+	case KVM_S390_MEMOP_SIDA_WRITE:
+		printf("SIDA, WRITE, ");
+		break;
+	case KVM_S390_MEMOP_ABSOLUTE_READ:
+		printf("ABSOLUTE, READ, ");
+		break;
+	case KVM_S390_MEMOP_ABSOLUTE_WRITE:
+		printf("ABSOLUTE, WRITE, ");
+		break;
+	}
+	printf("gaddr=%llu, size=%u, buf=%llu, ar=%u, key=%u",
+	       ksmo->gaddr, ksmo->size, ksmo->buf, ksmo->ar, ksmo->key);
+	if (ksmo->flags & KVM_S390_MEMOP_F_CHECK_ONLY)
+		printf(", CHECK_ONLY");
+	if (ksmo->flags & KVM_S390_MEMOP_F_INJECT_EXCEPTION)
+		printf(", INJECT_EXCEPTION");
+	if (ksmo->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION)
+		printf(", SKEY_PROTECTION");
+	puts(")");
+}
+
+static void memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
+{
+	if (vcpu.id == VM_VCPU_ID)
+		vm_ioctl(vcpu.vm, KVM_S390_MEM_OP, ksmo);
+	else
+		vcpu_ioctl(vcpu.vm, vcpu.id, KVM_S390_MEM_OP, ksmo);
+}
+
+static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
+{
+	if (vcpu.id == VM_VCPU_ID)
+		return _vm_ioctl(vcpu.vm, KVM_S390_MEM_OP, ksmo);
+	else
+		return _vcpu_ioctl(vcpu.vm, vcpu.id, KVM_S390_MEM_OP, ksmo);
+}
+
+#define MEMOP(err, vcpu_p, mop_target_p, access_mode_p, buf_p, size_p, ...)	\
+({										\
+	struct test_vcpu __vcpu = (vcpu_p);					\
+	struct mop_desc __desc = {						\
+		.target = (mop_target_p),					\
+		.mode = (access_mode_p),					\
+		.buf = (buf_p),							\
+		.size = (size_p),						\
+		__VA_ARGS__							\
+	};									\
+	struct kvm_s390_mem_op __ksmo;						\
+										\
+	if (__desc._gaddr_v) {							\
+		if (__desc.target == ABSOLUTE)					\
+			__desc.gaddr = addr_gva2gpa(__vcpu.vm, __desc.gaddr_v);	\
+		else								\
+			__desc.gaddr = __desc.gaddr_v;				\
+	}									\
+	__ksmo = ksmo_from_desc(__desc);					\
+	print_memop(__vcpu.id, &__ksmo);					\
+	err##memop_ioctl(__vcpu, &__ksmo);					\
+})
+
+#define MOP(...) MEMOP(, __VA_ARGS__)
+#define ERR_MOP(...) MEMOP(err_, __VA_ARGS__)
+
+#define GADDR(a) .gaddr = ((uintptr_t)a)
+#define GADDR_V(v) ._gaddr_v = 1, .gaddr_v = ((uintptr_t)v)
+#define CHECK_ONLY .f_check = 1
+#define SET_FLAGS(f) ._set_flags = 1, .set_flags = (f)
+#define SIDA_OFFSET(o) ._sida_offset = 1, .sida_offset = (o)
+#define AR(a) ._ar = 1, .ar = (a)
+#define KEY(a) .f_key = 1, .key = (a)
+
 #define VCPU_ID 1
 
 static uint8_t mem1[65536];
@@ -20,6 +202,7 @@ static uint8_t mem2[65536];
 
 struct test_default {
 	struct kvm_vm *kvm_vm;
+	struct test_vcpu vcpu;
 	struct kvm_run *run;
 	int size;
 };
@@ -30,6 +213,7 @@ static struct test_default test_default_init(void *guest_code)
 
 	t.size = min((size_t)kvm_check_cap(KVM_CAP_S390_MEM_OP), sizeof(mem1));
 	t.kvm_vm = vm_create_default(VCPU_ID, 0, guest_code);
+	t.vcpu = (struct test_vcpu) { t.kvm_vm, VCPU_ID };
 	t.run = vcpu_state(t.kvm_vm, VCPU_ID);
 	return t;
 }
@@ -43,20 +227,14 @@ static void guest_copy(void)
 static void test_copy(void)
 {
 	struct test_default t = test_default_init(guest_copy);
-	struct kvm_s390_mem_op ksmo;
 	int i;
 
 	for (i = 0; i < sizeof(mem1); i++)
 		mem1[i] = i * i + i;
 
 	/* Set the first array */
-	ksmo.gaddr = addr_gva2gpa(t.kvm_vm, (uintptr_t)mem1);
-	ksmo.flags = 0;
-	ksmo.size = t.size;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size,
+	    GADDR(addr_gva2gpa(t.kvm_vm, (uintptr_t)mem1)));
 
 	/* Let the guest code copy the first array to the second */
 	vcpu_run(t.kvm_vm, VCPU_ID);
@@ -68,13 +246,7 @@ static void test_copy(void)
 	memset(mem2, 0xaa, sizeof(mem2));
 
 	/* Get the second array */
-	ksmo.gaddr = (uintptr_t)mem2;
-	ksmo.flags = 0;
-	ksmo.size = t.size;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
-	ksmo.buf = (uintptr_t)mem2;
-	ksmo.ar = 0;
-	vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	MOP(t.vcpu, LOGICAL, READ, mem2, t.size, GADDR_V(mem2));
 
 	TEST_ASSERT(!memcmp(mem1, mem2, t.size),
 		    "Memory contents do not match!");
@@ -91,68 +263,31 @@ static void guest_idle(void)
 static void test_errors(void)
 {
 	struct test_default t = test_default_init(guest_idle);
-	struct kvm_s390_mem_op ksmo;
 	int rv;
 
-	/* Check error conditions - first bad size: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = -1;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	/* Bad size: */
+	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, -1, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
 
 	/* Zero size: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = 0;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, 0, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
 		    "ioctl allows 0 as size");
 
 	/* Bad flags: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = -1;
-	ksmo.size = t.size;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1), SET_FLAGS(-1));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
 
 	/* Bad operation: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = t.size;
-	ksmo.op = -1;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, INVALID, WRITE, mem1, t.size, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows bad operations");
 
 	/* Bad guest address: */
-	ksmo.gaddr = ~0xfffUL;
-	ksmo.flags = KVM_S390_MEMOP_F_CHECK_ONLY;
-	ksmo.size = t.size;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR((void *)~0xfffUL), CHECK_ONLY);
 	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
 
 	/* Bad host address: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = t.size;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = 0;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, 0, t.size, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == EFAULT,
 		    "ioctl does not report bad host memory address");
 
@@ -160,29 +295,16 @@ static void test_errors(void)
 	t.run->psw_mask &= ~(3UL << (63 - 17));
 	t.run->psw_mask |= 1UL << (63 - 17);  /* Enable AR mode */
 	vcpu_run(t.kvm_vm, VCPU_ID);              /* To sync new state to SIE block */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = t.size;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 17;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1), AR(17));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows ARs > 15");
 	t.run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
 	vcpu_run(t.kvm_vm, VCPU_ID);                  /* Run to sync new state */
 
 	/* Check that the SIDA calls are rejected for non-protected guests */
-	ksmo.gaddr = 0;
-	ksmo.flags = 0;
-	ksmo.size = 8;
-	ksmo.op = KVM_S390_MEMOP_SIDA_READ;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.sida_offset = 0x1c0;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, SIDA, READ, mem1, 8, GADDR(0), SIDA_OFFSET(0x1c0));
 	TEST_ASSERT(rv == -1 && errno == EINVAL,
 		    "ioctl does not reject SIDA_READ in non-protected mode");
-	ksmo.op = KVM_S390_MEMOP_SIDA_WRITE;
-	rv = _vcpu_ioctl(t.kvm_vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = ERR_MOP(t.vcpu, SIDA, WRITE, mem1, 8, GADDR(0), SIDA_OFFSET(0x1c0));
 	TEST_ASSERT(rv == -1 && errno == EINVAL,
 		    "ioctl does not reject SIDA_WRITE in non-protected mode");
 
-- 
2.35.1

