Return-Path: <kvm+bounces-70747-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIP4LF1Qi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70747-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 958F411C89F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2598A301F927
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5940E38A707;
	Tue, 10 Feb 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Wx1Z3JX0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224B53876DE;
	Tue, 10 Feb 2026 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737680; cv=none; b=nIBGTQ3aAKX0K+QKxW1H+MzHYn2vQ/n0fWzrSNlza1KMiSNqUoFieTqZ4uGwFpGkYgKfRbv7/7gIAIQwaPFgdvodQ39x2Mt3SY6ZMQtzBVtp/EeBuerDTEbfweQ5Y4u6oficcOkp1nt3aoXkCw+otwoymNzigkoD44jGjNgkysE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737680; c=relaxed/simple;
	bh=ZmAipqxvYyyn578iKEB4LWWr/PWfyN68JYYxfMY3yus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lE3cAXR7/MiAsnIrjQSzyDfBM8wJV1KzZi9bmg8CJrmh9c58iZ0Y5O1fOLIZMZ+yyW1f+pUpv5DkFgb/pgzkFsOa1jVMjkLpAXAq/A2ja+urHDsW3G6wWDBFxVR3SqQ5tPovKQ/7TRmrdiUqja2chZM5axkTLI/aa5iplSh2CQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Wx1Z3JX0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AA7Fe1328612;
	Tue, 10 Feb 2026 15:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SZbEVlq69fDI7/5Do
	JAOs7ZPvdLERTpKjq8NfbShuTY=; b=Wx1Z3JX0m3OdNbmo8HifZJ+LS5j1t3608
	jPr8FO/azq1SD8z5SepeAfTgFFGFWrxx5NBDRcDuoKRuZxVMXpKAcAVp0oH8TbbA
	GPDU8P5rsCKywATvlboM5oygx7Phpd9e7x7Jzv7BtuvUaenq7dAX1t3ZO6K9taOR
	2v9hppznmVNbActg19Ylx8SSOMUf28VOwAPuPGCEyLmQj/mGcrdJbD3IfPoaTIb1
	5Trp+zjkj9NEws5dM18XiQHyw16c4+fJka4E2psnrtO6RVJstoDwwm6slGqtW8Ob
	5RJ0GvlbbRIXETZ37gESWrrDIF9sqz+jSU6cjoaxLi7T4Mh/6OhDQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uts1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEbFaR001499;
	Tue, 10 Feb 2026 15:34:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1vf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYUdA47645140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 234F720040;
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A77D32004B;
	Tue, 10 Feb 2026 15:34:29 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:29 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 21/36] KVM: s390: Add helper functions for fault handling
Date: Tue, 10 Feb 2026 16:34:02 +0100
Message-ID: <20260210153417.77403-22-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXzFMR4gHj3gSL
 KgcCEul9r8pp6Qlyj0MsviqkTUBO+aEtcb5fLzMQpkRavMmdwLTl7oRLySJu18P4gJBvSPrvEja
 shpWCIoH7vqDQUMVqrlNpA0s4LXANZbHVqY+b29glJWqVUpiFNs4LkEtCaHUhQww7625twq4Do3
 ByyPiCWtB7mFVo9tRtJs+EEC9l0HcH78ATZKioDI1lo97YO4Dz46qrXjM2Xx/ssY7OG7lzKnw9L
 8U9XJQxbz9GKyYDwzPdcY8n8zDv7jMcfuwUL2S2OctQqkjLnRCxSXhVeaTsBS3VNaSQsO6cjLhx
 vYV0eHzX4NnxXQCTc9/fnXrUP3yAdjLxqOejc590nwPvrHdBAY9Z+TF+GksnU66yw+H4wjxASg3
 c3jsouzFywrXlZBh7shVVTEsuqXUahtyW718+0FZ1YkMB9KiP0UoNcH1f7H1TfZp7KN1bHfruaP
 hJh9fjeO8Y/QB1znc2w==
X-Proofpoint-ORIG-GUID: vjwIEK9HEj9P36ShjwhFYKkvoh4Q98gM
X-Proofpoint-GUID: vjwIEK9HEj9P36ShjwhFYKkvoh4Q98gM
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698b500a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=5alz5MtixxWFdSgp2hYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-70747-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 958F411C89F
X-Rspamd-Action: no action

Add some helper functions for handling multiple guest faults at the
same time.

