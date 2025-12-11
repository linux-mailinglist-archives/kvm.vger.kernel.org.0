Return-Path: <kvm+bounces-65708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8D3CB4D02
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:51:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8D4893001827
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463C82BE7C3;
	Thu, 11 Dec 2025 05:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UUTnyGRG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A522BE62E
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431863; cv=none; b=I4AlL8M/lftEa7JAcshZA/HjASpAMqLKQwMD/LlWmpxHBV8dGIMVIOcXSpQtGY34SWx175+XNUr9qiedaEYurpF0Z1XxWvtKCtoQ42lO3ht53OVOqfw0TTA05ogRfgl3XcZYjoVU4EuYyDhWpkqS0jMCvLP+yc16+E2WJCF74OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431863; c=relaxed/simple;
	bh=x0PXAqnx+JyOHSOJTK7j77gOmPTGVLtFdsCoGZuQvp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ePKIdrt1e7wI0K2MryeSMA79AkAV37KHZYPcY/T7eVSW+xK2EyYVY/WOae/u6tI6jD7+66+lq18vX61UCHQW3JORjPQYRXprS0cBpu+Px6Lp0Lt0r5u8JldDdAM9fW30Nkf7X5qQwyMlXoZ5uyI14r5R4FQTla1PTGEmTO7r054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UUTnyGRG; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431862; x=1796967862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x0PXAqnx+JyOHSOJTK7j77gOmPTGVLtFdsCoGZuQvp8=;
  b=UUTnyGRGvmY70rdCg452NNWNpNW0QFH5gSYX/M4NN5lV0HYvZK+/KO4E
   df7ynd+IdqGecZS3rCs2RZY/QOL5cu+NbSdkoKP054CwPS2b1cHQOd7J6
   lAFRghT+iIIYRRJZ1dV0kTbcpDktOOX/1WFWchth5VO1LYUBNK2IADhby
   ODOorq4tAp+265GML3YrRTDNUqaqoIuaPY5bOmMTCWwD3lDjffxfU2ZcU
   kK3Zo0ZJUuGJXPMVpTdDifODsAM3fB2sIp0xzhRzPKOzp1gY+SWE9bnIg
   m0PV6sUEekX+2GFss1+jw9ZLdsSJraRNd6uwUDf7PPdTP/42iaHyZGdNo
   A==;
X-CSE-ConnectionGUID: dGbLPIIiQm27aZaLunBDDg==
X-CSE-MsgGUID: NzsL1z9lTLm1avD1wGaqPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409943"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409943"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:22 -0800
X-CSE-ConnectionGUID: cj8B2o9eQB+/BzxTAyCSjg==
X-CSE-MsgGUID: aBTCTJaRSy2pG/QtWwlXYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366179"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:18 -0800
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
Subject: [PATCH v5 15/22] i386/kvm: Add save/restore support for KVM_REG_GUEST_SSP
Date: Thu, 11 Dec 2025 14:07:54 +0800
Message-Id: <20251211060801.3600039-16-zhao1.liu@intel.com>
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

CET provides a new architectural register, shadow stack pointer (SSP),
which cannot be directly encoded as a source, destination or memory
operand in instructions. But Intel VMCS & VMCB provide fields to
save/load guest & host's ssp.

It's necessary to save & restore Guest's ssp before & after migration.
To support this, KVM implements Guest's SSP as a special KVM internal
register - KVM_REG_GUEST_SSP, and allows QEMU to save & load it via
KVM_GET_ONE_REG/KVM_SET_ONE_REG.

Cache KVM_REG_GUEST_SSP in X86CPUState.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h     |  3 ++-
 target/i386/kvm/kvm.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 37cc218bf3a5..458775daaa3e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1979,7 +1979,7 @@ typedef struct CPUArchState {
     uint64_t fred_config;
 #endif
 
-    /* CET MSRs */
+    /* CET MSRs and register */
     uint64_t u_cet;
     uint64_t s_cet;
     uint64_t pl0_ssp; /* also used for FRED */
@@ -1989,6 +1989,7 @@ typedef struct CPUArchState {
 #ifdef TARGET_X86_64
     uint64_t int_ssp_table;
 #endif
+    uint64_t guest_ssp;
 
     uint64_t tsc_adjust;
     uint64_t tsc_deadline;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4eb58ca19d79..1ebe20f7fb57 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4292,6 +4292,35 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
     return kvm_buf_set_msrs(cpu);
 }
 
+static int kvm_put_kvm_regs(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    int ret;
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
+        ret = kvm_set_one_reg(CPU(cpu), KVM_X86_REG_KVM(KVM_REG_GUEST_SSP),
+                              &env->guest_ssp);
+        if (ret) {
+            return ret;
+        }
+    }
+    return 0;
+}
+
+static int kvm_get_kvm_regs(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    int ret;
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK)) {
+        ret = kvm_get_one_reg(CPU(cpu), KVM_X86_REG_KVM(KVM_REG_GUEST_SSP),
+                              &env->guest_ssp);
+        if (ret) {
+            return ret;
+        }
+    }
+    return 0;
+}
 
 static int kvm_get_xsave(X86CPU *cpu)
 {
@@ -5445,6 +5474,11 @@ int kvm_arch_put_registers(CPUState *cpu, KvmPutState level, Error **errp)
         error_setg_errno(errp, -ret, "Failed to set MSRs");
         return ret;
     }
+    ret = kvm_put_kvm_regs(x86_cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "Failed to set KVM type registers");
+        return ret;
+    }
     ret = kvm_put_vcpu_events(x86_cpu, level);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to set vCPU events");
@@ -5517,6 +5551,11 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
         error_setg_errno(errp, -ret, "Failed to get MSRs");
         goto out;
     }
+    ret = kvm_get_kvm_regs(cpu);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "Failed to get KVM type registers");
+        goto out;
+    }
     ret = kvm_get_apic(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret, "Failed to get APIC");
-- 
2.34.1


