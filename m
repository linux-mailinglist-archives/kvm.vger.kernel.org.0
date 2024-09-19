Return-Path: <kvm+bounces-27114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDDC597C290
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A3451F21C92
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB7DF18E1E;
	Thu, 19 Sep 2024 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVt8drsX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E75E12E48
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710066; cv=none; b=ratvZkpVhHVBd4uJurWHTMHy8YnFl3WxqJttyWjvi2cklL2Wh5w1aI0YJ9/fSsIx0iC/nm3nDSeW2G703InNJ6feMKOyb2Wv+5j8X7PpGL2yEG47lDm1czsZeqy+xd5PqBSzxTs5cNN+HnWI/2w/d1use1UlwGe32FOENzDR8LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710066; c=relaxed/simple;
	bh=wx8cdMXy87jbp3iDhkGcf2ZrKApAXiC+ip9Awek7e04=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XgDipk2aSaw2nDn3BdPeGF2kjeQJp85CazAAjrvii6VUv6kElsoLFreBOLvsOKy+28sWlxb78DEEjtvKYrrcvDmyjcb8aVFIsTr0VYhjJIJXSAFnDMtNylth25yWBcgQdj8yMeygdJarDtOq5tSSMZJXgPoxWbbmoIll402KTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gVt8drsX; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710065; x=1758246065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wx8cdMXy87jbp3iDhkGcf2ZrKApAXiC+ip9Awek7e04=;
  b=gVt8drsXqmRkbo6+GQea83+KmLahDIpqehv2HzPvc19pppwlKKhbO+yZ
   bTuaR0npy3D5FzUh4cFwO49OIsiDBZKKBXNhXEBfSgzDgTpaWaT/9WtGO
   Ug+DqlgG/E05M1VlJj/VGzoomR9QN0XzJZDx58EOaZI7Cv9gI/G96bxXg
   qRyn5VNz+a7ep0MjLY9+IDJAyCWvYEGXh0M5sWkqB+789lkT2zSQcbB2W
   5GwtSkkSMGNtIU7aZpBRXeEHlfrU5IWhXZ53n8EVwQsB6TV11aKw4Cemc
   E1YmRBkqMWtY7WFft2kaxkhGlJQwdJOC/SRQUXp9rLcQjxESbrj7O3O94
   A==;
X-CSE-ConnectionGUID: JOgoJLSVRMGpLvrTX8mnPw==
X-CSE-MsgGUID: G4jZ0ZriTy+2jxaj/cSfdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25798067"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25798067"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:41:04 -0700
X-CSE-ConnectionGUID: /9zU/3CdSJut5CeCqd6www==
X-CSE-MsgGUID: 6BJoj00JRPy92lBgaz2/QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70058955"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 18 Sep 2024 18:40:58 -0700
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
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 12/15] hw/i386: Allow i386 to create new CPUs in topology tree
Date: Thu, 19 Sep 2024 09:55:30 +0800
Message-Id: <20240919015533.766754-13-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919015533.766754-1-zhao1.liu@intel.com>
References: <20240919015533.766754-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For x86, CPU's apic ID represent its topology path and is the
combination of topology sub IDs in each leavl.

When x86 machine creates CPUs, to insert the CPU into topology tree, use
apic ID to get topology sub IDs.