This will be needed for VSIE, where a nested guest access also needs to
access all the page tables that map it.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   1 +
 arch/s390/kvm/Makefile           |   2 +-
 arch/s390/kvm/faultin.c          | 148 +++++++++++++++++++++++++++++++
 arch/s390/kvm/faultin.h          |  92 +++++++++++++++++++
 arch/s390/kvm/kvm-s390.c         |   2 +-
 arch/s390/kvm/kvm-s390.h         |   2 +
 6 files changed, 245 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/kvm/faultin.c
 create mode 100644 arch/s390/kvm/faultin.h

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 6ba99870fc32..816776a8a8e3 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -442,6 +442,7 @@ struct kvm_vcpu_arch {
 	bool acrs_loaded;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
+	void *mc; /* Placeholder */
 };
 
 struct kvm_vm_stat {
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 21088265402c..1e2dcd3e2436 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,7 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
-kvm-y += dat.o gmap.o
+kvm-y += dat.o gmap.o faultin.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/faultin.c b/arch/s390/kvm/faultin.c
new file mode 100644
index 000000000000..e37cd18200f5
--- /dev/null
+++ b/arch/s390/kvm/faultin.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  KVM guest fault handling.
+ *
+ *    Copyright IBM Corp. 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+
+#include "gmap.h"
+#include "trace.h"
+#include "faultin.h"
+
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu);
+
+/*
+ * kvm_s390_faultin_gfn() - handle a dat fault.
+ * @vcpu: The vCPU whose gmap is to be fixed up, or NULL if operating on the VM.
+ * @kvm: The VM whose gmap is to be fixed up, or NULL if operating on a vCPU.
+ * @f: The guest fault that needs to be resolved.
+ *
+ * Return:
+ * * 0 on success
+ * * < 0 in case of error
+ * * > 0 in case of guest exceptions
+ *
+ * Context:
+ * * The mm lock must not be held before calling
+ * * kvm->srcu must be held
+ * * may sleep
+ */
+int kvm_s390_faultin_gfn(struct kvm_vcpu *vcpu, struct kvm *kvm, struct guest_fault *f)
+{
+	struct kvm_s390_mmu_cache *local_mc __free(kvm_s390_mmu_cache) = NULL;
+	struct kvm_s390_mmu_cache *mc = NULL;
+	struct kvm_memory_slot *slot;
+	unsigned long inv_seq;
+	int foll, rc = 0;
+
+	foll = f->write_attempt ? FOLL_WRITE : 0;
+	foll |= f->attempt_pfault ? FOLL_NOWAIT : 0;
+
+	if (vcpu) {
+		kvm = vcpu->kvm;
+		mc = vcpu->arch.mc;
+	}
+
+	lockdep_assert_held(&kvm->srcu);
+
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (gmap_try_fixup_minor(kvm->arch.gmap, f) == 0)
+			return 0;
+	}
+
+	while (1) {
+		f->valid = false;
+		inv_seq = kvm->mmu_invalidate_seq;
+		/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+		smp_rmb();
+
+		if (vcpu)
+			slot = kvm_vcpu_gfn_to_memslot(vcpu, f->gfn);
+		else
+			slot = gfn_to_memslot(kvm, f->gfn);
+		f->pfn = __kvm_faultin_pfn(slot, f->gfn, foll, &f->writable, &f->page);
+
+		/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT). */
+		if (f->pfn == KVM_PFN_ERR_NEEDS_IO) {
+			if (unlikely(!f->attempt_pfault))
+				return -EAGAIN;
+			if (unlikely(!vcpu))
+				return -EINVAL;
+			trace_kvm_s390_major_guest_pfault(vcpu);
+			if (kvm_arch_setup_async_pf(vcpu))
+				return 0;
+			vcpu->stat.pfault_sync++;
+			/* Could not setup async pfault, try again synchronously. */
+			foll &= ~FOLL_NOWAIT;
+			f->pfn = __kvm_faultin_pfn(slot, f->gfn, foll, &f->writable, &f->page);
+		}
+
+		/* Access outside memory, addressing exception. */
+		if (is_noslot_pfn(f->pfn))
+			return PGM_ADDRESSING;
+		/* Signal pending: try again. */
+		if (f->pfn == KVM_PFN_ERR_SIGPENDING)
+			return -EAGAIN;
+		/* Check if it's read-only memory; don't try to actually handle that case. */
+		if (f->pfn == KVM_PFN_ERR_RO_FAULT)
+			return -EOPNOTSUPP;
+		/* Any other error. */
+		if (is_error_pfn(f->pfn))
+			return -EFAULT;
+
+		if (!mc) {
+			local_mc = kvm_s390_new_mmu_cache();
+			if (!local_mc)
+				return -ENOMEM;
+			mc = local_mc;
+		}
+
+		/* Loop, will automatically release the faulted page. */
+		if (mmu_invalidate_retry_gfn_unsafe(kvm, inv_seq, f->gfn)) {
+			kvm_release_faultin_page(kvm, f->page, true, false);
+			continue;
+		}
+
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			if (!mmu_invalidate_retry_gfn(kvm, inv_seq, f->gfn)) {
+				f->valid = true;
+				rc = gmap_link(mc, kvm->arch.gmap, f);
+				kvm_release_faultin_page(kvm, f->page, !!rc, f->write_attempt);
+				f->page = NULL;
+			}
+		}
+		kvm_release_faultin_page(kvm, f->page, true, false);
+
+		if (rc == -ENOMEM) {
+			rc = kvm_s390_mmu_cache_topup(mc);
+			if (rc)
+				return rc;
+		} else if (rc != -EAGAIN) {
+			return rc;
+		}
+	}
+}
+
+int kvm_s390_get_guest_page(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool w)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	int foll = w ? FOLL_WRITE : 0;
+
+	f->write_attempt = w;
+	f->gfn = gfn;
+	f->pfn = __kvm_faultin_pfn(slot, gfn, foll, &f->writable, &f->page);
+	if (is_noslot_pfn(f->pfn))
+		return PGM_ADDRESSING;
+	if (is_sigpending_pfn(f->pfn))
+		return -EINTR;
+	if (f->pfn == KVM_PFN_ERR_NEEDS_IO)
+		return -EAGAIN;
+	if (is_error_pfn(f->pfn))
+		return -EFAULT;
+
+	f->valid = true;
+	return 0;
+}
diff --git a/arch/s390/kvm/faultin.h b/arch/s390/kvm/faultin.h
new file mode 100644
index 000000000000..f86176d2769c
--- /dev/null
+++ b/arch/s390/kvm/faultin.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest fault handling.
+ *
+ *    Copyright IBM Corp. 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef __KVM_S390_FAULTIN_H
+#define __KVM_S390_FAULTIN_H
+
+#include <linux/kvm_host.h>
+
+#include "dat.h"
+
+int kvm_s390_faultin_gfn(struct kvm_vcpu *vcpu, struct kvm *kvm, struct guest_fault *f);
+int kvm_s390_get_guest_page(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool w);
+
+static inline int kvm_s390_faultin_gfn_simple(struct kvm_vcpu *vcpu, struct kvm *kvm,
+					      gfn_t gfn, bool wr)
+{
+	struct guest_fault f = { .gfn = gfn, .write_attempt = wr, };
+
+	return kvm_s390_faultin_gfn(vcpu, kvm, &f);
+}
+
+static inline int kvm_s390_get_guest_page_and_read_gpa(struct kvm *kvm, struct guest_fault *f,
+						       gpa_t gaddr, unsigned long *val)
+{
+	int rc;
+
+	rc = kvm_s390_get_guest_page(kvm, f, gpa_to_gfn(gaddr), false);
+	if (rc)
+		return rc;
+
+	*val = *(unsigned long *)phys_to_virt(pfn_to_phys(f->pfn) | offset_in_page(gaddr));
+
+	return 0;
+}
+
+static inline void kvm_s390_release_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
+					     int n, bool ignore)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		kvm_release_faultin_page(kvm, guest_faults[i].page, ignore,
+					 guest_faults[i].write_attempt);
+		guest_faults[i].page = NULL;
+	}
+}
+
+static inline bool kvm_s390_multiple_faults_need_retry(struct kvm *kvm, unsigned long seq,
+						       struct guest_fault *guest_faults, int n,
+						       bool unsafe)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		if (!guest_faults[i].valid)
+			continue;
+		if (unsafe && mmu_invalidate_retry_gfn_unsafe(kvm, seq, guest_faults[i].gfn))
+			return true;
+		if (!unsafe && mmu_invalidate_retry_gfn(kvm, seq, guest_faults[i].gfn))
+			return true;
+	}
+	return false;
+}
+
+static inline int kvm_s390_get_guest_pages(struct kvm *kvm, struct guest_fault *guest_faults,
+					   gfn_t start, int n_pages, bool write_attempt)
+{
+	int i, rc;
+
+	for (i = 0; i < n_pages; i++) {
+		rc = kvm_s390_get_guest_page(kvm, guest_faults + i, start + i, write_attempt);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+#define kvm_s390_release_faultin_array(kvm, array, ignore) \
+	kvm_s390_release_multiple(kvm, array, ARRAY_SIZE(array), ignore)
+
+#define kvm_s390_array_needs_retry_unsafe(kvm, seq, array) \
+	kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), true)
+
+#define kvm_s390_array_needs_retry_safe(kvm, seq, array) \
+	kvm_s390_multiple_faults_need_retry(kvm, seq, array, ARRAY_SIZE(array), false)
+
+#endif /* __KVM_S390_FAULTIN_H */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ec92e6361eab..2b5ecdc3814e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4637,7 +4637,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
 {
 	hva_t hva;
 	struct kvm_arch_async_pf arch;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 65c950760993..9ce71c8433a1 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -470,6 +470,8 @@ static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr,
 	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
 }
 
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu);
+
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
 
-- 
2.53.0


