Return-Path: <kvm+bounces-38332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E44AA37CF2
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F07E21718AE
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ACD19F424;
	Mon, 17 Feb 2025 08:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AM+APp6N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0293191F68
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739780333; cv=none; b=sTTFlMd64n0EQe4FY6xo/8RlT5PNIHv8C2ohZGazA3wP6LM5CoOSoZmAkSbXr9MVpG+9rY20RRbv0mEAjbKtXxx9G6sxA66W9kK4+wqGlff+XgDch/DcxhQSoyIceRKr1j5jqA3uWQm9l49LvzL3fCxP51G9bpakeeX/MXRiu90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739780333; c=relaxed/simple;
	bh=xqSOLjyi089bY2ndKhL6A+1UkPmyvIO0I3dcjqPvT+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rO4+ptJNX5Bzm3C0XZywcZ2ZQha1sCiYlP/G5/Y3ecVkJuWelut+CkiHOzQ2+J+nFfieCuBgyjRyRV1M7uO/mHllcnQciy5B4ZupouUNfYbl784qQdXbmxc4MrAQZqv+urpTR7RlOgoJ6x8wj6DUtNbRnkiw2hoGhBsr2hW3aUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AM+APp6N; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739780331; x=1771316331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xqSOLjyi089bY2ndKhL6A+1UkPmyvIO0I3dcjqPvT+Q=;
  b=AM+APp6N8CqrI39hAeLWSIYB7q6/qy83UGdpZ4+Plwec1wW+6QFAnBch
   91XJ57pkkW5pGwRaVQ6jIOvV7SJcF5+687fnx1NXx2fHwRZjMMVnbaWWi
   VDiZOLj3ZJa8QwnSW+WZv7+rYBQO+7goq7fHIuYxa3K1XhzsjIWMYoaqY
   MfBk59j7TnVHKRee7Uwcy2Uh18VujdUJ11qb5C0+sutBD/HexIeo+tzzk
   +VQh7rgBmyBTaqnNWZk2UqQVTuo+YqHspVUinruzN5yBRbVYB9kbiNbxX
   BfInAwchz/Mj5zEFV3cjq9B3JmSW+BteEYk85NT4jLYOM5ZbUeC2buXit
   Q==;
X-CSE-ConnectionGUID: gGLUXB5aRLih0pH038Feiw==
X-CSE-MsgGUID: QlPh+ZwKR1qFAFLnewl03g==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="50668966"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="50668966"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:51 -0800
X-CSE-ConnectionGUID: vLkH71JoTcaZPs2UNAiUVA==
X-CSE-MsgGUID: 7338LJpHQTO0rKHzS9lRAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118690172"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:48 -0800
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
Subject: [PATCH v2 1/6] memory: Export a helper to get intersection of a MemoryRegionSection with a given range
Date: Mon, 17 Feb 2025 16:18:20 +0800
Message-ID: <20250217081833.21568-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250217081833.21568-1-chenyi.qiang@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the helper to memory_region_section_intersect_range() to make it
more generic. Meanwhile, define the @end as Int128 and replace the
related operations with Int128_* format since the helper is exported as
a wider API.

Suggested-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v2:
- Make memory_region_section_intersect_range() an inline function.
- Add Reviewed-by from David
- Define the @end as Int128 and use the related Int128_* ops as a wilder
  API (Alexey)
---
 hw/virtio/virtio-mem.c | 32 +++++---------------------------
 include/exec/memory.h  | 27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index b1a003736b..21f16e4912 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -244,28 +244,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
     return ret;
 }
 
-/*
- * Adjust the memory section to cover the intersection with the given range.
- *
- * Returns false if the intersection is empty, otherwise returns true.
- */
-static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
-                                                uint64_t offset, uint64_t size)
-{
-    uint64_t start = MAX(s->offset_within_region, offset);
-    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
-                       offset + size);
-
-    if (end <= start) {
-        return false;
-    }
-
-    s->offset_within_address_space += start - s->offset_within_region;
-    s->offset_within_region = start;
-    s->size = int128_make64(end - start);
-    return true;
-}
-
 typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
 
 static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
@@ -287,7 +265,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
                                       first_bit + 1) - 1;
         size = (last_bit - first_bit + 1) * vmem->block_size;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             break;
         }
         ret = cb(&tmp, arg);
@@ -319,7 +297,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
                                  first_bit + 1) - 1;
         size = (last_bit - first_bit + 1) * vmem->block_size;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             break;
         }
         ret = cb(&tmp, arg);
@@ -355,7 +333,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
         rdl->notify_discard(rdl, &tmp);
@@ -371,7 +349,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
         ret = rdl->notify_populate(rdl, &tmp);
@@ -388,7 +366,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
             if (rdl2 == rdl) {
                 break;
             }
-            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
                 continue;
             }
             rdl2->notify_discard(rdl2, &tmp);
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 3ee1901b52..3bebc43d59 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1202,6 +1202,33 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
  */
 void memory_region_section_free_copy(MemoryRegionSection *s);
 
+/**
+ * memory_region_section_intersect_range: Adjust the memory section to cover
+ * the intersection with the given range.
+ *
+ * @s: the #MemoryRegionSection to be adjusted
+ * @offset: the offset of the given range in the memory region
+ * @size: the size of the given range
+ *
+ * Returns false if the intersection is empty, otherwise returns true.
+ */
+static inline bool memory_region_section_intersect_range(MemoryRegionSection *s,
+                                                         uint64_t offset, uint64_t size)
+{
+    uint64_t start = MAX(s->offset_within_region, offset);
+    Int128 end = int128_min(int128_add(int128_make64(s->offset_within_region), s->size),
+                            int128_add(int128_make64(offset), int128_make64(size)));
+
+    if (int128_le(end, int128_make64(start))) {
+        return false;
+    }
+
+    s->offset_within_address_space += start - s->offset_within_region;
+    s->offset_within_region = start;
+    s->size = int128_sub(end, int128_make64(start));
+    return true;
+}
+
 /**
  * memory_region_init: Initialize a memory region
  *
-- 
2.43.5


