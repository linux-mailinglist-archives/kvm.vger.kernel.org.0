Return-Path: <kvm+bounces-67122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BAACF7CBD
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 447FB313F698
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F23331211;
	Tue,  6 Jan 2026 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cjEgxr/u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB4330B3B;
	Tue,  6 Jan 2026 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695054; cv=none; b=FHaW4ETdKNwWVit0SM42rAo0dKVxS20cqLJGmgVj6oJ76gqaOzQjOF6GISQrz2i3iYr5KWdxv6NLmXC4Y8sX0eDZ7EOAlH0MW9vnQ0G/9baRyFoHSYNJ7QL4dK17UOaW/9z9bE0ByOss5bh/Bpvv5x01obKBpJeDbA3JmsdRoiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695054; c=relaxed/simple;
	bh=7p4aGDoalMVzElQ2eJw5W4B2KiyonDkzRB5bPxon/3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM1/HogaUsDxtddC5VGfz8Ye2YCPxCyw3R0qO7g11KXZyRxcfsR/VR1TqM57l8+s9r0vq7gnLoX+A7t/6jzrCMrLXBgid+71FgHvU5Z42LvjoHC4Xl8PyBmHLmEoqHwaUAyIb0dtbnW1C1BO9dLlv9cxkTi13KPh6pxm2dc57qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cjEgxr/u; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695053; x=1799231053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7p4aGDoalMVzElQ2eJw5W4B2KiyonDkzRB5bPxon/3E=;
  b=cjEgxr/utQZ/oqQJTPtBy4Pnvd2PZKhM4/ItKagnyza/YXOkYjCM9KBP
   Ywv1QcFivP/dAfIZERL9L1ru0TQ00SmDnfpg/23bR5gAjm8y7Lzz3Fi/1
   wbGfZKYmHZoQNAzxqgdNA0Q5BhD89wO8IfikIG8Dw7cWZD/YGuqo03AN7
   zz0jZnrMjRx6351N/dgrfr52rwj9RnBVMckspdYQvMTtpndFlN9UkW2Qq
   cMSkY50ro+F1XIPHAn5hxnJj252lSyW4WrKxvhml6zn1IUkam8oSKaQ59
   nqtAhCHIeFxGUhu4OEQgsYBvWQXELwJL5ZeyVabKCu21GQnw+8Ijx35n1
   Q==;
X-CSE-ConnectionGUID: YhwJNKdbQMKTI2b1B7nLvA==
X-CSE-MsgGUID: UX8SxS5SQbScvmsVZiJc7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68257895"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68257895"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:11 -0800
X-CSE-ConnectionGUID: jt86jOuEQoywKPhyMpRMQw==
X-CSE-MsgGUID: zZlpSrEWRa+F76crevGsvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="240111124"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:05 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 13/24] KVM: TDX: Honor the guest's accept level contained in an EPT violation
Date: Tue,  6 Jan 2026 18:22:07 +0800
Message-ID: <20260106102207.25143-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX requires guests to accept S-EPT mappings created by the host KVM. Due
to the current implementation of the TDX module, if a guest accepts a GFN
at a lower level after KVM maps it at a higher level, the TDX module will
emulate an EPT violation VMExit to KVM instead of returning a size mismatch
error to the guest. If KVM fails to perform page splitting in the EPT
violation handler, the guest's ACCEPT operation will be triggered again
upon re-entering the guest, causing a repeated EPT violation VMExit.

The TDX module thus have the EPT violation VMExit carry the guest's accept
level if it's caused by the guest's ACCEPT operation.

Honor the guest's accept level if an EPT violation VMExit contains guest
accept level:

(1) Set the guest inhibit bit in the lpage info to prevent KVM MMU core
    from mapping at a higher level than the guest's accept level.

(2) Split any existing mapping higher than the guest's accept level.

Use write mmu_lock to protect (1) and (2) for now. When the TDX module with
feature NON-BLOCKING-RESIZE is available, splitting can be performed under
shared mmu_lock as no need to worry about the failure of UNBLOCK after the
failure of DEMOTE. Then both (1) and (2) are possible to be done under
shared mmu_lock.

As an optimization, this patch calls hugepage_test_guest_inhibit() without
holding the mmu_lock to reduce the frequency of acquiring the write
mmu_lock. The write mmu_lock is thus only acquired if the guest inhibit bit
is not already set. This is safe because the guest inhibit bit is set in a
one-way manner while the splitting under the write mmu_lock is performed
before setting the guest inhibit bit.

