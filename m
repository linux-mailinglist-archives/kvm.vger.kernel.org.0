Return-Path: <kvm+bounces-25816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9C396AF05
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:17:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44C40286412
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DA384A4D;
	Wed,  4 Sep 2024 03:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FuMhmiZO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E25678C89;
	Wed,  4 Sep 2024 03:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419678; cv=none; b=bX6uexTVMvzBSg7qqdZ9yLr1dk7Hf50YPsEjf4te+JTi42rqK2WPkP06W5jekUnnb8t8VVkeu47BiThvT3JXA/VqobaDtW7F+7p0URYXxzjYNMxRG03JgkWSn2/R73Gyf8Ly1TTipSiQV9E4UlhDPKLbUSLrJ/y9EVRbCkLnjUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419678; c=relaxed/simple;
	bh=wkKEjNDf9/+HaaMVib+qLpU8xC2xWIBhbLnIL7xU3wQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NS1GRc8HJy6A4F13KAAqH/3wsus7cTub6+EByAouRoc0jNeop/fHOHvclFDC2PdiMrThrnFzc5eB1jenEdY3eO7B+t7ZGYtXxr7XdMuG0DZm6rZzvIni1GlnhzI4tRx1/ShJlRJGwa6i4ZatwYdEs47rTYtpjwRKsWRY3iCz0IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FuMhmiZO; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419676; x=1756955676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wkKEjNDf9/+HaaMVib+qLpU8xC2xWIBhbLnIL7xU3wQ=;
  b=FuMhmiZOV/85/nINHxEG9J8nEAlBdntjBgcW7ZPiNYgruc5wHnhmGH4M
   4LtmAGHo2ZyrONsYcH4cLo8X9fWPM7btOA/XdduvHSXBx2o5EqOsnFFPa
   ynhilOaVmFrLZAcOLNx+Xlfg53Gvpcdw20EG4l44N0dA/Ck3qL+DnWNME
   FlJq/d2QBLyGRjLzEKN39k1eWyu2IY12WRdNQe4FZsYvYOZNSrZ8BBf8u
   lFgnJqaZ0Js44dvpcnsThyRS4a3cm8inlCyRt/sfZ6RGSJH5kmJjBE1Nx
   EhLIAFYWV/I+LQtmy27fKR39SssU2vEQtvqZN5SpwgZNlp9dCZgZBsyCV
   A==;
X-CSE-ConnectionGUID: 2jvrWJ6qTZCT4Wb/usF8tw==
X-CSE-MsgGUID: 0SmFZtFvQYK/AaCy9LfWuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564649"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564649"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:01 -0700
X-CSE-ConnectionGUID: QeHFI92JTWqjtygkrbQ+Kg==
X-CSE-MsgGUID: S1XkK/AATJ6p4U249fE61A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106251"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:01 -0700
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
Subject: [PATCH 06/21] KVM: TDX: Add accessors VMX VMCS helpers
Date: Tue,  3 Sep 2024 20:07:36 -0700
Message-Id: <20240904030751.117579-7-rick.p.edgecombe@intel.com>
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

TDX defines SEAMCALL APIs to access TDX control structures corresponding to
the VMX VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Eliminate kvm_mmu_free_private_spt() and open code it.
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)

v19:
 - deleted unnecessary stub functions,
   tdvps_state_non_arch_check() and tdvps_management_check().
---
 arch/x86/kvm/vmx/tdx.h | 87 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 7eeb54fbcae1..66540c57ed61 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -76,6 +76,93 @@ static __always_inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
  */
 #include "tdx_ops.h"
 
+static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
+{
+#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
+#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
+#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
+#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
+
+	/* TDX is 64bit only.  HIGH field isn't supported. */
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
+			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
+			 "Read/Write to TD VMCS *_HIGH fields not supported");
+
+	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
+
+#define VMCS_ENC_WIDTH_MASK	GENMASK(14, 13)
+#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
+#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
+#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
+#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
+#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
+
+	/* TDX is 64bit only.  i.e. natural width = 64bit. */
+	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
+			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
+			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
+			 "Invalid TD VMCS access for 64-bit field");
+	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
+			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
+			 "Invalid TD VMCS access for 32-bit field");
+	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
+			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
+			 "Invalid TD VMCS access for 16-bit field");
+}
+
+#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
+static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
+							u32 field)		\
+{										\
+	u64 err, data;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_rd(tdx, TDVPS_##uclass(field), &data);			\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm)) {					\
+		pr_err("TDH_VP_RD["#uclass".0x%x] failed: 0x%llx\n",		\
+		       field, err);						\
+		return 0;							\
+	}									\
+	return (u##bits)data;							\
+}										\
+static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
+						      u32 field, u##bits val)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx, TDVPS_##uclass(field), val,			\
+		      GENMASK_ULL(bits - 1, 0));				\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
+		pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",	\
+		       field, (u64)val, err);					\
+}										\
+static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
+						       u32 field, u64 bit)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx, TDVPS_##uclass(field), bit, bit);			\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
+		pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",	\
+		       field, bit, err);					\
+}										\
+static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
+							 u32 field, u64 bit)	\
+{										\
+	u64 err;								\
+										\
+	tdvps_##lclass##_check(field, bits);					\
+	err = tdh_vp_wr(tdx, TDVPS_##uclass(field), 0, bit);			\
+	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
+		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
+		       field, bit,  err);					\
+}
+
+TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 #else
 static inline void tdx_bringup(void) {}
 static inline void tdx_cleanup(void) {}
-- 
2.34.1


