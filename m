Return-Path: <kvm+bounces-49325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92448AD7DD0
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 914851895DC2
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D19F2E1746;
	Thu, 12 Jun 2025 21:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mT/gdVrc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA312DECAA;
	Thu, 12 Jun 2025 21:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765031; cv=none; b=M6hE/JfcNdF75bbaH56lKhXK94s9EBa9mucusP4/7Fip4BgGMl9MG8Sp8tdnDFGwoJDkYo0RLe8CM4+lUgjiZOBaRVi2pW6yhk2FUjjYdg+FjFxfz8DGjuy/vw6IHq2EBj0XkLKvamBPU4ePsiq+eJ+ii6wvUKAjMapj5unaHKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765031; c=relaxed/simple;
	bh=nEU4c5folNgSZMdRvC95laRn9b0KITzv+SiB81fV5c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESSUtxPZE9SoiilPJ/SCUUVufY8suN8HMdzr9ggzPEPaE50mONC7aHFahaiZWif3o9rgeSO2BzpIcRgfJRnDbkqJr1JvDCaDVhp+wMmb9Oq05lcgAKo+fGwtZeGLqt9ld2dZ07DOpQ1Hy0nBGp30WUC+s8h5KQywGt07BWcJrZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mT/gdVrc; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765029; x=1781301029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nEU4c5folNgSZMdRvC95laRn9b0KITzv+SiB81fV5c4=;
  b=mT/gdVrcdCTKmun64yol/JKwbcsnawj+1682mpqDhLzXLnJGXOHWpS8C
   fTJ7YVU/MMrqcDfmxZb2Uf6KAoUGasCTUAwkrLuHUzuFctez6j4egA5bw
   c9HcLgYz/UZ0pC8ZVsqgoX0igBV+F6Q/syopa4b4uo4tSVuumEzSDGCwm
   efLwHAnhKumh5wVQxGEtnYe3aIkjspVBRJeunmrgj1sPRI8L5e6prO1FC
   ZbBLRIEJEPR7U7w0gl2ulaOIgLY5vHkcUu5QzttmVqn+qQxMg6iFL5J2v
   qGyhhY8s2ICupPJGmEbTBTv87A2LmcQ+KNBKCYSOTaO/u9ibTO6LVuWZ8
   g==;
X-CSE-ConnectionGUID: lZEZjgHYRbuT+suHZwziMw==
X-CSE-MsgGUID: omrkx81yRJG/hPgZToa6fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065320"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065320"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:28 -0700
X-CSE-ConnectionGUID: YrD6BlnuTMuaRgWFuloeZQ==
X-CSE-MsgGUID: FMyAUOwDRLKTB3RCrR0Swg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881950"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:27 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v7 03/10] x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
Date: Thu, 12 Jun 2025 14:48:42 -0700
Message-ID: <20250612214849.3950094-4-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NMI-source reporting is introduced to report the sources of NMIs with
FRED event delivery based on vectors in NMI interrupt messages or the
local APIC. This enables the kernel to avoid the latency incurred by
going over the entire NMI handler list and reduces ambiguity about the
source of an NMI.

Enumerate NMI-source reporting in cpufeatures.h. Also, since NMI-source
reporting uses the FRED event dispatch framework, make it dependent on
FRED in the CPUID dependency table. This ensures that NMI-source
reporting gets disabled when FRED is disabled.

NMI-source reporting is intended as a kernel feature and does not need
userspace enumeration or configuration. There is no need to expose it to
userspace through /proc/cpuinfo.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v7: No change.

v6: No change.

v5: Add NMI-source to the CPUID dependency table.
    Do not expose NMI-source feature through /proc/cpuinfo.
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ee176236c2be..b6c907666d5f 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -321,6 +321,7 @@
 #define X86_FEATURE_FRED		(12*32+17) /* "fred" Flexible Return and Event Delivery */
 #define X86_FEATURE_LKGS		(12*32+18) /* Load "kernel" (userspace) GS */
 #define X86_FEATURE_WRMSRNS		(12*32+19) /* Non-serializing WRMSR */
+#define X86_FEATURE_NMI_SOURCE		(12*32+20) /* NMI-Source reporting with FRED */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
 #define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
 #define X86_FEATURE_LAM			(12*32+26) /* "lam" Linear Address Masking */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 46efcbd6afa4..87a334f639d5 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -88,6 +88,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AMX_INT8,			X86_FEATURE_AMX_TILE  },
 	{ X86_FEATURE_SHSTK,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_FRED,			X86_FEATURE_LKGS      },
+	{ X86_FEATURE_NMI_SOURCE,		X86_FEATURE_FRED      },
 	{ X86_FEATURE_SPEC_CTRL_SSBD,		X86_FEATURE_SPEC_CTRL },
 	{}
 };
-- 
2.43.0


