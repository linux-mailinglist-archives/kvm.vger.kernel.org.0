Return-Path: <kvm+bounces-65139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 50AA6C9C1AD
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7A2C349559
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C3628CF49;
	Tue,  2 Dec 2025 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="neGExfyG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23C287503
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691592; cv=none; b=bNYWW/sZQXiJ0U55jaiQ98vFYn+GWqLjJJPRcukhaNS8uCfwopBoDXKGlhRA8TwucAn3oGxNRKIWkhloN2rW0X+vuEk/HAQPwmvdM/ZyNPtuGqepUppdt3hrJbgcqVfRPmf/3Wgw/KUQiyrD8lDsA4lfFaIdPV5COpJulDTnKmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691592; c=relaxed/simple;
	bh=iIFkXAwDouZhjCj49/RtwlrDvBr56i+CVsV4TELuVn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATzpuPwf0iWxoMZPSWiziSw0Iq5nK9xMlE7NHrvCf4Y+f4emZWPUcX9c64OdvlgZ2ddCRJwrt9HT+JpVQAT74lBL0H1UVTYrBsWYjPlnuE0vCzNVt0fFK71ui8zvwomHzDMpItH/uuL4sLpOSdzNKFYiCvqFwz/huOhIfpFwsHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=neGExfyG; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691591; x=1796227591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iIFkXAwDouZhjCj49/RtwlrDvBr56i+CVsV4TELuVn4=;
  b=neGExfyGzC/AFBwpTzO92+a0oVSksaDzhRTtf1xqqchmUSIpAPkatW/+
   O+q7lmRpWPYYXxnoYYLHh5KU7aqwz1T9vFONcR9mJaWGu+YRkhNlWafvr
   X6iZo0Np0Z6g1Lg276FcobOVbVBwmkvbGxItZahLkIMPC4Rg6xwwqEJOR
   6d0PAhhtCpOs397CWE2WazVWP/QmSgTXhHMC3TURlDehiejfCV+y2riOW
   bKf2WXl/XoyYSDW9xsSjunpGQkaqEbJfMlfRLT01kUQy9B+EvNYlZ3YQ1
   RPi7EfZaVwGyXvJev86JQmWJN36L696RThUl9SFyvBLm92u02uIvL+jzM
   g==;
X-CSE-ConnectionGUID: b3sMX9nSRQiHCH53OlEs0A==
X-CSE-MsgGUID: zeX/TypXT86HV1EK59EzFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142737"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142737"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:06:23 -0800
X-CSE-ConnectionGUID: lVG5CcosQviNXv4AEgnBgA==
X-CSE-MsgGUID: ZQar24nhT0KDs9MH5czLOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537512"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:06:14 -0800
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
Subject: [PATCH v5 15/28] hw/i386: Assume fw_cfg DMA is always enabled
Date: Wed,  3 Dec 2025 00:28:22 +0800
Message-Id: <20251202162835.3227894-16-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251202162835.3227894-1-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
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
index 1ee55382dab8..e8dc4d903bd6 100644
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


