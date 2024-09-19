Return-Path: <kvm+bounces-27163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 020D497C3FF
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87FFA1F21ECC
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7B212D214;
	Thu, 19 Sep 2024 05:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoD3HZYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8174424
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725375; cv=none; b=heg61Nf2E44LG0qPs0vSWSjLczjjPJPbhCY024jQhIPvFK73OVclZpMmPdpT0Z3CUfiAuVp4QetxrjdirDCbtAOOb2IIieXE78MYiRGLp8x24CIKNqGCZbpQt/9ZsNpid6PLUpjLQ5dWIojVJfi3g9NWeRi9hvkqEEnGbK6hO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725375; c=relaxed/simple;
	bh=NEuBE48juMTcQ/dJZHqJkRWuT1BVDd+3siUk37y9rsM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dEZfL83cQldekjQGx21F4/iSIUSlSAEbJFWnWVT8d/wa/+pu2ZtEkY52Pv+OHdcaZOOL7CyYFBguWonVzWmoh41ETT8HX3OuUMe/IfIoPl1gmv1Cg1IayNTpG4iCrabe+fJN0uP/h6FGRJehbXosuB2un2j0jXsCRhom0hjFkhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoD3HZYs; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725374; x=1758261374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NEuBE48juMTcQ/dJZHqJkRWuT1BVDd+3siUk37y9rsM=;
  b=EoD3HZYsPUlyJS6ZdixZSECaSEyFeI+wUDRqOBN498a2ZWdJBASDBec+
   sA0zGCDhr9JJmgHnr7Wpxq0pGUwrfap6i+AOLVfIZhT8zuGYd45w1C3ef
   ITUXQJyP9U9rSodyRitLoylG7v9B4rGvA9So4k3Z0qTjLpkvw7EOUIigd
   20DBgvNW5J1kswXEskiwkPNYViayDinj9O5jPEpm6WhibDDo+YfTvT6/P
   h4RQO15/iq6xY13w5Q9g+CsyKS2wEfRReGvbryiy5dDQxfxQdGjVE0SA0
   LRt3cuslQ1JhXiGwjlbtC0kEFrXWUDKaHrTVDvOZIljTkuMs6glnqyCmK
   A==;
X-CSE-ConnectionGUID: 2z2B/baAQq2XyjkwWomkTw==
X-CSE-MsgGUID: HePOw8JVT6Cjr9CvNqnG3g==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813632"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813632"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:13 -0700
X-CSE-ConnectionGUID: uRrDVkRIRWuVWkVS9YAxng==
X-CSE-MsgGUID: NLGU4weHTJKIgFAW97vQLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418749"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:56:07 -0700
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
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 07/12] hw/core: Re-implement topology helpers to honor max limitations
Date: Thu, 19 Sep 2024 14:11:23 +0800
Message-Id: <20240919061128.769139-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For custom topology case, the valid and reliable topology information
be obtained from topology max limitations.

Therefore, re-implement machine_topo_get_cores_per_socket() and
machine_topo_get_threads_per_socket() to consider the custom topology
case. And further, use the wrapped helper to set CPUState.nr_threads/
nr_cores, avoiding topology mismatches in custom topology scenarios.

Additionally, since test-smp-parse needs more stubs to compile with
cpu-slot.c, keep the old helpers for test-smp-parse' use for now. The
legacy old helpers will be cleaned up when full compilation support is
added later on.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/core/machine-smp.c       |  8 +++++---
 hw/cpu/cpu-slot.c           | 18 ++++++++++++++++++
 include/hw/boards.h         |  9 +++++++--
 include/hw/cpu/cpu-slot.h   |  2 ++
 system/cpus.c               |  2 +-
 tests/unit/test-smp-parse.c |  4 ++--
 6 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index d3be4352267d..2965b042fd92 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -376,14 +376,16 @@ bool machine_parse_smp_cache(MachineState *ms,
     return true;
 }
 
-unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
+unsigned int machine_topo_get_cores_per_socket_old(const MachineState *ms)
 {
+    assert(!ms->topo);
     return ms->smp.cores * ms->smp.modules * ms->smp.clusters * ms->smp.dies;
 }
 
-unsigned int machine_topo_get_threads_per_socket(const MachineState *ms)
+unsigned int machine_topo_get_threads_per_socket_old(const MachineState *ms)
 {
-    return ms->smp.threads * machine_topo_get_cores_per_socket(ms);
+    assert(!ms->topo);
+    return ms->smp.threads * machine_topo_get_cores_per_socket_old(ms);
 }
 
 CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
