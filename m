Return-Path: <kvm+bounces-25821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D33BD96AF10
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02B781F25D56
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F14D58203;
	Wed,  4 Sep 2024 03:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cStDTVrg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EB457C8D;
	Wed,  4 Sep 2024 03:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419682; cv=none; b=bev6kL0ozTxbNMtJqwx1cAURWF3HDQHZ05Ns6zIKo76JsYIF/idv+aACO+/vKlQ307oMsULGxBEHVBs12kz4cOxay2jcijSXPzQfsKJsYeDfCZpN4pUpjNLa8fTbTGGwNlJGMBcoXp56zjAJfiV6hDEZxSv36iC1Asb1x5ZEasQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419682; c=relaxed/simple;
	bh=VWxvMb0bIs/oli9SNRdkD05D1RIi3Y54Xn91m4sVxhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNw/nfwmVAFY2E4ljcnrvWy7JlxYXjhQUmd1zKR9ZGet59y+5aLWG2Z9J2ocdscKvbOd9R+TCbjRD8JNh8VJ5RrTLYMcm2QlIpnwpI9yQcH/SEhW6darYGuaB9mN0aHcLrL1NERGAllEFyFdiWWUY6BguZuEx/feSYAufpwsqe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cStDTVrg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419680; x=1756955680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VWxvMb0bIs/oli9SNRdkD05D1RIi3Y54Xn91m4sVxhU=;
  b=cStDTVrgstKLw0oyqCa+Nx2o4D7KPB5lv9JK+BLQ7ZS/zXkQq35EWpXR
   kguBelMscw7UKP9Udh2FTEEg8/JijQHdPTFZjmZ3budguMjZLcn8OsDii
   8ARwFYp/PiqyPHbEvVxqxmvjujPC/3E4KD63WPysZFZ/FDQ1o27MmsHPl
   vXu6HdScrUvBx2pq7E16kEKKqN3bNEhIkUlj17AWlG/jDR2Hm09J+jtfS
   E/RV+VE7BYSQgyxXyvMAkpC/xj9D632M5AjVvw5JAkxCsDdqNFJeXSuIU
   71uLQHhMMzMWLlKC88NpO7LBqWkD4VL9OKdUAgBOrsjWdghBYpxbubVeT
   g==;
X-CSE-ConnectionGUID: k7h4/RLpRNePFXe4QO75Xw==
X-CSE-MsgGUID: acrjs5I2SgOqB4ftwzqYBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564695"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564695"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
X-CSE-ConnectionGUID: 1imYM/m4SJ+EJS8QtSloVg==
X-CSE-MsgGUID: jzbUD0f1Sl2JAyt0v2ppPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106320"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:08 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Date: Tue,  3 Sep 2024 20:07:43 -0700
Message-Id: <20240904030751.117579-14-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle TLB tracking for TDX by introducing function tdx_track() for private
memory TLB tracking and implementing flush_tlb* hooks to flush TLBs for
shared memory.

Introduce function tdx_track() to do TLB tracking on private memory, which
basically does two things: calling TDH.MEM.TRACK to increase TD epoch and
kicking off all vCPUs. The private EPT will then be flushed when each vCPU
re-enters the TD. This function is unused temporarily in this patch and
will be called on a page-by-page basis on removal of private guest page in
a later patch.

In earlier revisions, tdx_track() relied on an atomic counter to coordinate
the synchronization between the actions of kicking off vCPUs, incrementing
the TD epoch, and the vCPUs waiting for the incremented TD epoch after
being kicked off.

However, the core MMU only actually needs to call tdx_track() while
aleady under a write mmu_lock. So this sychnonization can be made to be
unneeded. vCPUs are kicked off only after the successful execution of
TDH.MEM.TRACK, eliminating the need for vCPUs to wait for TDH.MEM.TRACK
completion after being kicked off. tdx_track() is therefore able to send
requests KVM_REQ_OUTSIDE_GUEST_MODE rather than KVM_REQ_TLB_FLUSH.

Hooks for flush_remote_tlb and flush_remote_tlbs_range are not necessary
for TDX, as tdx_track() will handle TLB tracking of private memory on
page-by-page basis when private guest pages are removed. There is no need
to invoke tdx_track() again in kvm_flush_remote_tlbs() even after changes
to the mirrored page table.

