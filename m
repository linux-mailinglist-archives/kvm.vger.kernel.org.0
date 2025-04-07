Return-Path: <kvm+bounces-42803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C454A7D6C6
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E08D416C4B3
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9511A8F93;
	Mon,  7 Apr 2025 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XknWAoLf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592B11A315F
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012206; cv=none; b=YneflveHYkGnOhagb1e0dU04zHb2EAHGmV4MqEH2K8fI/VQJY66bDgQTjWJvIz7RDWoxVpUWU5RGnbjtwawQN1dxgcxDKfYhtigKNuCMYjjSILyC6p9VwLeJaPBtSdpnAZpt4pMlIK3Rp4ZN4Pj6vj9rLVr+MCcXIOQc1OQTTMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012206; c=relaxed/simple;
	bh=myUEliAmem5ZX9Ho5nThrumB00xjkd8o41CqMTLUqlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8cV7lyFbucI1A7A01TSCgIGrdAUoLnRlXiJRHidHXAr4ZU9VTaEY9ZCREsfnsgrWhPGge4DNPgFo26SjsNxC1Kd/jKbLwY8EaqTnxgFOcZnWrqQHP47YPh02BpMHmDxdIDPq04iaZntf9rsw9AEYpSlDyWKNLDSr1PrMw2wvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XknWAoLf; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012204; x=1775548204;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=myUEliAmem5ZX9Ho5nThrumB00xjkd8o41CqMTLUqlg=;
  b=XknWAoLf377qXdtVzBfhPkW0vNEiZUN+cehJ8gqJ7I1Kd9VFixFvVJ8H
   Mqnv5XoteOhSYZeDtGmiQKfCKcqbjyxQhSU02kqneAWTd3RAlRrjPVhOO
   sprLEfuGuQrdQiCpJWPhVWtGVrfNC8Z51W3VSy//YY85C352ngdHxsXq9
   Nsz+vX+2n61eTfQpCIo+/kbt2wzwLhJ5zOZ4Fwb1xkEoobbpInEkBcYZs
   OtWQ7EvC1xtppMLp83Rxz/W6pbS+J4FRkOOrqxZ5mcVdlsXGbOH0bKzYm
   pqp06mn+zbkO/2UrsoJrjK5Ew3XP709QbhpPKAhnAcEstHq/kEbdYHTFg
   Q==;
X-CSE-ConnectionGUID: rvLePpiGQfei4uaqCu4i5g==
X-CSE-MsgGUID: LC7iCajwQ1misaAxHRxolg==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857533"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857533"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:03 -0700
X-CSE-ConnectionGUID: 0kVwWi0pQVCZT4RDvEUfJw==
X-CSE-MsgGUID: v7jnTIrwRkSktBAZCJ4zEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405523"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:49:59 -0700
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
Subject: [PATCH v4 04/13] memory: Introduce generic state change parent class for RamDiscardManager
Date: Mon,  7 Apr 2025 15:49:24 +0800
Message-ID: <20250407074939.18657-5-chenyi.qiang@intel.com>
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

RamDiscardManager is an interface used by virtio-mem to adjust VFIO
mappings in relation to VM page assignment. It manages the state of
populated and discard for the RAM. To accommodate future scnarios for
managing RAM states, such as private and shared states in confidential
VMs, the existing RamDiscardManager interface needs to be generalized.

Introduce a parent class, GenericStateManager, to manage a pair of
opposite states with RamDiscardManager as its child. The changes include
- Define a new abstract class GenericStateChange.
- Extract six callbacks into GenericStateChangeClass and allow the child
  classes to inherit them.
- Modify RamDiscardManager-related helpers to use GenericStateManager
  ones.
- Define a generic StatChangeListener to extract fields from
  RamDiscardManager listener which allows future listeners to embed it
  and avoid duplication.
- Change the users of RamDiscardManager (virtio-mem, migration, etc.) to
  switch to use GenericStateChange helpers.

It can provide a more flexible and resuable framework for RAM state
management, facilitating future enhancements and use cases.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Newly added.
---
 hw/vfio/common.c        |  30 ++--
 hw/virtio/virtio-mem.c  |  95 ++++++------
 include/exec/memory.h   | 313 ++++++++++++++++++++++------------------
 migration/ram.c         |  16 +-
 system/memory.c         | 106 ++++++++------
 system/memory_mapping.c |   6 +-
 6 files changed, 310 insertions(+), 256 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index f7499a9b74..3172d877cc 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -335,9 +335,10 @@ out:
     rcu_read_unlock();
 }
 
-static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
+static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
                                             MemoryRegionSection *section)
 {
+    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
     VFIOContainerBase *bcontainer = vrdl->bcontainer;
@@ -353,9 +354,10 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
     }
 }
 
-static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
+static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
                                             MemoryRegionSection *section)
 {
+    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
     VFIOContainerBase *bcontainer = vrdl->bcontainer;
@@ -381,7 +383,7 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
                                      vaddr, section->readonly);
         if (ret) {
             /* Rollback */
-            vfio_ram_discard_notify_discard(rdl, section);
+            vfio_ram_discard_notify_discard(scl, section);
             return ret;
         }
     }
