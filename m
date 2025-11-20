Return-Path: <kvm+bounces-63769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 313E1C7236A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 05:48:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 36AFB350D99
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 04:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2169A308F32;
	Thu, 20 Nov 2025 04:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KJInBQyd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACB9306B39;
	Thu, 20 Nov 2025 04:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763613964; cv=none; b=pLaKP+iw4CZLljo04tRsxRImdZACkSslj/V0462Wa/ViHGCtJOfMvyyBkBscB7ePX4VfnV4GKbOvx0NqmYB2bBF/C/wgxpS0S8hR6VxjsPpRmgnCwCV52oiKztrySiyUun3K10MFdzX/6Vhy1xnApKpMsoNOPET0xWW+PjzcCGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763613964; c=relaxed/simple;
	bh=dqrBODGjQcmaAi4yBNWJYjHwbP/LCn16gIcr7UnBmsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZMQFhUwU0vIwx8LpJPGCzDG5TnBt4aVVHA0mrtVQsjBtBk7BHdxKSEkj/tL6r/oEZcgVNhhAKhMK0PcuBd8HO5reKB6W7pB8xyLa+BSJza3vPgGUASXTdvvXA6MrVjlue3PoDM8ksonZwQjgWAikZ9d14x1UYWco9JXfDBEpoVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KJInBQyd; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763613962; x=1795149962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dqrBODGjQcmaAi4yBNWJYjHwbP/LCn16gIcr7UnBmsQ=;
  b=KJInBQydrg6zM6IzdcdSWa+NtS0hPocBMG/I8c6f7ox6p7TFVrqsQ5tU
   mjNawPKabsecqv9YuiEir9kGMs8ZUVu2k0jv1Eb1ZiDP3sqfiUKhAsGM2
   rEAolN6T2QAwc6ULdV+5e2KzNaGKcV7fDCkd2ZeBTm4Anj8jYzaBwgok7
   6xs0FdmtwMmXnvTsWTdfb5CHt5mZW8mJkdW7VvSf5qJrKEMLVq6pq7AGt
   UreWei3s9Qjws9WHa5W5WqPMDwWCrNU6VCVAwqT91TXdHRucduELeJ5PR
   2nwjO1MeU1FKMJQ14uSBuwdr0z3R/pvkE7hsnHR+aiMkqszVyZmpZxQ5w
   g==;
X-CSE-ConnectionGUID: qcztNZwqS7eUOEM3IbgYNg==
X-CSE-MsgGUID: wo6BlNVGT4il2kozuJD+qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65602283"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65602283"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 20:46:02 -0800
X-CSE-ConnectionGUID: LMtK62oWQW2RnYesgO5B+A==
X-CSE-MsgGUID: IvMDVhb4S1agPrriE5AZ0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196380894"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 19 Nov 2025 20:45:59 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 4/4] KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace
Date: Thu, 20 Nov 2025 13:07:20 +0800
Message-Id: <20251120050720.931449-5-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define and pass AVX10_VNNI_INT CPUID through to the guest.

AVX10_VNNI_INT (0x24.0x1.ECX[bit 2]) is a discrete feature bit
introduced on Intel Diamond Rapids, which enumerates the support for
EVEX VPDP* instructions for INT8/INT16 [*].

Since this feature has no actual kernel usages, define it as a KVM-only
feature in reverse_cpuid.h.

Advertise new CPUID subleaf 0x24.0x1 with AVX10_VNNI_INT bit to
userspace for guest use. It's safe since no additional enabling work
is needed in the host kernel.

[*]: Intel Advanced Vector Extensions 10.2 Architecture Specification
     (rev 5.0).

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Reference link: https://cdrdv2.intel.com/v1/dl/getContent/856721
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 18 +++++++++++++++++-
 arch/x86/kvm/reverse_cpuid.h    |  4 ++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db7bf364f4fc..992a0abbcc48 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -777,6 +777,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_8000_0021_ECX,
 	CPUID_7_1_ECX,
 	CPUID_1E_1_EAX,
+	CPUID_24_1_ECX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 984fbee2795e..58db5a87757e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1074,6 +1074,10 @@ void kvm_set_cpu_caps(void)
 		F(AVX10_512),
 	);
 
+	kvm_cpu_cap_init(CPUID_24_1_ECX,
+		F(AVX10_VNNI_INT),
+	);
+
 	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
 		F(LAHF_LM),
 		F(CMP_LEGACY),
@@ -1650,6 +1654,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			break;
 		}
 
+		max_idx = entry->eax = min(entry->eax, 1u);
 		/*
 		 * The AVX10 version is encoded in EBX[7:0].  Note, the version
 		 * is guaranteed to be >=1 if AVX10 is supported.  Note #2, the
@@ -1659,9 +1664,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_entry_override(entry, CPUID_24_0_EBX);
 		entry->ebx |= avx10_version;
 
-		entry->eax = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
+
+		/* KVM only supports up to 0x24.0x1, capped above via min(). */
+		if (max_idx >= 1) {
+			entry = do_host_cpuid(array, function, 1);
+			if (!entry)
+				goto out;
+
+			cpuid_entry_override(entry, CPUID_24_1_ECX);
+			entry->eax = 0;
+			entry->ebx = 0;
+			entry->edx = 0;
+		}
 		break;
 	}
 	case KVM_CPUID_SIGNATURE: {
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 99ec9e656655..a240abaaa5e0 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -59,6 +59,9 @@
 #define X86_FEATURE_AVX10_256		KVM_X86_FEATURE(CPUID_24_0_EBX, 17)
 #define X86_FEATURE_AVX10_512		KVM_X86_FEATURE(CPUID_24_0_EBX, 18)
 
+/* Intel-defined sub-features, CPUID level 0x00000024:1 (ECX) */
+#define X86_FEATURE_AVX10_VNNI_INT	KVM_X86_FEATURE(CPUID_24_1_ECX, 2)
+
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
@@ -102,6 +105,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0021_ECX] = {0x80000021, 0, CPUID_ECX},
 	[CPUID_7_1_ECX]       = {         7, 1, CPUID_ECX},
 	[CPUID_1E_1_EAX]      = {      0x1e, 1, CPUID_EAX},
+	[CPUID_24_1_ECX]      = {      0x24, 1, CPUID_ECX},
 };
 
 /*
-- 
2.34.1


