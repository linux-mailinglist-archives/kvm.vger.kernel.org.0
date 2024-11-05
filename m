Return-Path: <kvm+bounces-30656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B57349BC5DF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C3A1C21808
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EFC1FDF90;
	Tue,  5 Nov 2024 06:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LXpQAEIP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C721FCF45
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788679; cv=none; b=teapMB00y5jup0EORmMif/MEdIhaBpTGZns9UlyVL6YoP6TY41PK9z+tv/cip0gDtoJ3ccwo/ZpZH9Uw8v2f/rnfum3C/n5T31SBgJXC1csnMPn0+hwFPJvnZV7C/efTaESgI6dsyEW1D4mJ5DErF78knq8Rcg52ouIg/mVXqDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788679; c=relaxed/simple;
	bh=tiZmHs4SbtcRLxGmTdYVWdzKXeiosxgYMBJw0d6ZN1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EtFol4EB4yJIQLfKfB18pqvdEgfpyOiV6SF3sgceXNMHcUMuJ7JLW0SQyxDoxxFlnrp9arOtNIQIHYv1Org7oIEy/gwBwFFRaNWdTRHgtIsTCqD3xWKBb3eDjQGL+y4VJDXN6jSUVmpbZt+QR26FDm44x5+wHZ31PiXfgqgSvDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LXpQAEIP; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788678; x=1762324678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tiZmHs4SbtcRLxGmTdYVWdzKXeiosxgYMBJw0d6ZN1Y=;
  b=LXpQAEIPjvb7vh6Aew/nkbSOEGpNy3aLAnS9X7kJmsjzlvzLfjsEym2e
   zuWheKB7WOKHJuWa6HfmElhMgt+6Z7mlJxVZ/ts75jgM17dXXU1bcViwe
   yRw+43KMkPHsksj/K0O2LtBBP6es+lvNZ+n38SntLWRoAuhl3qt2wUyU+
   WK2BLi5Ms2Wz5FU4GnJIfqjIw/QmfRxVassPUC+3rSkFWboJQ5EIwqCW3
   wlH4FbENZXT80r9+w2mn6dlC3yrCOTIFf5ok02FU10txhCk8ncAchfChr
   7JaD22XrpWSCM/S0+nM0HcVfUSVharuUqL0VWFJK3aifbMS5z5i4LO1dT
   A==;
X-CSE-ConnectionGUID: POKVADIGSkmTS+/uCEoyAA==
X-CSE-MsgGUID: z2fyhAPRT3ae8y6+0jmP5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689545"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689545"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:57 -0800
X-CSE-ConnectionGUID: 32Lx/LQZQMqakH3q9ZtDCA==
X-CSE-MsgGUID: VWRxPBIxTIWZtwHpbO/mfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988996"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:53 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 22/60] i386/tdx: Track RAM entries for TDX VM
Date: Tue,  5 Nov 2024 01:23:30 -0500
Message-Id: <20241105062408.3533704-23-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RAM of TDX VM can be classified into two types:

 - TDX_RAM_UNACCEPTED: default type of TDX memory, which needs to be
   accepted by TDX guest before it can be used and will be all-zeros
   after being accepted.

 - TDX_RAM_ADDED: the RAM that is ADD'ed to TD guest before running, and
   can be used directly. E.g., TD HOB and TEMP MEM that needed by TDVF.

Maintain TdxRamEntries[] which grabs the initial RAM info from e820 table
and mark each RAM range as default type TDX_RAM_UNACCEPTED.

Then turn the range of TD HOB and TEMP MEM to TDX_RAM_ADDED since these
ranges will be ADD'ed before TD runs and no need to be accepted runtime.

The TdxRamEntries[] are later used to setup the memory TD resource HOB
that passes memory info from QEMU to TDVF.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes in v3:
- use enum TdxRamType in struct TdxRamEntry; (Isaku)
- Fix the indention; (Daniel)

Changes in v1:
  - simplify the algorithm of tdx_accept_ram_range() (Suggested-by: Gerd Hoffman)
    (1) Change the existing entry to cover the accepted ram range.
    (2) If there is room before the accepted ram range add a
	TDX_RAM_UNACCEPTED entry for that.
    (3) If there is room after the accepted ram range add a
	TDX_RAM_UNACCEPTED entry for that.
---
 target/i386/kvm/tdx.c | 111 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  14 ++++++
 2 files changed, 125 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6777f66a6451..76b40f278dd4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "qom/object_interfaces.h"
 #include "sysemu/sysemu.h"
 
+#include "hw/i386/e820_memory_layout.h"
 #include "hw/i386/x86.h"
 #include "hw/i386/tdvf.h"
 #include "hw/i386/x86.h"
@@ -130,11 +131,117 @@ void tdx_set_tdvf_region(MemoryRegion *tdvf_mr)
     tdx_guest->tdvf_mr = tdvf_mr;
 }
 
