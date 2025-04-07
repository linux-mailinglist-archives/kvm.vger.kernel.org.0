Return-Path: <kvm+bounces-42807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8706EA7D6B8
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87EED1888D04
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B55E226170;
	Mon,  7 Apr 2025 07:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U/tZwQV2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D286F227B8C
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012219; cv=none; b=jeH67HW+z/E7G42r+yKpaa5QpjbZcqVwlOC9YufH7MS3sFQoEv/N+zS/6KeVizVtlY+RIazcT74bVAArdm+m+daYG8xXt/QgHo+c4AGPHwfP11U6MV96jwwI3xyDTrrF+5G7DR+loXcpVxSzYsi3Ej9Qxrh6uRAnoS4s+LWPshE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012219; c=relaxed/simple;
	bh=o+a/Hw3O4JaruEHuRPJRaztD3Sx+cvobAeN0HQKIJvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1ifOIwPF5+aj8J76DYeltcmB/68pmz4zkoqfZVgNwW3AAym3G/qDKi2ehryslfdlsR6FNFj2mHC6JDkwqkIp5ZJO4bUnMhw4e0gniCaXAfp6WHPOHPergeGd9HDYtcPp4V8vOXS7r6Tb+MU91/gaUGWZFpHs6s4wO02eisXCm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U/tZwQV2; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012218; x=1775548218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o+a/Hw3O4JaruEHuRPJRaztD3Sx+cvobAeN0HQKIJvQ=;
  b=U/tZwQV2FI8GQONgAaAf1ZPIEaq5+jxVUBPgaffZIFuMiFrUxe95OScb
   ll9zHQ/+dLXHdxm5xjXGchYSvvbzPXRPg3SUazi0b9O9C/8q4NS+I2zdF
   xDLU0eM7T7oWLRY7YZLsacS+UAJ4S3iLYOdX5OzIKP0yWwWYHpNWsXcgd
   qvj6XiyS4omMwFTPkCjdXMh9hyOh6l3+8jG3QTc0bcgikLpt1gLNKN8gB
   Rjy+QiPX/RmWfPzKLw1j71w5gYyiLQSsKjHKHlAgxtN7rTriI5t+nezc6
   7epsBhpehxg+vwn9UBdtEFs6V+xPtFqHBAvIIOjqO5GkBVkoRbycKdtr6
   g==;
X-CSE-ConnectionGUID: Roh34rF2RwaujkdoSy+dKA==
X-CSE-MsgGUID: wYAhUGAmR7O+BWIJ0AGxlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857563"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857563"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:18 -0700
X-CSE-ConnectionGUID: ZqAUSgJjSNmFp9U52hhdEg==
X-CSE-MsgGUID: qT3igI5+Ro6ZU3k+HwPskw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405652"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:14 -0700
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
Subject: [PATCH v4 08/13] ram-block-attribute: Introduce a callback to notify shared/private state changes
Date: Mon,  7 Apr 2025 15:49:28 +0800
Message-ID: <20250407074939.18657-9-chenyi.qiang@intel.com>
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

A new state_change() callback is introduced in PrivateSharedManageClass
to efficiently notify all registered PrivateSharedListeners, including
VFIO listeners, about memory conversion events in guest_memfd. The VFIO
listener can dynamically DMA map/unmap shared pages based on conversion
types:
- For conversions from shared to private, the VFIO system ensures the
  discarding of shared mapping from the IOMMU.
- For conversions from private to shared, it triggers the population of
  the shared mapping into the IOMMU.

Additionally, special conversion requests are handled as followed:
- If a conversion request is made for a page already in the desired
  state, the helper simply returns success.
- For requests involving a range partially in the desired state, only
  the necessary segments are converted, ensuring efficient compliance
  with the request. In this case, fallback to "1 block at a time"
  handling so that the range passed to the notify_to_private/shared() is
  always in the desired state.
- If a conversion request is declined by other systems, such as a
  failure from VFIO during notify_to_shared(), the helper rolls back the
  request to maintain consistency. As for notify_to_private() handling,
  failure in VFIO is unexpected, so no error check is performed.

Note that the bitmap status is updated before callbacks, allowing
listeners to handle memory based on the latest status.

Opportunistically, introduce a helper to trigger the state_change()
callback of the class.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Add the state_change() callback in PrivateSharedManagerClass
      instead of the RamBlockAttribute.

