Return-Path: <kvm+bounces-63475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B5DC671E0
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 04:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 9AF4629DD2
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFA9329C59;
	Tue, 18 Nov 2025 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KKCS8pY9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F4131577D
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 03:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763436072; cv=none; b=s6bGDxueVILQjed9EpWivBrTeKo2tKFLIQiqu5Xqpy1Jf4QtuhLc/l1JXSj3QrAvJygCrjJ4yraDSKG/w58Xumij5Os6gfVr0HhQisFfsGhpjYlsa/hojNHsIcmHztyfHGmCnigEnKdC3r7wpbW/hhrT2q1a48Bu4DBI6rFgF6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763436072; c=relaxed/simple;
	bh=OT9yXKg8cGU4vWhy5aN4ndDqiEVed8ea36SkVfyMMTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qUi5UAZwCrxblaXzYMLE2izhTsdh0/vModK6riSZ+YHPfX8IpzXKNDaB+9d7hhkRjiImVV6foxrNFnfHw5s1ygDw8FPdEGrjQXkzlfB0MX2mGDgD4mb9TxEke3Vd8xdQK1hlONYUNLIB0NDujUWa4yipk2xxxJqlkJjubIvpn3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KKCS8pY9; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763436070; x=1794972070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OT9yXKg8cGU4vWhy5aN4ndDqiEVed8ea36SkVfyMMTw=;
  b=KKCS8pY99ht3SkKyPHJ0IpshK9H9ms+HCy+1NyD00YqS0LhsOCI859Z0
   mNnceYVv4UqNYdYnhv3zoHxicCnw5mYONBzaR7bfKbKclF2W99YnwE8l7
   Svkkw6erSzQYy7e1p7HpKUnupBkf50HU1ubJQVWkTM7dSeDQAa1eTAKFk
   iGtfK7vlAom0dhnXRrFws6nDQ2KrOUecnPhnnI89l7PkQPPnHsFMWcOyK
   bjm7VZdoM3Kc0Zfxlw5RSQ/TAA5aja3fE34EdGaKBgEaaa5YDley2nrYS
   O0SWucc5ohvHn+mc66pY7qlcDJzCVEEx3eFUgxYMS0ocCirixDtcyTGG/
   g==;
X-CSE-ConnectionGUID: MtVgAdSOQIaRedbCiBB3Wg==
X-CSE-MsgGUID: TKOKAm6TQ6qdD1fHbzkmbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="68053884"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="68053884"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 19:21:10 -0800
X-CSE-ConnectionGUID: z3MWa+37RL2HVBKD4nv5tA==
X-CSE-MsgGUID: cwPmblDqQneNRq0+Oxn7fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221537295"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 19:21:05 -0800
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
Subject: [PATCH v4 15/23] i386/kvm: Add save/restore support for CET MSRs
Date: Tue, 18 Nov 2025 11:42:23 +0800
Message-Id: <20251118034231.704240-16-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118034231.704240-1-zhao1.liu@intel.com>
References: <20251118034231.704240-1-zhao1.liu@intel.com>
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
index 0432af1769d2..661b798da4d0 100644
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
@@ -1976,8 +1982,16 @@ typedef struct CPUArchState {
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


