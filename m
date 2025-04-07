Return-Path: <kvm+bounces-42805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A56A7D6B4
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 791F31883C75
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14674225A29;
	Mon,  7 Apr 2025 07:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RpaNHXXP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8768F192D68
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012212; cv=none; b=m0Pf3xUVS35/+0Blsq9XU9fVullN5Dsb9YG/ty+NrbNacNCB6zFFdxNuBScxL1XOM/qq//vQ6fXGXBI170GcaZxlnm5PDeaHpX1Zwti0OqeCN+9b9orN5LgCA5BFTzCF8h20f64w/aoy5fEn73NObdIMA6WTvSZBlvC1lXU+ziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012212; c=relaxed/simple;
	bh=jOVy7Ml6/2LDRm72chti/Lz4qTE3xrNmv1SgD04lXdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzwcj2V7H9z3prIMvQ8ceEbb6OtwFOgSTMgqeqpQlfD718Ft96p9AfCsnp+n1QSqCZqAhj6CXwYu2yBSuxzYZZiU4MNJXFZMz+uyAwS15AUphtm6Arloygzb8F4uZex39uGlRzhle/p/iCimz9zuNhDadH6NK5C0jyi+Cyn7KpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RpaNHXXP; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012211; x=1775548211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOVy7Ml6/2LDRm72chti/Lz4qTE3xrNmv1SgD04lXdk=;
  b=RpaNHXXPTpbfAJ7X2Ezmo/KIuqUWPfF/cKrxJScVWEVTX9uO2YqbOyTd
   djC5jmWzUydf8RLv0o2fHu9inQqqoaajYaZLQ5h6xsZNUpLjxadHhTLZO
   aDLQuaQbRlBxAHjHveSlvDwojxFhcRJOh8Dz+HfUaz8FivHJX9o5JzEN6
   Nd4jkHfeNxocb6V/C8GDmiCpcq4MPSKShROarU1yUHPDiCVj1CT7qhWYL
   zyDO6AMFKQCNTdFKD5WO0I2xaKp4zfgx5HxXgDgwLLuQpjA+gir7ejSMU
   MnzNOFTOdRjDC9wjJofSY+ZEtiy+d2nVZ9X2lVdSLXCe41ro7GJcnkVqw
   Q==;
X-CSE-ConnectionGUID: AsiSGhvNTFGEoJyTf0aofw==
X-CSE-MsgGUID: OqEFHlJnRGy4Unu6Kx3KeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857550"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857550"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:11 -0700
X-CSE-ConnectionGUID: WKLDJ1FmTiejDRlLKWWZ3Q==
X-CSE-MsgGUID: hw6BqKrnQpe7BwXSvQbjGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405620"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:07 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v4 06/13] vfio: Add the support for PrivateSharedManager Interface
Date: Mon,  7 Apr 2025 15:49:26 +0800
Message-ID: <20250407074939.18657-7-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subsystems like VFIO previously disabled ram block discard and only
allowed coordinated discarding via RamDiscardManager. However,
guest_memfd in confidential VMs relies on discard operations for page
conversion between private and shared memory. This can lead to stale
IOMMU mapping issue when assigning a hardware device to a confidential
VM via shared memory. With the introduction of PrivateSharedManager
interface to manage private and shared states and being distinct from
RamDiscardManager, include PrivateSharedManager in coordinated RAM
discard and add related support in VFIO.

Currently, migration support for confidential VMs is not available, so
vfio_sync_dirty_bitmap() handling for PrivateSharedListener can be
ignored. The register/unregister of PrivateSharedListener is necessary
during vfio_listener_region_add/del(). The listener callbacks are
similar between RamDiscardListener and PrivateSharedListener, allowing
for extraction of common parts opportunisticlly.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4
    - Newly added.