@@ -391,8 +393,9 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
 static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
                                                MemoryRegionSection *section)
 {
-    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
     VFIORamDiscardListener *vrdl;
+    RamDiscardListener *rdl;
 
     /* Ignore some corner cases not relevant in practice. */
     g_assert(QEMU_IS_ALIGNED(section->offset_within_region, TARGET_PAGE_SIZE));
@@ -405,17 +408,18 @@ static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
     vrdl->mr = section->mr;
     vrdl->offset_within_address_space = section->offset_within_address_space;
     vrdl->size = int128_get64(section->size);
-    vrdl->granularity = ram_discard_manager_get_min_granularity(rdm,
-                                                                section->mr);
+    vrdl->granularity = generic_state_manager_get_min_granularity(gsm,
+                                                                  section->mr);
 
     g_assert(vrdl->granularity && is_power_of_2(vrdl->granularity));
     g_assert(bcontainer->pgsizes &&
              vrdl->granularity >= 1ULL << ctz64(bcontainer->pgsizes));
 
-    ram_discard_listener_init(&vrdl->listener,
+    rdl = &vrdl->listener;
+    ram_discard_listener_init(rdl,
                               vfio_ram_discard_notify_populate,
                               vfio_ram_discard_notify_discard, true);
-    ram_discard_manager_register_listener(rdm, &vrdl->listener, section);
+    generic_state_manager_register_listener(gsm, &rdl->scl, section);
     QLIST_INSERT_HEAD(&bcontainer->vrdl_list, vrdl, next);
 
     /*
@@ -465,8 +469,9 @@ static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
 static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
                                                  MemoryRegionSection *section)
 {
-    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
     VFIORamDiscardListener *vrdl = NULL;
+    RamDiscardListener *rdl;
 
     QLIST_FOREACH(vrdl, &bcontainer->vrdl_list, next) {
         if (vrdl->mr == section->mr &&
@@ -480,7 +485,8 @@ static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
         hw_error("vfio: Trying to unregister missing RAM discard listener");
     }
 
-    ram_discard_manager_unregister_listener(rdm, &vrdl->listener);
+    rdl = &vrdl->listener;
+    generic_state_manager_unregister_listener(gsm, &rdl->scl);
     QLIST_REMOVE(vrdl, next);
     g_free(vrdl);
 }
@@ -1265,7 +1271,7 @@ static int
 vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainerBase *bcontainer,
                                             MemoryRegionSection *section)
 {
-    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
     VFIORamDiscardListener *vrdl = NULL;
 
     QLIST_FOREACH(vrdl, &bcontainer->vrdl_list, next) {
@@ -1284,7 +1290,7 @@ vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainerBase *bcontainer,
      * We only want/can synchronize the bitmap for actually mapped parts -
      * which correspond to populated parts. Replay all populated parts.
      */
-    return ram_discard_manager_replay_populated(rdm, section,
+    return generic_state_manager_replay_on_state_set(gsm, section,
                                               vfio_ram_discard_get_dirty_bitmap,
                                                 &vrdl);
 }
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 1a88d649cb..40e8267254 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -312,16 +312,16 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
 
 static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
 {
-    RamDiscardListener *rdl = arg;
+    StateChangeListener *scl = arg;
 
-    return rdl->notify_populate(rdl, s);
+    return scl->notify_to_state_set(scl, s);
 }
 
 static int virtio_mem_notify_discard_cb(MemoryRegionSection *s, void *arg)
 {
-    RamDiscardListener *rdl = arg;
+    StateChangeListener *scl = arg;
 
-    rdl->notify_discard(rdl, s);
+    scl->notify_to_state_clear(scl, s);
     return 0;
 }
 
@@ -331,12 +331,13 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
     RamDiscardListener *rdl;
 
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
+        StateChangeListener *scl = &rdl->scl;
+        MemoryRegionSection tmp = *scl->section;
 
         if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
-        rdl->notify_discard(rdl, &tmp);
+        scl->notify_to_state_clear(scl, &tmp);
     }
 }
 
@@ -347,12 +348,13 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
     int ret = 0;
 
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        MemoryRegionSection tmp = *rdl->section;
+        StateChangeListener *scl = &rdl->scl;
+        MemoryRegionSection tmp = *scl->section;
 
         if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
-        ret = rdl->notify_populate(rdl, &tmp);
+        ret = scl->notify_to_state_set(scl, &tmp);
         if (ret) {
             break;
         }
@@ -361,7 +363,8 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
     if (ret) {
         /* Notify all already-notified listeners. */
         QLIST_FOREACH(rdl2, &vmem->rdl_list, next) {
-            MemoryRegionSection tmp = *rdl2->section;
+            StateChangeListener *scl2 = &rdl2->scl;
+            MemoryRegionSection tmp = *scl2->section;
 
             if (rdl2 == rdl) {
                 break;
@@ -369,7 +372,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
             if (!memory_region_section_intersect_range(&tmp, offset, size)) {
                 continue;
             }
-            rdl2->notify_discard(rdl2, &tmp);
+            scl2->notify_to_state_clear(scl2, &tmp);
         }
     }
     return ret;
@@ -384,10 +387,11 @@ static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
     }
 
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
+        StateChangeListener *scl = &rdl->scl;
         if (rdl->double_discard_supported) {
-            rdl->notify_discard(rdl, rdl->section);
+            scl->notify_to_state_clear(scl, scl->section);
         } else {
-            virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
+            virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
                                                 virtio_mem_notify_discard_cb);
         }
     }
@@ -1053,8 +1057,8 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
      * Set ourselves as RamDiscardManager before the plug handler maps the
      * memory region and exposes it via an address space.
      */