Note: For EPT violation VMExits without the guest's accept level, they are
not caused by the guest's ACCEPT operation, but are instead caused by the
guest's access of memory before it accepts the memory. Since KVM can't
obtain guest accept level info from such EPT violation VMExits (the ACCEPT
operation hasn't occurred yet), KVM may still map at a higher level than
the later guest's accept level.

So, the typical guest/KVM interaction flow is:
- If guest accesses private memory without first accepting it,
  (like non-Linux guests):
  1. Guest accesses a private memory.
  2. KVM finds it can map the GFN at 2MB. So, AUG at 2MB.
  3. Guest accepts the GFN at 4KB.
  4. KVM receives an EPT violation with eeq_type of ACCEPT + 4KB level.
  5. KVM splits the 2MB mapping.
  6. Guest accepts successfully and accesses the page.

- If guest first accepts private memory before accessing it,
  (like Linux guests):
  1. Guest accepts a private memory at 4KB.
  2. KVM receives an EPT violation with eeq_type of ACCEPT + 4KB level.
  3. KVM AUG at 4KB.
  4. Guest accepts successfully and accesses the page.

Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- tdx_check_accept_level() --> tdx_honor_guest_accept_level(). (Binbin)
- Add patch log and code comment to describe the flows for EPT violations
  w/ and w/o accept level better. (Kai)
- Add a comment to descibe why kvm_flush_remote_tlbs() is not needed after
  kvm_split_cross_boundary_leafs(). (Kai).
- Return ret to userspace on error of tdx_honor_guest_accept_level(). (Kai)

RFC v2
- Change tdx_get_accept_level() to tdx_check_accept_level().
- Invoke kvm_split_cross_boundary_leafs() and hugepage_set_guest_inhibit()
  to change KVM mapping level in a global way according to guest accept
  level. (Rick, Sean).

RFC v1:
- Introduce tdx_get_accept_level() to get guest accept level.
- Use tdx->violation_request_level and tdx->violation_gfn* to pass guest
  accept level to tdx_gmem_private_max_mapping_level() to detemine KVM
  mapping level.
---
 arch/x86/kvm/vmx/tdx.c      | 77 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h |  3 ++
 2 files changed, 80 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1e29722abb36..712aaa3d45b7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1983,6 +1983,79 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
 	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
 }
 
+/*
+ * An EPT violation can be either due to the guest's ACCEPT operation or
+ * due to the guest's access of memory before the guest accepts the
+ * memory.
+ *
+ * Type TDX_EXT_EXIT_QUAL_TYPE_ACCEPT in the extended exit qualification
+ * identifies the former case, which must also contain a valid guest
+ * accept level.
+ *
+ * For the former case, honor guest's accept level by setting guest inhibit bit
+ * on levels above the guest accept level and split the existing mapping for the
+ * faulting GFN if it's with a higher level than the guest accept level.
+ *
+ * Do nothing if the EPT violation is due to the latter case. KVM will map the
+ * GFN without considering the guest's accept level (unless the guest inhibit
+ * bit is already set).
+ */
+static inline int tdx_honor_guest_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(vcpu->kvm, gfn);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm *kvm = vcpu->kvm;
+	u64 eeq_type, eeq_info;
+	int level = -1;
+
+	if (!slot)
+		return 0;
+
+	eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
+		return 0;
+
+	eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
+		   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
+
+	level = (eeq_info & GENMASK(2, 0)) + 1;
+
+	if (level == PG_LEVEL_4K || level == PG_LEVEL_2M) {
+		if (!hugepage_test_guest_inhibit(slot, gfn, level + 1)) {
+			gfn_t base_gfn = gfn_round_for_level(gfn, level);
+			struct kvm_gfn_range gfn_range = {
+				.start = base_gfn,
+				.end = base_gfn + KVM_PAGES_PER_HPAGE(level),
+				.slot = slot,
+				.may_block = true,
+				.attr_filter = KVM_FILTER_PRIVATE,
+			};
+
+			scoped_guard(write_lock, &kvm->mmu_lock) {
+				int ret;
+
+				/*
+				 * No kvm_flush_remote_tlbs() is required after
+				 * the split for S-EPT, because the
+				 * "BLOCK + TRACK + kick off vCPUs" sequence in
+				 * tdx_sept_split_private_spte() has guaranteed
+				 * the TLB flush. The hardware also doesn't
+				 * cache stale huge mappings in the fault path.
+				 */
+				ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range,
+								     false);
+				if (ret)
+					return ret;
+
+				hugepage_set_guest_inhibit(slot, gfn, level + 1);
+				if (level == PG_LEVEL_4K)
+					hugepage_set_guest_inhibit(slot, gfn, level + 2);
+			}
+		}
+	}
+	return 0;
+}
+
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
@@ -2008,6 +2081,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
 
+		ret = tdx_honor_guest_accept_level(vcpu, gpa_to_gfn(gpa));
+		if (ret)
+			return ret;
+
 		/* Only private GPA triggers zero-step mitigation */
 		local_retry = true;
 	} else {
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index a30e880849e3..af006a73ee05 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -82,7 +82,10 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
 
 #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
+#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
 #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
+#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
+#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.43.2


