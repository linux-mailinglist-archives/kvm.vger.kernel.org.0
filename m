Return-Path: <kvm+bounces-25825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0952996AF1A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB7B62823DC
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B1D13D880;
	Wed,  4 Sep 2024 03:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8VpK2Dy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2753513AA4C;
	Wed,  4 Sep 2024 03:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419685; cv=none; b=L18ctWD8vEoIQ1uN5rxwbOGNGX7vyYGOBy2C/INveHakGwHsm5+XdO3Kkg2CmC1CWBA44wWsr30pM/ypebu0TWmbtwZ0n8yGUAyyKoFqL1n4RTVumXxRqmFlFMK/KsQ7cedvHzCjXtBtco1EdDnukP3NgLCHEKyG2xpql75SGas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419685; c=relaxed/simple;
	bh=8+bE6q1YJllLLISK12nO0Yax9Yjf9NeRSGBD2+kh0Hk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GwcHU+8/SQ1EffUz3xfMMh8BrLQVZdCKxB6+NL41N3Eghk26mRp7sMOaACg2fKTw71WhCuihCmZHF4xqCizNiE8yfEskfQVenGYhu2DbZuQSnI9hxpeWQ7qajcl7KVsgaKNfSEVgJhaCOgpSTpscgm0ydI1D38yb2p93/7JqGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8VpK2Dy; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419683; x=1756955683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+bE6q1YJllLLISK12nO0Yax9Yjf9NeRSGBD2+kh0Hk=;
  b=E8VpK2Dy1WFd+T0VNGxU8S0tOXF3dDB/kfn+qqnnXfeZjFPR1RsYTF6V
   EUDt5dsdaFaceu3/xGFxHt+RXD8GHty3E5CYRlsew71y3rJcOBYnDD9oJ
   xRbEdwZ+eobg6H+05Ou183SFhQXgrKC/o7dvL9wbC04fjGtHqypS07urq
   BZ5ulR61d4oOKRJxAq11C9WpQGuxLgzOYNM8EI+FCt4nDeXdbCsIxMSYx
   bCJnwuymd5owz56IjBgt/LeAiKcMPgwDC2668cu2CiWcwQklLk5AiJkZe
   /Brw8epMH9EqAcaplNj1RKyLPosoxnsq21AI4TFDL9hcUoFTc6jiqY3ek
   A==;
X-CSE-ConnectionGUID: KtmR1/rFRaSNQ98dSRkm7w==
X-CSE-MsgGUID: 2ujPfcr7RqKEYhhl4DbQ+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564715"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564715"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:11 -0700
X-CSE-ConnectionGUID: FE1RKMh1T3a2utLTXqrMng==
X-CSE-MsgGUID: UhPLdk+1QH6pWYMlmbFu2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106356"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:10 -0700
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
Subject: [PATCH 17/21] KVM: TDX: MTRR: implement get_mt_mask() for TDX
Date: Tue,  3 Sep 2024 20:07:47 -0700
Message-Id: <20240904030751.117579-18-rick.p.edgecombe@intel.com>
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

Although TDX supports only WB for private GPA, it's desirable to support
MTRR for shared GPA.  Always honor guest PAT for shared EPT as what's done
for normal VMs.

Suggested-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Align with latest vmx code in kvm/queue.
 - Updated patch log.
 - Dropped KVM_BUG_ON() in vt_get_mt_mask(). (Rick)

v19:
 - typo in the commit message
 - Deleted stale paragraph in the commit message
---
 arch/x86/kvm/vmx/main.c    | 10 +++++++++-
 arch/x86/kvm/vmx/tdx.c     |  8 ++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5d43b44e2467..8f5dbab9099f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -168,6 +168,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
+
+	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -292,7 +300,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 435112562954..50ce24905062 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -374,6 +374,14 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 66829413797d..d8a00ab4651c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -128,6 +128,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -153,6 +154,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.34.1


