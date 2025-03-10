Return-Path: <kvm+bounces-40603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C86A58DEE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:20:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BBA47A313D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA6D223335;
	Mon, 10 Mar 2025 08:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="egsr+2T7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282792206B7
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594832; cv=none; b=WUFh1wpvw2n/0TLfG1c+N+bn/87OBrY/J2VPSyJ0tJ+I396xmlOhCx4QX2ns1OnXozkGnp1ra8dgFUZF3SWaiLeYlNBr5y3McuuEFGsoi4dCyHYoS4evPm6210D6rV6IDLX+9m1L2DbCP7JMte5xd9cG8+coGfTOgxIoWegLJBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594832; c=relaxed/simple;
	bh=HxWtun9ij4pwEwNTy5OfOAU4jVRK3y6QcvEkKC14gyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boXKGAc/DOex4aRgGNDW/R1vf2zeBC/ue1xUGGtyF7pAKUtRdiqYItktLIY7J9Vxdq868i+zBS2MJFP8yppjp5Wtc1c+mTMevLEWCOvIORhcGKFXDe9M33ZOsVx/1ZZnRQ4ST4DiSODfwhWk3+b3QfwY1wz+C2F3Bl7Wt46JIB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=egsr+2T7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741594830; x=1773130830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HxWtun9ij4pwEwNTy5OfOAU4jVRK3y6QcvEkKC14gyw=;
  b=egsr+2T7VfiuhC8nVVza/4zqVsym/sy5KS2YK6aT2YYZk3iB6STMiuAX
   /fBXvrC03yNUJuntjcmhJvcY61dk/roQMYMwCXYpuBARCuL+Y7xFQ7g9p
   JR1GonU35GI1NFKk2DoIGRB7vkBqhw1WeDwu9IrmkUm4BP390JModUTHw
   XY2wkHkT3KDGXzWhctVEKE8RwddGIqnGvNOxjzxfyp0ckUSsvAXQ8DRtf
   tNl59gFOts0eOsfFh/nQia0Yg5qCbRrDXXli4Ripc/TN1tXB7S/gnIUT6
   zfkQCfwd+m11gH/4cz0s9x/fNO5MYJhX8cmvNvliyX0op60QIRuQdHGEH
   g==;
X-CSE-ConnectionGUID: CX+cvLVHS4iXOByjAgI+jw==
X-CSE-MsgGUID: URT/c8GHRUS8BvnyjoxB+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42688479"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42688479"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:30 -0700
X-CSE-ConnectionGUID: 6I13lfMUTVil4T7P96Ktbg==
X-CSE-MsgGUID: Rd2hUbOGQS2lqDVUd3huHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150862818"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:26 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
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
Subject: [PATCH v3 4/7] memory-attribute-manager: Introduce MemoryAttributeManager to manage RAMBLock with guest_memfd
Date: Mon, 10 Mar 2025 16:18:32 +0800
Message-ID: <20250310081837.13123-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250310081837.13123-1-chenyi.qiang@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
uncoordinated discard") highlighted, some subsystems like VFIO may
disable ram block discard. However, guest_memfd relies on the discard
operation to perform page conversion between private and shared memory.
This can lead to stale IOMMU mapping issue when assigning a hardware
device to a confidential VM via shared memory. To address this, it is
crucial to ensure systems like VFIO refresh its IOMMU mappings.

RamDiscardManager is an existing concept (used by virtio-mem) to adjust
VFIO mappings in relation to VM page assignment. Effectively page
conversion is similar to hot-removing a page in one mode and adding it
back in the other. Therefore, similar actions are required for page
conversion events. Introduce the RamDiscardManager to guest_memfd to
facilitate this process.

Since guest_memfd is not an object, it cannot directly implement the
RamDiscardManager interface. One potential attempt is to implement it in
HostMemoryBackend. This is not appropriate because guest_memfd is per
RAMBlock. Some RAMBlocks have a memory backend but others do not. In
particular, the ones like virtual BIOS calling
memory_region_init_ram_guest_memfd() do not.

To manage the RAMBlocks with guest_memfd, define a new object named
MemoryAttributeManager to implement the RamDiscardManager interface. The
object stores guest_memfd information such as shared_bitmap, and handles
page conversion notification. Using the name of MemoryAttributeManager is
aimed to make it more generic. The term "Memory" emcompasses not only RAM
but also private MMIO in TEE I/O, which might rely on this
object/interface to handle page conversion events in the future. The
term "Attribute" allows for the management of various attributes beyond
shared and private. For instance, it could support scenarios where
discard vs. populated and shared vs. private states co-exists, such as
supporting virtio-mem or something similar in the future.

