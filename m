Return-Path: <kvm+bounces-40604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3D8A58DEF
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8117E188D86B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D55223705;
	Mon, 10 Mar 2025 08:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZGI/iz1d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C94223704
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594835; cv=none; b=RvLoz1ho2C3sdYPnSU3biNyVTloWK59x73LWE4XVAnYHEkdsdUW4yiu4EvsoAFoxhYGm+Ku6Cy7DVp6NGmQu0ObVJ4EoaPkLoxbmqslB+pjLpoKJLRuo81m6cxCAj0HJ9reE8gvHvaePLZDNWCgbOrJ3U1357g5VfgVYDgbBORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594835; c=relaxed/simple;
	bh=b6lchNVADy7xTCAqWEfXhsSnOKmLmxfVx+1juDHu804=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajh9PTnba/3Ysq73WUm+/nftjLHKad/jdG4dgc4jsER/ke8JuWE9dnpxFZgApxWFEhW5+DuEolcUCl9Ab5txcSyq+Czh8n4xVZ3egv5ZQ90PgxZ4eEH8UYT32FnWqFeJfR74XtXEMMYmPMdaEn2mXFuRC4UDDOlxYFS18iXtrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZGI/iz1d; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741594833; x=1773130833;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6lchNVADy7xTCAqWEfXhsSnOKmLmxfVx+1juDHu804=;
  b=ZGI/iz1dQzU0XKtUoZTq54uSWidunkaiCKxF1eMqB0M3vv0oeoJBhZKq
   YN6+wZOzjoAunArrL/nfHNGPlYYsVdBblzLrm5XDC1b1waDyNuNa3O2OY
   qaqTZiZMIKxoHyXW/DLgSWGgcAF2thGPQugIXtJ5j7ZJAiwZfSzSeN6Gf
   5HBYV1P4e6HyUf2EyClO6HRuEy2r4ULQn1Lv6Au44GBuoO6174MkNRqZO
   AAnj497ccgC5BRkPaEQ2aDllNRvFDMcB8v9wJBP2BzdvSADWTO90O4wrm
   SENBQIpLC5ezQTxAtk9bP/qH204nprfmX+cdduAc8PcgnI5XqE9u9WWQc
   g==;
X-CSE-ConnectionGUID: 7unmDtFbSQuVm708gRlq7Q==
X-CSE-MsgGUID: dHpRa+FpRAOmk1TBv8JbCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42688493"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42688493"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:33 -0700
X-CSE-ConnectionGUID: whMZImZRRfyA/jFe6PRazw==
X-CSE-MsgGUID: JoK30sO+ReKoPWf5DZzAdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150862833"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:30 -0700
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
Subject: [PATCH v3 5/7] memory-attribute-manager: Introduce a callback to notify the shared/private state change
Date: Mon, 10 Mar 2025 16:18:33 +0800
Message-ID: <20250310081837.13123-6-chenyi.qiang@intel.com>
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

Introduce a new state_change() callback in MemoryAttributeManagerClass to
efficiently notify all registered RamDiscardListeners, including VFIO
listeners about the memory conversion events in guest_memfd. The
existing VFIO listener can dynamically DMA map/unmap the shared pages
based on conversion types:
- For conversions from shared to private, the VFIO system ensures the
  discarding of shared mapping from the IOMMU.
- For conversions from private to shared, it triggers the population of
  the shared mapping into the IOMMU.

Additionally, there could be some special conversion requests:
- When a conversion request is made for a page already in the desired
  state, the helper simply returns success.
- For requests involving a range partially in the desired state, only
  the necessary segments are converted, ensuring the entire range
  complies with the request efficiently. In this case, fallback to a "1
  block at a time" handling.
- In scenarios where a conversion request is declined by other systems,
  such as a failure from VFIO during notify_populate(), the helper will
  roll back the request, maintaining consistency.

Note that the bitmap status is updated before the notifier callbacks so
that the listener can handle the memory based on the latest status.

Opportunistically introduce a helper to trigger the state_change()
callback of the class.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
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
 include/system/memory-attribute-manager.h |  18 +++
 system/memory-attribute-manager.c         | 188 ++++++++++++++++++++++
 2 files changed, 206 insertions(+)

diff --git a/include/system/memory-attribute-manager.h b/include/system/memory-attribute-manager.h
index 23375a14b8..3d9227d62a 100644
--- a/include/system/memory-attribute-manager.h
+++ b/include/system/memory-attribute-manager.h
@@ -34,8 +34,26 @@ struct MemoryAttributeManager {
 
 struct MemoryAttributeManagerClass {
     ObjectClass parent_class;
+
+    int (*state_change)(MemoryAttributeManager *mgr, uint64_t offset, uint64_t size,
+                        bool to_private);
 };
 
+static inline int memory_attribute_manager_state_change(MemoryAttributeManager *mgr, uint64_t offset,
+                                                        uint64_t size, bool to_private)
+{
+    MemoryAttributeManagerClass *klass;
+
+    if (mgr == NULL) {
+        return 0;
+    }
+
+    klass = MEMORY_ATTRIBUTE_MANAGER_GET_CLASS(mgr);
+
+    g_assert(klass->state_change);
+    return klass->state_change(mgr, offset, size, to_private);
+}
+
 int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr);
 void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
 
diff --git a/system/memory-attribute-manager.c b/system/memory-attribute-manager.c
index 7c3789cf49..6456babc95 100644
--- a/system/memory-attribute-manager.c
+++ b/system/memory-attribute-manager.c
@@ -234,6 +234,191 @@ static int memory_attribute_rdm_replay_discarded(const RamDiscardManager *rdm,
                                                        memory_attribute_rdm_replay_cb);
 }
 
