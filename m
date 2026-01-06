Return-Path: <kvm+bounces-67116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 741BACF7F46
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:05:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 165E430D8FE8
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B100D328260;
	Tue,  6 Jan 2026 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSaE+B0O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC00327C00;
	Tue,  6 Jan 2026 10:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694979; cv=none; b=BsRF+EXhgXdqYwoxMprnhlOGcQ/I5iG3PYozrEbZrDqic1EeZVr6PWupQoOJnrPaUCFrr702JJ5MX9Yar6o0cSuGW4F95Yna6RrInM5vAma86wY68+CnE4LegKyJ5X1iorMAkNAWHeGz/7euTU4HgmGwFmUyVk4vW6G3H7GS+Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694979; c=relaxed/simple;
	bh=zxX1DVIirvSLgAHnUL44AWniee+nugavXFptHQZ63Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txtg/Qsnk/Rj3MjxvBSEHbz2Sa6k7bqAx4RFFryUem9VJXbvHTz6q1crt3bxOpj91RvUFb8diF4MkM4XE2KxHnqcon/ZlSCkbyrMGip4mZusJp3ug7l2mj+J3mAIofdNqWRlMhg7KhKjQA5iob/hIvtDSkAH4a5/fvBvkj51E9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSaE+B0O; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694978; x=1799230978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zxX1DVIirvSLgAHnUL44AWniee+nugavXFptHQZ63Ac=;
  b=SSaE+B0O/Rqb72+0ToNQ4mzV3wsORYA+urVK/PwSrt+mRNRDcd7Ijc3B
   hrsT9ZGbwcw5ahGiSKKzTgXs9iecEQQfEwORSkloBnlbtFWB7n+7qBqbS
   4ulnzDTGyhjoviNEvrjIr9Xm5MTehupur7wMf+TB6+rn4/EZr1ymo9x8m
   owvlf06uOyUgV20eSEoKcK5bOxADLxq4O/diB4neAkiZ0DFpKuV1/PeZs
   sCZ9+NLYXGrlbckM2dzvGCEN4OJaHv9+gp+K0j4l/91O0bNODtFx/BLWL
   KCXy4y6OC1mUiO6e/WUfGzrZBWiLY60SfDBNByabBxJB7PBoKgRLInlDG
   w==;
X-CSE-ConnectionGUID: 2YDCRk8uR7qvThRfxPx/3Q==
X-CSE-MsgGUID: AKz5K+myT7m7INLuXuLKnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80176859"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80176859"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:58 -0800
X-CSE-ConnectionGUID: b5vPav7MS26oI6wqed3aTg==
X-CSE-MsgGUID: 6bgZCcwOSBCtLJTPYmtgRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="203085166"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:51 -0800
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
Subject: [PATCH v3 08/24] KVM: TDX: Enable huge page splitting under write mmu_lock
Date: Tue,  6 Jan 2026 18:20:55 +0800
Message-ID: <20260106102055.25058-1-yan.y.zhao@intel.com>
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

Implement kvm_x86_ops.split_external_spte() under TDX to enable huge page
splitting under write mmu_lock.

Invoke tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs, and
tdh_mem_page_demote() in sequence. All operations are performed under
kvm->mmu_lock held for writing, similar to those in page removal.

Though with kvm->mmu_lock held for writing, tdh_mem_page_demote() may still
contend with tdh_vp_enter() and potentially with the guest's S-EPT entry
operations. Therefore, kick off other vCPUs and prevent tdh_vp_enter()
from being called on them to ensure success on the second attempt. Use
KVM_BUG_ON() for any other unexpected errors.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Rebased on top of Sean's cleanup series.
- Call out UNBLOCK is not required after DEMOTE. (Kai)
- tdx_sept_split_private_spt() --> tdx_sept_split_private_spte().

RFC v2:
- Split out the code to handle the error TDX_INTERRUPTED_RESTARTABLE.
- Rebased to 6.16.0-rc6 (the way of defining TDX hook changes).

RFC v1:
- Split patch for exclusive mmu_lock only,
- Invoke tdx_sept_zap_private_spte() and tdx_track() for splitting.
- Handled busy error of tdh_mem_page_demote() by kicking off vCPUs.
---
 arch/x86/kvm/vmx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 405afd2a56b7..b41793402769 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1914,6 +1914,45 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	tdx_pamt_put(page);
 }
 
+/*
+ * Split a 2MB huge mapping.
+ *
+ * Invoke "BLOCK + TRACK + kick off vCPUs (inside tdx_track())" since DEMOTE
+ * now does not support yet the NON-BLOCKING-RESIZE feature. No UNBLOCK is
+ * needed after a successful DEMOTE.
+ *
+ * Under write mmu_lock, kick off all vCPUs (inside tdh_do_no_vcpus()) to ensure
+ * DEMOTE will succeed on the second invocation if the first invocation returns
+ * BUSY.
+ */
+static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				       u64 old_mirror_spte, void *new_private_spt)
+{
+	struct page *new_sept_page = virt_to_page(new_private_spt);
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+
+	if (KVM_BUG_ON(kvm_tdx->state != TD_STATE_RUNNABLE ||
+		       level != PG_LEVEL_2M, kvm))
+		return -EIO;
+
+	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
+			      tdx_level, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
+		return -EIO;
+
+	tdx_track(kvm);
+
+	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
+			      tdx_level, new_sept_page, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm))
+		return -EIO;
+
+	return 0;
+}
+
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector)
 {
@@ -3672,6 +3711,7 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+	vt_x86_ops.split_external_spte = tdx_sept_split_private_spte;
 	vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
 	vt_x86_ops.alloc_external_fault_cache = tdx_alloc_external_fault_cache;
 	vt_x86_ops.topup_external_fault_cache = tdx_topup_external_fault_cache;
-- 
2.43.2


