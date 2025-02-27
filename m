Return-Path: <kvm+bounces-39441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C03C5A470D3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9E927A95B9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB4314F9F4;
	Thu, 27 Feb 2025 01:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wy2zMwuI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE1422F01;
	Thu, 27 Feb 2025 01:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619141; cv=none; b=qC81KS+wOaotP2jPaeMGYEb55SOYGndy+ZYnhuCDcxOMUXMUP/8FA6UY3smtPq94VS2SkouWJHBBIAkPYuFhwOU8+RaErQ004nNnYBOcCbvJcPSknr+3KXwI/tgxQobgTtWFaETkyoHOxsusRfKSI3KURGiBNL/xaFl84+Deq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619141; c=relaxed/simple;
	bh=DmK8LRAGl5CcObJpm47+U2I+JjTgigBYqYk/CcW5jq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVGOfFN/phTb8ImFQtvq+HBCc3V8vtEeXE/0AYtUwXP3IPL4AT3lN6MV/JFngrdOhVMcxGrR+jq319X5dHYwU5Kay0IFQTaoHro5uR+utQLu8K8tAU7j9AFOey7RHswPTHEp68+WsLY0y4DRFCpxD33GN8C4pAab7tZRfQOnIe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wy2zMwuI; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619139; x=1772155139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DmK8LRAGl5CcObJpm47+U2I+JjTgigBYqYk/CcW5jq0=;
  b=Wy2zMwuIYkoX7P/6lxwbCp6DzNVLCwqlmA3aEmQsfHwti4WPC1n9+L2y
   Crrmo+IIbrZGWI7jQB+/ccCMTLCSSUxW0LZsj/tnC4m4oNVihubDxbZXc
   +cQe0PD7RR3Cq1/WYGG/fgb+eFF0JuYGOnjfYbFYiZqWfmMZKPl/ak9uD
   jFE4ZD3LnAt4cSu4eM4PN/Wqb9T7nfydP4EasqxFhcwe8e2oAyF/75pja
   tFLU/9bUOrIcxQ61TibAmVLuZoktzHQ5Ptq4aVTcZ73Pwq5YkRZjxwybg
   B1I9LBKMzrBN1Wyef5Ieiw5k4nrC/ytUxnebyHzrRSTy4T/+eWFFLCXpK
   w==;
X-CSE-ConnectionGUID: ZIiosn3LTs+mc5GAAlNdIw==
X-CSE-MsgGUID: h6nPWl5hSoKZGIONPm0w8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959598"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959598"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:59 -0800
X-CSE-ConnectionGUID: jvspfqGaTo21I7sy2NgkcA==
X-CSE-MsgGUID: c8rykWehTv+q2chbFli9SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674839"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:18:55 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 03/20] KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY
Date: Thu, 27 Feb 2025 09:20:04 +0800
Message-ID: <20250227012021.1778144-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

Retry locally in the TDX EPT violation handler for private memory to reduce
the chances for tdh_mem_sept_add()/tdh_mem_page_aug() to contend with
tdh_vp_enter().

TDX EPT violation installs private pages via tdh_mem_sept_add() and
tdh_mem_page_aug(). The two may have contention with tdh_vp_enter() or
TDCALLs.

Resources    SHARED  users      EXCLUSIVE users
------------------------------------------------------------
SEPT tree  tdh_mem_sept_add     tdh_vp_enter(0-step mitigation)
           tdh_mem_page_aug
------------------------------------------------------------
SEPT entry                      tdh_mem_sept_add (Host lock)
                                tdh_mem_page_aug (Host lock)
                                tdg_mem_page_accept (Guest lock)
                                tdg_mem_page_attr_rd (Guest lock)
                                tdg_mem_page_attr_wr (Guest lock)

Though the contention between tdh_mem_sept_add()/tdh_mem_page_aug() and
TDCALLs may be removed in future TDX module, their contention with
tdh_vp_enter() due to 0-step mitigation still persists.

The TDX module may trigger 0-step mitigation in SEAMCALL TDH.VP.ENTER,
which works as follows:
0. Each TDH.VP.ENTER records the guest RIP on TD entry.
1. When the TDX module encounters a VM exit with reason EPT_VIOLATION, it
   checks if the guest RIP is the same as last guest RIP on TD entry.
   -if yes, it means the EPT violation is caused by the same instruction
            that caused the last VM exit.
            Then, the TDX module increases the guest RIP no-progress count.
            When the count increases from 0 to the threshold (currently 6),
            the TDX module records the faulting GPA into a
            last_epf_gpa_list.
   -if no,  it means the guest RIP has made progress.
            So, the TDX module resets the RIP no-progress count and the
            last_epf_gpa_list.
