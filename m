Return-Path: <kvm+bounces-70754-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNmsE4lQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70754-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E840611C8EE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E87C7302693B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF73238A9D1;
	Tue, 10 Feb 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VYVhuyP1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6AB38552B;
	Tue, 10 Feb 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737689; cv=none; b=eiTNJ3GW0leDdDlqOWjaRDH9h7t45mR8a7Su0+WaYBocP0vr3ff2wWer2KzVeMb5O1WyjcG6HOxDE2dHAS3kwVl4mmZJXQz+WbxltiVChSc9XOU9IvmcFa08sQtIe/p+bnwPoIvKYSFWhD10EUPPEKHWuNeBgViAqDYZwGO3Scg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737689; c=relaxed/simple;
	bh=0FKee0gUrYotONDV5CkNBgFE/d26S/CF1OyfFS3y398=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6RjFB3oKdTRtCrOvve0qYlUu/GV0b83DMp0OJ8H3j1+Ad+AycPFQFmdGNprJSkHieCP/R6F7Wb5NuNK2F4dybeIxkU64/pBp0Kvt6L7HO7OxuH3hRYMB+kIBgYjGm0YEpH5niV7S3OFqlvq4ntZeJ35weRc+CU3k7jtSrqNVfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VYVhuyP1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A5Qp143475385;
	Tue, 10 Feb 2026 15:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WBiDrVKn5/wM56asW
	CgBhaTaTppAPG8jy24tQg/ouE4=; b=VYVhuyP1T6ZKoLuQERYllzVXhTTWGt6nd
	U7jDz/ZxjJvI0UVkDB1/VV45SeZnhiKZdT7UBA9ubqzJGvPHoLfc6qKUKzozt8h7
	nKdYfVZUjdYsSQj/dQTwBpyTIc89weVM1L1TCfxSpA3TalHRTuNlDQfMuJ1BldOr
	jRAAyib/Ds27kReNCSzCqtBQrsmsEBcET7EBj635zkIc9v6rLbRmBUWqXQqx3GTF
	wdET25C0RDoHnBFZAta4ai40B7IWpuR6ATT9CcCC0i9HJYOrRnCSAPWjzA9LCoyn
	dvR4n/slLwdeCFQyKsV0go3O+wATuwJS0J97swuDFdHF0Wa64VoOA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wtsmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AENCSE008413;
	Tue, 10 Feb 2026 15:34:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y9y4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYZFT52167160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 722DA20040;
	Tue, 10 Feb 2026 15:34:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02A8A20043;
	Tue, 10 Feb 2026 15:34:35 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 30/36] KVM: s390: selftests: Add selftest for the KVM_S390_KEYOP ioctl
Date: Tue, 10 Feb 2026 16:34:11 +0100
Message-ID: <20260210153417.77403-31-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698b5010 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=kO5kFCcFLGMwZ0vRLfsA:9
X-Proofpoint-GUID: Lb7klBaja-m4aeIX-w-ja3Qv9_yW0uj9
X-Proofpoint-ORIG-GUID: Lb7klBaja-m4aeIX-w-ja3Qv9_yW0uj9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX/mrQfap7rdGd
 rycqc6BJ/219pJbvtW7Ird8LO8xDueL2HSHHLNuJ0MLmAJ1bKImwaA0CiWhO+YJL1Rf3vhUk3Vd
 QK2SgNyUgiCNg1uJZqvbzOTALiwsAR8UVrqje1rCXIEvLhjvqWN3soZLJAACW/pK0W6wNFRryKk
 +lsDktYBer1GK/NZJ0pSqCkQtCAUydIB2iioIqP7EFq4HlHHkFos20wp2LjVWox3eE1sE4a8O9X
 tal6e5E1F7RhJNIhzaRFrwyMtIsjXUsG27basg/MiSaGzFvMkVkg6id9Bhy6BC2xtGSM2Vwyo+u
 plqTcer9E/EGbZnT6gzxXtg2rniAGQUd3CI43Qpy89hpw4hSGiZghWkUhE75xuVCstx/x3/VPO1
 ngGQcGbskchY03DZENc4fStEaOwqiZ0dWUDjFYa/Opg4DgvgsthhNs3rVA1Z7DNkFd62aqrpdEy
 GBCzyusyWg1BD8APhgQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70754-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E840611C8EE