Changes in v3:
    - Move the bitmap update before notifier callbacks.
    - Call the notifier callbacks directly in notify_discard/populate()
      with the expectation that the request memory range is in the
      desired attribute.
    - For the case that only partial range in the desire status, handle
      the range with block_size granularity for ease of rollback
      (https://lore.kernel.org/qemu-devel/812768d7-a02d-4b29-95f3-fb7a125cf54e@redhat.com/)

Changes in v2:
    - Do the alignment changes due to the rename to MemoryAttributeManager
    - Move the state_change() helper definition in this patch.
---
 include/exec/memory.h        |   7 ++
 system/memory.c              |  10 ++
 system/ram-block-attribute.c | 191 +++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 08f25e5e84..a61896251c 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -780,6 +780,9 @@ struct PrivateSharedListener {
 struct PrivateSharedManagerClass {
     /* private */
     GenericStateManagerClass parent_class;
+
+    int (*state_change)(PrivateSharedManager *mgr, uint64_t offset, uint64_t size,
+                        bool to_private);
 };
 
 static inline void private_shared_listener_init(PrivateSharedListener *psl,
@@ -789,6 +792,10 @@ static inline void private_shared_listener_init(PrivateSharedListener *psl,
     state_change_listener_init(&psl->scl, populate_fn, discard_fn);
 }
 
+int private_shared_manager_state_change(PrivateSharedManager *mgr,
+                                        uint64_t offset, uint64_t size,
+                                        bool to_private);
+
 /**
  * memory_get_xlat_addr: Extract addresses from a TLB entry
  *
diff --git a/system/memory.c b/system/memory.c
index e6e944d9c0..2f6eaf6314 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2206,6 +2206,16 @@ void generic_state_manager_unregister_listener(GenericStateManager *gsm,
     gsmc->unregister_listener(gsm, scl);
 }
 
+int private_shared_manager_state_change(PrivateSharedManager *mgr,
+                                        uint64_t offset, uint64_t size,
+                                        bool to_private)
+{
+    PrivateSharedManagerClass *psmc = PRIVATE_SHARED_MANAGER_GET_CLASS(mgr);
+
+    g_assert(psmc->state_change);
+    return psmc->state_change(mgr, offset, size, to_private);
+}
+
 /* Called with rcu_read_lock held.  */
 bool memory_get_xlat_addr(IOMMUTLBEntry *iotlb, void **vaddr,
                           ram_addr_t *ram_addr, bool *read_only,
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index 283c03b354..06ed134cda 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -233,6 +233,195 @@ static int ram_block_attribute_psm_replay_on_private(const GenericStateManager *
                                                         ram_block_attribute_psm_replay_cb);
 }
 
+static bool ram_block_attribute_is_valid_range(RamBlockAttribute *attr,
+                                               uint64_t offset, uint64_t size)
+{
+    MemoryRegion *mr = attr->mr;
+
+    g_assert(mr);
+
+    uint64_t region_size = memory_region_size(mr);
+    int block_size = ram_block_attribute_get_block_size(attr);
+
+    if (!QEMU_IS_ALIGNED(offset, block_size)) {
+        return false;
+    }
+    if (offset + size < offset || !size) {
+        return false;
+    }
+    if (offset >= region_size || offset + size > region_size) {
+        return false;
+    }
+    return true;
+}
+
+static void ram_block_attribute_notify_to_private(RamBlockAttribute *attr,
+                                                  uint64_t offset, uint64_t size)
+{
+    PrivateSharedListener *psl;
+
+    QLIST_FOREACH(psl, &attr->psl_list, next) {
+        StateChangeListener *scl = &psl->scl;
+        MemoryRegionSection tmp = *scl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        scl->notify_to_state_clear(scl, &tmp);
+    }
+}
+
+static int ram_block_attribute_notify_to_shared(RamBlockAttribute *attr,
+                                                uint64_t offset, uint64_t size)
+{
+    PrivateSharedListener *psl, *psl2;
+    int ret = 0;
+
+    QLIST_FOREACH(psl, &attr->psl_list, next) {
+        StateChangeListener *scl = &psl->scl;
+        MemoryRegionSection tmp = *scl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        ret = scl->notify_to_state_set(scl, &tmp);
+        if (ret) {
+            break;
+        }
+    }
+
+    if (ret) {
+        /* Notify all already-notified listeners. */
+        QLIST_FOREACH(psl2, &attr->psl_list, next) {
+            StateChangeListener *scl2 = &psl2->scl;
+            MemoryRegionSection tmp = *scl2->section;
+
+            if (psl == psl2) {
+                break;
+            }
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+                continue;
+            }
+            scl2->notify_to_state_clear(scl2, &tmp);
+        }
+    }
+    return ret;
+}
+
+static bool ram_block_attribute_is_range_shared(RamBlockAttribute *attr,
+                                                uint64_t offset, uint64_t size)
+{
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_zero_bit(attr->shared_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static bool ram_block_attribute_is_range_private(RamBlockAttribute *attr,
+                                                uint64_t offset, uint64_t size)
+{
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_bit(attr->shared_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static int ram_block_attribute_psm_state_change(PrivateSharedManager *mgr, uint64_t offset,
+                                                uint64_t size, bool to_private)
+{
+    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(mgr);
+    const int block_size = ram_block_attribute_get_block_size(attr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long nbits = size / block_size;
+    const uint64_t end = offset + size;
+    unsigned long bit;
+    uint64_t cur;
+    int ret = 0;
+
+    if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
+        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
+                     __func__, offset, size);
+        return -1;
+    }
+
+    if (to_private) {
+        if (ram_block_attribute_is_range_private(attr, offset, size)) {
+            /* Already private */
+        } else if (!ram_block_attribute_is_range_shared(attr, offset, size)) {
+            /* Unexpected mixture: process individual blocks */
+            for (cur = offset; cur < end; cur += block_size) {
+                bit = cur / block_size;
+                if (!test_bit(bit, attr->shared_bitmap)) {
+                    continue;
+                }
+                clear_bit(bit, attr->shared_bitmap);
+                ram_block_attribute_notify_to_private(attr, cur, block_size);
+            }
+        } else {
+            /* Completely shared */
+            bitmap_clear(attr->shared_bitmap, first_bit, nbits);
+            ram_block_attribute_notify_to_private(attr, offset, size);
+        }
+    } else {
+        if (ram_block_attribute_is_range_shared(attr, offset, size)) {
+            /* Already shared */
+        } else if (!ram_block_attribute_is_range_private(attr, offset, size)) {
+            /* Unexpected mixture: process individual blocks */
+            unsigned long *modified_bitmap = bitmap_new(nbits);
+
+            for (cur = offset; cur < end; cur += block_size) {
+                bit = cur / block_size;
+                if (test_bit(bit, attr->shared_bitmap)) {
+                    continue;
+                }
+                set_bit(bit, attr->shared_bitmap);
+                ret = ram_block_attribute_notify_to_shared(attr, cur, block_size);
+                if (!ret) {
+                    set_bit(bit - first_bit, modified_bitmap);
+                    continue;
+                }
+                clear_bit(bit, attr->shared_bitmap);
+                break;
+            }
+
+            if (ret) {
+                /*
+                 * Very unexpected: something went wrong. Revert to the old
+                 * state, marking only the blocks as private that we converted
+                 * to shared.
+                 */
+                for (cur = offset; cur < end; cur += block_size) {
+                    bit = cur / block_size;
+                    if (!test_bit(bit - first_bit, modified_bitmap)) {
+                        continue;
+                    }
+                    assert(test_bit(bit, attr->shared_bitmap));
+                    clear_bit(bit, attr->shared_bitmap);
+                    ram_block_attribute_notify_to_private(attr, cur, block_size);
+                }
+            }
+            g_free(modified_bitmap);
+        } else {
+            /* Complete private */
+            bitmap_set(attr->shared_bitmap, first_bit, nbits);
+            ret = ram_block_attribute_notify_to_shared(attr, offset, size);
+            if (ret) {
+                bitmap_clear(attr->shared_bitmap, first_bit, nbits);
+            }
+        }
+    }
+
+    return ret;
+}
+
 int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr)
 {
     uint64_t shared_bitmap_size;
@@ -272,6 +461,7 @@ static void ram_block_attribute_finalize(Object *obj)
 static void ram_block_attribute_class_init(ObjectClass *oc, void *data)
 {
     GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_CLASS(oc);
+    PrivateSharedManagerClass *psmc = PRIVATE_SHARED_MANAGER_CLASS(oc);
 
     gsmc->get_min_granularity = ram_block_attribute_psm_get_min_granularity;
     gsmc->register_listener = ram_block_attribute_psm_register_listener;
@@ -279,4 +469,5 @@ static void ram_block_attribute_class_init(ObjectClass *oc, void *data)
     gsmc->is_state_set = ram_block_attribute_psm_is_shared;
     gsmc->replay_on_state_set = ram_block_attribute_psm_replay_on_shared;
     gsmc->replay_on_state_clear = ram_block_attribute_psm_replay_on_private;
+    psmc->state_change = ram_block_attribute_psm_state_change;
 }
-- 
2.43.5


