Return-Path: <kvm+bounces-36507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4540BA1B703
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9258C3AEDDA
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F0D43ACB;
	Fri, 24 Jan 2025 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LbAsiLqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507FB3594E
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725907; cv=none; b=H/NwvJ3r7xTvs3um0RTcYGHsFNlgv6AX0EPPoyugT9e5BQ6LdN2+CHnVINZu3j5TNZ+kY0732eDtc1v1+MAfUJR2zO16nLYp1IFUfPcrjijjWmjzjgHvFPTSBPzoF9fnugm3xkdSBPjZxOCBIWRQyUm9Mg11pK0t0LtJoDVleJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725907; c=relaxed/simple;
	bh=ixU51CF6UUWsmb9IHjxnBODnRzhifF9E991mS+vT1Ps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYao13lxKWdUJfmKQYforVKPic7Ifiijr0Jif5AGXpv4u4GJVmvCvSiv1zo3epezdT7jyc01TMfvkGlQh+XVk2ShmRVo5FbLAkxpJylN3k8Dvf87dTi4qdESO5duIfYhMbndtPOGtdH34fbzKveXAz2cutsMqJAPI7UyBCk5Oi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LbAsiLqZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725906; x=1769261906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ixU51CF6UUWsmb9IHjxnBODnRzhifF9E991mS+vT1Ps=;
  b=LbAsiLqZGMn0CvyB3gviq9ZrEDHbgaLn1hNkkrFiOco8v05bs3z+d/Pg
   foC+Bb/B+IXmnC99uqwbndqNDD3SsxUQDBY7A8drfFiyZS56N9QsxfRVm
   DIPvQJeBv4DU08I+ukIRry49UMUqWB+lqg2yUcHYLx6js/lCnKK4EugKW
   EkxNEIMQMd+gAW4NPMU/mePTGnHHO/A55hJTLePdwZu58awwMLauC01Hb
   1ZWaLiz5Kk1jgfB0JW1u6LnysIsqFctB3sNrcwU4XBNqv1ci1+9uPxnac
   86LbKnkzRMSTOin7bF1CGzP3PBDusNbfZpxjY2cqFUv1xGMUM5wUtOPlp
   g==;
X-CSE-ConnectionGUID: 8CTLDNh9TGSWWFWjPd2uXQ==
X-CSE-MsgGUID: t2+ANXkVTeOoQCIcZYUvgA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246401"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246401"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:25 -0800
X-CSE-ConnectionGUID: 5jMKAbHeRFqxjG/GKagFTw==
X-CSE-MsgGUID: 1EZBSxV5QWmHBGZW3V2tOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804306"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:21 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 22/52] i386/tdx: Setup the TD HOB list
Date: Fri, 24 Jan 2025 08:20:18 -0500
Message-Id: <20250124132048.3229049-23-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TD HOB list is used to pass the information from VMM to TDVF. The TD
HOB must include PHIT HOB and Resource Descriptor HOB. More details can
be found in TDVF specification and PI specification.

Build the TD HOB in TDX's machine_init_done callback.

Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v7:
 - use SPDX tag for license info;
 - clean up the included headers;

Changes in v1:
 - drop the code of adding mmio resources since OVMF prepares all the
   MMIO hob itself.
---
 hw/i386/meson.build   |   2 +-
 hw/i386/tdvf-hob.c    | 130 ++++++++++++++++++++++++++++++++++++++++++
 hw/i386/tdvf-hob.h    |  26 +++++++++
 target/i386/kvm/tdx.c |  16 ++++++
 4 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 hw/i386/tdvf-hob.c
 create mode 100644 hw/i386/tdvf-hob.h

diff --git a/hw/i386/meson.build b/hw/i386/meson.build
index 3bc1da2b6eb4..7896f348cff8 100644
--- a/hw/i386/meson.build
+++ b/hw/i386/meson.build
@@ -32,7 +32,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
   'port92.c'))
 i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
                                         if_false: files('pc_sysfw_ovmf-stubs.c'))