-    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
-                                              RAM_DISCARD_MANAGER(vmem))) {
+    if (memory_region_set_generic_state_manager(&vmem->memdev->mr,
+                                                GENERIC_STATE_MANAGER(vmem))) {
         error_setg(errp, "Failed to set RamDiscardManager");
         ram_block_coordinated_discard_require(false);
         return;
@@ -1158,7 +1162,7 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
      * The unplug handler unmapped the memory region, it cannot be
      * found via an address space anymore. Unset ourselves.
      */
-    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
+    memory_region_set_generic_state_manager(&vmem->memdev->mr, NULL);
     ram_block_coordinated_discard_require(false);
 }
 
@@ -1207,7 +1211,8 @@ static int virtio_mem_post_load_bitmap(VirtIOMEM *vmem)
      * into an address space. Replay, now that we updated the bitmap.
      */
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
-        ret = virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
+        StateChangeListener *scl = &rdl->scl;
+        ret = virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
                                                  virtio_mem_notify_populate_cb);
         if (ret) {
             return ret;
@@ -1704,19 +1709,19 @@ static const Property virtio_mem_properties[] = {
                      dynamic_memslots, false),
 };
 
-static uint64_t virtio_mem_rdm_get_min_granularity(const RamDiscardManager *rdm,
+static uint64_t virtio_mem_rdm_get_min_granularity(const GenericStateManager *gsm,
                                                    const MemoryRegion *mr)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
 
     g_assert(mr == &vmem->memdev->mr);
     return vmem->block_size;
 }
 
-static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
+static bool virtio_mem_rdm_is_populated(const GenericStateManager *gsm,
                                         const MemoryRegionSection *s)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
     uint64_t start_gpa = vmem->addr + s->offset_within_region;
     uint64_t end_gpa = start_gpa + int128_get64(s->size);
 
@@ -1744,12 +1749,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
     return data->fn(s, data->opaque);
 }
 
-static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
+static int virtio_mem_rdm_replay_populated(const GenericStateManager *gsm,
                                            MemoryRegionSection *s,
                                            ReplayStateChange replay_fn,
                                            void *opaque)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
     struct VirtIOMEMReplayData data = {
         .fn = replay_fn,
         .opaque = opaque,
@@ -1769,12 +1774,12 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
     return 0;
 }
 
-static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
+static int virtio_mem_rdm_replay_discarded(const GenericStateManager *gsm,
                                            MemoryRegionSection *s,
                                            ReplayStateChange replay_fn,
                                            void *opaque)
 {
-    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
     struct VirtIOMEMReplayData data = {
         .fn = replay_fn,
         .opaque = opaque,
@@ -1785,18 +1790,19 @@ static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
                                                  virtio_mem_rdm_replay_discarded_cb);
 }
 
-static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl,
+static void virtio_mem_rdm_register_listener(GenericStateManager *gsm,
+                                             StateChangeListener *scl,
                                              MemoryRegionSection *s)
 {
-    VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    VirtIOMEM *vmem = VIRTIO_MEM(gsm);
+    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
     int ret;
 
     g_assert(s->mr == &vmem->memdev->mr);
-    rdl->section = memory_region_section_new_copy(s);
+    scl->section = memory_region_section_new_copy(s);
 
     QLIST_INSERT_HEAD(&vmem->rdl_list, rdl, next);
-    ret = virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
+    ret = virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
                                               virtio_mem_notify_populate_cb);
     if (ret) {
         error_report("%s: Replaying plugged ranges failed: %s", __func__,
@@ -1804,23 +1810,24 @@ static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
     }
 }
 
-static void virtio_mem_rdm_unregister_listener(RamDiscardManager *rdm,
-                                               RamDiscardListener *rdl)
+static void virtio_mem_rdm_unregister_listener(GenericStateManager *gsm,
+                                               StateChangeListener *scl)
 {
-    VirtIOMEM *vmem = VIRTIO_MEM(rdm);
+    VirtIOMEM *vmem = VIRTIO_MEM(gsm);
+    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
 
-    g_assert(rdl->section->mr == &vmem->memdev->mr);
+    g_assert(scl->section->mr == &vmem->memdev->mr);
     if (vmem->size) {
         if (rdl->double_discard_supported) {
-            rdl->notify_discard(rdl, rdl->section);
+            scl->notify_to_state_clear(scl, scl->section);
         } else {
-            virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
+            virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
                                                 virtio_mem_notify_discard_cb);
         }
     }
 
-    memory_region_section_free_copy(rdl->section);
-    rdl->section = NULL;
+    memory_region_section_free_copy(scl->section);
+    scl->section = NULL;
     QLIST_REMOVE(rdl, next);
 }
 
@@ -1853,7 +1860,7 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
     DeviceClass *dc = DEVICE_CLASS(klass);
     VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
     VirtIOMEMClass *vmc = VIRTIO_MEM_CLASS(klass);
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_CLASS(klass);
 
     device_class_set_props(dc, virtio_mem_properties);
     dc->vmsd = &vmstate_virtio_mem;
@@ -1874,12 +1881,12 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
     vmc->remove_size_change_notifier = virtio_mem_remove_size_change_notifier;
     vmc->unplug_request_check = virtio_mem_unplug_request_check;
 