+static bool memory_attribute_is_valid_range(MemoryAttributeManager *mgr,
+                                            uint64_t offset, uint64_t size)
+{
+    MemoryRegion *mr = mgr->mr;
+
+    g_assert(mr);
+
+    uint64_t region_size = memory_region_size(mr);
+    int block_size = memory_attribute_manager_get_block_size(mgr);
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
+static void memory_attribute_notify_discard(MemoryAttributeManager *mgr,
+                                            uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl;
+
+    QLIST_FOREACH(rdl, &mgr->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        rdl->notify_discard(rdl, &tmp);
+    }
+}
+
+static int memory_attribute_notify_populate(MemoryAttributeManager *mgr,
+                                            uint64_t offset, uint64_t size)
+{
+    RamDiscardListener *rdl, *rdl2;
+    int ret = 0;
+
+    QLIST_FOREACH(rdl, &mgr->rdl_list, next) {
+        MemoryRegionSection tmp = *rdl->section;
+
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+            continue;
+        }
+        ret = rdl->notify_populate(rdl, &tmp);
+        if (ret) {
+            break;
+        }
+    }
+
+    if (ret) {
+        /* Notify all already-notified listeners. */
+        QLIST_FOREACH(rdl2, &mgr->rdl_list, next) {
+            MemoryRegionSection tmp = *rdl2->section;
+
+            if (rdl2 == rdl) {
+                break;
+            }
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
+                continue;
+            }
+            rdl2->notify_discard(rdl2, &tmp);
+        }
+    }
+    return ret;
+}
+
+static bool memory_attribute_is_range_populated(MemoryAttributeManager *mgr,
+                                                uint64_t offset, uint64_t size)
+{
+    const int block_size = memory_attribute_manager_get_block_size(mgr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_zero_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static bool memory_attribute_is_range_discarded(MemoryAttributeManager *mgr,
+                                                uint64_t offset, uint64_t size)
+{
+    const int block_size = memory_attribute_manager_get_block_size(mgr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long last_bit = first_bit + (size / block_size) - 1;
+    unsigned long found_bit;
+
+    /* We fake a shorter bitmap to avoid searching too far. */
+    found_bit = find_next_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
+    return found_bit > last_bit;
+}
+
+static int memory_attribute_state_change(MemoryAttributeManager *mgr, uint64_t offset,
+                                         uint64_t size, bool to_private)
+{
+    const int block_size = memory_attribute_manager_get_block_size(mgr);
+    const unsigned long first_bit = offset / block_size;
+    const unsigned long nbits = size / block_size;
+    const uint64_t end = offset + size;
+    unsigned long bit;
+    uint64_t cur;
+    int ret = 0;
+
+    if (!memory_attribute_is_valid_range(mgr, offset, size)) {
+        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
+                     __func__, offset, size);
+        return -1;
+    }
+
+    if (to_private) {
+        if (memory_attribute_is_range_discarded(mgr, offset, size)) {
+            /* Already private */
+        } else if (!memory_attribute_is_range_populated(mgr, offset, size)) {
+            /* Unexpected mixture: process individual blocks */
+            for (cur = offset; cur < end; cur += block_size) {
+                bit = cur / block_size;
+                if (!test_bit(bit, mgr->shared_bitmap)) {
+                    continue;
+                }
+                clear_bit(bit, mgr->shared_bitmap);
+                memory_attribute_notify_discard(mgr, cur, block_size);
+            }
+        } else {
+            /* Completely shared */
+            bitmap_clear(mgr->shared_bitmap, first_bit, nbits);
+            memory_attribute_notify_discard(mgr, offset, size);
+        }
+    } else {
+        if (memory_attribute_is_range_populated(mgr, offset, size)) {
+            /* Already shared */
+        } else if (!memory_attribute_is_range_discarded(mgr, offset, size)) {
+            /* Unexpected mixture: process individual blocks */
+            unsigned long *modified_bitmap = bitmap_new(nbits);
+
+            for (cur = offset; cur < end; cur += block_size) {
+                bit = cur / block_size;
+                if (test_bit(bit, mgr->shared_bitmap)) {
+                    continue;
+                }
+                set_bit(bit, mgr->shared_bitmap);
+                ret = memory_attribute_notify_populate(mgr, cur, block_size);
+                if (!ret) {
+                    set_bit(bit - first_bit, modified_bitmap);
+                    continue;
+                }
+                clear_bit(bit, mgr->shared_bitmap);
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
+                    assert(test_bit(bit, mgr->shared_bitmap));
+                    clear_bit(bit, mgr->shared_bitmap);
+                    memory_attribute_notify_discard(mgr, cur, block_size);
+                }
+            }
+            g_free(modified_bitmap);
+        } else {
+            /* Complete private */
+            bitmap_set(mgr->shared_bitmap, first_bit, nbits);
+            ret = memory_attribute_notify_populate(mgr, offset, size);
+            if (ret) {
+                bitmap_clear(mgr->shared_bitmap, first_bit, nbits);
+            }
+        }
+    }
+
+    return ret;
+}
+
 int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr)
 {
     uint64_t shared_bitmap_size;
@@ -272,8 +457,11 @@ static void memory_attribute_manager_finalize(Object *obj)
 
 static void memory_attribute_manager_class_init(ObjectClass *oc, void *data)
 {
+    MemoryAttributeManagerClass *mamc = MEMORY_ATTRIBUTE_MANAGER_CLASS(oc);
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
 
+    mamc->state_change = memory_attribute_state_change;
+
     rdmc->get_min_granularity = memory_attribute_rdm_get_min_granularity;
     rdmc->register_listener = memory_attribute_rdm_register_listener;
     rdmc->unregister_listener = memory_attribute_rdm_unregister_listener;
-- 
2.43.5