2. On the next TDH.VP.ENTER, the TDX module (after saving the guest RIP on
   TD entry) checks if the last_epf_gpa_list is empty.
   -if yes, TD entry continues without acquiring the lock on the SEPT tree.
   -if no,  it triggers the 0-step mitigation by acquiring the exclusive
            lock on SEPT tree, walking the EPT tree to check if all page
            faults caused by the GPAs in the last_epf_gpa_list have been
            resolved before continuing TD entry.

Since KVM TDP MMU usually re-enters guest whenever it exits to userspace
(e.g. for KVM_EXIT_MEMORY_FAULT) or encounters a BUSY, it is possible for a
tdh_vp_enter() to be called more than the threshold count before a page
fault is addressed, triggering contention when tdh_vp_enter() attempts to
acquire exclusive lock on SEPT tree.

Retry locally in TDX EPT violation handler to reduce the count of invoking
tdh_vp_enter(), hence reducing the possibility of its contention with
tdh_mem_sept_add()/tdh_mem_page_aug(). However, the 0-step mitigation and
the contention are still not eliminated due to KVM_EXIT_MEMORY_FAULT,
signals/interrupts, and cases when one instruction faults more GFNs than
the threshold count.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
Changes from "KVM: TDX SEPT SEAMCALL retry" series [1]
- Use kvm_vcpu_has_events() to replace "pi_has_pending_interrupt(vcpu) ||
  kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)" [2].
  (Sean)
- Update code comment to explain why break out for false positive of
  interrupt injection is fine (Sean).

[1]: https://lore.kernel.org/all/20250113021218.18922-1-yan.y.zhao@intel.com
[2]: https://lore.kernel.org/all/Z4rIGv4E7Jdmhl8P@google.com
---
 arch/x86/kvm/vmx/tdx.c | 57 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b8701e343e80..6fa6f7e13e15 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1698,6 +1698,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
 	gpa_t gpa = to_tdx(vcpu)->exit_gpa;
+	bool local_retry = false;
+	int ret;
 
 	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
 		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
@@ -1716,6 +1718,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 * due to aliasing a single HPA to multiple GPAs.
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
+
+		/* Only private GPA triggers zero-step mitigation */
+		local_retry = true;
 	} else {
 		exit_qual = vmx_get_exit_qual(vcpu);
 		/*
@@ -1728,7 +1733,57 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_page_fault(vcpu, gpa, exit_qual);
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
+
+	/*
+	 * To minimize TDH.VP.ENTER invocations, retry locally for private GPA
+	 * mapping in TDX.
+	 *
+	 * KVM may return RET_PF_RETRY for private GPA due to
+	 * - contentions when atomically updating SPTEs of the mirror page table
+	 * - in-progress GFN invalidation or memslot removal.
+	 * - TDX_OPERAND_BUSY error from TDH.MEM.PAGE.AUG or TDH.MEM.SEPT.ADD,
+	 *   caused by contentions with TDH.VP.ENTER (with zero-step mitigation)
+	 *   or certain TDCALLs.
+	 *
+	 * If TDH.VP.ENTER is invoked more times than the threshold set by the
+	 * TDX module before KVM resolves the private GPA mapping, the TDX
+	 * module will activate zero-step mitigation during TDH.VP.ENTER. This
+	 * process acquires an SEPT tree lock in the TDX module, leading to
+	 * further contentions with TDH.MEM.PAGE.AUG or TDH.MEM.SEPT.ADD
+	 * operations on other vCPUs.
+	 *
+	 * Breaking out of local retries for kvm_vcpu_has_events() is for
+	 * interrupt injection. kvm_vcpu_has_events() should not see pending
+	 * events for TDX. Since KVM can't determine if IRQs (or NMIs) are
+	 * blocked by TDs, false positives are inevitable i.e., KVM may re-enter
+	 * the guest even if the IRQ/NMI can't be delivered.
+	 *
+	 * Note: even without breaking out of local retries, zero-step
+	 * mitigation may still occur due to
+	 * - invoking of TDH.VP.ENTER after KVM_EXIT_MEMORY_FAULT,
+	 * - a single RIP causing EPT violations for more GFNs than the
+	 *   threshold count.
+	 * This is safe, as triggering zero-step mitigation only introduces
+	 * contentions to page installation SEAMCALLs on other vCPUs, which will
+	 * handle retries locally in their EPT violation handlers.
+	 */
+	while (1) {
+		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
+
+		if (ret != RET_PF_RETRY || !local_retry)
+			break;
+
+		if (kvm_vcpu_has_events(vcpu) || signal_pending(current))
+			break;
+
+		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
+			ret = -EIO;
+			break;
+		}
+
+		cond_resched();
+	}
+	return ret;
 }
 
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
-- 
2.46.0