-    rdmc->get_min_granularity = virtio_mem_rdm_get_min_granularity;
-    rdmc->is_populated = virtio_mem_rdm_is_populated;
-    rdmc->replay_populated = virtio_mem_rdm_replay_populated;
-    rdmc->replay_discarded = virtio_mem_rdm_replay_discarded;
-    rdmc->register_listener = virtio_mem_rdm_register_listener;
-    rdmc->unregister_listener = virtio_mem_rdm_unregister_listener;
+    gsmc->get_min_granularity = virtio_mem_rdm_get_min_granularity;
+    gsmc->is_state_set = virtio_mem_rdm_is_populated;
+    gsmc->replay_on_state_set = virtio_mem_rdm_replay_populated;
+    gsmc->replay_on_state_clear = virtio_mem_rdm_replay_discarded;
+    gsmc->register_listener = virtio_mem_rdm_register_listener;
+    gsmc->unregister_listener = virtio_mem_rdm_unregister_listener;
 }
 
 static const TypeInfo virtio_mem_info = {
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 3b1d25a403..30e5838d02 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -43,6 +43,12 @@ typedef struct IOMMUMemoryRegionClass IOMMUMemoryRegionClass;
 DECLARE_OBJ_CHECKERS(IOMMUMemoryRegion, IOMMUMemoryRegionClass,
                      IOMMU_MEMORY_REGION, TYPE_IOMMU_MEMORY_REGION)
 
+#define TYPE_GENERIC_STATE_MANAGER "generic-state-manager"
+typedef struct GenericStateManagerClass GenericStateManagerClass;
+typedef struct GenericStateManager GenericStateManager;
+DECLARE_OBJ_CHECKERS(GenericStateManager, GenericStateManagerClass,
+                     GENERIC_STATE_MANAGER, TYPE_GENERIC_STATE_MANAGER)
+
 #define TYPE_RAM_DISCARD_MANAGER "ram-discard-manager"
 typedef struct RamDiscardManagerClass RamDiscardManagerClass;
 typedef struct RamDiscardManager RamDiscardManager;
@@ -506,103 +512,59 @@ struct IOMMUMemoryRegionClass {
     int (*num_indexes)(IOMMUMemoryRegion *iommu);
 };
 
-typedef struct RamDiscardListener RamDiscardListener;
-typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
-typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
+typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
+
+typedef struct StateChangeListener StateChangeListener;
+typedef int (*NotifyStateSet)(StateChangeListener *scl,
+                              MemoryRegionSection *section);
+typedef void (*NotifyStateClear)(StateChangeListener *scl,
                                  MemoryRegionSection *section);
 
-struct RamDiscardListener {
+struct StateChangeListener {
     /*
-     * @notify_populate:
+     * @notify_to_state_set:
      *
-     * Notification that previously discarded memory is about to get populated.
-     * Listeners are able to object. If any listener objects, already
-     * successfully notified listeners are notified about a discard again.
+     * Notification that previously state clear part is about to be set.
      *
-     * @rdl: the #RamDiscardListener getting notified
-     * @section: the #MemoryRegionSection to get populated. The section
+     * @scl: the #StateChangeListener getting notified
+     * @section: the #MemoryRegionSection to be state-set. The section
      *           is aligned within the memory region to the minimum granularity
      *           unless it would exceed the registered section.
      *
      * Returns 0 on success. If the notification is rejected by the listener,
      * an error is returned.
      */
-    NotifyRamPopulate notify_populate;
+    NotifyStateSet notify_to_state_set;
 
     /*
-     * @notify_discard:
+     * @notify_to_state_clear:
      *
-     * Notification that previously populated memory was discarded successfully
-     * and listeners should drop all references to such memory and prevent
-     * new population (e.g., unmap).
+     * Notification that previously state set part is about to be cleared
      *
-     * @rdl: the #RamDiscardListener getting notified
-     * @section: the #MemoryRegionSection to get populated. The section
+     * @scl: the #StateChangeListener getting notified
+     * @section: the #MemoryRegionSection to be state-cleared. The section
      *           is aligned within the memory region to the minimum granularity
      *           unless it would exceed the registered section.
-     */
-    NotifyRamDiscard notify_discard;
-
-    /*
-     * @double_discard_supported:
      *
-     * The listener suppors getting @notify_discard notifications that span
-     * already discarded parts.
+     * Returns 0 on success. If the notification is rejected by the listener,
+     * an error is returned.
      */
-    bool double_discard_supported;
+    NotifyStateClear notify_to_state_clear;
 
     MemoryRegionSection *section;
-    QLIST_ENTRY(RamDiscardListener) next;
 };
 
-static inline void ram_discard_listener_init(RamDiscardListener *rdl,
-                                             NotifyRamPopulate populate_fn,
-                                             NotifyRamDiscard discard_fn,
-                                             bool double_discard_supported)
-{
-    rdl->notify_populate = populate_fn;
-    rdl->notify_discard = discard_fn;
-    rdl->double_discard_supported = double_discard_supported;
-}
-
-typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
-
 /*
- * RamDiscardManagerClass:
- *
- * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
- * regions are currently populated to be used/accessed by the VM, notifying
- * after parts were discarded (freeing up memory) and before parts will be
- * populated (consuming memory), to be used/accessed by the VM.
- *
- * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
- * #MemoryRegion isn't mapped into an address space yet (either directly
- * or via an alias); it cannot change while the #MemoryRegion is
- * mapped into an address space.
+ * GenericStateManagerClass:
  *
- * The #RamDiscardManager is intended to be used by technologies that are
- * incompatible with discarding of RAM (e.g., VFIO, which may pin all
- * memory inside a #MemoryRegion), and require proper coordination to only
- * map the currently populated parts, to hinder parts that are expected to
- * remain discarded from silently getting populated and consuming memory.
- * Technologies that support discarding of RAM don't have to bother and can
- * simply map the whole #MemoryRegion.
- *
- * An example #RamDiscardManager is virtio-mem, which logically (un)plugs
- * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
- * Logically unplugging memory consists of discarding RAM. The VM agreed to not
- * access unplugged (discarded) memory - especially via DMA. virtio-mem will
- * properly coordinate with listeners before memory is plugged (populated),
- * and after memory is unplugged (discarded).
+ * A #GenericStateManager is a common interface used to manage the state of
+ * a #MemoryRegion. The managed states is a pair of opposite states, such as
+ * populated and discarded, or private and shared. It is abstract as set and
+ * clear in below callbacks, and the actual state is managed by the
+ * implementation.
  *
- * Listeners are called in multiples of the minimum granularity (unless it
- * would exceed the registered range) and changes are aligned to the minimum
- * granularity within the #MemoryRegion. Listeners have to prepare for memory
- * becoming discarded in a different granularity than it was populated and the
- * other way around.
  */
-struct RamDiscardManagerClass {
+struct GenericStateManagerClass {
     /* private */
     InterfaceClass parent_class;
 
@@ -612,122 +574,188 @@ struct RamDiscardManagerClass {
      * @get_min_granularity:
      *
      * Get the minimum granularity in which listeners will get notified
-     * about changes within the #MemoryRegion via the #RamDiscardManager.
+     * about changes within the #MemoryRegion via the #GenericStateManager.
      *
-     * @rdm: the #RamDiscardManager
+     * @gsm: the #GenericStateManager
      * @mr: the #MemoryRegion
      *
      * Returns the minimum granularity.
      */
-    uint64_t (*get_min_granularity)(const RamDiscardManager *rdm,
+    uint64_t (*get_min_granularity)(const GenericStateManager *gsm,
                                     const MemoryRegion *mr);
 
     /**
-     * @is_populated:
+     * @is_state_set:
      *
-     * Check whether the given #MemoryRegionSection is completely populated
-     * (i.e., no parts are currently discarded) via the #RamDiscardManager.
-     * There are no alignment requirements.
+     * Check whether the given #MemoryRegionSection state is set.
+     * via the #GenericStateManager.
      *
-     * @rdm: the #RamDiscardManager
+     * @gsm: the #GenericStateManager
      * @section: the #MemoryRegionSection
      *
-     * Returns whether the given range is completely populated.
+     * Returns whether the given range is completely set.
      */
-    bool (*is_populated)(const RamDiscardManager *rdm,
+    bool (*is_state_set)(const GenericStateManager *gsm,
                          const MemoryRegionSection *section);
 
     /**
-     * @replay_populated:
+     * @replay_on_state_set:
      *
-     * Call the #ReplayStateChange callback for all populated parts within the
-     * #MemoryRegionSection via the #RamDiscardManager.
+     * Call the #ReplayStateChange callback for all state set parts within the
+     * #MemoryRegionSection via the #GenericStateManager.
      *
      * In case any call fails, no further calls are made.
      *
-     * @rdm: the #RamDiscardManager
+     * @gsm: the #GenericStateManager
      * @section: the #MemoryRegionSection
      * @replay_fn: the #ReplayStateChange callback
      * @opaque: pointer to forward to the callback
      *
      * Returns 0 on success, or a negative error if any notification failed.
      */
-    int (*replay_populated)(const RamDiscardManager *rdm,
-                            MemoryRegionSection *section,
-                            ReplayStateChange replay_fn, void *opaque);
+    int (*replay_on_state_set)(const GenericStateManager *gsm,
+                               MemoryRegionSection *section,
+                               ReplayStateChange replay_fn, void *opaque);
 
     /**
-     * @replay_discarded:
+     * @replay_on_state_clear:
      *
-     * Call the #ReplayStateChange callback for all discarded parts within the
-     * #MemoryRegionSection via the #RamDiscardManager.
+     * Call the #ReplayStateChange callback for all state clear parts within the
+     * #MemoryRegionSection via the #GenericStateManager.
+     *
+     * In case any call fails, no further calls are made.
      *
-     * @rdm: the #RamDiscardManager
+     * @gsm: the #GenericStateManager
      * @section: the #MemoryRegionSection
      * @replay_fn: the #ReplayStateChange callback
      * @opaque: pointer to forward to the callback
      *
      * Returns 0 on success, or a negative error if any notification failed.
      */
-    int (*replay_discarded)(const RamDiscardManager *rdm,
-                            MemoryRegionSection *section,
-                            ReplayStateChange replay_fn, void *opaque);
+    int (*replay_on_state_clear)(const GenericStateManager *gsm,
+                                 MemoryRegionSection *section,
+                                 ReplayStateChange replay_fn, void *opaque);
 
     /**
      * @register_listener:
      *
-     * Register a #RamDiscardListener for the given #MemoryRegionSection and
-     * immediately notify the #RamDiscardListener about all populated parts
-     * within the #MemoryRegionSection via the #RamDiscardManager.
+     * Register a #StateChangeListener for the given #MemoryRegionSection and
+     * immediately notify the #StateChangeListener about all state-set parts
+     * within the #MemoryRegionSection via the #GenericStateManager.
      *
      * In case any notification fails, no further notifications are triggered
      * and an error is logged.
      *
-     * @rdm: the #RamDiscardManager
-     * @rdl: the #RamDiscardListener
+     * @rdm: the #GenericStateManager
+     * @rdl: the #StateChangeListener
      * @section: the #MemoryRegionSection
      */
-    void (*register_listener)(RamDiscardManager *rdm,
-                              RamDiscardListener *rdl,
+    void (*register_listener)(GenericStateManager *gsm,
+                              StateChangeListener *scl,
                               MemoryRegionSection *section);
 
     /**
      * @unregister_listener:
      *
-     * Unregister a previously registered #RamDiscardListener via the
-     * #RamDiscardManager after notifying the #RamDiscardListener about all
-     * populated parts becoming unpopulated within the registered
+     * Unregister a previously registered #StateChangeListener via the
+     * #GenericStateManager after notifying the #StateChangeListener about all
+     * state-set parts becoming state-cleared within the registered
      * #MemoryRegionSection.
      *
-     * @rdm: the #RamDiscardManager
-     * @rdl: the #RamDiscardListener
+     * @rdm: the #GenericStateManager
+     * @rdl: the #StateChangeListener
      */
-    void (*unregister_listener)(RamDiscardManager *rdm,
-                                RamDiscardListener *rdl);
+    void (*unregister_listener)(GenericStateManager *gsm,
+                                StateChangeListener *scl);
 };
 
-uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
-                                                 const MemoryRegion *mr);
+uint64_t generic_state_manager_get_min_granularity(const GenericStateManager *gsm,
+                                                   const MemoryRegion *mr);
 
-bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section);
+bool generic_state_manager_is_state_set(const GenericStateManager *gsm,
+                                        const MemoryRegionSection *section);
 
-int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayStateChange replay_fn,
-                                         void *opaque);
+int generic_state_manager_replay_on_state_set(const GenericStateManager *gsm,
+                                           MemoryRegionSection *section,
+                                           ReplayStateChange replay_fn,
+                                           void *opaque);
 
-int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayStateChange replay_fn,
-                                         void *opaque);
+int generic_state_manager_replay_on_state_clear(const GenericStateManager *gsm,
+                                                MemoryRegionSection *section,
+                                                ReplayStateChange replay_fn,
+                                                void *opaque);
 
-void ram_discard_manager_register_listener(RamDiscardManager *rdm,
-                                           RamDiscardListener *rdl,
-                                           MemoryRegionSection *section);
+void generic_state_manager_register_listener(GenericStateManager *gsm,
+                                             StateChangeListener *scl,
+                                             MemoryRegionSection *section);
 
-void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl);
+void generic_state_manager_unregister_listener(GenericStateManager *gsm,
+                                               StateChangeListener *scl);
+
+typedef struct RamDiscardListener RamDiscardListener;
+
+struct RamDiscardListener {
+    struct StateChangeListener scl;
+
+    /*
+     * @double_discard_supported:
+     *
+     * The listener suppors getting @notify_discard notifications that span
+     * already discarded parts.
+     */
+    bool double_discard_supported;
+
+    QLIST_ENTRY(RamDiscardListener) next;
+};
+
+static inline void ram_discard_listener_init(RamDiscardListener *rdl,
+                                             NotifyStateSet populate_fn,
+                                             NotifyStateClear discard_fn,
+                                             bool double_discard_supported)
+{
+    rdl->scl.notify_to_state_set = populate_fn;
+    rdl->scl.notify_to_state_clear = discard_fn;
+    rdl->double_discard_supported = double_discard_supported;
+}
+
+/*
+ * RamDiscardManagerClass:
+ *
+ * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
+ * regions are currently populated to be used/accessed by the VM, notifying
+ * after parts were discarded (freeing up memory) and before parts will be
+ * populated (consuming memory), to be used/accessed by the VM.
+ *
+ * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
+ * #MemoryRegion isn't mapped into an address space yet (either directly
+ * or via an alias); it cannot change while the #MemoryRegion is
+ * mapped into an address space.
+ *
+ * The #RamDiscardManager is intended to be used by technologies that are
+ * incompatible with discarding of RAM (e.g., VFIO, which may pin all
+ * memory inside a #MemoryRegion), and require proper coordination to only
+ * map the currently populated parts, to hinder parts that are expected to
+ * remain discarded from silently getting populated and consuming memory.
+ * Technologies that support discarding of RAM don't have to bother and can
+ * simply map the whole #MemoryRegion.
+ *
+ * An example #RamDiscardManager is virtio-mem, which logically (un)plugs
+ * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
+ * Logically unplugging memory consists of discarding RAM. The VM agreed to not
+ * access unplugged (discarded) memory - especially via DMA. virtio-mem will
+ * properly coordinate with listeners before memory is plugged (populated),
+ * and after memory is unplugged (discarded).
+ *
+ * Listeners are called in multiples of the minimum granularity (unless it
+ * would exceed the registered range) and changes are aligned to the minimum
+ * granularity within the #MemoryRegion. Listeners have to prepare for memory
+ * becoming discarded in a different granularity than it was populated and the
+ * other way around.
+ */
+struct RamDiscardManagerClass {
+    /* private */
+    GenericStateManagerClass parent_class;
+};
 
 /**
  * memory_get_xlat_addr: Extract addresses from a TLB entry
@@ -795,7 +823,7 @@ struct MemoryRegion {
     const char *name;
     unsigned ioeventfd_nb;
     MemoryRegionIoeventfd *ioeventfds;
-    RamDiscardManager *rdm; /* Only for RAM */
+    GenericStateManager *gsm; /* Only for RAM */
 
     /* For devices designed to perform re-entrant IO into their own IO MRs */
     bool disable_reentrancy_guard;
@@ -2462,39 +2490,36 @@ bool memory_region_present(MemoryRegion *container, hwaddr addr);
 bool memory_region_is_mapped(MemoryRegion *mr);
 
 /**
- * memory_region_get_ram_discard_manager: get the #RamDiscardManager for a
+ * memory_region_get_generic_state_manager: get the #GenericStateManager for a
  * #MemoryRegion
  *
- * The #RamDiscardManager cannot change while a memory region is mapped.
+ * The #GenericStateManager cannot change while a memory region is mapped.
  *
  * @mr: the #MemoryRegion
  */
-RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr);
+GenericStateManager *memory_region_get_generic_state_manager(MemoryRegion *mr);
 
 /**
- * memory_region_has_ram_discard_manager: check whether a #MemoryRegion has a
- * #RamDiscardManager assigned
+ * memory_region_set_generic_state_manager: set the #GenericStateManager for a
+ * #MemoryRegion
+ *
+ * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
+ * that does not cover RAM, or a #MemoryRegion that already has a
+ * #GenericStateManager assigned. Return 0 if the gsm is set successfully.
  *
  * @mr: the #MemoryRegion
+ * @gsm: #GenericStateManager to set
  */
-static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
-{
-    return !!memory_region_get_ram_discard_manager(mr);
-}
+int memory_region_set_generic_state_manager(MemoryRegion *mr,
+                                            GenericStateManager *gsm);
 
 /**
- * memory_region_set_ram_discard_manager: set the #RamDiscardManager for a
- * #MemoryRegion
- *
- * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
- * that does not cover RAM, or a #MemoryRegion that already has a
- * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
+ * memory_region_has_ram_discard_manager: check whether a #MemoryRegion has a
+ * #RamDiscardManager assigned
  *
  * @mr: the #MemoryRegion
- * @rdm: #RamDiscardManager to set
  */
-int memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                          RamDiscardManager *rdm);
+bool memory_region_has_ram_discard_manager(MemoryRegion *mr);
 
 /**
  * memory_region_find: translate an address/size relative to a
diff --git a/migration/ram.c b/migration/ram.c
index 053730367b..c881523e64 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -857,14 +857,14 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
     uint64_t cleared_bits = 0;
 
     if (rb->mr && rb->bmap && memory_region_has_ram_discard_manager(rb->mr)) {
-        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = 0,
             .size = int128_make64(qemu_ram_get_used_length(rb)),
         };
 
-        ram_discard_manager_replay_discarded(rdm, &section,
+        generic_state_manager_replay_on_state_clear(gsm, &section,
                                              dirty_bitmap_clear_section,
                                              &cleared_bits);
     }
@@ -880,14 +880,14 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
 bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
 {
     if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
-        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = start,
             .size = int128_make64(qemu_ram_pagesize(rb)),
         };
 
-        return !ram_discard_manager_is_populated(rdm, &section);
+        return !generic_state_manager_is_state_set(gsm, &section);
     }
     return false;
 }
@@ -1545,14 +1545,14 @@ static void ram_block_populate_read(RAMBlock *rb)
      * Note: The result is only stable while migrating (precopy/postcopy).
      */
     if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
