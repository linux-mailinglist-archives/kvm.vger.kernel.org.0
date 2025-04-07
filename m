Return-Path: <kvm+bounces-42810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8110CA7D6D0
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEF1A16E3D0
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68092227E82;
	Mon,  7 Apr 2025 07:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SLDvahDD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880F226883
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012231; cv=none; b=T7855+Y+adpfZvy/hxxDNy9A7IlocyeExy3uMYqv7rOfyZnzr15lGFfS4Y6oPev8H4beHPiW+Bgu1/LM2FsNZ55mfJX5HN4RNw4P/MzEQzF4eI9MwRrbboLhSZ3nIPyW7ZBO1jqkuDiyrTGKvSdLb/YinxlckHXf7u42IrieLt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012231; c=relaxed/simple;
	bh=LMM4jg2KgMvxa59xhZRJFI8Q6LECqUZX8PbGNMlnhmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKlIYJPN8m9Fw0PukkNpm02UlkXWYqb5cXHZlveOCH1uu9D+2Qhc7SgZW5af1Ea6BatHhW/qmGsBO6pjcaWMW3LfOTZ0hHte3CBijbugsm36vsVbhZG3eDdJB+8lvbW2QyjPvfw9SZntP4HBbWmJooGf747w04p8t2sWPbARSNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SLDvahDD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012230; x=1775548230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LMM4jg2KgMvxa59xhZRJFI8Q6LECqUZX8PbGNMlnhmI=;
  b=SLDvahDDypKvu9QpZi+IHwuPN1py72J2jzDm2a4jHEEC34jOaYAjKiTZ
   k8RtJKAK6n4cBE8+154AlxiwpRtAv9ugCdbeEdoR4u7pTg2nNw+00mFIm
   R6N60HaOcO+9nL89HFkWRVBB4rwfjF15n5G0UA1o1lLP4rxx++QL21sRf
   FNCUZW+rl+xhNSHt0cDktrOFeG3ulWPFtsjb1yGwyVnWNcTb3qTnEfvSe
   uPCENs8GqBnSmWCCoeWgBOo2rALOB6othpq9EgnhKqmPAF//yx1TSL9Ez
   lm7qunAwBraLl7g6h2hHdQ3+v6y6rsH/9q6RELZya3NZpBB+q1937bdPY
   g==;
X-CSE-ConnectionGUID: kvDkuGAeSRuYWucV9xGkhQ==
X-CSE-MsgGUID: i5i+kCkyReWVMpiaUwc3HA==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857596"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857596"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:30 -0700
X-CSE-ConnectionGUID: kzUdn2HcR1SCId2TI2iwPg==
X-CSE-MsgGUID: DHbBCsbTSEi+NmWP/DDS1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405694"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:50:25 -0700
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
Subject: [PATCH v4 11/13] KVM: Introduce CVMPrivateSharedListener for attribute changes during page conversions
Date: Mon,  7 Apr 2025 15:49:31 +0800
Message-ID: <20250407074939.18657-12-chenyi.qiang@intel.com>
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

With the introduction of the RamBlockAttribute object to manage
RAMBlocks with guest_memfd and the implementation of
PrivateSharedManager interface to convey page conversion events, it is
more elegant to move attribute changes into a PrivateSharedListener.

The PrivateSharedListener is reigstered/unregistered for each memory
region section during kvm_region_add/del(), and listeners are stored in
a CVMPrivateSharedListener list for easy management. The listener
handler performs attribute changes upon receiving notifications from
private_shared_manager_state_change() calls. With this change, the
state changes operations in kvm_convert_memory() can be removed.

