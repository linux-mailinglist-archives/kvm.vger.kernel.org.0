Return-Path: <kvm+bounces-26774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC1D9775AE
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 01:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A80A1F21955
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 23:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE041C32F9;
	Thu, 12 Sep 2024 23:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V4pAr80e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0D192D89;
	Thu, 12 Sep 2024 23:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726184215; cv=none; b=dlhvs8TZReLOpikFMOM7AbAUE6FKFhksh58hwmMf4KdT8+e1Q+lEk+DfwggNikXmNMs/8Ehxk2/gDtvt05YVsxGCUxPmRGoGJM8E5CDHF3kIL+g+EXZ0FYVMIWnWDv9vRRT3hufh+V2/8PHtr9blx8EuKY1haq0omKXU69S9aNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726184215; c=relaxed/simple;
	bh=wdid401fOcZ79pRICK35R5o0c4yr7gaSFJ7QjTVeZ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=excc25K2tR+qNgYR+xlxh1yHpMbFWfC2uE+708ySGWuberWT6BZDkO3IgLOKw0WXhVYHOgWzy7X1A99boE2mzEW5Hz0jAJBfNQYg/FCO17rF7tTD8me17kiNQwxVfm2NQicVR70jqw1+X/+HrGd50pnAou1Dv0QlOEZ6sdfx1KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V4pAr80e; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726184214; x=1757720214;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wdid401fOcZ79pRICK35R5o0c4yr7gaSFJ7QjTVeZ3w=;
  b=V4pAr80eJQ6eh2KR2eVGflb+B+g/T/IBB5R93Uy0ehhUMeu5iMldkp9p
   eMQ6SF9QvHuupkZHZvDcA4SijgyMnryd0w01VyS0OnxKvTArjbTR+qJ6y
   NmWgGFETYVBNDc9JSqr2PsPQSGmz6vq8aMaMpD/T/ToAD86tIF+lw7yDO
   AtbvxreWLfdnbc2yEhTdWsipmxXymvHh1zRLzNhVuDDRuFYqba92xf0pD
   5lGm/c959dVxzNwX/08cbimwvrf6hI8rI9RLfZlakmoBesyj7B+Mw1XcE
   0Deuf7QsLpGJiD01qGcHZjzGvXJb8hPkZMBc/UvtoNLlmaeG0z01Hj6tB
   w==;
X-CSE-ConnectionGUID: 4rAKlaB+Rx+L3C0Qo7w8Uw==
X-CSE-MsgGUID: bWmh3fmfSy2hXLLav4R+uw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="24612919"
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="24612919"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 16:36:53 -0700
X-CSE-ConnectionGUID: VJYbjJb0QyiRTsHzGdLnPA==
X-CSE-MsgGUID: q/y02pccSUu68gXB4lw6jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="72670883"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 16:36:53 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	sagis@google.com,
	chao.gao@intel.com,
	pbonzini@redhat.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an interesting change
Date: Thu, 12 Sep 2024 16:36:52 -0700
Message-ID: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is for kvm-coco-queue branch.  Please Feel free to squash this
patch to the patch that this fixes.

Call the link_external_spt() hook only when the present bit is changed
from non-present to present. And add debug print of SPTE values.

TDH.MEM.PAGE.AUG() of the TDX backend via set_external_spt() hook fails
unexpectedly with TDX_EPT_ENTRY_STATE_INCORRECT + SPTE PENDING or PRESENT.
When the multiple vCPUs fault in the same GFN simultaneously, the hook is
called many times with some bits changed while both old/new SPTEs have the
present bits.  The leaf SPTE is a complex state machine, and the value can
change with software available bits and hardware bits.  However, the
callback assumes that it's called only when non-present => present leaf
SPTE change.

There are several options:
- Tame the SPTE state machine so that SPTE change won't happen for mirrored
  page table.
  PRO: It's conceptually natural to disable D bit support because mirrored
       page table doesn't support AD bits.
  CON: Not only D bit but also other bits can be modified.
       setting strict kvm_page_table.role.ad_disabled = true doesn't work.
       It requires to change the SPTE more deeply.

- Add a check to the TDP MMU so that it won't call the hook unnecessarily
  PRO: Direct fix.
  CON: Hard code in the TDP MMU when the hook is needed.

- Pass old and new SPTE values to the hooks, add a check to the backend
  PRO: The backend can determine whether the callback is needed.
  CON: The KVM MMU implementation details leak to the backend because
       The SPTE encoding is specific to the KVM MMU implementation.
       And it's subject to change in the future.
       For example, is_shadow_present_pte() needs to be exported from the
       KVM MMU to the backend.