-        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = 0,
             .size = rb->mr->size,
         };
 
-        ram_discard_manager_replay_populated(rdm, &section,
+        generic_state_manager_replay_on_state_set(gsm, &section,
                                              populate_read_section, NULL);
     } else {
         populate_read_range(rb, 0, rb->used_length);
@@ -1604,14 +1604,14 @@ static int ram_block_uffd_protect(RAMBlock *rb, int uffd_fd)
 
     /* See ram_block_populate_read() */
     if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
-        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
         MemoryRegionSection section = {
             .mr = rb->mr,
             .offset_within_region = 0,
             .size = rb->mr->size,
         };
 
-        return ram_discard_manager_replay_populated(rdm, &section,
+        return generic_state_manager_replay_on_state_set(gsm, &section,
                                                     uffd_protect_section,
                                                     (void *)(uintptr_t)uffd_fd);
     }
diff --git a/system/memory.c b/system/memory.c
index b5ab729e13..7b921c66a6 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2107,83 +2107,93 @@ int memory_region_iommu_num_indexes(IOMMUMemoryRegion *iommu_mr)
     return imrc->num_indexes(iommu_mr);
 }
 
-RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
+GenericStateManager *memory_region_get_generic_state_manager(MemoryRegion *mr)
 {
     if (!memory_region_is_ram(mr)) {
         return NULL;
     }
-    return mr->rdm;
+    return mr->gsm;
 }
 