Then search the topology tree for the corresponding parent topology
device and insert the CPU into the CPU bus of the parent device.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86-common.c | 101 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 97 insertions(+), 4 deletions(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index b21d2ab97349..a7f082b0a90b 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -53,14 +53,107 @@
 /* Physical Address of PVH entry point read from kernel ELF NOTE */
 static size_t pvh_start_addr;
 
-static void x86_cpu_new(X86MachineState *x86ms, int64_t apic_id, Error **errp)
+static int x86_cpu_get_topo_id(const X86CPUTopoIDs *topo_ids,
+                               CpuTopologyLevel level)
 {
-    Object *cpu = object_new(MACHINE(x86ms)->cpu_type);
+    switch (level) {
+    case CPU_TOPOLOGY_LEVEL_THREAD:
+        return topo_ids->smt_id;
+    case CPU_TOPOLOGY_LEVEL_CORE:
+        return topo_ids->core_id;
+    case CPU_TOPOLOGY_LEVEL_MODULE:
+        return topo_ids->module_id;
+    case CPU_TOPOLOGY_LEVEL_DIE:
+        return topo_ids->die_id;
+    case CPU_TOPOLOGY_LEVEL_SOCKET:
+        return topo_ids->pkg_id;
+    default:
+        g_assert_not_reached();
+    }
+
+    return -1;
+}
+
+typedef struct SearchCoreCb {
+    const X86CPUTopoIDs *topo_ids;
+    const CPUTopoState *parent;
+} SearchCoreCb;
+
+static int x86_search_topo_parent(DeviceState *dev, void *opaque)
+{
+    CPUTopoState *topo = CPU_TOPO(dev);
+    CpuTopologyLevel level = GET_CPU_TOPO_LEVEL(topo);
+    SearchCoreCb *cb = opaque;
+    int topo_id, index;
+
+    topo_id = x86_cpu_get_topo_id(cb->topo_ids, level);
+    index = cpu_topo_get_index(topo);
+
+    if (topo_id < 0) {
+        error_report("Invalid %s-id: %d",
+                     CpuTopologyLevel_str(level), topo_id);
+        error_printf("Try to set the %s-id in [0-%d].\n",
+                     CpuTopologyLevel_str(level),
+                     cpu_topo_get_instances_num(topo) - 1);
+        return TOPO_FOREACH_ERR;
+    }
+
+    if (topo_id == index) {
+        if (level == CPU_TOPOLOGY_LEVEL_CORE) {
+            cb->parent = topo;
+            /* The error result could exit directly. */
+            return TOPO_FOREACH_ERR;
+        }
+        return TOPO_FOREACH_CONTINUE;
+    }
+    return TOPO_FOREACH_END;
+}
+
+static BusState *x86_find_topo_bus(MachineState *ms, X86CPUTopoIDs *topo_ids)
+{
+    SearchCoreCb cb;
+
+    cb.topo_ids = topo_ids;
+    cb.parent = NULL;
+    qbus_walk_children(BUS(&ms->topo->bus), x86_search_topo_parent,
+                       NULL, NULL, NULL, &cb);
+
+    if (!cb.parent) {
+        return NULL;
+    }
+
+    return BUS(cb.parent->bus);
+}
+
+static void x86_cpu_new(X86MachineState *x86ms, int index,
+                        int64_t apic_id, Error **errp)
+{
+    MachineState *ms = MACHINE(x86ms);
+    MachineClass *mc = MACHINE_GET_CLASS(ms);
+    Object *cpu = object_new(ms->cpu_type);
+    DeviceState *dev = DEVICE(cpu);
+    BusState *bus = NULL;
+
+    /*
+     * Once x86 machine supports topo_tree_supported, x86 CPU would
+     * also have bus_type.
+     */
+    if (mc->smp_props.topo_tree_supported) {
+        X86CPUTopoIDs topo_ids;
+        X86CPUTopoInfo topo_info;
+
+        init_topo_info(&topo_info, x86ms);
+        x86_topo_ids_from_apicid(apic_id, &topo_info, &topo_ids);
+        bus = x86_find_topo_bus(ms, &topo_ids);
+
+        /* Only with dev->id, CPU can be inserted into topology tree. */
+        dev->id = g_strdup_printf("%s[%d]", ms->cpu_type, index);
+    }
 
     if (!object_property_set_uint(cpu, "apic-id", apic_id, errp)) {
         goto out;
     }
-    qdev_realize(DEVICE(cpu), NULL, errp);
+    qdev_realize(dev, bus, errp);
 
 out:
     object_unref(cpu);
@@ -111,7 +204,7 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 
     possible_cpus = mc->possible_cpu_arch_ids(ms);
     for (i = 0; i < ms->smp.cpus; i++) {
-        x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
+        x86_cpu_new(x86ms, i, possible_cpus->cpus[i].arch_id, &error_fatal);
     }
 }
 
-- 
2.34.1


