Return-Path: <kvm+bounces-30654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B0B9BC592
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B7631F21E7D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874CA1FE116;
	Tue,  5 Nov 2024 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hFsfEmKo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386531F76A8
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788670; cv=none; b=iLF3Tv9jBvXq8IPofCpkSsiyoq1LKtWZHRh1a6waVsYFZeRBdY6Xh/llqfe6ZEG0Uk8eTXzERRgytZ/2Tnwn6ZVAkKKKyWH3/EpWVHRwAMi+da4QJUOhCi98f/OnN7DzuGv7GZWNtF0DTiL2mBbQOXPTEsrA9rZil2mL4+oDkxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788670; c=relaxed/simple;
	bh=UOhXpmceQkEx8s4Oa9vrgi40TyS418oe+WG7+rZTz0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Il+cIh+NvKVJZ0l5CcpZ2LggU+inFxg6uBupoCGD0zeEfdkKzqp7lHofqLMVJ3bjtKDClNPDeEerJ706BAb/yguZnFh1WRPccXMgFz3rfePwpSoUSH43qNkNlAU0o3MiUjY8+nIKQ+yqy8Wnyzu7Rq2xvsjxyWLzVdbRGI6OeQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hFsfEmKo; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788669; x=1762324669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UOhXpmceQkEx8s4Oa9vrgi40TyS418oe+WG7+rZTz0Q=;
  b=hFsfEmKocVYLApeQbANtWOmeNcb7grCBYFFkxCzeg6T3Y18KLrbwwMZE
   tytRTohJjAzpTD0ILYneMle6CUHlfEuFaXwpRWnqQE6Qo190Oh5hxbBeM
   n7AB6bIjNqUocVqudtizkp5Nmv38Vu7TOKSWwyL+hPmGUqQVie4Vb+F84
   h0QEJxkA0+K4ZBJZ1fzigqT+uzXdBWpAql1yuEIibZKp5cok3PBBZChvr
   eMewA8fKVuT+MyJ+jZGOrZlW01DonhJVxH0KMQlSod/Zjqh60Lva/FGPe
   CYTV3+v5jF4Gj3GsmjRc1ZJ3Pa4I8elLsch5NyjlcHrgrgUeg14cmHXlW
   A==;
X-CSE-ConnectionGUID: aK9xtO2GRq2X73lGEx9ang==
X-CSE-MsgGUID: ifY7kEwYTRaIk0blvxKv1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689520"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689520"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:37:49 -0800
X-CSE-ConnectionGUID: EWYM0303ShenTTql/6GbMg==
X-CSE-MsgGUID: Nr3+H8eZQYORr8CJ9auVUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988959"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:37:44 -0800
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
Subject: [PATCH v6 20/60] i386/tdx: Don't initialize pc.rom for TDX VMs
Date: Tue,  5 Nov 2024 01:23:28 -0500
Message-Id: <20241105062408.3533704-21-xiaoyao.li@intel.com>
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
index 2047633e4cf7..4a23856aed47 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -43,6 +43,7 @@
 #include "sysemu/xen.h"
 #include "sysemu/reset.h"
 #include "kvm/kvm_i386.h"
+#include "kvm/tdx.h"
 #include "hw/xen/xen.h"
 #include "qapi/qmp/qlist.h"
 #include "qemu/error-report.h"
@@ -966,21 +967,23 @@ void pc_memory_init(PCMachineState *pcms,
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