-int memory_region_set_ram_discard_manager(MemoryRegion *mr,
-                                          RamDiscardManager *rdm)
+int memory_region_set_generic_state_manager(MemoryRegion *mr,
+                                            GenericStateManager *gsm)
 {
     g_assert(memory_region_is_ram(mr));
-    if (mr->rdm && rdm) {
+    if (mr->gsm && gsm) {
         return -EBUSY;
     }
 
-    mr->rdm = rdm;
+    mr->gsm = gsm;
     return 0;
 }
 
-uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
-                                                 const MemoryRegion *mr)
+bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    if (!memory_region_is_ram(mr) ||
+        !object_dynamic_cast(OBJECT(mr->gsm), TYPE_RAM_DISCARD_MANAGER)) {
+        return false;
+    }
+
+    return true;
+}
+
+uint64_t generic_state_manager_get_min_granularity(const GenericStateManager *gsm,
+                                                   const MemoryRegion *mr)
+{
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
 
-    g_assert(rdmc->get_min_granularity);
-    return rdmc->get_min_granularity(rdm, mr);
+    g_assert(gsmc->get_min_granularity);
+    return gsmc->get_min_granularity(gsm, mr);
 }
 
-bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section)
+bool generic_state_manager_is_state_set(const GenericStateManager *gsm,
+                                        const MemoryRegionSection *section)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
 