X-Rspamd-Action: no action

This test allows to test the various storage key handling functions.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 tools/testing/selftests/kvm/Makefile.kvm |   1 +
 tools/testing/selftests/kvm/s390/keyop.c | 299 +++++++++++++++++++++++
 2 files changed, 300 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390/keyop.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..2e4774666723 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -199,6 +199,7 @@ TEST_GEN_PROGS_s390 += s390/cpumodel_subfuncs_test
 TEST_GEN_PROGS_s390 += s390/shared_zeropage_test
 TEST_GEN_PROGS_s390 += s390/ucontrol_test
 TEST_GEN_PROGS_s390 += s390/user_operexec
+TEST_GEN_PROGS_s390 += s390/keyop
 TEST_GEN_PROGS_s390 += rseq_test
 
 TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
diff --git a/tools/testing/selftests/kvm/s390/keyop.c b/tools/testing/selftests/kvm/s390/keyop.c
new file mode 100644
index 000000000000..c7805e87d12c
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390/keyop.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test for s390x KVM_S390_KEYOP
+ *
+ * Copyright IBM Corp. 2026
+ *
+ * Authors:
+ *  Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include <linux/bits.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "processor.h"
+
+#define BUF_PAGES 128UL
+#define GUEST_PAGES 256UL
+
+#define BUF_START_GFN	(GUEST_PAGES - BUF_PAGES)
+#define BUF_START_ADDR	(BUF_START_GFN << PAGE_SHIFT)
+
+#define KEY_BITS_ACC	0xf0
+#define KEY_BIT_F	0x08
+#define KEY_BIT_R	0x04
+#define KEY_BIT_C	0x02
+
+#define KEY_BITS_RC	(KEY_BIT_R | KEY_BIT_C)
+#define KEY_BITS_ALL	(KEY_BITS_ACC | KEY_BIT_F | KEY_BITS_RC)
+
+static unsigned char tmp[BUF_PAGES];
+static unsigned char old[BUF_PAGES];
+static unsigned char expected[BUF_PAGES];
+
+static int _get_skeys(struct kvm_vcpu *vcpu, unsigned char skeys[])
+{
+	struct kvm_s390_skeys skeys_ioctl = {
+		.start_gfn = BUF_START_GFN,
+		.count = BUF_PAGES,
+		.skeydata_addr = (unsigned long)skeys,
+	};
+
+	return __vm_ioctl(vcpu->vm, KVM_S390_GET_SKEYS, &skeys_ioctl);
+}
+
+static void get_skeys(struct kvm_vcpu *vcpu, unsigned char skeys[])
+{
+	int r = _get_skeys(vcpu, skeys);
+
+	TEST_ASSERT(!r, "Failed to get storage keys, r=%d", r);
+}
+
+static void set_skeys(struct kvm_vcpu *vcpu, unsigned char skeys[])
+{
+	struct kvm_s390_skeys skeys_ioctl = {
+		.start_gfn = BUF_START_GFN,
+		.count = BUF_PAGES,
+		.skeydata_addr = (unsigned long)skeys,
+	};
+	int r;
+
+	r = __vm_ioctl(vcpu->vm, KVM_S390_SET_SKEYS, &skeys_ioctl);
+	TEST_ASSERT(!r, "Failed to set storage keys, r=%d", r);
+}
+
+static int do_keyop(struct kvm_vcpu *vcpu, int op, unsigned long page_idx, unsigned char skey)
+{
+	struct kvm_s390_keyop keyop = {
+		.guest_addr = BUF_START_ADDR + page_idx * PAGE_SIZE,
+		.key = skey,
+		.operation = op,
+	};
+	int r;
+
+	r = __vm_ioctl(vcpu->vm, KVM_S390_KEYOP, &keyop);
+	TEST_ASSERT(!r, "Failed to perform keyop, r=%d", r);
+	TEST_ASSERT((keyop.key & 1) == 0,
+		    "Last bit of key is 1, should be 0! page %lu, new key=%#x, old key=%#x",
+		    page_idx, skey, keyop.key);
+
+	return keyop.key;
+}
+
+static void fault_in_buffer(struct kvm_vcpu *vcpu, int where, int cur_loc)
+{
+	unsigned long i;
+	int r;
+
+	if (where != cur_loc)
+		return;
+
+	for (i = 0; i < BUF_PAGES; i++) {
+		r = ioctl(vcpu->fd, KVM_S390_VCPU_FAULT, BUF_START_ADDR + i * PAGE_SIZE);
+		TEST_ASSERT(!r, "Faulting in buffer page %lu, r=%d", i, r);
+	}
+}
+
+static inline void set_pattern(unsigned char skeys[])
+{
+	int i;
+
+	for (i = 0; i < BUF_PAGES; i++)
+		skeys[i] = i << 1;
+}
+
+static void dump_sk(const unsigned char skeys[], const char *descr)
+{
+	int i, j;
+
+	fprintf(stderr, "# %s:\n", descr);
+	for (i = 0; i < BUF_PAGES; i += 32) {
+		fprintf(stderr, "# %3d: ", i);
+		for (j = 0; j < 32; j++)
+			fprintf(stderr, "%02x ", skeys[i + j]);
+		fprintf(stderr, "\n");
+	}
+}
+
+static inline void compare(const unsigned char what[], const unsigned char expected[],
+			   const char *descr, int fault_in_loc)
+{
+	int i;
+
+	for (i = 0; i < BUF_PAGES; i++) {
+		if (expected[i] != what[i]) {
+			dump_sk(expected, "Expected");
+			dump_sk(what, "Got");
+		}
+		TEST_ASSERT(expected[i] == what[i],
+			    "%s! fault-in location %d, page %d, expected %#x, got %#x",
+			    descr, fault_in_loc, i, expected[i], what[i]);
+	}
+}
+
+static inline void clear_all(void)
+{
+	memset(tmp, 0, BUF_PAGES);
+	memset(old, 0, BUF_PAGES);
+	memset(expected, 0, BUF_PAGES);
+}
+
+static void test_init(struct kvm_vcpu *vcpu, int fault_in)
+{
+	/* Set all storage keys to zero */
+	fault_in_buffer(vcpu, fault_in, 1);
+	set_skeys(vcpu, expected);
+
+	fault_in_buffer(vcpu, fault_in, 2);
+	get_skeys(vcpu, tmp);
+	compare(tmp, expected, "Setting keys not zero", fault_in);
+
+	/* Set storage keys to a sequential pattern */
+	fault_in_buffer(vcpu, fault_in, 3);
+	set_pattern(expected);
+	set_skeys(vcpu, expected);
+
+	fault_in_buffer(vcpu, fault_in, 4);
+	get_skeys(vcpu, tmp);
+	compare(tmp, expected, "Setting storage keys failed", fault_in);
+}
+
+static void test_rrbe(struct kvm_vcpu *vcpu, int fault_in)
+{
+	unsigned char k;
+	int i;
+
+	/* Set storage keys to a sequential pattern */
+	fault_in_buffer(vcpu, fault_in, 1);
+	set_pattern(expected);
+	set_skeys(vcpu, expected);
+
+	/* Call the RRBE KEYOP ioctl on each page and verify the result */
+	fault_in_buffer(vcpu, fault_in, 2);
+	for (i = 0; i < BUF_PAGES; i++) {
+		k = do_keyop(vcpu, KVM_S390_KEYOP_RRBE, i, 0xff);
+		TEST_ASSERT((expected[i] & KEY_BITS_RC) == k,
+			    "Old R or C value mismatch! expected: %#x, got %#x",
+			    expected[i] & KEY_BITS_RC, k);
+		if (i == BUF_PAGES / 2)
+			fault_in_buffer(vcpu, fault_in, 3);
+	}
+
+	for (i = 0; i < BUF_PAGES; i++)
+		expected[i] &= ~KEY_BIT_R;
+
+	/* Verify that only the R bit has been cleared */
+	fault_in_buffer(vcpu, fault_in, 4);
+	get_skeys(vcpu, tmp);
+	compare(tmp, expected, "New value mismatch", fault_in);
+}
+
+static void test_iske(struct kvm_vcpu *vcpu, int fault_in)
+{
+	int i;
+
+	/* Set storage keys to a sequential pattern */
+	fault_in_buffer(vcpu, fault_in, 1);
+	set_pattern(expected);
+	set_skeys(vcpu, expected);
+
+	/* Call the ISKE KEYOP ioctl on each page and verify the result */
+	fault_in_buffer(vcpu, fault_in, 2);
+	for (i = 0; i < BUF_PAGES; i++) {
+		tmp[i] = do_keyop(vcpu, KVM_S390_KEYOP_ISKE, i, 0xff);
+		if (i == BUF_PAGES / 2)
+			fault_in_buffer(vcpu, fault_in, 3);
+	}
+	compare(tmp, expected, "Old value mismatch", fault_in);
+
+	/* Check storage keys have not changed */
+	fault_in_buffer(vcpu, fault_in, 4);
+	get_skeys(vcpu, tmp);
+	compare(tmp, expected, "Storage keys values changed", fault_in);
+}
+
+static void test_sske(struct kvm_vcpu *vcpu, int fault_in)
+{
+	int i;
+
+	/* Set storage keys to a sequential pattern */
+	fault_in_buffer(vcpu, fault_in, 1);
+	set_pattern(tmp);
+	set_skeys(vcpu, tmp);
+
+	/* Call the SSKE KEYOP ioctl on each page and verify the result */
+	fault_in_buffer(vcpu, fault_in, 2);
+	for (i = 0; i < BUF_PAGES; i++) {
+		expected[i] = ~tmp[i] & KEY_BITS_ALL;
+		/* Set the new storage keys to be the bit-inversion of the previous ones */
+		old[i] = do_keyop(vcpu, KVM_S390_KEYOP_SSKE, i, expected[i] | 1);
+		if (i == BUF_PAGES / 2)
+			fault_in_buffer(vcpu, fault_in, 3);
+	}
+	compare(old, tmp, "Old value mismatch", fault_in);
+
+	/* Verify that the storage keys have been set correctly */
+	fault_in_buffer(vcpu, fault_in, 4);
+	get_skeys(vcpu, tmp);
+	compare(tmp, expected, "New value mismatch", fault_in);
+}
+
+static struct testdef {
+	const char *name;
+	void (*test)(struct kvm_vcpu *vcpu, int fault_in_location);
+	int n_fault_in_locations;
+} testplan[] = {
+	{ "Initialization", test_init, 5 },
+	{ "RRBE", test_rrbe, 5 },
+	{ "ISKE", test_iske, 5 },
+	{ "SSKE", test_sske, 5 },
+};
+
+static void run_test(void (*the_test)(struct kvm_vcpu *, int), int fault_in_location)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int r;
+
+	vm = vm_create_barebones();
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, GUEST_PAGES, 0);
+	vcpu = __vm_vcpu_add(vm, 0);
+
+	r = _get_skeys(vcpu, tmp);
+	TEST_ASSERT(r == KVM_S390_GET_SKEYS_NONE,
+		    "Storage keys are not disabled initially, r=%d", r);
+
+	clear_all();
+
+	the_test(vcpu, fault_in_location);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	int i, f;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_KEYOP));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_UCONTROL));
+
+	ksft_print_header();
+	for (i = 0, f = 0; i < ARRAY_SIZE(testplan); i++)
+		f += testplan[i].n_fault_in_locations;
+	ksft_set_plan(f);
+
+	for (i = 0; i < ARRAY_SIZE(testplan); i++) {
+		for (f = 0; f < testplan[i].n_fault_in_locations; f++) {
+			run_test(testplan[i].test, f);
+			ksft_test_result_pass("%s (fault-in location %d)\n", testplan[i].name, f);
+		}
+	}
+
+	ksft_finished();	/* Print results and exit() accordingly */
+}
-- 
2.53.0