In the current context, MemoryAttributeManager signifies discarded state
as private and populated state as shared. Memory state is tracked at the
host page size granularity, as the minimum memory conversion size can be one
page per request. Additionally, VFIO expects the DMA mapping for a
specific iova to be mapped and unmapped with the same granularity.
Confidential VMs may perform  partial conversions, e.g. conversion
happens on a small region within a large region. To prevent such invalid
cases and until cut_mapping operation support is introduced, all
operations are performed with 4K granularity.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v3:
    - Some rename (bitmap_size->shared_bitmap_size,
      first_one/zero_bit->first_bit, etc.)
    - Change shared_bitmap_size from uint32_t to unsigned
    - Return mgr->mr->ram_block->page_size in get_block_size()
    - Move set_ram_discard_manager() up to avoid a g_free() in failure
      case.
    - Add const for the memory_attribute_manager_get_block_size()
    - Unify the ReplayRamPopulate and ReplayRamDiscard and related
      callback.

Changes in v2:
    - Rename the object name to MemoryAttributeManager
    - Rename the bitmap to shared_bitmap to make it more clear.
    - Remove block_size field and get it from a helper. In future, we
      can get the page_size from RAMBlock if necessary.
    - Remove the unncessary "struct" before GuestMemfdReplayData
    - Remove the unncessary g_free() for the bitmap
    - Add some error report when the callback failure for
      populated/discarded section.
    - Move the realize()/unrealize() definition to this patch.
---
 include/system/memory-attribute-manager.h |  42 ++++
 system/memory-attribute-manager.c         | 283 ++++++++++++++++++++++
 system/meson.build                        |   1 +
 3 files changed, 326 insertions(+)
 create mode 100644 include/system/memory-attribute-manager.h
 create mode 100644 system/memory-attribute-manager.c