-i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
+i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c', 'tdvf-hob.c'))
 
 subdir('kvm')
 subdir('xen')
diff --git a/hw/i386/tdvf-hob.c b/hw/i386/tdvf-hob.c
new file mode 100644
index 000000000000..782b3d157879
--- /dev/null
+++ b/hw/i386/tdvf-hob.c
@@ -0,0 +1,130 @@
+/*
+ * Copyright (c) 2025 Intel Corporation
+ * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
+ *                        <isaku.yamahata at intel.com>
+ *         Xiaoyao Li <xiaoyao.li@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "standard-headers/uefi/uefi.h"
+#include "hw/pci/pcie_host.h"
+#include "tdvf-hob.h"
+
+typedef struct TdvfHob {
+    hwaddr hob_addr;
+    void *ptr;
+    int size;
+
+    /* working area */
+    void *current;
+    void *end;
+} TdvfHob;
+
+static uint64_t tdvf_current_guest_addr(const TdvfHob *hob)
+{
+    return hob->hob_addr + (hob->current - hob->ptr);
+}
+
+static void tdvf_align(TdvfHob *hob, size_t align)
+{
+    hob->current = QEMU_ALIGN_PTR_UP(hob->current, align);
+}
+
+static void *tdvf_get_area(TdvfHob *hob, uint64_t size)
+{
+    void *ret;
+
+    if (hob->current + size > hob->end) {
+        error_report("TD_HOB overrun, size = 0x%" PRIx64, size);
+        exit(1);
+    }
+
+    ret = hob->current;
+    hob->current += size;
+    tdvf_align(hob, 8);
+    return ret;
+}
+
+static void tdvf_hob_add_memory_resources(TdxGuest *tdx, TdvfHob *hob)
+{
+    EFI_HOB_RESOURCE_DESCRIPTOR *region;
+    EFI_RESOURCE_ATTRIBUTE_TYPE attr;
+    EFI_RESOURCE_TYPE resource_type;
+
+    TdxRamEntry *e;
+    int i;
+
+    for (i = 0; i < tdx->nr_ram_entries; i++) {
+        e = &tdx->ram_entries[i];
+
+        if (e->type == TDX_RAM_UNACCEPTED) {
+            resource_type = EFI_RESOURCE_MEMORY_UNACCEPTED;
+            attr = EFI_RESOURCE_ATTRIBUTE_TDVF_UNACCEPTED;
+        } else if (e->type == TDX_RAM_ADDED) {
+            resource_type = EFI_RESOURCE_SYSTEM_MEMORY;
+            attr = EFI_RESOURCE_ATTRIBUTE_TDVF_PRIVATE;
+        } else {
+            error_report("unknown TDX_RAM_ENTRY type %d", e->type);
+            exit(1);
+        }
+
+        region = tdvf_get_area(hob, sizeof(*region));
+        *region = (EFI_HOB_RESOURCE_DESCRIPTOR) {
+            .Header = {
+                .HobType = EFI_HOB_TYPE_RESOURCE_DESCRIPTOR,
+                .HobLength = cpu_to_le16(sizeof(*region)),
+                .Reserved = cpu_to_le32(0),
+            },
+            .Owner = EFI_HOB_OWNER_ZERO,
+            .ResourceType = cpu_to_le32(resource_type),
+            .ResourceAttribute = cpu_to_le32(attr),
+            .PhysicalStart = cpu_to_le64(e->address),
+            .ResourceLength = cpu_to_le64(e->length),
+        };
+    }
+}
+
+void tdvf_hob_create(TdxGuest *tdx, TdxFirmwareEntry *td_hob)
+{
+    TdvfHob hob = {
+        .hob_addr = td_hob->address,
+        .size = td_hob->size,
+        .ptr = td_hob->mem_ptr,
+
+        .current = td_hob->mem_ptr,
+        .end = td_hob->mem_ptr + td_hob->size,
+    };
+
+    EFI_HOB_GENERIC_HEADER *last_hob;
+    EFI_HOB_HANDOFF_INFO_TABLE *hit;
+
+    /* Note, Efi{Free}Memory{Bottom,Top} are ignored, leave 'em zeroed. */
+    hit = tdvf_get_area(&hob, sizeof(*hit));
+    *hit = (EFI_HOB_HANDOFF_INFO_TABLE) {
+        .Header = {
+            .HobType = EFI_HOB_TYPE_HANDOFF,
+            .HobLength = cpu_to_le16(sizeof(*hit)),
+            .Reserved = cpu_to_le32(0),
+        },
+        .Version = cpu_to_le32(EFI_HOB_HANDOFF_TABLE_VERSION),
+        .BootMode = cpu_to_le32(0),
+        .EfiMemoryTop = cpu_to_le64(0),
+        .EfiMemoryBottom = cpu_to_le64(0),
+        .EfiFreeMemoryTop = cpu_to_le64(0),
+        .EfiFreeMemoryBottom = cpu_to_le64(0),
+        .EfiEndOfHobList = cpu_to_le64(0), /* initialized later */
+    };
+
+    tdvf_hob_add_memory_resources(tdx, &hob);
+
+    last_hob = tdvf_get_area(&hob, sizeof(*last_hob));
+    *last_hob =  (EFI_HOB_GENERIC_HEADER) {
+        .HobType = EFI_HOB_TYPE_END_OF_HOB_LIST,
+        .HobLength = cpu_to_le16(sizeof(*last_hob)),
+        .Reserved = cpu_to_le32(0),
+    };
+    hit->EfiEndOfHobList = tdvf_current_guest_addr(&hob);
+}
diff --git a/hw/i386/tdvf-hob.h b/hw/i386/tdvf-hob.h
new file mode 100644
index 000000000000..4fc6a3740a57
--- /dev/null
+++ b/hw/i386/tdvf-hob.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef HW_I386_TD_HOB_H
+#define HW_I386_TD_HOB_H
+
+#include "hw/i386/tdvf.h"
+#include "target/i386/kvm/tdx.h"
+
+void tdvf_hob_create(TdxGuest *tdx, TdxFirmwareEntry *td_hob);
+
+#define EFI_RESOURCE_ATTRIBUTE_TDVF_PRIVATE     \
+    (EFI_RESOURCE_ATTRIBUTE_PRESENT |           \
+     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
+     EFI_RESOURCE_ATTRIBUTE_TESTED)
+
+#define EFI_RESOURCE_ATTRIBUTE_TDVF_UNACCEPTED  \
+    (EFI_RESOURCE_ATTRIBUTE_PRESENT |           \
+     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
+     EFI_RESOURCE_ATTRIBUTE_TESTED)
+
+#define EFI_RESOURCE_ATTRIBUTE_TDVF_MMIO        \
+    (EFI_RESOURCE_ATTRIBUTE_PRESENT     |       \
+     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
+     EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE)
+
+#endif
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2dcdc2a7d977..cac073a6d291 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -22,6 +22,7 @@
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
+#include "hw/i386/tdvf-hob.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 
@@ -148,6 +149,19 @@ void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
     tdx_guest->tdvf_mr = tdvf_mr;
 }
 
+static TdxFirmwareEntry *tdx_get_hob_entry(TdxGuest *tdx)
+{
+    TdxFirmwareEntry *entry;
+
+    for_each_tdx_fw_entry(&tdx->tdvf, entry) {
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB) {
+            return entry;
+        }
+    }
+    error_report("TDVF metadata doesn't specify TD_HOB location.");
+    exit(1);
+}
+
 static void tdx_add_ram_entry(uint64_t address, uint64_t length,
                               enum TdxRamType type)
 {
@@ -279,6 +293,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 
     qsort(tdx_guest->ram_entries, tdx_guest->nr_ram_entries,
           sizeof(TdxRamEntry), &tdx_ram_entry_compare);
+
+    tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


