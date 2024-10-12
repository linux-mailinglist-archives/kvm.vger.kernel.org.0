Return-Path: <kvm+bounces-28685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED2699B2FD
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 12:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B656D1F23277
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 10:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B13154BEA;
	Sat, 12 Oct 2024 10:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SkaEnmQ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D79479
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 10:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728728941; cv=none; b=BAVqICtYLzrnitJTzZrA1KssB5nAed1p2NWa1IXyeBBNq1Efqev2JOnHrGYdGIP/pM2+j0a4j4+A6VWPLYRhkkPMdVwu5aLJrkFlOyAqb8ZKLa5PsREdqVv8OHE5J1oweWeRjoyelidIuUJhADzvyCXvhX1DGY7UTX4Y7JsEeDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728728941; c=relaxed/simple;
	bh=hTwITS9Ep9g3JTsw1ONqb/mB140UzyU2nuvpNS9Faz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VSKCwQ3u1GF5cjJQ0Ti6N2QLhf3neYmpeoswWpFb8cVcLhdCWxsRbF2XaXK7oxStn3tHubxD5s96MnOOm+UXC9NJs6AACtIxgwaxavtPbxM3pWZ7WGqGUn7n4KrZZyRhhmyj4ZsGzrUw/yPyRPzjT+8EzKzzJYop/vxGMeAy6zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SkaEnmQ9; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728728940; x=1760264940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTwITS9Ep9g3JTsw1ONqb/mB140UzyU2nuvpNS9Faz0=;
  b=SkaEnmQ9UwHk3NkxPMrX3CbTkL+z6RXKs9DSyIjY1EvyzsN7Eg+X3kdj
   Wdu4a2KKaWLU3BnlSM7zJq8OIBSIlc5Azl+LIOjpoXDjVafsEKr/5aZpC
   eoQNuxQhSBfxaD/svKSH856ZPy2kE8GJWJ8d2S/0c2yBMjq+FA3+aoGBI
   dXGa/j7nLHfpyMFdnj3GQkgMPcPfpaxnlXN5RPR3asYpw9bv0bzQxGWHY
   GldagrFMBVv6w+ollyXXP8U2LS48VNHR0CkfCgqdtjlE+NUQWw6c8L603
   /CtkKDolviTxFirsg4wPSTCyHWXPpPWRVOG5f90UpEE4UuUnvmB2Gwjjq
   w==;
X-CSE-ConnectionGUID: +xLu/mWBQ5CAUtbcsQAR2Q==
X-CSE-MsgGUID: bq7Xd3dhRgeBkLlKf6PzbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="45634926"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="45634926"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 03:29:00 -0700
X-CSE-ConnectionGUID: tTkP4fn+TRq8J33ibN7BkQ==
X-CSE-MsgGUID: bzdAmRy2SkWle//aCvYwJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="77050857"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa010.jf.intel.com with ESMTP; 12 Oct 2024 03:28:54 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v3 5/7] i386/cpu: Update cache topology with machine's configuration
Date: Sat, 12 Oct 2024 18:44:27 +0800
Message-Id: <20241012104429.1048908-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241012104429.1048908-1-zhao1.liu@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
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
Changes since RFC v2:
 * Used smp_cache array to override cache topology.
 * Wrapped the updating into a function.
---
 target/i386/cpu.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 202bfe5086be..c8a04faf3764 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7597,6 +7597,38 @@ static void x86_cpu_hyperv_realize(X86CPU *cpu)
     cpu->hyperv_limits[2] = 0;
 }
 
+#ifndef CONFIG_USER_ONLY
+static void x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+    CpuTopologyLevel level;
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l1d_cache->share_level = level;
+        env->cache_info_amd.l1d_cache->share_level = level;
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l1i_cache->share_level = level;
+        env->cache_info_amd.l1i_cache->share_level = level;
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l2_cache->share_level = level;
+        env->cache_info_amd.l2_cache->share_level = level;
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l3_cache->share_level = level;
+        env->cache_info_amd.l3_cache->share_level = level;
+    }
+}
+#endif
+
 static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
@@ -7821,6 +7853,13 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+
+    /*
+     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless Updates
+     * if user didn't set smp_cache.
+     */
+    x86_cpu_update_smp_cache_topo(ms, cpu);
+
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
 
     if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
-- 
2.34.1