For hooks flush_tlb_current and flush_tlb_all, which are invoked during
kvm_mmu_load() and vcpu load for normal VMs, let VMM to flush all EPTs in
the two hooks for simplicity, since TDX does not depend on the two
hooks to notify TDX module to flush private EPT in those cases.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Split from the big patch "KVM: TDX: TDP MMU TDX support".
 - Modification of synchronization mechanism in tdx_track().
 - Dropped hooks flush_remote_tlb and flush_remote_tlbs_range.
 - Let VMM to flush all EPTs in hooks flush_tlb_all and flush_tlb_current.
 - Dropped KVM_BUG_ON() in vt_flush_tlb_gva(). (Rick)
---
 arch/x86/kvm/vmx/main.c    | 52 ++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     | 55 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 2cc29d0fc279..1c86849680a3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -101,6 +101,50 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
+	 * private EPT will be flushed on the next TD enter.
+	 * No need to call tdx_track() here again even when this callback is as
+	 * a result of zapping private EPT.
+	 * Just invoke invept() directly here to work for both shared EPT and
+	 * private EPT.
+	 */
+	if (is_td_vcpu(vcpu)) {
+		ept_sync_global();
+		return;
+	}
+
+	vmx_flush_tlb_all(vcpu);
+}
+
+static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_flush_tlb_current(vcpu);
+		return;
+	}
+
+	vmx_flush_tlb_current(vcpu);
+}
+
+static void vt_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_flush_tlb_gva(vcpu, addr);
+}
+
+static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_flush_tlb_guest(vcpu);
+}
+
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			int pgd_level)
 {
@@ -190,10 +234,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
-	.flush_tlb_all = vmx_flush_tlb_all,
-	.flush_tlb_current = vmx_flush_tlb_current,
-	.flush_tlb_gva = vmx_flush_tlb_gva,
-	.flush_tlb_guest = vmx_flush_tlb_guest,
+	.flush_tlb_all = vt_flush_tlb_all,
+	.flush_tlb_current = vt_flush_tlb_current,
+	.flush_tlb_gva = vt_flush_tlb_gva,
+	.flush_tlb_guest = vt_flush_tlb_guest,
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
 	.vcpu_run = vmx_vcpu_run,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9da71782660f..6feb3ab96926 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "mmu.h"
 #include "tdx.h"
 #include "tdx_ops.h"
+#include "vmx.h"
 #include "mmu/spte.h"
 
 #undef pr_fmt
@@ -446,6 +447,51 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+/*
+ * Ensure shared and private EPTs to be flushed on all vCPUs.
+ * tdh_mem_track() is the only caller that increases TD epoch. An increase in
+ * the TD epoch (e.g., to value "N + 1") is successful only if no vCPUs are
+ * running in guest mode with the value "N - 1".
+ *
+ * A successful execution of tdh_mem_track() ensures that vCPUs can only run in
+ * guest mode with TD epoch value "N" if no TD exit occurs after the TD epoch
+ * being increased to "N + 1".
+ *
+ * Kicking off all vCPUs after that further results in no vCPUs can run in guest
+ * mode with TD epoch value "N", which unblocks the next tdh_mem_track() (e.g.
+ * to increase TD epoch to "N + 2").
+ *
+ * TDX module will flush EPT on the next TD enter and make vCPUs to run in
+ * guest mode with TD epoch value "N + 1".
+ *
+ * kvm_make_all_cpus_request() guarantees all vCPUs are out of guest mode by
+ * waiting empty IPI handler ack_kick().
+ *
+ * No action is required to the vCPUs being kicked off since the kicking off
+ * occurs certainly after TD epoch increment and before the next
+ * tdh_mem_track().
+ */
+static void __always_unused tdx_track(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+
+	/* If TD isn't finalized, it's before any vcpu running. */
+	if (unlikely(!is_td_finalized(kvm_tdx)))
+		return;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	do {
+		err = tdh_mem_track(kvm_tdx);
+	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
+
+	if (KVM_BUG_ON(err, kvm))
+		pr_tdx_error(TDH_MEM_TRACK, err);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
@@ -947,6 +993,15 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * flush_tlb_current() is used only the first time for the vcpu to run.
+	 * As it isn't performance critical, keep this function simple.
+	 */
+	ept_sync_global();
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index dcf2b36efbb9..28fda93f0b27 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -131,6 +131,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -145,6 +146,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
+static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
-- 
2.34.1


