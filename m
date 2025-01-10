Return-Path: <kvm+bounces-35052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD4DA09389
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 15:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53EBE188BFF0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3040D21128D;
	Fri, 10 Jan 2025 14:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4/cmLoW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B766A21127E
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519584; cv=none; b=XMnfNZ5MYWZqHcCNOqBbXTg6zx2GvP6uxaczH2qfLtsGVlokSk5NTUNd7CKvaTZnR9oxy8WtvMdi7pMTaLCYtTxysDJKFRK2lM2r62RoAi+fYUfZLMKcJAXm0pWSCa6TY1D5B7Fu8DGZlnIAeGulORGRc6PCxYlXizli+yPH0rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519584; c=relaxed/simple;
	bh=4zIiyRBJx2uUEgy/m5M23r7WgU1QXI3Eb0MeZznc3Pk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F7j31EKQoCacLJBb2bxGec3Nx2ZCvntd7sw56OyaUkxq5dgqn++nUIM3ntjwAQIEVC1N7jylJrWTflelC+HIRO2ymhqcUDUCL7If2lzCChIZkCOE9i47IsaZopo/mTHI7mbRwQofKagqOHasPWcJ+lKEyUrUVf+Vx1u/Iuapubk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4/cmLoW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736519582; x=1768055582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4zIiyRBJx2uUEgy/m5M23r7WgU1QXI3Eb0MeZznc3Pk=;
  b=e4/cmLoWM2TbNfouH7oGYB9PFI5IXnXDHXwsgI96yyJZXmWGE1r6Dqad
   USyiPrdns/9zmurtmzV1AWcDzDaWrtsl0Hzyi+IOhu0mU8gAbxcykDkrp
   ozyVikX9eE/TQi22XosRjY2/YESHDi6Hjiqb6bo6Ub7TMH16M98mJRPN9
   nPviQIfMheqBD+vDwNpVPzgMSPX8CV/GPqliLKTO+nBfWhLORvb1hxcJ3
   q3yA5ARXk6/6ml6VTRpUXoiJNNckX9tHEfVbbtK2AqM1sSLLPki9J82oZ
   cMehvVn2xUH0suKRyY1eJQlPcBI3yXE4xxWYSiCFKxDzErdKmrBQ0wfov
   Q==;
X-CSE-ConnectionGUID: vW0dxKaYTDSS///aExfSSA==
X-CSE-MsgGUID: qfbigOvWTGCxeD9rh3UE0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="62185522"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="62185522"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 06:33:02 -0800
X-CSE-ConnectionGUID: 5uvsCvEhStiwdcSy6Bcagg==
X-CSE-MsgGUID: bNUJw0NfRi2Q7V2MmXdSoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108790869"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 10 Jan 2025 06:32:58 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 RESEND 3/5] i386/cpu: Update cache topology with machine's configuration
Date: Fri, 10 Jan 2025 22:51:13 +0800
Message-Id: <20250110145115.1574345-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250110145115.1574345-1-zhao1.liu@intel.com>
References: <20250110145115.1574345-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User will configure smp cache topology via -machine smp-cache.

For this case, update the x86 CPUs' cache topology with user's
configuration in MachineState.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes since Patch v3:
 * Updated MachineState.smp_cache to consume "default" level and did a
   check to ensure topological hierarchical relationships are correct.
---
 target/i386/cpu.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4728373fdf03..b6d6c4b96d49 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7758,6 +7758,64 @@ static void x86_cpu_hyperv_realize(X86CPU *cpu)
     cpu->hyperv_limits[2] = 0;
 }
 
+#ifndef CONFIG_USER_ONLY
+static bool x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu,
+                                          Error **errp)
+{
+    CPUX86State *env = &cpu->env;
+    CpuTopologyLevel level;
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l1d_cache->share_level = level;
+        env->cache_info_amd.l1d_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
+            env->cache_info_cpuid4.l1d_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
+            env->cache_info_amd.l1d_cache->share_level);
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l1i_cache->share_level = level;
+        env->cache_info_amd.l1i_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
+            env->cache_info_cpuid4.l1i_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
+            env->cache_info_amd.l1i_cache->share_level);
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l2_cache->share_level = level;
+        env->cache_info_amd.l2_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
+            env->cache_info_cpuid4.l2_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
+            env->cache_info_amd.l2_cache->share_level);
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l3_cache->share_level = level;
+        env->cache_info_amd.l3_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
+            env->cache_info_cpuid4.l3_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
+            env->cache_info_amd.l3_cache->share_level);
+    }
+
+    if (!machine_check_smp_cache(ms, errp)) {
+        return false;
+    }
+    return true;
+}
+#endif
+
 static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
@@ -7982,6 +8040,15 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+
+    /*
+     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless updates
+     * if user didn't set smp_cache.
+     */
+    if (!x86_cpu_update_smp_cache_topo(ms, cpu, errp)) {
+        return;
+    }
+
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
 
     if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
-- 
2.34.1