+static void tdx_add_ram_entry(uint64_t address, uint64_t length,
+                              enum TdxRamType type)
+{
+    uint32_t nr_entries = tdx_guest->nr_ram_entries;
+    tdx_guest->ram_entries = g_renew(TdxRamEntry, tdx_guest->ram_entries,
+                                     nr_entries + 1);
+
+    tdx_guest->ram_entries[nr_entries].address = address;
+    tdx_guest->ram_entries[nr_entries].length = length;
+    tdx_guest->ram_entries[nr_entries].type = type;
+    tdx_guest->nr_ram_entries++;
+}
+
+static int tdx_accept_ram_range(uint64_t address, uint64_t length)
+{
+    uint64_t head_start, tail_start, head_length, tail_length;
+    uint64_t tmp_address, tmp_length;
+    TdxRamEntry *e;
+    int i;
+
+    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
+        e = &tdx_guest->ram_entries[i];
+
+        if (address + length <= e->address ||
+            e->address + e->length <= address) {
+            continue;
+        }
+
+        /*
+         * The to-be-accepted ram range must be fully contained by one
+         * RAM entry.
+         */
+        if (e->address > address ||
+            e->address + e->length < address + length) {
+            return -EINVAL;
+        }
+
+        if (e->type == TDX_RAM_ADDED) {
+            return -EINVAL;
+        }
+
+        break;
+    }
+
+    if (i == tdx_guest->nr_ram_entries) {
+        return -1;
+    }
+
+    tmp_address = e->address;
+    tmp_length = e->length;
+
+    e->address = address;
+    e->length = length;
+    e->type = TDX_RAM_ADDED;
+
+    head_length = address - tmp_address;
+    if (head_length > 0) {
+        head_start = tmp_address;
+        tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);
+    }
+
+    tail_start = address + length;
+    if (tail_start < tmp_address + tmp_length) {
+        tail_length = tmp_address + tmp_length - tail_start;
+        tdx_add_ram_entry(tail_start, tail_length, TDX_RAM_UNACCEPTED);
+    }
+
+    return 0;
+}
+
+static int tdx_ram_entry_compare(const void *lhs_, const void* rhs_)
+{
+    const TdxRamEntry *lhs = lhs_;
+    const TdxRamEntry *rhs = rhs_;
+
+    if (lhs->address == rhs->address) {
+        return 0;
+    }
+    if (le64_to_cpu(lhs->address) > le64_to_cpu(rhs->address)) {
+        return 1;
+    }
+    return -1;
+}
+
+static void tdx_init_ram_entries(void)
+{
+    unsigned i, j, nr_e820_entries;
+
+    nr_e820_entries = e820_get_table(NULL);
+    tdx_guest->ram_entries = g_new(TdxRamEntry, nr_e820_entries);
+
+    for (i = 0, j = 0; i < nr_e820_entries; i++) {
+        uint64_t addr, len;
+
+        if (e820_get_entry(i, E820_RAM, &addr, &len)) {
+            tdx_guest->ram_entries[j].address = addr;
+            tdx_guest->ram_entries[j].length = len;
+            tdx_guest->ram_entries[j].type = TDX_RAM_UNACCEPTED;
+            j++;
+        }
+    }
+    tdx_guest->nr_ram_entries = j;
+}
+
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
 
+    tdx_init_ram_entries();
+
     for_each_tdx_fw_entry(tdvf, entry) {
         switch (entry->type) {
         case TDVF_SECTION_TYPE_BFV:
@@ -145,12 +252,16 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
         case TDVF_SECTION_TYPE_TEMP_MEM:
             entry->mem_ptr = qemu_ram_mmap(-1, entry->size,
                                            qemu_real_host_page_size(), 0, 0);
+            tdx_accept_ram_range(entry->address, entry->size);
             break;
         default:
             error_report("Unsupported TDVF section %d", entry->type);
             exit(1);
         }
     }
+
+    qsort(tdx_guest->ram_entries, tdx_guest->nr_ram_entries,
+          sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 }
 
 static Notifier tdx_machine_done_notify = {
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 6b7926be3efe..c669e0d0daca 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -18,6 +18,17 @@ typedef struct TdxGuestClass {
 /* TDX requires bus frequency 25MHz */
 #define TDX_APIC_BUS_CYCLES_NS 40
 
+enum TdxRamType {
+    TDX_RAM_UNACCEPTED,
+    TDX_RAM_ADDED,
+};
+
+typedef struct TdxRamEntry {
+    uint64_t address;
+    uint64_t length;
+    enum TdxRamType type;
+} TdxRamEntry;
+
 typedef struct TdxGuest {
     X86ConfidentialGuest parent_obj;
 
@@ -32,6 +43,9 @@ typedef struct TdxGuest {
 
     MemoryRegion *tdvf_mr;
     TdxFirmware tdvf;
+
+    uint32_t nr_ram_entries;
+    TdxRamEntry *ram_entries;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.34.1


