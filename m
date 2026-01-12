Return-Path: <kvm+bounces-67861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A269D15F78
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5433030CF592
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8A322D795;
	Tue, 13 Jan 2026 00:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y9IS7VKz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F44322127A;
	Tue, 13 Jan 2026 00:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263511; cv=none; b=dOKjpXAVRQTlkqaT9IJySysRTVKeX8i51b+LnyU/wj5WDcAnk/kAGj+vFKtB//S+gbwFuZR7yNhz2yoP2vO/Zic3rBTQ19TQALi+LTRdcMIJCNMyrF4WetBUou6guCeXhBioOqAp43WCwb96cg7+LZlozf2nlaYTOI4+X9pHVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263511; c=relaxed/simple;
	bh=7OLJeE4hP1UBif4Q0D4hZdBBpUFs03hbPj/fLA4pS6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln2tIQU8WhwpA+BL4+Q3zZjBkgi5hM9z8ivmvvoaUTLbRLSKA+Vs2xVO3eQYjdPtNjBY6NXPfihTUd4xw4PTijeP4BuWRX6b1w0AKLjkRn/rH99xYH0ewnkScre/OjakGa9+y4c3avOP6lyIF9dbl38UJBTo0N0pGFj8KmoI43w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y9IS7VKz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263510; x=1799799510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7OLJeE4hP1UBif4Q0D4hZdBBpUFs03hbPj/fLA4pS6M=;
  b=Y9IS7VKzZCF/Qcn0XP8P/RLr3BJu7AL4NriCYcU3aCbNM3ci4BlHADJT
   MJgYAM2dK9lLlKKcNY9beB0g05aVML7iU2r3ZdSVhZTZ7BvBUuZuX8i9Y
   eUQ//MIPnqkC8ztJTlMNwo57H5fDKqNzSwcmev12xsLGKAytWjF2hyX3q
   2pXJZ8JgvbgYzq3iG8kRBAhBLCkAirSYS8WqdZ9jBm8fO7h6URUVD5+Sm
   tgdz0Ixa003LAyfFOSZdIaMhe4mJuU/XZgs8hUpWlNhgKdp7TMGptqwCM
   5F9jNv8fK1dBDefyfC8T263jJTQoOvtLtrpWIpZ6bVXfkD1PeWxmzplGW
   g==;
X-CSE-ConnectionGUID: exihDauyToSPzYors36mMg==
X-CSE-MsgGUID: dQ6AaponTY2bRk1MiSmWKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264240"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264240"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:29 -0800
X-CSE-ConnectionGUID: dtJk7QaVRQmTVz2svv6iGg==
X-CSE-MsgGUID: VWQ6r6GCQ0O96ANkd8+Obw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042263"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:30 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 08/16] KVM: nVMX: Propagate the extended instruction info field
Date: Mon, 12 Jan 2026 23:54:00 +0000
Message-ID: <20260112235408.168200-9-chang.seok.bae@intel.com>
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

Define a new extended_instruction_info field in struct vmcs12 and
propagate it to nested VMX.

Gate the propagation on the guest APX enumeration which aligns with VMX
behavior. Define the CPUID bit for that.

Link: https://lore.kernel.org/CABgObfa-vqWCenVvvTAoB773AQ+9a1OOT9n5hjqT=zZBDQbb+Q@mail.gmail.com
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
V1 -> V2: Fix build error by defining APX CPUID bit here,
          and refine the changelog
---
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 arch/x86/kvm/vmx/nested.c    | 6 ++++++
 arch/x86/kvm/vmx/vmcs12.c    | 1 +
 arch/x86/kvm/vmx/vmcs12.h    | 3 ++-
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 81b4a7acf72e..e538b5444919 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -35,6 +35,7 @@
 #define X86_FEATURE_AVX_VNNI_INT16      KVM_X86_FEATURE(CPUID_7_1_EDX, 10)
 #define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 #define X86_FEATURE_AVX10               KVM_X86_FEATURE(CPUID_7_1_EDX, 19)
+#define KVM_X86_FEATURE_APX             KVM_X86_FEATURE(CPUID_7_1_EDX, 21)
 
 /* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX) */
 #define X86_FEATURE_INTEL_PSFD		KVM_X86_FEATURE(CPUID_7_2_EDX, 0)
@@ -125,6 +126,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	KVM_X86_TRANSLATE_FEATURE(SGX1);
 	KVM_X86_TRANSLATE_FEATURE(SGX2);
 	KVM_X86_TRANSLATE_FEATURE(SGX_EDECCSSA);
+	KVM_X86_TRANSLATE_FEATURE(APX);
 	KVM_X86_TRANSLATE_FEATURE(CONSTANT_TSC);
 	KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
 	KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 46c12b64e819..da17e73d2414 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4747,6 +4747,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs12->vm_exit_intr_info = exit_intr_info;
 		vmcs12->vm_exit_instruction_len = exit_insn_len;
 		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+		/*
+		 * The APX enumeration guarantees the presence of the extended
+		 * fields. This CPUID bit alone is sufficient to rely on it.
+		 */
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_APX))
+			vmcs12->extended_instruction_info = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
 
 		/*
 		 * According to spec, there's no need to store the guest's
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..ea2b690a419e 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -53,6 +53,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
 	FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
 	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
+	FIELD64(EXTENDED_INSTRUCTION_INFO, extended_instruction_info),
 	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
 	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
 	FIELD64(GUEST_IA32_PAT, guest_ia32_pat),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..2146e45aaade 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -71,7 +71,7 @@ struct __packed vmcs12 {
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
 	u64 tsc_multiplier;
-	u64 padding64[1]; /* room for future expansion */
+	u64 extended_instruction_info;
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -261,6 +261,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(tsc_multiplier, 328);
+	CHECK_OFFSET(extended_instruction_info, 336);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
-- 
2.51.0


