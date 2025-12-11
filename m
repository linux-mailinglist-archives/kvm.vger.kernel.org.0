Return-Path: <kvm+bounces-65707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C738FCB4D22
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C6C4301FF65
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A862BDC3F;
	Thu, 11 Dec 2025 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CnbP7n9H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C729E101
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431860; cv=none; b=RZcdRr4wbE+fgRGrxoznIWWn8b39gPOF2RnCbvwEDxqV+4eG72tvfBRdPZrLK1y8uSoZVVM+z9/Karm7hPHz6qy3bu3w7VIoJ4AgSXmI2UJZbKlCcJREUNT2WUt1QG09UAHCfnMcFDMNXz3IjWl/8C+pZpigUu3SZgA/7/VKNhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431860; c=relaxed/simple;
	bh=sBpe2qGYGh44L7Eww11sVA8mfktkl9T4AxGNbJqJsBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z7P4tjNjl581ZfvIQDFzvT6Y23FKwYD3Up+MRQALUGOOZ6CZI31aErfPkg/osmY7um/S+ucTfo8uaJyW0FVS1CouG0Ha689bhBse8F7RKW9qCoGT+Lb/qPLa9mzo8oS0a4HvgM2kDzY6itFzt9BxTwp5B31Rum8RfE3/fx60ETo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CnbP7n9H; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431858; x=1796967858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sBpe2qGYGh44L7Eww11sVA8mfktkl9T4AxGNbJqJsBY=;
  b=CnbP7n9HdwMU5sDyBd1S6Fp1z+W7dFexZ7PZUCIrTKs+LFXkwKwho88q
   Sb2jA0838WqFea40c+aPAMrhfxXh3Xfh3X16ojeXYnqAUL9rm2KND3viZ
   W3vRb6uaCVhhdAUlF3OFZ3mw3z5mhmp/CJz5/Eak/8q1kwpOeQBdn8VRv
   Oo1e4ihAJAfwlf6ou4ScDqGeLAaLfAx813t6HWgM4ud+lBbuFCJpYW0pp
   4XtYVqUIZjxJ0otUaNI2Sxte3ablBbOhhVBA7bilcmWtuabSMo/Fl7Nrx
   iS+5ucs/lwvKR4d18ZpKBfwLrM5NmMQJ9/KghTROwrPe+28nAY/4gPIg6
   w==;
X-CSE-ConnectionGUID: u/rjZHYdRP+SxQmEIPOkng==
X-CSE-MsgGUID: yoPrN40wR7eGZ43xbMBYrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409933"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409933"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:18 -0800
X-CSE-ConnectionGUID: JXba38jmSKaDSEbZkeS9aQ==
X-CSE-MsgGUID: d10Ru7jKQViwJMMUSinCOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366157"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:13 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 14/22] i386/kvm: Add save/restore support for CET MSRs
Date: Thu, 11 Dec 2025 14:07:53 +0800
Message-Id: <20251211060801.3600039-15-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

CET (architectural) MSRs include:
MSR_IA32_U_CET - user mode CET control bits.
MSR_IA32_S_CET - supervisor mode CET control bits.
MSR_IA32_PL{0,1,2,3}_SSP - linear addresses of SSPs for user/kernel modes.
MSR_IA32_INT_SSP_TAB - linear address of interrupt SSP table

Since FRED also needs to save/restore MSR_IA32_PL0_SSP, to avoid duplicate
operations, make FRED only save/restore MSR_IA32_PL0_SSP when CET-SHSTK
is not enumerated.

And considerring MSR_IA32_SSP_TBL_ADDR is only presented on 64 bit
processor, wrap it with TARGET_X86_64 macro.

For other MSRs, add save/restore support directly.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Make FRED only save/restore MSR_IA32_PL0_SSP when CET-SHSTK isn't
   enumerated.
 - Wrap MSR_IA32_INT_SSP_TAB with TARGET_X86_64 since it's a
   x86_64-specific MSR.

Changes Since v2:
 - Rename MSR_IA32_SSP_TBL_ADDR to MSR_IA32_INT_SSP_TAB.
 - Rename X86CPUState.ssp_table_addr to X86CPUState.int_ssp_table.
 - Drop X86CPUStete.guest_ssp since it is not used in current commit.
 - Do not check CET-S & CET-U xtates when get/set MSTs since CET
   is XSAVE-managed feature but is not XSAVE-enabled.
