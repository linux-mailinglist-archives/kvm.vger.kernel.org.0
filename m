Return-Path: <kvm+bounces-67860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B961D15F75
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D06630CEF4F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6E922D4C3;
	Tue, 13 Jan 2026 00:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M3R/dKik"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA9C42AB7;
	Tue, 13 Jan 2026 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263511; cv=none; b=TxAxcKVWjfIpM3jOkjnLpE5eCuD9Q1eo8At4u8KrbhR3ra9URMsy+6X1XezFgrh7bOycoNIsHkIPWlsJ0lq8YAIhdwHPg5VzWRS+hyopNQbW3q7ewkCeIR5uwogAPRZTggth0S0uYG6zhPPsOBF+97PwEmCtUsFyP3Rk8z2bw9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263511; c=relaxed/simple;
	bh=9P+wM6gafHW0wSB7dhCz2sdL6IyN88yEg6n5053amAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naNSBtHUeFwxAHZ/IAI9nUICrhBQyBRr4qDbzaeRJi/eiD1NCyTL84FGruAlAL3hzEtWVfxru3p0IMFgOs1KTcjmr1fypxxX6gz1ZCZczAq7Bz0S62u4ll2y1l/U9dDnyE0qLkF5ZeoN+yQojNq18s7h/t3cVdvYD2nZYWeqqBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M3R/dKik; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263508; x=1799799508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9P+wM6gafHW0wSB7dhCz2sdL6IyN88yEg6n5053amAo=;
  b=M3R/dKikKbG9mAMUR3jtD8nMpSLmpjMwKGdcC1oizBXSqdK331aT8cwD
   VZAheyvuvEjaoPrsYE4GljGQJvhSwrWf1Z0AwDpmXRx0mxp1M7ijb47j0
   oarDJVlHCesGUfNepmIcFCi83SqG0viPM4yKI75sm6awWyjFH6Y/DnH0n
   25tabt8S+/TZLBYo+0+5+NJ41+5oVFlGu+Cfn41nyj5ASPZ0aox3oFsrs
   H79giryeVZCG3behlpp9T4Kcbal2Ps/nnCzMRLtA4+5+lUgvB2DdTSzPu
   erzDuUVt+Gi3IhFAwZEoUDUFwqxVUgqYELYGR3hBcxy2Uaidld8rx6wgP
   w==;
X-CSE-ConnectionGUID: haO1s5v+Q8GNOGbwUjvb0A==
X-CSE-MsgGUID: 5WhiK3qsQtijeCuZOLFqzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264235"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264235"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:26 -0800
X-CSE-ConnectionGUID: mnbF3JiBT1eUlwQ/TjGHlg==
X-CSE-MsgGUID: AeVjomSZTpGFy/CodFlz4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042260"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:27 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 07/16] KVM: VMX: Support extended register index in exit handling
Date: Mon, 12 Jan 2026 23:53:59 +0000
Message-ID: <20260112235408.168200-8-chang.seok.bae@intel.com>
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

Define the VMCS field offset for the extended instruction information.
Then, support 5-bit register indices retrieval from VMCS fields when APX
feature is enumerated.

The presence of the extended instruction information field is indicated
by APX enumeration, regardless of the XCR0.APX bit setting.

With APX enumerated, the previously reserved bit in the exit qualification
can be referenced safely now. However, there is no guarantee that older
implementations always zeroed this bit.

Link: https://lore.kernel.org/7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
V1 -> V2:
* Switch the change order; putting this ahead of nVMX changes (Chao)
* Subsequently, define the field offset here.
---
 arch/x86/include/asm/vmx.h |  2 ++
 arch/x86/kvm/vmx/vmx.h     | 23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..6170251306db 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -264,6 +264,8 @@ enum vmcs_field {
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	EXTENDED_INSTRUCTION_INFO       = 0x00002406,
+	EXTENDED_INSTRUCTION_INFO_HIGH  = 0x00002407,
 	VMCS_LINK_POINTER               = 0x00002800,
 	VMCS_LINK_POINTER_HIGH          = 0x00002801,
 	GUEST_IA32_DEBUGCTL             = 0x00002802,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8d3e0aff2e13..a24d87aa4f79 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -372,12 +372,26 @@ struct vmx_insn_info {
 	union insn_info info;
 };
 
+/*
+ * The APX enumeration guarantees the presence of the extended fields.
+ * The host CPUID bit alone is sufficient to rely on it.
+ */
+static inline bool vmx_insn_info_extended(void)
+{
+	return static_cpu_has(X86_FEATURE_APX);
+}
+
 static inline struct vmx_insn_info vmx_get_insn_info(void)
 {
 	struct vmx_insn_info insn;
 
-	insn.extended  = false;
-	insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+	if (vmx_insn_info_extended()) {
+		insn.extended   = true;
+		insn.info.dword = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
+	} else {
+		insn.extended  = false;
+		insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
+	}
 
 	return insn;
 }
@@ -413,7 +427,10 @@ static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 
 static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
 {
-	return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
+	if (vmx_insn_info_extended())
+		return (vmx_get_exit_qual(vcpu) >> 8) & 0x1f;
+	else
+		return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
 }
 
 static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
-- 
2.51.0