---
 hw/vfio/common.c                      | 104 +++++++++++++++++++++++---
 hw/vfio/container-base.c              |   1 +
 include/hw/vfio/vfio-container-base.h |  10 +++
 3 files changed, 105 insertions(+), 10 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 3172d877cc..48468a12c3 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -335,13 +335,9 @@ out:
     rcu_read_unlock();
 }
 
-static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
-                                            MemoryRegionSection *section)
+static void vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontainer,
+                                                    MemoryRegionSection *section)
 {
-    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
-    VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
-                                                listener);
-    VFIOContainerBase *bcontainer = vrdl->bcontainer;
     const hwaddr size = int128_get64(section->size);
     const hwaddr iova = section->offset_within_address_space;
     int ret;
@@ -354,13 +350,28 @@ static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
     }
 }
 
-static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
+static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
                                             MemoryRegionSection *section)
 {
     RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
-    VFIOContainerBase *bcontainer = vrdl->bcontainer;
+    vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
+}
+
+static void vfio_private_shared_notify_to_private(StateChangeListener *scl,
+                                                  MemoryRegionSection *section)
+{
+    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
+    VFIOPrivateSharedListener *vpsl = container_of(psl, VFIOPrivateSharedListener,
+                                                   listener);
+    vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
+}
+
+static int vfio_state_change_notify_to_state_set(VFIOContainerBase *bcontainer,
+                                                 MemoryRegionSection *section,
+                                                 uint64_t granularity)
+{
     const hwaddr end = section->offset_within_region +
                        int128_get64(section->size);
     hwaddr start, next, iova;
@@ -372,7 +383,7 @@ static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
      * unmap in minimum granularity later.
      */
     for (start = section->offset_within_region; start < end; start = next) {
-        next = ROUND_UP(start + 1, vrdl->granularity);
+        next = ROUND_UP(start + 1, granularity);
         next = MIN(next, end);
 
         iova = start - section->offset_within_region +
@@ -383,13 +394,33 @@ static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
                                      vaddr, section->readonly);
         if (ret) {
             /* Rollback */
-            vfio_ram_discard_notify_discard(scl, section);
+            vfio_state_change_notify_to_state_clear(bcontainer, section);
             return ret;
         }
     }
     return 0;
 }
 
+static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
+                                            MemoryRegionSection *section)
+{
+    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
+    VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
+                                                listener);
+    return vfio_state_change_notify_to_state_set(vrdl->bcontainer, section,
+                                                 vrdl->granularity);
+}
+
+static int vfio_private_shared_notify_to_shared(StateChangeListener *scl,
+                                                MemoryRegionSection *section)
+{
+    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
+    VFIOPrivateSharedListener *vpsl = container_of(psl, VFIOPrivateSharedListener,
+                                                   listener);
+    return vfio_state_change_notify_to_state_set(vpsl->bcontainer, section,
+                                                 vpsl->granularity);
+}
+
 static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
                                                MemoryRegionSection *section)
 {
@@ -466,6 +497,27 @@ static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
     }
 }
 
+static void vfio_register_private_shared_listener(VFIOContainerBase *bcontainer,
+                                                  MemoryRegionSection *section)
+{
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
+    VFIOPrivateSharedListener *vpsl;
+    PrivateSharedListener *psl;
+
+    vpsl = g_new0(VFIOPrivateSharedListener, 1);
+    vpsl->bcontainer = bcontainer;
+    vpsl->mr = section->mr;
+    vpsl->offset_within_address_space = section->offset_within_address_space;
+    vpsl->granularity = generic_state_manager_get_min_granularity(gsm,
+                                                                  section->mr);
+
+    psl = &vpsl->listener;
+    private_shared_listener_init(psl, vfio_private_shared_notify_to_shared,
+                                 vfio_private_shared_notify_to_private);
+    generic_state_manager_register_listener(gsm, &psl->scl, section);
+    QLIST_INSERT_HEAD(&bcontainer->vpsl_list, vpsl, next);
+}
+
 static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
                                                  MemoryRegionSection *section)
 {
@@ -491,6 +543,31 @@ static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
     g_free(vrdl);
 }
 