Note that after moving attribute changes into a listener, errors can be
returned in ram_block_attribute_notify_to_private() if attribute changes
fail in corner cases (e.g. -ENOMEM). Since there is currently no rollback
operation for the to_private case, an assert is used to prevent the
guest from continuing with a partially changed attribute state.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Newly added.
---
 accel/kvm/kvm-all.c                         | 73 ++++++++++++++++++---
 include/system/confidential-guest-support.h | 10 +++
 system/ram-block-attribute.c                | 17 ++++-
 target/i386/kvm/tdx.c                       |  1 +
 target/i386/sev.c                           |  1 +
 5 files changed, 90 insertions(+), 12 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 546b58b737..aec64d559b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -48,6 +48,7 @@
 #include "kvm-cpus.h"
 #include "system/dirtylimit.h"
 #include "qemu/range.h"
+#include "system/confidential-guest-support.h"
 
 #include "hw/boards.h"
 #include "system/stats.h"
@@ -1691,28 +1692,91 @@ static int kvm_dirty_ring_init(KVMState *s)
     return 0;
 }
 
+static int kvm_private_shared_notify(StateChangeListener *scl,
+                                     MemoryRegionSection *section,
+                                     bool to_private)
+{
+    hwaddr start = section->offset_within_address_space;
+    hwaddr size = section->size;
+
+    if (to_private) {
+        return kvm_set_memory_attributes_private(start, size);
+    } else {
+        return kvm_set_memory_attributes_shared(start, size);
+    }
+}
+
+static int kvm_private_shared_notify_to_shared(StateChangeListener *scl,
+                                               MemoryRegionSection *section)
+{
+    return kvm_private_shared_notify(scl, section, false);
+}
+
+static int kvm_private_shared_notify_to_private(StateChangeListener *scl,
+                                                MemoryRegionSection *section)
+{
+    return kvm_private_shared_notify(scl, section, true);
+}
+
 static void kvm_region_add(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
     KVMMemoryUpdate *update;
+    CVMPrivateSharedListener *cpsl;
+    PrivateSharedListener *psl;
+
 
     update = g_new0(KVMMemoryUpdate, 1);
     update->section = *section;
 
     QSIMPLEQ_INSERT_TAIL(&kml->transaction_add, update, next);
+
+    if (!memory_region_has_guest_memfd(section->mr) || !gsm) {
+        return;
+    }
+
+    cpsl = g_new0(CVMPrivateSharedListener, 1);
+    cpsl->mr = section->mr;
+    cpsl->offset_within_address_space = section->offset_within_address_space;
+    cpsl->granularity = generic_state_manager_get_min_granularity(gsm, section->mr);
+    psl = &cpsl->listener;
+    QLIST_INSERT_HEAD(&cgs->cvm_private_shared_list, cpsl, next);
+    private_shared_listener_init(psl, kvm_private_shared_notify_to_shared,
+                                 kvm_private_shared_notify_to_private);
+    generic_state_manager_register_listener(gsm, &psl->scl, section);
 }
 
 static void kvm_region_del(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
     KVMMemoryUpdate *update;
+    CVMPrivateSharedListener *cpsl;
+    PrivateSharedListener *psl;
 
     update = g_new0(KVMMemoryUpdate, 1);
     update->section = *section;
 
     QSIMPLEQ_INSERT_TAIL(&kml->transaction_del, update, next);
+    if (!memory_region_has_guest_memfd(section->mr) || !gsm) {
+        return;
+    }
+
+    QLIST_FOREACH(cpsl, &cgs->cvm_private_shared_list, next) {
+        if (cpsl->mr == section->mr &&
+            cpsl->offset_within_address_space == section->offset_within_address_space) {
+            psl = &cpsl->listener;
+            generic_state_manager_unregister_listener(gsm, &psl->scl);
+            QLIST_REMOVE(cpsl, next);
+            g_free(cpsl);
+            break;
+        }
+    }
 }
 
 static void kvm_region_commit(MemoryListener *listener)
@@ -3076,15 +3140,6 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         goto out_unref;
     }
 
