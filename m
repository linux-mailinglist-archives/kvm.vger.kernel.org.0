Return-Path: <kvm+bounces-67121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A67B0CF7CB4
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6795930A4EE3
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF3A325723;
	Tue,  6 Jan 2026 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eGUcRATV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A83532F749;
	Tue,  6 Jan 2026 10:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695037; cv=none; b=VpK4fcDP0CwNymZ6HCaV4qc5A84olfxxZMJL296dtkGs2YWSzMabNCzs/rOxbfro4jnTgQAkgI2ja4ZM10hd8zONCv9ZjFjbFC84x7tyc/gdxRvmDrddGXQ8s0fXm1fbrrBieerofxx67NO5OozVLb4Mt9mctdo3jHX2+KHtcXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695037; c=relaxed/simple;
	bh=C4M7RSRYEuSHh59yYwRTI2YQscvta/YplpTRjhoDSAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWL/wBk+RetW+Mwz4+8bSxt5+IAEHMpWevEPSWznfqcU8L7fpge+Ve3bo/mOxefET05Mcbt6gy3FLd+wnS7qZRvHKes0Kj3V4YZ4PFpnyWN5669g3xTgmvABaBGSgzSNKHGwvKNIHjJ5CCvrdnsZv//1Dg2gK/RDk0/wV1YADes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eGUcRATV; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695035; x=1799231035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C4M7RSRYEuSHh59yYwRTI2YQscvta/YplpTRjhoDSAI=;
  b=eGUcRATVMCGyWbSxDBuAtGI9Tw/g1vue/wSothnnFQ/Hyf7ZrBuFHdlb
   /wXX1duP8wvGFtEoMVPoAvV4HkYtGb7irANa3DWJJxv/1aqTnpymsC60x
   PEd1+r/Vx2XCGV0N9u71lZbMeHKbIC7po2Lr60llZYd15iqvDWl/NZ0WL
   yIV6NQV/WyD3isuGZSNYsJmqzuBQieJSXVKLgkanh+T3er24w/pgY3yvF
   8XgjvcsyFZSp4dWeb7PvwcO3ETyRQgPpZQ9e6GkaltA6e2ZWUYIYP60cJ
   bam3tjSjY6OvWrAjTQvd2pt4DJSzWalSiSImRQjx1NxTffXhIGcbJ2Nl6
   w==;
X-CSE-ConnectionGUID: blLFSnQPSL6IpcmhH7DoSA==
X-CSE-MsgGUID: DRYMc/VoTDuIWcpPQ20wuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68257879"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68257879"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:55 -0800
X-CSE-ConnectionGUID: Yfs1q9+hSIm5UwVMmYkzZQ==
X-CSE-MsgGUID: rEM7+xFlSe2JGTIJHnLTgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="240111081"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:49 -0800
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
Subject: [PATCH v3 12/24] KVM: x86: Introduce hugepage_set_guest_inhibit()
Date: Tue,  6 Jan 2026 18:21:51 +0800
Message-ID: <20260106102151.25125-1-yan.y.zhao@intel.com>
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
error to the guest. If KVM fails to perform page splitting in the VMExit
handler, the guest's accept operation will be triggered again upon
re-entering the guest, causing a repeated EPT violation VMExit.

To facilitate passing the guest's accept level information to the KVM MMU
core and to prevent the repeated mapping of a GFN at different levels due
to different accept levels specified by different vCPUs, introduce the
interface hugepage_set_guest_inhibit(). This interface specifies across
vCPUs that mapping at a certain level is inhibited from the guest.

The KVM_LPAGE_GUEST_INHIBIT_FLAG bit is currently modified in one
direction (set), so no unset interface is provided.

Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com/ [1]
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Use EXPORT_SYMBOL_FOR_KVM_INTERNAL().

RFC v2:
- new in RFC v2
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 830f46145692..f97bedff5c4c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -322,4 +322,7 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn & kvm_gfn_direct_bits(kvm);
 }
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f40af7ac75b3..029f2f272ffc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -714,12 +714,14 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
 }
 
 /*
- * The most significant bit in disallow_lpage tracks whether or not memory
- * attributes are mixed, i.e. not identical for all gfns at the current level.
+ * The most 2 significant bits in disallow_lpage tracks whether or not memory
+ * attributes are mixed, i.e. not identical for all gfns at the current level,
+ * or whether or not guest inhibits the current level of hugepage at the gfn.
  * The lower order bits are used to refcount other cases where a hugepage is
  * disallowed, e.g. if KVM has shadow a page table at the gfn.
  */
 #define KVM_LPAGE_MIXED_FLAG	BIT(31)
+#define KVM_LPAGE_GUEST_INHIBIT_FLAG   BIT(30)
 
 static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 					    gfn_t gfn, int count)
@@ -732,7 +734,8 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 
 		old = linfo->disallow_lpage;
 		linfo->disallow_lpage += count;
-		WARN_ON_ONCE((old ^ linfo->disallow_lpage) & KVM_LPAGE_MIXED_FLAG);
+		WARN_ON_ONCE((old ^ linfo->disallow_lpage) &
+			     (KVM_LPAGE_MIXED_FLAG | KVM_LPAGE_GUEST_INHIBIT_FLAG));
 	}
 }
 
@@ -1644,6 +1647,18 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
+bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(hugepage_test_guest_inhibit);
+
+void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_GUEST_INHIBIT_FLAG;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(hugepage_set_guest_inhibit);
+
 /*
  * Split large leafs crossing the boundary of the specified range.
  * Only support TDP MMU. Do nothing if !tdp_mmu_enabled.
-- 
2.43.2