diff --git a/include/system/memory-attribute-manager.h b/include/system/memory-attribute-manager.h
new file mode 100644
index 0000000000..23375a14b8
--- /dev/null
+++ b/include/system/memory-attribute-manager.h
@@ -0,0 +1,42 @@
+/*
+ * QEMU memory attribute manager
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Chenyi Qiang <chenyi.qiang@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
+#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
+
+#include "system/hostmem.h"
+
+#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
+
+OBJECT_DECLARE_TYPE(MemoryAttributeManager, MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
+
+struct MemoryAttributeManager {
+    Object parent;
+
+    MemoryRegion *mr;
+
+    /* 1-setting of the bit represents the memory is populated (shared) */
+    unsigned shared_bitmap_size;
+    unsigned long *shared_bitmap;
+
+    QLIST_HEAD(, RamDiscardListener) rdl_list;
+};
+
+struct MemoryAttributeManagerClass {
+    ObjectClass parent_class;
+};
+
+int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr);
+void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
+
+#endif
diff --git a/system/memory-attribute-manager.c b/system/memory-attribute-manager.c
new file mode 100644
index 0000000000..7c3789cf49
--- /dev/null
+++ b/system/memory-attribute-manager.c
@@ -0,0 +1,283 @@
+/*
+ * QEMU memory attribute manager
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Chenyi Qiang <chenyi.qiang@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "exec/ramblock.h"
+#include "system/memory-attribute-manager.h"
+
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
+                                   memory_attribute_manager,
+                                   MEMORY_ATTRIBUTE_MANAGER,
+                                   OBJECT,
+                                   { TYPE_RAM_DISCARD_MANAGER },
+                                   { })
+
+static size_t memory_attribute_manager_get_block_size(const MemoryAttributeManager *mgr)
+{
+    /*
+     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
+     * Use the host page size as the granularity to track the memory attribute.
+     */
+    g_assert(mgr && mgr->mr && mgr->mr->ram_block);
+    g_assert(mgr->mr->ram_block->page_size == qemu_real_host_page_size());
+    return mgr->mr->ram_block->page_size;
+}
+
+
+static bool memory_attribute_rdm_is_populated(const RamDiscardManager *rdm,
+                                              const MemoryRegionSection *section)
+{
+    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
+    const int block_size = memory_attribute_manager_get_block_size(mgr);
+    uint64_t first_bit = section->offset_within_region / block_size;
+    uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
+    unsigned long first_discard_bit;
+
+    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
+    return first_discard_bit > last_bit;
+}
+
+typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s, void *arg);
+
+static int memory_attribute_notify_populate_cb(MemoryRegionSection *section, void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    return rdl->notify_populate(rdl, section);
+}
+
+static int memory_attribute_notify_discard_cb(MemoryRegionSection *section, void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    rdl->notify_discard(rdl, section);
+
+    return 0;
+}
+
+static int memory_attribute_for_each_populated_section(const MemoryAttributeManager *mgr,
+                                                       MemoryRegionSection *section,
+                                                       void *arg,
+                                                       memory_attribute_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const int block_size = memory_attribute_manager_get_block_size(mgr);
+    int ret = 0;
+
+    first_bit = section->offset_within_region / block_size;
+    first_bit = find_next_bit(mgr->shared_bitmap, mgr->shared_bitmap_size, first_bit);
+
+    while (first_bit < mgr->shared_bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_bit * block_size;
+        last_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
+                                      first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * block_size;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
+                         strerror(-ret));
+            break;
+        }
+
+        first_bit = find_next_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
+                                  last_bit + 2);
+    }
+
+    return ret;
+}
+
+static int memory_attribute_for_each_discarded_section(const MemoryAttributeManager *mgr,
+                                                       MemoryRegionSection *section,
+                                                       void *arg,
+                                                       memory_attribute_section_cb cb)
+{
+    unsigned long first_bit, last_bit;
+    uint64_t offset, size;
+    const int block_size = memory_attribute_manager_get_block_size(mgr);
+    int ret = 0;
+
+    first_bit = section->offset_within_region / block_size;
+    first_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
+                                   first_bit);
+
+    while (first_bit < mgr->shared_bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_bit * block_size;
+        last_bit = find_next_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
+                                      first_bit + 1) - 1;
+        size = (last_bit - first_bit + 1) * block_size;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
+                         strerror(-ret));
+            break;
+        }
+
+        first_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
+                                       last_bit + 2);
+    }
+
+    return ret;
+}
+
+static uint64_t memory_attribute_rdm_get_min_granularity(const RamDiscardManager *rdm,
+                                                         const MemoryRegion *mr)
+{
+    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
+
+    g_assert(mr == mgr->mr);
+    return memory_attribute_manager_get_block_size(mgr);
+}
+
+static void memory_attribute_rdm_register_listener(RamDiscardManager *rdm,
+                                                   RamDiscardListener *rdl,
+                                                   MemoryRegionSection *section)
+{
+    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
+    int ret;
+
+    g_assert(section->mr == mgr->mr);
+    rdl->section = memory_region_section_new_copy(section);
+
+    QLIST_INSERT_HEAD(&mgr->rdl_list, rdl, next);
+
+    ret = memory_attribute_for_each_populated_section(mgr, section, rdl,
+                                                      memory_attribute_notify_populate_cb);
+    if (ret) {
+        error_report("%s: Failed to register RAM discard listener: %s", __func__,
+                     strerror(-ret));
+    }
+}
+
+static void memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
+                                                     RamDiscardListener *rdl)
+{
+    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
+    int ret;
+
+    g_assert(rdl->section);
+    g_assert(rdl->section->mr == mgr->mr);
+
+    ret = memory_attribute_for_each_populated_section(mgr, rdl->section, rdl,
+                                                      memory_attribute_notify_discard_cb);
+    if (ret) {
+        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
+                     strerror(-ret));
+    }
+
+    memory_region_section_free_copy(rdl->section);
+    rdl->section = NULL;
+    QLIST_REMOVE(rdl, next);
+
+}
+
+typedef struct MemoryAttributeReplayData {
+    ReplayRamStateChange fn;
+    void *opaque;
+} MemoryAttributeReplayData;
+
+static int memory_attribute_rdm_replay_cb(MemoryRegionSection *section, void *arg)
+{
+    MemoryAttributeReplayData *data = arg;
+
+    return data->fn(section, data->opaque);
+}
+
+static int memory_attribute_rdm_replay_populated(const RamDiscardManager *rdm,
+                                                 MemoryRegionSection *section,
+                                                 ReplayRamStateChange replay_fn,
+                                                 void *opaque)
+{
+    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
+    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == mgr->mr);
+    return memory_attribute_for_each_populated_section(mgr, section, &data,
+                                                       memory_attribute_rdm_replay_cb);
+}
+
+static int memory_attribute_rdm_replay_discarded(const RamDiscardManager *rdm,
+                                                 MemoryRegionSection *section,
+                                                 ReplayRamStateChange replay_fn,
+                                                 void *opaque)
+{
+    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
+    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == mgr->mr);
+    return memory_attribute_for_each_discarded_section(mgr, section, &data,
+                                                       memory_attribute_rdm_replay_cb);
+}
+
+int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr)
+{
+    uint64_t shared_bitmap_size;
+    const int block_size  = qemu_real_host_page_size();
+    int ret;
+
+    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
+
+    mgr->mr = mr;
+    ret = memory_region_set_ram_discard_manager(mgr->mr, RAM_DISCARD_MANAGER(mgr));
+    if (ret) {
+        return ret;
+    }
+    mgr->shared_bitmap_size = shared_bitmap_size;
+    mgr->shared_bitmap = bitmap_new(shared_bitmap_size);
+
+    return ret;
+}
+
+void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
+{
+    g_free(mgr->shared_bitmap);
+    memory_region_set_ram_discard_manager(mgr->mr, NULL);
+}
+
+static void memory_attribute_manager_init(Object *obj)
+{
+    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
+
+    QLIST_INIT(&mgr->rdl_list);
+}
+
+static void memory_attribute_manager_finalize(Object *obj)
+{
+}
+
+static void memory_attribute_manager_class_init(ObjectClass *oc, void *data)
+{
+    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
+
+    rdmc->get_min_granularity = memory_attribute_rdm_get_min_granularity;
+    rdmc->register_listener = memory_attribute_rdm_register_listener;
+    rdmc->unregister_listener = memory_attribute_rdm_unregister_listener;
+    rdmc->is_populated = memory_attribute_rdm_is_populated;
+    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
+    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
+}
diff --git a/system/meson.build b/system/meson.build
index 4952f4b2c7..ab07ff1442 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -15,6 +15,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'memory-attribute-manager.c',
   'memory_mapping.c',
   'qdev-monitor.c',
   'qtest.c',
-- 
2.43.5