-    g_assert(rdmc->is_populated);
-    return rdmc->is_populated(rdm, section);
+    g_assert(gsmc->is_state_set);
+    return gsmc->is_state_set(gsm, section);
 }
 
-int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayStateChange replay_fn,
-                                         void *opaque)
+int generic_state_manager_replay_on_state_set(const GenericStateManager *gsm,
+                                              MemoryRegionSection *section,
+                                              ReplayStateChange replay_fn,
+                                              void *opaque)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
 
-    g_assert(rdmc->replay_populated);
-    return rdmc->replay_populated(rdm, section, replay_fn, opaque);
+    g_assert(gsmc->replay_on_state_set);
+    return gsmc->replay_on_state_set(gsm, section, replay_fn, opaque);
 }
 
-int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                         MemoryRegionSection *section,
-                                         ReplayStateChange replay_fn,
-                                         void *opaque)
+int generic_state_manager_replay_on_state_clear(const GenericStateManager *gsm,
+                                                MemoryRegionSection *section,
+                                                ReplayStateChange replay_fn,
+                                                void *opaque)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
 
-    g_assert(rdmc->replay_discarded);
-    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
+    g_assert(gsmc->replay_on_state_clear);
+    return gsmc->replay_on_state_clear(gsm, section, replay_fn, opaque);
 }
 
