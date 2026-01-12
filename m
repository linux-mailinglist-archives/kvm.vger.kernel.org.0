Return-Path: <kvm+bounces-67868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CA5D15F9F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 117DB30FDEE2
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF69280317;
	Tue, 13 Jan 2026 00:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwKlG+C0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6E4231829;
	Tue, 13 Jan 2026 00:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768263529; cv=none; b=ZAvP8E5uraPQtW8+RIMwDo2yMTWmUR+1I+pk2DSAc0NwVAVPjgWtHs20AJBNnFWIPq3gn8IwiuuZFH60XoTEG93XwwBmO3MxryPoDIR0ybDC9iEat7Z02+nXUkxfrHuPnn0BwQUGpPmkJH+7Rnvt9mkOZ2xzkJYCdSdGZH2IYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768263529; c=relaxed/simple;
	bh=aJDl/dLPu2CRPvLxhv0nvmTvQ6Z0nXekpGldPpU1kdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XP25Zz/An4QuCEUkDI37qJzvFz8s1fNkXq91Q2MhHpthoSZnwzAY5dB0IOBypcgVTVTH8s1jv7CBo8K5Nl/laGQUDycI3qXF/xrU+jFK5U5Vc9oo5xPN/2GNQIbOGCxUe81Tz80jZqLPwVPU2ltAeHXqbXMy6l3Wdr0aXW/9dJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwKlG+C0; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768263528; x=1799799528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aJDl/dLPu2CRPvLxhv0nvmTvQ6Z0nXekpGldPpU1kdI=;
  b=CwKlG+C0enDHa4Yv5VBLrWyPlsWQAo8k9k0dsoI9z6TuzJFrv58PPDiz
   kDE9g6aUsqcsB/FWtfaZBFDO8T56sXThDdvAFV6mdrrjWm7a1t5p5tbxf
   9QGeXI3DKqraoSNW4HYbFIGD+bwhv5rTy4SWJGyy9GpldiU/Hdgiy9CSl
   NSeoJHOdYtA/7MR5BSMFFcRZ38gd0cKEkJ6KkkAZ6b8owfNra4aOGEFNe
   Ea+gl6vcnCuGve8ttUM1UtNadELPzK2rP+NLtyXAAnf9fWuZPBjDh5TYJ
   PFoce3GJJ8IqmRpUpCTbFTx5I+tm2/Ujnq6kpaigPySf5vuEpA3xDbe7t
   g==;
X-CSE-ConnectionGUID: KBzdVkJ+RGO9OhtuDT5/Xw==
X-CSE-MsgGUID: iOzoOMPrTo6Jr8Be/Dr5mQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80264291"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80264291"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 16:18:48 -0800
X-CSE-ConnectionGUID: q7mfnKIWS2+qZkO2vBm4ow==
X-CSE-MsgGUID: yPN8q+/kT+6eUprl2fmHyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204042313"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa009.jf.intel.com with ESMTP; 12 Jan 2026 16:18:48 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chao.gao@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v2 15/16] KVM: x86: Expose APX sub-features to guests
Date: Mon, 12 Jan 2026 23:54:07 +0000
Message-ID: <20260112235408.168200-16-chang.seok.bae@intel.com>
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

Add CPUID leaf 0x29 sub-leaf 0 to enumerate APX sub-features to guests.
This leaf currently defines the following sub-features:

  * New Conditional Instructions (NCI)
  * New Data Destination (NDD)
  * Flags Suppression (NF)

The CPUID leaf is only exposed if the APX feature is enabled.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 10 ++++++++--
 arch/x86/kvm/reverse_cpuid.h    |  4 ++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9dedb8d77222..d75a76152340 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -794,6 +794,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_24_0_EBX,
 	CPUID_8000_0021_ECX,
 	CPUID_7_1_ECX,
+	CPUID_29_0_EBX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5431e31a4851..347b8f2402c7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1070,6 +1070,10 @@ void kvm_set_cpu_caps(void)
 		F(AVX10_512),
 	);
 
+	kvm_cpu_cap_init(CPUID_29_0_EBX,
+		F(APX_NCI_NDD_NF),
+	);
+
 	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
 		F(LAHF_LM),
 		F(CMP_LEGACY),
@@ -1648,8 +1652,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	}
 	case 0x29: {
-		/* No APX sub-features are supported yet */
-		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		if (!(kvm_caps.supported_xcr0 & XFEATURE_MASK_APX)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
 		break;
 	}
 	case KVM_CPUID_SIGNATURE: {
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index e538b5444919..f8587586d031 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -50,6 +50,9 @@
 #define X86_FEATURE_AVX10_256		KVM_X86_FEATURE(CPUID_24_0_EBX, 17)
 #define X86_FEATURE_AVX10_512		KVM_X86_FEATURE(CPUID_24_0_EBX, 18)
 
+/* Intel-defined sub-features, CPUID level 0x00000029:0 (EBX) */
+#define X86_FEATURE_APX_NCI_NDD_NF	KVM_X86_FEATURE(CPUID_29_0_EBX, 0)
+
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
@@ -91,6 +94,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_24_0_EBX]      = {      0x24, 0, CPUID_EBX},
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 	[CPUID_7_1_ECX]       = {         7, 1, CPUID_ECX},
+	[CPUID_29_0_EBX]      = {      0x29, 0, CPUID_EBX},
 };
 
 /*
-- 
2.51.0


