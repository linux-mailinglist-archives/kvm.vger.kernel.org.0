Return-Path: <kvm+bounces-36503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F38EA1B6FA
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DA793AE9C3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D121D6CDBA;
	Fri, 24 Jan 2025 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E47nIG7f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989534F21D
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725891; cv=none; b=XLY2I29lrezpNlcusVmfFHrKwtFD75dw9koFL2pNMHECEcu503VPXGfRIVA5nHPon8yM9oBlTD40B1rmVfJusW13HI1YLlrhPBzLY4lzZ9u9NKRb8EDWOKRD+LJfWWHLtbk3IlJtxwJX3jV88Ofk9JbGicPB9UXLElGCxEqqDXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725891; c=relaxed/simple;
	bh=HuvboPRDLbZB+Way0U2g7CeCQn9FZ60lR92Vrz/24ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j5zMXIQ8mRXHEAJm0E3E69bnmO8g8Hkoj/93cqbnTqJWl33IVITX1BPRsugAVCKaDiIyOuZX6S5Pwb0iH78/FypCefWQgHoU+B0OL84+TdaxfU4vwpJmrkx5YJLVWvL7xJaMTq7TyL3TVrVrqFsCaK1ZLmkvsGAeCyYo2PYU8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E47nIG7f; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725890; x=1769261890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HuvboPRDLbZB+Way0U2g7CeCQn9FZ60lR92Vrz/24ac=;
  b=E47nIG7f3kqkc4fDQFDi8rg89U37ho3sbqkgD4lQIo51B67ae54Upu0e
   mpehOnbsSYY/OYyey6vtiSoExHTvCFcp+7WYstoXuJ3YJZmLdVpOUaRVM
   7HLylC4w/tSd1vBm/CqmrZKjzQ52N26nhOEUJhJxjow0DLksjv00Red7E
   fW/ur1MCiulFELBqTuO35XiOSgVFqYD9JQg1TcquXFKQh1sRdoc6I5vM8
   2KFSeek+NdanIS3TKHe8ZrV+r81Hm/VaYas8aa9f9GgQrRgDsF8O57wn3
   vzpBdlsCdSmka5r4GX/RwfUHbgoSX/wqG4gh89HSoaMnmGYJCYMsF7ZyO
   A==;
X-CSE-ConnectionGUID: 4VuBybO9SXCP2yCCXrlo+g==
X-CSE-MsgGUID: v44nAiKwSymdI0JjRtc1IQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246351"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246351"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:10 -0800
X-CSE-ConnectionGUID: 6Xjezrm4TTSM0aXpZtsPeQ==
X-CSE-MsgGUID: epRjCEB6QUiuy6YVgLWgAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804269"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:05 -0800
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
Subject: [PATCH v7 18/52] i386/tdx: Don't initialize pc.rom for TDX VMs
Date: Fri, 24 Jan 2025 08:20:14 -0500
Message-Id: <20250124132048.3229049-19-xiaoyao.li@intel.com>
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

For TDX, the address below 1MB are entirely general RAM. No need to
initialize pc.rom memory region for TDs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
This is more as a workaround of the issue that for q35 machine type, the
real memslot update (which requires memslot deletion )for pc.rom happens
after tdx_init_memory_region. It leads to the private memory ADD'ed
before get lost. I haven't work out a good solution to resolve the
order issue. So just skip the pc.rom setup to avoid memslot deletion.
---
 hw/i386/pc.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index b46975c8a4db..44ccc82e2472 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -43,6 +43,7 @@
 #include "system/xen.h"
 #include "system/reset.h"
 #include "kvm/kvm_i386.h"
+#include "kvm/tdx.h"
 #include "hw/xen/xen.h"
 #include "qapi/qmp/qlist.h"
 #include "qemu/error-report.h"
@@ -972,21 +973,23 @@ void pc_memory_init(PCMachineState *pcms,
     /* Initialize PC system firmware */
     pc_system_firmware_init(pcms, rom_memory);
 
-    option_rom_mr = g_malloc(sizeof(*option_rom_mr));
-    if (machine_require_guest_memfd(machine)) {
-        memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
-                                           PC_ROM_SIZE, &error_fatal);
-    } else {
-        memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
-                               &error_fatal);
-        if (pcmc->pci_enabled) {
-            memory_region_set_readonly(option_rom_mr, true);
+    if (!is_tdx_vm()) {
+        option_rom_mr = g_malloc(sizeof(*option_rom_mr));
+        if (machine_require_guest_memfd(machine)) {
+            memory_region_init_ram_guest_memfd(option_rom_mr, NULL, "pc.rom",
+                                            PC_ROM_SIZE, &error_fatal);
+        } else {
+            memory_region_init_ram(option_rom_mr, NULL, "pc.rom", PC_ROM_SIZE,
+                                &error_fatal);
+            if (pcmc->pci_enabled) {
+                memory_region_set_readonly(option_rom_mr, true);
+            }
         }
+        memory_region_add_subregion_overlap(rom_memory,
+                                            PC_ROM_MIN_VGA,
+                                            option_rom_mr,
+                                            1);
     }
-    memory_region_add_subregion_overlap(rom_memory,
-                                        PC_ROM_MIN_VGA,
-                                        option_rom_mr,
-                                        1);
 
     fw_cfg = fw_cfg_arch_create(machine,
                                 x86ms->boot_cpus, x86ms->apic_id_limit);
-- 
2.34.1


