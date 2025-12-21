Return-Path: <kvm+bounces-66449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3B46CD3BC1
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 05:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31D363055790
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 04:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8675423183A;
	Sun, 21 Dec 2025 04:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WWYVIMHY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF44223705;
	Sun, 21 Dec 2025 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766291500; cv=none; b=Cl9G6RvnbpxNoU2WPjTsAxBrM14GxqiTtT8c2wyJzfmJvVeOTvNTt0hfwIExUu2L8TqC10fpD+Q49pH80ZucrAGZS+XopEVx0LFrLQjIlMtGe3pK3gB24F9Eq/N0PA1s+lcUdRX0HbLvhbMKuMFLqoEDbK214Mv9Re5IujQe1Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766291500; c=relaxed/simple;
	bh=I8VBhy6rygv+7rZ1aV4AF7DUYQgORjwnVyQili26KyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZEg7RpfxkPs+Q8QXZKnKVGzsoRTpz03NPHLQ9bCptjRl/+9hnUUPwfccC6HQjiW1f2RxEGlHkPxpv0GkQBMRj+6pA07q98aIckDjOAcUs9QQDbJ9C/xVuxyaHO0Z622EWXc0wObGAU9YZd09HpUYkN43F4e2nq4xXIlGnDH7XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WWYVIMHY; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766291498; x=1797827498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I8VBhy6rygv+7rZ1aV4AF7DUYQgORjwnVyQili26KyE=;
  b=WWYVIMHYh+oEZRPlWTNOA4+MJZzzy0lS4w5n0r7c75DX/ASaN7//EZ1d
   kmguWgB3wSf4tZ1u4fQNVioLDiK5OAlvEfXtLSMSo0gr3YcdLFV2xKBBV
   ReloO/c6OVSmf3YwPMIwon7RT1pBtb5qY6cnKwf4MQ7aeSClZKdh/mKSP
   XExbqhF2+W8Owr3oSa193/bto3I99ik3XMerRTafkRdzQrD/FROAxeejW
   8oQul80vHmGho36t+SSG5e1ducTn4CXXofWiRKDoPvXL+c/yZxXX76P1P
   ELZDGaItWGJwyo0XlKNuqd3dAgJMNuoulbhUnUiXyR1qTA/O+rxQU0DZ3
   Q==;
X-CSE-ConnectionGUID: oAQU7mAATGWOiYVfYdS2Zg==
X-CSE-MsgGUID: V3zctVNTTJinzzZS7UeuIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68132402"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68132402"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 20:31:38 -0800
X-CSE-ConnectionGUID: et7ZrMymRoabH+KTKRX0UQ==
X-CSE-MsgGUID: IleDPW+sRMG7K17d1c4kew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229884992"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 20 Dec 2025 20:31:38 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH 07/16] KVM: nVMX: Propagate the extended instruction info field
Date: Sun, 21 Dec 2025 04:07:33 +0000
Message-ID: <20251221040742.29749-8-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251221040742.29749-1-chang.seok.bae@intel.com>
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the VMCS field offset for the extended instruction information.
Then, propagate the field to nested VMX.

When a virtual CPU enumerates the APX capability, nested VMX should
expose the extended field to address higher register indices.

Link: https://lore.kernel.org/CABgObfa-vqWCenVvvTAoB773AQ+9a1OOT9n5hjqT=zZBDQbb+Q@mail.gmail.com
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes since last version:
* Check the availability based on the guest APX capability (Chao)
* Massage the changelog to reflect this fact.
---
 arch/x86/include/asm/vmx.h | 2 ++
 arch/x86/kvm/vmx/nested.c  | 6 ++++++
 arch/x86/kvm/vmx/vmcs12.c  | 1 +
 arch/x86/kvm/vmx/vmcs12.h  | 3 ++-
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..ab0684948c56 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -264,6 +264,8 @@ enum vmcs_field {
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	EXTENDED_INSTRUCTION_INFO	= 0x00002406,
+	EXTENDED_INSTRUCTION_INFO_HIGH	= 0x00002407,
 	VMCS_LINK_POINTER               = 0x00002800,
 	VMCS_LINK_POINTER_HIGH          = 0x00002801,
 	GUEST_IA32_DEBUGCTL             = 0x00002802,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1e35e1923aec..ce972eeaa6f7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4746,6 +4746,12 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
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


