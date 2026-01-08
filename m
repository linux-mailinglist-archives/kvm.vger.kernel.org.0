Return-Path: <kvm+bounces-67330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 319E8D00D4D
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CD933029C47
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D3F298CC7;
	Thu,  8 Jan 2026 03:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iA/1TeXw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E62957B6
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841670; cv=none; b=eKzsZdUd+pKDzgb824ronx3jBAQkHaoNvDmGJlLUWZWHcomi/5ljONBxDWtDdRy+IvAXmLNBmGMIRmZuJOHDMdRtm8jNfu8D2Gl/hHzNuE5X87jioEsfPVIjC9WKxYByYJH+qdHP5eLChkf3fHUqtvUo812o+WUvYfFugbHzf6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841670; c=relaxed/simple;
	bh=IRTgZmIWz6CsY+7Oa1ePtlrcNoid6wNT/jzG8t5hBVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HzmQxU8KYKdU7zr3kV0M7c+o4zbPelyNSEYo1Alh7CRME77mt3xY+cAdEnZHuMj7aU9gD/FZc52XzgOlNToHG1CyH8fdE/42qbFwasRP3Cddv5EYkJp1ksFNwzQs2NxAmRbpJycbNxvxqfPpCYiSwNlDx3Zn1sKf5SKsYXZQeQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iA/1TeXw; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841669; x=1799377669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IRTgZmIWz6CsY+7Oa1ePtlrcNoid6wNT/jzG8t5hBVc=;
  b=iA/1TeXw40wrk7+2ft745UR2LRJnAAx7t6WKT1yrrfxRgAsPWbFzI2tX
   73GXVssYC5TxsOiXh6vt+Jfm56SQKbbwKb8Q3OK+AAU/vajwAQfY/HNFw
   i+rFAHNf5VlWv/IZdZiRH1a3oD0L5QqocsZaRd5SKJsJhx4n1yvcxilyy
   HjYzXgrcHHWZpQGRpqRO6DkeM1wxlbaCZ+RTeVDksmKsfpyluIP64++l/
   G4tjBlOAU4WfjXnYbkX6gJBMGosQqbvPdlQQeXOnUaMNeGbvYt3rN6ZRF
   EbO0M6war4BDdju7nNbxY/hf340o2Wui1k+2PMkzM7nOTmx5u+jLtuz1W
   Q==;
X-CSE-ConnectionGUID: hmRPNb5aSl+tJe/Zg8HmLQ==
X-CSE-MsgGUID: HTZOsfSITT2K/3ylJgiE4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877293"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877293"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:07:48 -0800
X-CSE-ConnectionGUID: muz8WEMJR1aLs41oUukI4w==
X-CSE-MsgGUID: nZtYAevLSdqV6SnKthR/1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202210997"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:07:38 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,
	devel@lists.libvirt.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Peter Krempa <pkrempa@redhat.com>,
	Jiri Denemark <jdenemar@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 14/27] hw/i386: Assume fw_cfg DMA is always enabled
Date: Thu,  8 Jan 2026 11:30:38 +0800
Message-Id: <20260108033051.777361-15-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108033051.777361-1-zhao1.liu@intel.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Now all calls of x86 machines to fw_cfg_init_io_dma() pass DMA
arguments, so the FWCfgState (FWCfgIoState) created by x86 machines
enables DMA by default.

Although other callers of fw_cfg_init_io_dma() besides x86 also pass
DMA arguments to create DMA-enabled FwCfgIoState, the "dma_enabled"
property of FwCfgIoState cannot yet be removed, because Sun4u and Sun4v
still create DMA-disabled FwCfgIoState (bypass fw_cfg_init_io_dma()) in
sun4uv_init() (hw/sparc64/sun4u.c).

Maybe reusing fw_cfg_init_io_dma() for them would be a better choice, or
adding fw_cfg_init_io_nodma(). However, before that, first simplify the
handling of FwCfgState in x86.

Considering that FwCfgIoState in x86 enables DMA by default, remove the
handling for DMA-disabled cases and replace DMA checks with assertions
to ensure that the default DMA-enabled setting is not broken.

Then 'linuxboot.bin' isn't used anymore, and it will be removed in the
next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
---
Changes since v4:
 * Keep "dma_enabled" property in fw_cfg_io_properties[].
 * Replace DMA checks with assertions for x86 machines.
---
 hw/i386/fw_cfg.c     | 16 ++++++++--------
 hw/i386/x86-common.c |  6 ++----
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
index 5c0bcd5f8a9f..5670e8553eaa 100644
--- a/hw/i386/fw_cfg.c
+++ b/hw/i386/fw_cfg.c
@@ -215,18 +215,18 @@ void fw_cfg_build_feature_control(MachineState *ms, FWCfgState *fw_cfg)
 #ifdef CONFIG_ACPI
 void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw_cfg)
 {
+    uint8_t io_size;
+    Aml *dev = aml_device("FWCF");
+    Aml *crs = aml_resource_template();
+
     /*
      * when using port i/o, the 8-bit data register *always* overlaps
      * with half of the 16-bit control register. Hence, the total size
-     * of the i/o region used is FW_CFG_CTL_SIZE; when using DMA, the
-     * DMA control register is located at FW_CFG_DMA_IO_BASE + 4
+     * of the i/o region used is FW_CFG_CTL_SIZE; And the DMA control
+     * register is located at FW_CFG_DMA_IO_BASE + 4
      */
-    Object *obj = OBJECT(fw_cfg);
-    uint8_t io_size = object_property_get_bool(obj, "dma_enabled", NULL) ?
-        ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t) :
-        FW_CFG_CTL_SIZE;
-    Aml *dev = aml_device("FWCF");
-    Aml *crs = aml_resource_template();
+    assert(fw_cfg_dma_enabled(fw_cfg));
+    io_size = ROUND_UP(FW_CFG_CTL_SIZE, 4) + sizeof(dma_addr_t);
 
     aml_append(dev, aml_name_decl("_HID", aml_string("QEMU0002")));
 
diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index 192e91042f22..de4cd7650a40 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -1002,10 +1002,8 @@ void x86_load_linux(X86MachineState *x86ms,
     }
 
     option_rom[nb_option_roms].bootindex = 0;
-    option_rom[nb_option_roms].name = "linuxboot.bin";
-    if (fw_cfg_dma_enabled(fw_cfg)) {
-        option_rom[nb_option_roms].name = "linuxboot_dma.bin";
-    }
+    assert(fw_cfg_dma_enabled(fw_cfg));
+    option_rom[nb_option_roms].name = "linuxboot_dma.bin";
     nb_option_roms++;
 }
 
-- 
2.34.1