The first choice is out because it doesn't easily handle the problem.  The
second option was chosen over the third choice because the current
interesting change is only non-present => present because we don't support
dirty page tracking by write protect and large page yet by TDX KVM for
now. (TDX supports them.) They're future work for TDX KVM.

Note that we care only about the leaf SPTE because non-leaf doesn't have a
state machine.  See make_nonleaf_spte().

The following is a summary of how the KVM MMU and the TDX behave to help
understanding.

KVM MMU behavior
================
The leaf SPTE state machine is coded in make_spte().  Consider AD bits and
the present bits for simplicity.  The two functionalities and AD bits
support are related in this context.  unsync (manipulate D bit and W bit,
and handle write protect fault) and access tracking (manipulate A bit and
present bit, and hand handle page fault).  (We don't consider dirty page
tracking for now as it's future work of TDX KVM.)

* If AD bit is enabled:
D bit state change for dirty page tracking
On the first EPT violation without prefetch,
- D bits are set.
- Make SPTE writable as TDX supports only RXW (or if write fault).
  (TDX KVM doesn't support write protection at this state. It's future work.)

On the second EPT violation.
- clear D bits if write fault.

A bit change for access tracking
If prefetch:
- clear A bit and clear present bit.

If !prefetch:
- Set A bit and set present bit.

* If AD bit is disabled:
- AD bits aren't set.
- Access tracking is still enabled.  A bit isn't set with only the present
  bits change.

TDX behavior
============
On the first EPT violation:
The SPTE of the mirrored page table is changed from non-present to present.
i.e. is_shadow_present_pte() false => true

If guest memory access causes an EPT violation, the SPTE state changes as
follows.
  FREE => EPT violation: TDH.MEM.PAGE.AUG()
       => PENDING and inject #VE
       => #VE handler issues TDH.MEM.PAGE.ACCEPT()
       => MAPPED

If TD.ATTRIBUTES.SEPT_VE_DISABLE=1, #VE isn't injected. The page remains in
PENDING and it falls in the EPT violation loop until another vCPU accepts
the page.

If TDG.MEM.PAGE.ACCEPT() causes EPT violation, and the SPTE state changes as
follows.
  FREE => EPT violation: TDH.MEM.PAGE.AUG()
       => MAPPED
       => TDG.MEM.PAGE.ACCEPT() success

On the racy second EPT violation, the SPTE was made present.  The page
state can be PENDING or MAPPED.
If PENDING, error = TDX_EPT_ENTRY_STATE_INCORRECT and TDX_SEPT_PENDING
If MAPPED, error = TDX_EPT_ENTRY_STATE_INCORRECT and TDX_SEPT_PRESENT

By checking was_present = false, is_present = true, we can avoid both
cases.

Reported-by: Sagi Shahar <sagis@google.com>
Fixes: 161d4f7c6d80 ("KVM: x86/tdp_mmu: Propagate building mirror page tables")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.h    |  6 ++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a72f0e3bde17..1726f8ec5a50 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -214,6 +214,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  */
 #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
 
+#define EXTERNAL_SPTE_IGNORE_CHANGE_MASK		\
+	(shadow_acc_track_mask |			\
+	 (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<		\
+	  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) |		\
+	 shadow_dirty_mask | shadow_accessed_mask)
+
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 019b43723d90..cfb82ede8982 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -503,8 +503,6 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
 	int ret = 0;
 
-	KVM_BUG_ON(was_present, kvm);
-
 	lockdep_assert_held(&kvm->mmu_lock);
 	/*
 	 * We need to lock out other updates to the SPTE until the external
@@ -519,10 +517,34 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	 * external page table, or leaf.
 	 */
 	if (is_leaf) {
-		ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
+		/*
+		 * SPTE is state machine with software available bits used.
+		 * Check if the change is interesting to the backend.
+		 */
+		if (!was_present)
+			ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
+		else {
+			/*
+			 * The external PTEs don't need updates for some bits,
+			 * but if others are changed, bug the VM.
+			 */
+			if (KVM_BUG_ON(~EXTERNAL_SPTE_IGNORE_CHANGE_MASK &
+				       (old_spte ^ new_spte), kvm)) {
+				ret = -EIO;
+			}
+		}
+
+		/*
+		 * The backend shouldn't return an error except EAGAIN.
+		 * It's hard to debug without those info.
+		 */
+		if (ret && ret != EAGAIN)
+			pr_debug("gfn 0x%llx old_spte 0x%llx new_spte 0x%llx level %d\n",
+				 gfn, old_spte, new_spte, level);
 	} else {
 		void *external_spt = get_external_spt(gfn, new_spte, level);
 
+		KVM_BUG_ON(was_present, kvm);
 		KVM_BUG_ON(!external_spt, kvm);
 		ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
 	}

base-commit: d2c7662a6ea1c325a9ae878b3f1a265264bcd18b
-- 
2.45.2