diff --git a/hw/cpu/cpu-slot.c b/hw/cpu/cpu-slot.c
index f2b9c412926f..8c0d55e835e2 100644
--- a/hw/cpu/cpu-slot.c
+++ b/hw/cpu/cpu-slot.c
@@ -204,6 +204,8 @@ static int get_smp_info_by_level(const CpuTopology *smp_info,
         return smp_info->cores;
     case CPU_TOPOLOGY_LEVEL_MODULE:
         return smp_info->modules;
+    case CPU_TOPOLOGY_LEVEL_CLUSTER:
+        return smp_info->clusters;
     case CPU_TOPOLOGY_LEVEL_DIE:
         return smp_info->dies;
     case CPU_TOPOLOGY_LEVEL_SOCKET:
@@ -356,6 +358,22 @@ int get_max_topo_by_level(const MachineState *ms, CpuTopologyLevel level)
     return ms->topo->stat.entries[level].max_limit;
 }
 
+unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
+{
+    int cores = 1, i;
+
+    for (i = CPU_TOPOLOGY_LEVEL_CORE; i < CPU_TOPOLOGY_LEVEL_SOCKET; i++) {
+        cores *= get_max_topo_by_level(ms, i);
+    }
+    return cores;
+}
+
+unsigned int machine_topo_get_threads_per_socket(const MachineState *ms)
+{
+    return get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_THREAD) *
+           machine_topo_get_cores_per_socket(ms);
+}
+
 bool machine_parse_custom_topo_config(MachineState *ms,
                                       const SMPConfiguration *config,
                                       Error **errp)
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 6ef4ea322590..faf7859debdd 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -48,8 +48,13 @@ void machine_parse_smp_config(MachineState *ms,
 bool machine_parse_smp_cache(MachineState *ms,
                              const SmpCachePropertiesList *caches,
                              Error **errp);
-unsigned int machine_topo_get_cores_per_socket(const MachineState *ms);
-unsigned int machine_topo_get_threads_per_socket(const MachineState *ms);
+/*
+ * TODO: Drop these old helpers when cpu-slot.c could be compiled for
+ * test-smp-parse. Pls use machine_topo_get_cores_per_socket() and
+ * machine_topo_get_threads_per_socket() instead.
+ */
+unsigned int machine_topo_get_cores_per_socket_old(const MachineState *ms);
+unsigned int machine_topo_get_threads_per_socket_old(const MachineState *ms);
 CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
                                               CacheLevelAndType cache);
 void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size);
diff --git a/include/hw/cpu/cpu-slot.h b/include/hw/cpu/cpu-slot.h
index f56a0b08dca4..230309b67fe1 100644
--- a/include/hw/cpu/cpu-slot.h
+++ b/include/hw/cpu/cpu-slot.h
@@ -81,6 +81,8 @@ struct CPUSlot {
 void machine_plug_cpu_slot(MachineState *ms);
 bool machine_create_topo_tree(MachineState *ms, Error **errp);
 int get_max_topo_by_level(const MachineState *ms, CpuTopologyLevel level);
+unsigned int machine_topo_get_cores_per_socket(const MachineState *ms);
+unsigned int machine_topo_get_threads_per_socket(const MachineState *ms);
 bool machine_parse_custom_topo_config(MachineState *ms,
                                       const SMPConfiguration *config,
                                       Error **errp);
diff --git a/system/cpus.c b/system/cpus.c
index 1c818ff6828c..53e7cfb8a55f 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -667,7 +667,7 @@ void qemu_init_vcpu(CPUState *cpu)
     MachineState *ms = MACHINE(qdev_get_machine());
 
     cpu->nr_cores = machine_topo_get_cores_per_socket(ms);
-    cpu->nr_threads =  ms->smp.threads;
+    cpu->nr_threads = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_THREAD);
     cpu->stopped = true;
     cpu->random_seed = qemu_guest_random_seed_thread_part1();
 
diff --git a/tests/unit/test-smp-parse.c b/tests/unit/test-smp-parse.c
index f9bccb56abc7..44d2213a7163 100644
--- a/tests/unit/test-smp-parse.c
+++ b/tests/unit/test-smp-parse.c
@@ -801,8 +801,8 @@ static void check_parse(MachineState *ms, const SMPConfiguration *config,
     /* call the generic parser */
     machine_parse_smp_config(ms, config, &err);
 
-    ms_threads_per_socket = machine_topo_get_threads_per_socket(ms);
-    ms_cores_per_socket = machine_topo_get_cores_per_socket(ms);
+    ms_threads_per_socket = machine_topo_get_threads_per_socket_old(ms);
+    ms_cores_per_socket = machine_topo_get_cores_per_socket_old(ms);
     output_topo_str = cpu_topology_to_string(&ms->smp,
                                              ms_threads_per_socket,
                                              ms_cores_per_socket,
-- 
2.34.1


