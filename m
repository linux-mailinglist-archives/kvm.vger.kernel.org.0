Return-Path: <kvm+bounces-67857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAF9D15F54
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 512463089CF0
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23065226D02;
	Tue, 13 Jan 2026 00:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/4ATciD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D421CC5C;
	Tue, 13 Jan 2026 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263498; cv=none; b=l3iLbRdLNTzGGLmhkFsGB1jQgkGnNicNXkJjTQ0+jClYblbLVdHyQtO+1KNF5T/5K7X2+GHMVKivKenitEI23VKb56Vpm1cPP2orIi9Qb/pdpSgZDnOq4TYBemsrZFOZ2v5Gib2FdlK3t5nYE0X/OhfQKCZgMyWkOl8NcmHytcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263498; c=relaxed/simple;
	bh=hn4G0kbKkKgfiqgThHkliUKFIqZhgxWKz+4vUPM5Ndc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opl1eSl1Y1mQTFdHSX/Arhrj/kB+BK8FF+XBrjtU8RhPVkrLJ0Q/VtWo6rXWV81mOwF7uToJ0kRbeu7H3dNhRmFjZqgwgykGlrbERO3iSxFrId1+4y0bs3hbFEJj2q0pB2wStzgrEDLEXGlTLMYZNQaH7IhR1eGx0wZgBG/++PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/4ATciD; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263497; x=1799799497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hn4G0kbKkKgfiqgThHkliUKFIqZhgxWKz+4vUPM5Ndc=;
  b=i/4ATciD8tKRY5rYITsRJ2w6D5QUlk0e+9wo/7DGgxLNOFycKs+fv4Mj
   lLRT19kcbx43XMcLoZevJ3eo7sbqelI90pEI6476OwJ+jFrv0eCZpdoYX
   kUhAWBzeOb5QaZRy40m+WXxGTb1J+DCZeHwBnyT7g8lwoz9MD4zFgLBH9
   RyfzpFadqLL2My9duiH9mfZYlT2FkFs2xtK6QXmZNjWtrHF/0ekYCEsvv
   oGJcbefmVDqfWkUsF/gzAh3RYoU5s1/2q3dNLshKYWfPejQHdkNMh987i
   SuVneWZkU3nzpTV9swr3GHO8IW4jrppLfl8tL7rVFdkx5Mf5CMO3yl3QW
   g==;
X-CSE-ConnectionGUID: xH9KKRFaTkyh7zk3scTsOA==
X-CSE-MsgGUID: BCzWJsQ/TkK9G5a2ElUf5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264208"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264208"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:15 -0800
X-CSE-ConnectionGUID: ZYS+w289R2i/2PUDXq5g8w==
X-CSE-MsgGUID: vW/e9uVKQzSnYxFyD0baEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042226"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:16 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 04/16] KVM: VMX: Introduce unified instruction info structure
Date: Mon, 12 Jan 2026 23:53:56 +0000
Message-ID: <20260112235408.168200-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112235408.168200-1-chang.seok.bae@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define a unified data structure that can represent both the legacy and
extended VMX instruction information formats.

VMX provides per-instruction metadata for VM exits to help decode the
attributes of the instruction that triggered the exit. The legacy format,
however, only supports up to 16 GPRs and thus cannot represent EGPRs. To
support these new registers, VMX introduces an extended 64-bit layout.

Instead of maintaining separate storage for each format, a single
union structure makes the overall handling simple. The field names are
consistent across both layouts. While the presence of certain fields
depends on the instruction type, the offsets remain fixed within each
format.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bc3ed3145d7e..567320115a5a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -311,6 +311,67 @@ struct kvm_vmx {
 	u64 *pid_table;
 };
 
+/*
+ * 32-bit layout of the legacy instruction information field. This format
+ * supports the 16 legacy GPRs.
+ */
+struct base_insn_info {
+	u32 scale		: 2;	/* Scaling factor */
+	u32 reserved1		: 1;
+	u32 reg1		: 4;	/* First register index */
+	u32 asize		: 3;	/* Address size */
+	u32 is_reg		: 1;	/* 0: memory, 1: register */
+	u32 osize		: 2;	/* Operand size */
+	u32 reserved2		: 2;
+	u32 seg			: 3;	/* Segment register index */
+	u32 index		: 4;	/* Index register index */
+	u32 index_invalid	: 1;	/* 0: valid, 1: invalid */
+	u32 base		: 4;	/* Base register index */
+	u32 base_invalid	: 1;	/* 0: valid, 1: invalid */
+	u32 reg2		: 4;	/* Second register index */
+};
+
+/*
+ * 64-bit layout of the extended instruction information field, which
+ * supports EGPRs.
+ */
+struct ext_insn_info {
+	u64 scale		: 2;	/* Scaling factor */
+	u64 asize		: 2;	/* Address size */
+	u64 is_reg		: 1;	/* 0: memory, 1: register */
+	u64 osize		: 2;	/* Operand size */
+	u64 seg			: 3;	/* Segment register index */
+	u64 index_invalid	: 1;	/* 0: valid, 1: invalid */
+	u64 base_invalid	: 1;	/* 0: valid, 1: invalid */
+	u64 reserved1		: 4;
+	u64 reg1		: 5;	/* First register index */
+	u64 reserved2		: 3;
+	u64 index		: 5;	/* Index register index */
+	u64 reserved3		: 3;
+	u64 base		: 5;	/* Base register index */
+	u64 reserved4		: 3;
+	u64 reg2		: 5;	/* Second register index */
+	u64 reserved5		: 19;
+};
+
+/* Union for accessing either the legacy or extended format. */
+union insn_info {
+	struct base_insn_info base;
+	struct ext_insn_info  ext;
+	u32 word;
+	u64 dword;
+};
+
+/*
+ * Wrapper structure combining the instruction info and a flag indicating
+ * whether the extended layout is in use.
+ */
+struct vmx_insn_info {
+	/* true if using the extended layout */
+	bool extended;
+	union insn_info info;
+};
+
 static __always_inline struct vcpu_vt *to_vt(struct kvm_vcpu *vcpu)
 {
 	return &(container_of(vcpu, struct vcpu_vmx, vcpu)->vt);
-- 
2.51.0


