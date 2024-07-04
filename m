Return-Path: <kvm+bounces-20928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CE9D926DBF
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 05:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEA661F24497
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B3917C73;
	Thu,  4 Jul 2024 03:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cWFSnOzv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597701B7F4
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 03:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062055; cv=none; b=LArVrH6IgA3ItbhQRgBqqoS4N0XUDNgaYbQIb6px9jpBzdnU7n7A+qgvUlOldIVo119XLJRJkzo17pgWvWiNHzVfQNAYMYgPxDdIo2lzoGDcYazprLRoSkeMmMV9PhIlbq/+gVdWMHqe6Y6+lDp3Vlm1udt3WQ9nFuo9FtQ+n3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062055; c=relaxed/simple;
	bh=O2y+4W7xDQI5Ehrauiwct9/OVeYocKJKMH4u39+XG9I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mEEcsXu8LL8GK8LVVvIZmz9L0IzcehkH8OKAAo3du25wBQ3ysTbd6tqvQPk7c10XZrgVJGgFQ5w7ZOXpblKA+1qfcuJhZgR2zqVXBdJnT6Od99vYV0XJBdFKjTLyjgePYXF3Xj3qDAOonNtIgcBi5VCBcz5+KzIaTLFlt9sWvt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cWFSnOzv; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720062053; x=1751598053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O2y+4W7xDQI5Ehrauiwct9/OVeYocKJKMH4u39+XG9I=;
  b=cWFSnOzvrYq2zViXJ5uUCoxCXe+ArfjA1joiH6KiwUeGmUrFLbMM9CCJ
   Y6ZGuUfjEhjKmRabZSVg1OCB0Jdy5t/eVFwEmGe2NbYtjJRcaLWgXOo8/
   z+62x5EBNGKaVvDkCwNGkCKyy/iIwy581DsJpo+08oqCL/Nih8slgykoy
   gIbPsoENHkOLjWH85KpwtVa+0T10hfy/irs+ENge2kXv6h0VaaIRLChqY
   OfYZB+xAtWhQ1LATmer1PSJB4iSc2ZW0DFN1p2qpbYAob3ZP5WuctNvxy
   up2Y1RfKt3HDobatQ+azu3DmWnGu7ox9lOs2Da+dgJl1K3JDojKgG16iu
   Q==;
X-CSE-ConnectionGUID: bz1T5beOQJeemb+u/xLwuw==
X-CSE-MsgGUID: 4XfcfhhHTICGRwOOp2nEug==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39838103"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="39838103"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 20:00:51 -0700
X-CSE-ConnectionGUID: /7A5MSBTTam4dTB6DCKBFg==
X-CSE-MsgGUID: azFKFs3BSMWR4qbPeaPRsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51052203"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Jul 2024 20:00:43 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
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
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 3/8] hw/core: Add smp cache topology for machine
Date: Thu,  4 Jul 2024 11:15:58 +0800
Message-Id: <20240704031603.1744546-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240704031603.1744546-1-zhao1.liu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With smp-cache object support, add smp cache topology for machine by
linking the smp-cache object.

Also add a helper to access cache topology level.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC v2:
 * Linked machine's smp_cache to smp-cache object instead of a builtin
   structure. This is to get around the fact that the keyval format of
   -machine can't support JSON.
 * Wrapped the cache topology level access into a helper.
---
 hw/core/machine-smp.c | 6 ++++++
 hw/core/machine.c     | 9 +++++++++
 include/hw/boards.h   | 5 ++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 5d8d7edcbd3f..88a73743eb1c 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -270,3 +270,9 @@ unsigned int machine_topo_get_threads_per_socket(const MachineState *ms)
 {
     return ms->smp.threads * machine_topo_get_cores_per_socket(ms);
 }
+
+CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
+                                              SMPCacheName cache)
+{
+    return ms->smp_cache->props[cache].topo;
+}
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 655d75c21fc1..09ef9fcd4a0b 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1045,6 +1045,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "smp",
         "CPU topology");
 
+    /* TODO: Implement check() method based on machine support. */
+    object_class_property_add_link(oc, "smp-cache",
+                                   TYPE_SMP_CACHE,
+                                   offsetof(MachineState, smp_cache),
+                                   object_property_allow_set_link,
+                                   OBJ_PROP_LINK_STRONG);
+    object_class_property_set_description(oc, "smp-cache",
+        "SMP cache property");
+
     object_class_property_add(oc, "phandle-start", "int",
         machine_get_phandle_start, machine_set_phandle_start,
         NULL, NULL);
diff --git a/include/hw/boards.h b/include/hw/boards.h
index ef6f18f2c1a7..56fa252cfcd2 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -6,10 +6,10 @@
 #include "exec/memory.h"
 #include "sysemu/hostmem.h"
 #include "sysemu/blockdev.h"
-#include "qapi/qapi-types-machine.h"
 #include "qemu/module.h"
 #include "qom/object.h"
 #include "hw/core/cpu.h"
+#include "hw/core/smp-cache.h"
 
 #define TYPE_MACHINE_SUFFIX "-machine"
 
@@ -45,6 +45,8 @@ void machine_parse_smp_config(MachineState *ms,
                               const SMPConfiguration *config, Error **errp);
 unsigned int machine_topo_get_cores_per_socket(const MachineState *ms);
 unsigned int machine_topo_get_threads_per_socket(const MachineState *ms);
+CpuTopologyLevel machine_get_cache_topo_level(const MachineState *ms,
+                                              SMPCacheName cache);
 void machine_memory_devices_init(MachineState *ms, hwaddr base, uint64_t size);
 
 /**
@@ -409,6 +411,7 @@ struct MachineState {
     AccelState *accelerator;
     CPUArchIdList *possible_cpus;
     CpuTopology smp;
+    SMPCache *smp_cache;
     struct NVDIMMState *nvdimms_state;
     struct NumaState *numa_state;
 };
-- 
2.34.1