-    if (to_private) {
-        ret = kvm_set_memory_attributes_private(start, size);
-    } else {
-        ret = kvm_set_memory_attributes_shared(start, size);
-    }
-    if (ret) {
-        goto out_unref;
-    }
-
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
index b68c4bebbc..64f67db19a 100644
--- a/include/system/confidential-guest-support.h
+++ b/include/system/confidential-guest-support.h
@@ -23,12 +23,20 @@
 #endif
 
 #include "qom/object.h"
+#include "exec/memory.h"
 
 #define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
 OBJECT_DECLARE_TYPE(ConfidentialGuestSupport,
                     ConfidentialGuestSupportClass,
                     CONFIDENTIAL_GUEST_SUPPORT)
 
+typedef struct CVMPrivateSharedListener {
+    MemoryRegion *mr;
+    hwaddr offset_within_address_space;
+    uint64_t granularity;
+    PrivateSharedListener listener;
+    QLIST_ENTRY(CVMPrivateSharedListener) next;
+} CVMPrivateSharedListener;
 
 struct ConfidentialGuestSupport {
     Object parent;
@@ -38,6 +46,8 @@ struct ConfidentialGuestSupport {
      */
     bool require_guest_memfd;
 
+    QLIST_HEAD(, CVMPrivateSharedListener) cvm_private_shared_list;
+
     /*
      * ready: flag set by CGS initialization code once it's ready to
      *        start executing instructions in a potentially-secure
diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
index 06ed134cda..15c9aebd09 100644
--- a/system/ram-block-attribute.c
+++ b/system/ram-block-attribute.c
@@ -259,6 +259,7 @@ static void ram_block_attribute_notify_to_private(RamBlockAttribute *attr,
                                                   uint64_t offset, uint64_t size)
 {
     PrivateSharedListener *psl;
+    int ret;
 
     QLIST_FOREACH(psl, &attr->psl_list, next) {
         StateChangeListener *scl = &psl->scl;
@@ -267,7 +268,12 @@ static void ram_block_attribute_notify_to_private(RamBlockAttribute *attr,
         if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
-        scl->notify_to_state_clear(scl, &tmp);
+        /*
+         * No undo operation for the state_clear() callback failure at present.
+         * Expect the state_clear() callback always succeed.
+         */
+        ret = scl->notify_to_state_clear(scl, &tmp);
+        g_assert(!ret);
     }
 }
 
@@ -275,7 +281,7 @@ static int ram_block_attribute_notify_to_shared(RamBlockAttribute *attr,
                                                 uint64_t offset, uint64_t size)
 {
     PrivateSharedListener *psl, *psl2;
-    int ret = 0;
+    int ret = 0, ret2 = 0;
 
     QLIST_FOREACH(psl, &attr->psl_list, next) {
         StateChangeListener *scl = &psl->scl;
@@ -302,7 +308,12 @@ static int ram_block_attribute_notify_to_shared(RamBlockAttribute *attr,
             if (!memory_region_section_intersect_range(&tmp, offset, size)) {
                 continue;
             }
-            scl2->notify_to_state_clear(scl2, &tmp);
+            /*
+             * No undo operation for the state_clear() callback failure at present.
+             * Expect the state_clear() callback always succeed.
+             */
+            ret2 = scl2->notify_to_state_clear(scl2, &tmp);
+            g_assert(!ret2);
         }
     }
     return ret;
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index c906a76c4c..718385c8de 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1179,6 +1179,7 @@ static void tdx_guest_init(Object *obj)
     qemu_mutex_init(&tdx->lock);
 
     cgs->require_guest_memfd = true;
+    QLIST_INIT(&cgs->cvm_private_shared_list);
     tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
 
     object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 217b19ad7b..6647727a44 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2432,6 +2432,7 @@ sev_snp_guest_instance_init(Object *obj)
     SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
 
     cgs->require_guest_memfd = true;
+    QLIST_INIT(&cgs->cvm_private_shared_list);
 
     /* default init/start/finish params for kvm */
     sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
-- 
2.43.5


