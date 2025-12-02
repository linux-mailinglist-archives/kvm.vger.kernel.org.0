Return-Path: <kvm+bounces-65135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F09CC9C181
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF3434E4384
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2183428640F;
	Tue,  2 Dec 2025 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dI8pY5dT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAF2279DA2
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691549; cv=none; b=Axbt9Qp2+eQhqcu7XQ9K4nrk9rtuuQ9XDX6oGr1P2+k7/Jx9NY++f5Hs8WGkgwrwyrx+XQYWiR8QBY70fA6mPrmTahhwAjmZBSMsF2/mgw1AV8z8UMx9AP9J5tJC9gM3T7o269qSFZHp7/z+pJ69HI1jbNHLobWMr4+g6gkAtbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691549; c=relaxed/simple;
	bh=E5+7iTc+dO+F+UitkYbSsd0MeqgH7entNSr1JVgqG1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n+nYXV4RdttqU4vbl2uGeUOdM0BLCh+uUJsPyGBSAN0dtzq+XwCYZD7GaIP09t6SduT9V62VpWffzLs/TfG7yRNP7Q/A4q3vLr3PIj+qXPuq6244vEE+Wd3T3Rx5EvCznZDLsj/PlTZtCFSpaYzq+VG5ZsZDVOHPMxoxC/6jUQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dI8pY5dT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691548; x=1796227548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E5+7iTc+dO+F+UitkYbSsd0MeqgH7entNSr1JVgqG1M=;
  b=dI8pY5dTkSr0DYQSiGvkQj6O4I+bk0JmboFUbWhulm0obHTz9FadXDwz
   zGV5tOmUN3Br5LsfixSFdKi7sX2odfczY52vEvo8PMzbfRlClY49/r/Gw
   eYH0eHQn0nJAVcFwZqRqRFRQjQH5gzmBJyDwM1HTfdzIdA6ibDM+1EJtG
   k9Nd6MijHopV2+K6029k/Klu68ujvqKg6n+jJ8jZcOKyr7tp8Ugq2sylt
   qSknJVS0FjUKt/AHbVfxtMgjwDtqlE8WYMn/R0hVzvqUCpI8UFeiNHyg4
   Re0cnS0SYW80+nbHaLrg/IRgsg6tqjKrYEh5IIEiq/6xrCCVY6zdo67ED
   g==;
X-CSE-ConnectionGUID: Y0dH5nt+Spm91RuC+jSHEw==
X-CSE-MsgGUID: FsqW6BinQF2zheLRa4N5DQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142590"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142590"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:05:47 -0800
X-CSE-ConnectionGUID: CNUx5QXSRI67Z0d7XnVuCg==
X-CSE-MsgGUID: aSMAzTuOTRSW8+mpe9UL2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199537237"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:05:38 -0800
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
Subject: [PATCH v5 11/28] hw/nvram/fw_cfg: Factor fw_cfg_init_mem_internal() out
Date: Wed,  3 Dec 2025 00:28:18 +0800
Message-Id: <20251202162835.3227894-12-zhao1.liu@intel.com>
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

Factor fw_cfg_init_mem_internal() out of fw_cfg_init_mem_wide().
In fw_cfg_init_mem_wide(), assert DMA arguments are provided.
Callers without DMA have to use the fw_cfg_init_mem() helper.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v4:
 * Fix a "typo" argument in fw_cfg_init_mem_wide().
---
 hw/nvram/fw_cfg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/hw/nvram/fw_cfg.c b/hw/nvram/fw_cfg.c
index 2b8715679fe7..c65deeb7c382 100644
--- a/hw/nvram/fw_cfg.c
+++ b/hw/nvram/fw_cfg.c
@@ -1054,9 +1054,9 @@ FWCfgState *fw_cfg_init_io_dma(uint32_t iobase, uint32_t dma_iobase,
     return s;
 }
 
-FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
-                                 hwaddr data_addr, uint32_t data_width,
-                                 hwaddr dma_addr, AddressSpace *dma_as)
+static FWCfgState *fw_cfg_init_mem_internal(hwaddr ctl_addr,
+                                            hwaddr data_addr, uint32_t data_width,
+                                            hwaddr dma_addr, AddressSpace *dma_as)
 {
     DeviceState *dev;
     SysBusDevice *sbd;
@@ -1088,10 +1088,19 @@ FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
     return s;
 }
 
+FWCfgState *fw_cfg_init_mem_wide(hwaddr ctl_addr,
+                                 hwaddr data_addr, uint32_t data_width,
+                                 hwaddr dma_addr, AddressSpace *dma_as)
+{
+    assert(dma_addr && dma_as);
+    return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_width,
+                                    dma_addr, dma_as);
+}
+
 FWCfgState *fw_cfg_init_mem_nodma(hwaddr ctl_addr, hwaddr data_addr,
                                   unsigned data_width)
 {
-    return fw_cfg_init_mem_wide(ctl_addr, data_addr, data_width, 0, NULL);
+    return fw_cfg_init_mem_internal(ctl_addr, data_addr, data_width, 0, NULL);
 }
 
 
-- 
2.34.1