-void ram_discard_manager_register_listener(RamDiscardManager *rdm,
-                                           RamDiscardListener *rdl,
-                                           MemoryRegionSection *section)
+void generic_state_manager_register_listener(GenericStateManager *gsm,
+                                             StateChangeListener *scl,
+                                             MemoryRegionSection *section)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
 
-    g_assert(rdmc->register_listener);
-    rdmc->register_listener(rdm, rdl, section);
+    g_assert(gsmc->register_listener);
+    gsmc->register_listener(gsm, scl, section);
 }
 
-void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
-                                             RamDiscardListener *rdl)
+void generic_state_manager_unregister_listener(GenericStateManager *gsm,
+                                               StateChangeListener *scl)
 {
-    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
 
-    g_assert(rdmc->unregister_listener);
-    rdmc->unregister_listener(rdm, rdl);
+    g_assert(gsmc->unregister_listener);
+    gsmc->unregister_listener(gsm, scl);
 }
 
 /* Called with rcu_read_lock held.  */
@@ -2210,7 +2220,7 @@ bool memory_get_xlat_addr(IOMMUTLBEntry *iotlb, void **vaddr,
         error_setg(errp, "iommu map to non memory area %" HWADDR_PRIx "", xlat);
         return false;
     } else if (memory_region_has_ram_discard_manager(mr)) {
-        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(mr);
+        GenericStateManager *gsm = memory_region_get_generic_state_manager(mr);
         MemoryRegionSection tmp = {
             .mr = mr,
             .offset_within_region = xlat,
@@ -2225,7 +2235,7 @@ bool memory_get_xlat_addr(IOMMUTLBEntry *iotlb, void **vaddr,
          * Disallow that. vmstate priorities make sure any RamDiscardManager
          * were already restored before IOMMUs are restored.
          */
-        if (!ram_discard_manager_is_populated(rdm, &tmp)) {
+        if (!generic_state_manager_is_state_set(gsm, &tmp)) {
             error_setg(errp, "iommu map to discarded memory (e.g., unplugged"
                          " via virtio-mem): %" HWADDR_PRIx "",
                          iotlb->translated_addr);
@@ -3814,8 +3824,15 @@ static const TypeInfo iommu_memory_region_info = {
     .abstract           = true,
 };
 
-static const TypeInfo ram_discard_manager_info = {
+static const TypeInfo generic_state_manager_info = {
     .parent             = TYPE_INTERFACE,
+    .name               = TYPE_GENERIC_STATE_MANAGER,
+    .class_size         = sizeof(GenericStateManagerClass),
+    .abstract           = true,
+};
+
+static const TypeInfo ram_discard_manager_info = {
+    .parent             = TYPE_GENERIC_STATE_MANAGER,
     .name               = TYPE_RAM_DISCARD_MANAGER,
     .class_size         = sizeof(RamDiscardManagerClass),
 };
@@ -3824,6 +3841,7 @@ static void memory_register_types(void)
 {
     type_register_static(&memory_region_info);
     type_register_static(&iommu_memory_region_info);
+    type_register_static(&generic_state_manager_info);
     type_register_static(&ram_discard_manager_info);
 }
 
diff --git a/system/memory_mapping.c b/system/memory_mapping.c
index 37d3325f77..e9d15c737d 100644
--- a/system/memory_mapping.c
+++ b/system/memory_mapping.c
@@ -271,10 +271,8 @@ static void guest_phys_blocks_region_add(MemoryListener *listener,
 
     /* for special sparse regions, only add populated parts */
     if (memory_region_has_ram_discard_manager(section->mr)) {
-        RamDiscardManager *rdm;
-
-        rdm = memory_region_get_ram_discard_manager(section->mr);
-        ram_discard_manager_replay_populated(rdm, section,
+        GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
+        generic_state_manager_replay_on_state_set(gsm, section,
                                              guest_phys_ram_populate_cb, g);
         return;
     }
-- 
2.43.5


