Return-Path: <kvm+bounces-45920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1167DAAFE70
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D541E3AF34B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEA02797AE;
	Thu,  8 May 2025 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kk6KNzWH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1BF2820C9
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716749; cv=none; b=Jvp+87hZz6pD7m1tfbeKMrorAsFn/LCa3AqTGzMOiPxnxzQxcXQpBzndxG1XaxxQCUmkjkz4PunAeOS9rsjh+NeMLY7+7uxxlkrP/lS8egOLfzHsqZrrQuy4vcprptl020BKEVR+YhNznfhdYJ1P1seDb2BEI00gTHA4mi9XtIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716749; c=relaxed/simple;
	bh=C5lTbAM0beIlxdL2l0uX9OnA7Y2C8gpl3EtBuGsvABg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnDFgbL0sL6iulHr0hMnRlexm0QpAT6wvow8OtI04nAADD2Qx1KS3Weeb17m1q3pARbYRZQ0cWQ9nrzjX7qXjJ9R5oYMCJxzVSOff6DNaId1edLuWM+TtqSpAcjslqbppWdx+mDwUxkdol+EYcgcKRLg47UMkSfYhEbRBvwZSwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kk6KNzWH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716748; x=1778252748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C5lTbAM0beIlxdL2l0uX9OnA7Y2C8gpl3EtBuGsvABg=;
  b=Kk6KNzWH3ASbI2NiYhBiPqIYzR6PfBNVJb/iyuFol2a9iArlxj3jRcdE
   oGw1Gmd3gKLCbCi0cGNfhRlKSvoQ2xHPMJ0Rpfwl2i71YUxiEZ6BkQUSB
   TpRVZlyrRfrc2/ZV4hZj1Ej4JcYz2Z4VfYfgEH3q0lDuuGk7r3JH5QvYi
   OoZI6DnXTbx3NHUHFuf+5CRbnNp1lcWObsbAlp4mXTHONVxC4kWs8T0wL
   lFldu7XUvqgwTGRL8x0WhsH8bHCvK04BBXSgAcfWZYlWaP8e13moEhxtN
   FT3uNV4QZOYDgKPnMkkHnH/GMZm5GPgKRldYxPphKnJBiHDJoLnPYb5Wb
   g==;
X-CSE-ConnectionGUID: OV+gjcGORX6iQjRi2VHhxA==
X-CSE-MsgGUID: j30TG9PfTmu2Tp4b6aaXKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888130"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888130"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:47 -0700
X-CSE-ConnectionGUID: GiizR6uLSfCIqbmt2dJWuA==
X-CSE-MsgGUID: /VwqVaUeS0WZnepubwvUIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439921"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:44 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 17/55] i386/tdvf: Introduce function to parse TDVF metadata
Date: Thu,  8 May 2025 10:59:23 -0400
Message-ID: <20250508150002.689633-18-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX VM needs to boot with its specialized firmware, Trusted Domain
Virtual Firmware (TDVF). QEMU needs to parse TDVF and map it in TD
guest memory prior to running the TDX VM.

A TDVF Metadata in TDVF image describes the structure of firmware.
QEMU refers to it to setup memory for TDVF. Introduce function
tdvf_parse_metadata() to parse the metadata from TDVF image and store
the info of each TDVF section.

TDX metadata is located by a TDX metadata offset block, which is a
GUID-ed structure. The data portion of the GUID structure contains
only an 4-byte field that is the offset of TDX metadata to the end
of firmware file.

Select X86_FW_OVMF when TDX is enable to leverage existing functions
to parse and search OVMF's GUID-ed structures.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - Add comment for TdvfSectionEntry and TdvfMetadata;

Changes in v8:
 - Drop the failure handling of memcpy() since it cannot fail;

Changes in v7:
 - Update license info to only use SPDX tag;
 - use g_autofree to avoid manually free;

Changes in v6:
 - Drop the the data endianness change for metadata->Length;

Changes in v1:
 - rename tdvf_parse_section_entry() to
   tdvf_parse_and_check_section_entry()

Changes in RFC v4:
 - rename TDX_METADATA_GUID to TDX_METADATA_OFFSET_GUID
---
 hw/i386/Kconfig        |   1 +
 hw/i386/meson.build    |   1 +
 hw/i386/tdvf.c         | 187 +++++++++++++++++++++++++++++++++++++++++
 include/hw/i386/tdvf.h |  38 +++++++++
 4 files changed, 227 insertions(+)
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 include/hw/i386/tdvf.h

diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index cce9521ba934..eb65bda6e071 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -12,6 +12,7 @@ config SGX
 
 config TDX
     bool
+    select X86_FW_OVMF
     depends on KVM
 
 config PC
diff --git a/hw/i386/meson.build b/hw/i386/meson.build
index 10bdfde27c69..3bc1da2b6eb4 100644
--- a/hw/i386/meson.build
+++ b/hw/i386/meson.build
@@ -32,6 +32,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
   'port92.c'))
 i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
                                         if_false: files('pc_sysfw_ovmf-stubs.c'))
+i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
 
 subdir('kvm')
 subdir('xen')
diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
new file mode 100644
index 000000000000..6b1c6aede1e7
--- /dev/null
+++ b/hw/i386/tdvf.c
@@ -0,0 +1,187 @@
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
+
+#include "hw/i386/pc.h"
+#include "hw/i386/tdvf.h"
+#include "system/kvm.h"
+
+#define TDX_METADATA_OFFSET_GUID    "e47a6535-984a-4798-865e-4685a7bf8ec2"
+#define TDX_METADATA_VERSION        1
+#define TDVF_SIGNATURE              0x46564454 /* TDVF as little endian */
+
+/*
+ * the raw structs read from TDVF keeps the name convention in
+ * TDVF Design Guide spec.
+ */
+typedef struct {
+    uint32_t DataOffset;
+    uint32_t RawDataSize;
+    uint64_t MemoryAddress;
+    uint64_t MemoryDataSize;
+    uint32_t Type;
+    uint32_t Attributes;
+} TdvfSectionEntry;
+
+typedef struct {
+    uint32_t Signature;
+    uint32_t Length;
+    uint32_t Version;
+    uint32_t NumberOfSectionEntries;
+    TdvfSectionEntry SectionEntries[];
+} TdvfMetadata;
+
+struct tdx_metadata_offset {
+    uint32_t offset;
+};
+
+static TdvfMetadata *tdvf_get_metadata(void *flash_ptr, int size)
+{
+    TdvfMetadata *metadata;
+    uint32_t offset = 0;
+    uint8_t *data;
+
+    if ((uint32_t) size != size) {
+        return NULL;
+    }
+
+    if (pc_system_ovmf_table_find(TDX_METADATA_OFFSET_GUID, &data, NULL)) {
+        offset = size - le32_to_cpu(((struct tdx_metadata_offset *)data)->offset);
+
+        if (offset + sizeof(*metadata) > size) {
+            return NULL;
+        }
+    } else {
+        error_report("Cannot find TDX_METADATA_OFFSET_GUID");
+        return NULL;
+    }
+
+    metadata = flash_ptr + offset;
+
+    /* Finally, verify the signature to determine if this is a TDVF image. */
+    metadata->Signature = le32_to_cpu(metadata->Signature);
+    if (metadata->Signature != TDVF_SIGNATURE) {
+        error_report("Invalid TDVF signature in metadata!");
+        return NULL;
+    }
+
+    /* Sanity check that the TDVF doesn't overlap its own metadata. */
+    metadata->Length = le32_to_cpu(metadata->Length);
+    if (offset + metadata->Length > size) {
+        return NULL;
+    }
+
+    /* Only version 1 is supported/defined. */
+    metadata->Version = le32_to_cpu(metadata->Version);
+    if (metadata->Version != TDX_METADATA_VERSION) {
+        return NULL;
+    }
+
+    return metadata;
+}
+
+static int tdvf_parse_and_check_section_entry(const TdvfSectionEntry *src,
+                                              TdxFirmwareEntry *entry)
+{
+    entry->data_offset = le32_to_cpu(src->DataOffset);
+    entry->data_len = le32_to_cpu(src->RawDataSize);
+    entry->address = le64_to_cpu(src->MemoryAddress);
+    entry->size = le64_to_cpu(src->MemoryDataSize);
+    entry->type = le32_to_cpu(src->Type);
+    entry->attributes = le32_to_cpu(src->Attributes);
+
+    /* sanity check */
+    if (entry->size < entry->data_len) {
+        error_report("Broken metadata RawDataSize 0x%x MemoryDataSize 0x%lx",
+                     entry->data_len, entry->size);
+        return -1;
+    }
+    if (!QEMU_IS_ALIGNED(entry->address, TARGET_PAGE_SIZE)) {
+        error_report("MemoryAddress 0x%lx not page aligned", entry->address);
+        return -1;
+    }
+    if (!QEMU_IS_ALIGNED(entry->size, TARGET_PAGE_SIZE)) {
+        error_report("MemoryDataSize 0x%lx not page aligned", entry->size);
+        return -1;
+    }
+
+    switch (entry->type) {
+    case TDVF_SECTION_TYPE_BFV:
+    case TDVF_SECTION_TYPE_CFV:
+        /* The sections that must be copied from firmware image to TD memory */
+        if (entry->data_len == 0) {
+            error_report("%d section with RawDataSize == 0", entry->type);
+            return -1;
+        }
+        break;
+    case TDVF_SECTION_TYPE_TD_HOB:
+    case TDVF_SECTION_TYPE_TEMP_MEM:
+        /* The sections that no need to be copied from firmware image */
+        if (entry->data_len != 0) {
+            error_report("%d section with RawDataSize 0x%x != 0",
+                         entry->type, entry->data_len);
+            return -1;
+        }
+        break;
+    default:
+        error_report("TDVF contains unsupported section type %d", entry->type);
+        return -1;
+    }
+
+    return 0;
+}
+
+int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
+{
+    g_autofree TdvfSectionEntry *sections = NULL;
+    TdvfMetadata *metadata;
+    ssize_t entries_size;
+    int i;
+
+    metadata = tdvf_get_metadata(flash_ptr, size);
+    if (!metadata) {
+        return -EINVAL;
+    }
+
+    /* load and parse metadata entries */
+    fw->nr_entries = le32_to_cpu(metadata->NumberOfSectionEntries);
+    if (fw->nr_entries < 2) {
+        error_report("Invalid number of fw entries (%u) in TDVF Metadata",
+                     fw->nr_entries);
+        return -EINVAL;
+    }
+
+    entries_size = fw->nr_entries * sizeof(TdvfSectionEntry);
+    if (metadata->Length != sizeof(*metadata) + entries_size) {
+        error_report("TDVF metadata len (0x%x) mismatch, expected (0x%x)",
+                     metadata->Length,
+                     (uint32_t)(sizeof(*metadata) + entries_size));
+        return -EINVAL;
+    }
+
+    fw->entries = g_new(TdxFirmwareEntry, fw->nr_entries);
+    sections = g_new(TdvfSectionEntry, fw->nr_entries);
+
+    memcpy(sections, (void *)metadata + sizeof(*metadata), entries_size);
+
+    for (i = 0; i < fw->nr_entries; i++) {
+        if (tdvf_parse_and_check_section_entry(&sections[i], &fw->entries[i])) {
+            goto err;
+        }
+    }
+
+    return 0;
+
+err:
+    fw->entries = 0;
+    g_free(fw->entries);
+    return -EINVAL;
+}
diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
new file mode 100644
index 000000000000..7ebcac42a36c
--- /dev/null
+++ b/include/hw/i386/tdvf.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c) 2025 Intel Corporation
+ * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
+ *                        <isaku.yamahata at intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef HW_I386_TDVF_H
+#define HW_I386_TDVF_H
+
+#include "qemu/osdep.h"
+
+#define TDVF_SECTION_TYPE_BFV               0
+#define TDVF_SECTION_TYPE_CFV               1
+#define TDVF_SECTION_TYPE_TD_HOB            2
+#define TDVF_SECTION_TYPE_TEMP_MEM          3
+
+#define TDVF_SECTION_ATTRIBUTES_MR_EXTEND   (1U << 0)
+#define TDVF_SECTION_ATTRIBUTES_PAGE_AUG    (1U << 1)
+
+typedef struct TdxFirmwareEntry {
+    uint32_t data_offset;
+    uint32_t data_len;
+    uint64_t address;
+    uint64_t size;
+    uint32_t type;
+    uint32_t attributes;
+} TdxFirmwareEntry;
+
+typedef struct TdxFirmware {
+    uint32_t nr_entries;
+    TdxFirmwareEntry *entries;
+} TdxFirmware;
+
+int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size);
+
+#endif /* HW_I386_TDVF_H */
-- 
2.43.0