+static void vfio_unregister_private_shared_listener(VFIOContainerBase *bcontainer,
+                                                    MemoryRegionSection *section)
+{
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
+    VFIOPrivateSharedListener *vpsl = NULL;
+    PrivateSharedListener *psl;
+
+    QLIST_FOREACH(vpsl, &bcontainer->vpsl_list, next) {
+        if (vpsl->mr == section->mr &&
+            vpsl->offset_within_address_space ==
+            section->offset_within_address_space) {
+            break;
+        }
+    }
+
+    if (!vpsl) {
+        hw_error("vfio: Trying to unregister missing RAM discard listener");
+    }
+
+    psl = &vpsl->listener;
+    generic_state_manager_unregister_listener(gsm, &psl->scl);
+    QLIST_REMOVE(vpsl, next);
+    g_free(vpsl);
+}
+
 static bool vfio_known_safe_misalignment(MemoryRegionSection *section)
 {
     MemoryRegion *mr = section->mr;
@@ -644,6 +721,9 @@ static void vfio_listener_region_add(MemoryListener *listener,
     if (memory_region_has_ram_discard_manager(section->mr)) {
         vfio_register_ram_discard_listener(bcontainer, section);
         return;
+    } else if (memory_region_has_private_shared_manager(section->mr)) {
+        vfio_register_private_shared_listener(bcontainer, section);
+        return;
     }
 
     vaddr = memory_region_get_ram_ptr(section->mr) +
@@ -764,6 +844,10 @@ static void vfio_listener_region_del(MemoryListener *listener,
         vfio_unregister_ram_discard_listener(bcontainer, section);
         /* Unregistering will trigger an unmap. */
         try_unmap = false;
+    } else if (memory_region_has_private_shared_manager(section->mr)) {
+        vfio_unregister_private_shared_listener(bcontainer, section);
+        /* Unregistering will trigger an unmap. */
+        try_unmap = false;
     }
 
     if (try_unmap) {
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
index 749a3fd29d..ff5df925c2 100644
--- a/hw/vfio/container-base.c
+++ b/hw/vfio/container-base.c
@@ -135,6 +135,7 @@ static void vfio_container_instance_init(Object *obj)
     bcontainer->iova_ranges = NULL;
     QLIST_INIT(&bcontainer->giommu_list);
     QLIST_INIT(&bcontainer->vrdl_list);
+    QLIST_INIT(&bcontainer->vpsl_list);
 }
 
 static const TypeInfo types[] = {
diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
index 4cff9943ab..8d7c0b1179 100644
--- a/include/hw/vfio/vfio-container-base.h
+++ b/include/hw/vfio/vfio-container-base.h
@@ -47,6 +47,7 @@ typedef struct VFIOContainerBase {
     bool dirty_pages_started; /* Protected by BQL */
     QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
     QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
+    QLIST_HEAD(, VFIOPrivateSharedListener) vpsl_list;
     QLIST_ENTRY(VFIOContainerBase) next;
     QLIST_HEAD(, VFIODevice) device_list;
     GList *iova_ranges;
@@ -71,6 +72,15 @@ typedef struct VFIORamDiscardListener {
     QLIST_ENTRY(VFIORamDiscardListener) next;
 } VFIORamDiscardListener;
 
+typedef struct VFIOPrivateSharedListener {
+    VFIOContainerBase *bcontainer;
+    MemoryRegion *mr;
+    hwaddr offset_within_address_space;
+    uint64_t granularity;
+    PrivateSharedListener listener;
+    QLIST_ENTRY(VFIOPrivateSharedListener) next;
+} VFIOPrivateSharedListener;
+
 int vfio_container_dma_map(VFIOContainerBase *bcontainer,
                            hwaddr iova, ram_addr_t size,
                            void *vaddr, bool readonly);
-- 
2.43.5