---
 target/i386/cpu.h     | 26 ++++++++++---
 target/i386/kvm/kvm.c | 91 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 98 insertions(+), 19 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 84e5cf0ab0c1..37cc218bf3a5 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -543,7 +543,7 @@ typedef enum X86Seg {
 #define MSR_IA32_XFD                    0x000001c4
 #define MSR_IA32_XFD_ERR                0x000001c5
 
-/* FRED MSRs */
+/* FRED MSRs (MSR_IA32_FRED_SSP0 is defined as MSR_IA32_PL0_SSP in CET MSRs) */
 #define MSR_IA32_FRED_RSP0              0x000001cc       /* Stack level 0 regular stack pointer */
 #define MSR_IA32_FRED_RSP1              0x000001cd       /* Stack level 1 regular stack pointer */
 #define MSR_IA32_FRED_RSP2              0x000001ce       /* Stack level 2 regular stack pointer */
@@ -554,9 +554,6 @@ typedef enum X86Seg {
 #define MSR_IA32_FRED_SSP3              0x000001d3       /* Stack level 3 shadow stack pointer in ring 0 */
 #define MSR_IA32_FRED_CONFIG            0x000001d4       /* FRED Entrypoint and interrupt stack level */
 
-/* FRED and CET MSR */
-#define MSR_IA32_PL0_SSP                0x000006a4       /* ring-0 shadow stack pointer (aka MSR_IA32_FRED_SSP0 for FRED) */
-
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
 #define MSR_IA32_UMWAIT_CONTROL         0xe1
@@ -583,6 +580,15 @@ typedef enum X86Seg {
 #define MSR_APIC_START                  0x00000800
 #define MSR_APIC_END                    0x000008ff
 
+/* CET MSRs */
+#define MSR_IA32_U_CET                  0x000006a0       /* user mode cet */
+#define MSR_IA32_S_CET                  0x000006a2       /* kernel mode cet */
+#define MSR_IA32_PL0_SSP                0x000006a4       /* ring-0 shadow stack pointer */
+#define MSR_IA32_PL1_SSP                0x000006a5       /* ring-1 shadow stack pointer */
+#define MSR_IA32_PL2_SSP                0x000006a6       /* ring-2 shadow stack pointer */
+#define MSR_IA32_PL3_SSP                0x000006a7       /* ring-3 shadow stack pointer */
+#define MSR_IA32_INT_SSP_TAB            0x000006a8       /* exception shadow stack table */
+
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
 #define XSTATE_YMM_BIT                  2
@@ -1973,8 +1979,16 @@ typedef struct CPUArchState {
     uint64_t fred_config;
 #endif
 
-    /* MSR used for both FRED and CET (SHSTK) */
-    uint64_t pl0_ssp;
+    /* CET MSRs */
+    uint64_t u_cet;
+    uint64_t s_cet;
+    uint64_t pl0_ssp; /* also used for FRED */
+    uint64_t pl1_ssp;
+    uint64_t pl2_ssp;
+    uint64_t pl3_ssp;
+#ifdef TARGET_X86_64
+    uint64_t int_ssp_table;
+#endif
 
     uint64_t tsc_adjust;
     uint64_t tsc_deadline;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 00fead0827ed..4eb58ca19d79 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4008,11 +4008,14 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, env->fred_ssp2);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, env->fred_ssp3);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, env->fred_config);
-            /*
-             * Aka MSR_IA32_FRED_SSP0. This MSR is accessible even if
-             * CET shadow stack is not supported.
-             */
-            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
+
+            if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
+                /*
+                 * Aka MSR_IA32_FRED_SSP0. This MSR is accessible even if
+                 * CET shadow stack is not supported.
+                 */
+                kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
+            }
         }
     }
 #endif
@@ -4266,6 +4269,26 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
         }
     }
 
+    if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK ||
+        env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, env->u_cet);
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, env->s_cet);
+
+        if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, env->pl1_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, env->pl2_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, env->pl3_ssp);
+
+#ifdef TARGET_X86_64
+            if (lm_capable_kernel) {
+                kvm_msr_entry_add(cpu, MSR_IA32_INT_SSP_TAB,
+                                  env->int_ssp_table);
+            }
+#endif
+        }
+    }
+
     return kvm_buf_set_msrs(cpu);
 }
 
@@ -4500,11 +4523,14 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, 0);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, 0);
             kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, 0);
-            /*
-             * Aka MSR_IA32_FRED_SSP0. This MSR is accessible even if
-             * CET shadow stack is not supported.
-             */
-            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
+
+            if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
+                /*
+                 * Aka MSR_IA32_FRED_SSP0. This MSR is accessible even if
+                 * CET shadow stack is not supported.
+                 */
+                kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
+            }
         }
     }
 #endif
@@ -4662,6 +4688,25 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK ||
+        env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, 0);
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, 0);
+
+        if (env->features[FEAT_7_0_EDX] & CPUID_7_0_ECX_CET_SHSTK) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, 0);
+
+#ifdef TARGET_X86_64
+            if (lm_capable_kernel) {
+                kvm_msr_entry_add(cpu, MSR_IA32_INT_SSP_TAB, 0);
+            }
+#endif
+        }
+    }
+
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
     if (ret < 0) {
         return ret;
@@ -4756,9 +4801,6 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_FRED_CONFIG:
             env->fred_config = msrs[i].data;
             break;
-        case MSR_IA32_PL0_SSP: /* aka MSR_IA32_FRED_SSP0 */
-            env->pl0_ssp = msrs[i].data;
-            break;
 #endif
         case MSR_IA32_TSC:
             env->tsc = msrs[i].data;
@@ -5012,6 +5054,29 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
             env->lbr_records[index - MSR_ARCH_LBR_INFO_0].info = msrs[i].data;
             break;
+        case MSR_IA32_U_CET:
+            env->u_cet = msrs[i].data;
+            break;
+        case MSR_IA32_S_CET:
+            env->s_cet = msrs[i].data;
+            break;
+        case MSR_IA32_PL0_SSP: /* aka MSR_IA32_FRED_SSP0 */
+            env->pl0_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL1_SSP:
+            env->pl1_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL2_SSP:
+            env->pl2_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL3_SSP:
+            env->pl3_ssp = msrs[i].data;
+            break;
+#ifdef TARGET_X86_64
+        case MSR_IA32_INT_SSP_TAB:
+            env->int_ssp_table = msrs[i].data;
+            break;
+#endif
         case MSR_K7_HWCR:
             env->msr_hwcr = msrs[i].data;
             break;
-- 
2.34.1


