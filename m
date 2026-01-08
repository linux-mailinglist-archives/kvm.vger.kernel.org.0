Return-Path: <kvm+bounces-67333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EED39D00CBD
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:10:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B8F1303868A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241852BD5B4;
	Thu,  8 Jan 2026 03:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gq5dx+5i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D586129D293
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841697; cv=none; b=UZRE9DSOOGDX7QbFxfN/xIxFMaIHGi31y+7BI3RiqL/KMysuil/2kVS8wCf4uOLh78iNLuPaTyMP6fInB817Cwm7kM4+d9kW23ULy8BekPBHcO7VLEIoZsZVP/2XCdlM4RbzyJF90HXhQq/7x0V0SZ+ME41zF00WHOijQMrUMP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841697; c=relaxed/simple;
	bh=bViFc5gPbLLdovLuGgpm8Gleys7YArcVZOQcG9JoFFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zv9pdkY46FyS0OIrdA51YQtiUJPELO40W0UjAekcmYNlo/oOxrP1sExqzQoeR3GOy6q/94VVoG3r7EzTqCuaSrV7doDSP675yJdMZfGkdJLqG0onXLTeol57/YPq3neUS/SrOFIeoI4YM2P0GcM9SrT6LOYElBdG5nPTOYzBl5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gq5dx+5i; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841696; x=1799377696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bViFc5gPbLLdovLuGgpm8Gleys7YArcVZOQcG9JoFFs=;
  b=Gq5dx+5i/sHF4dUvCZAdkwL5/bplzMTYj3jFVRnYFXOtu1TJhpPmm8Dn
   tazIpFZzU0mnR72LqFOPJKNw5PPACvpT9cUqYzVgSFiwcdxtBXsKQ6x8b
   T6GJ+5xRvOAhj8OppSzjTgtTm8SRh0hi1myk9H9fMXsZR5Nea1kn6r0mz
   Pz/3KswoaGFLwV/i8/1mBnJ6GzBZmf/K6KeypFm7H5y5kIFSKHZ+62hQX
   kZ0rY4j9EjicZ22Rtod1D7fNguJpOo4dRsZ4DfDvnBUvZE94cxsF54NQz
   amhpLs5k/AaqdOnNjXcslDD7SEqvl1qopLh1ZyPIaDuo3bSpCeOsfsb7p
   A==;
X-CSE-ConnectionGUID: ogovAYc9TIy/Ret5twrZRw==
X-CSE-MsgGUID: QaaSD+jvRb+sPfGkaOj3LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91877390"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91877390"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:08:16 -0800
X-CSE-ConnectionGUID: X5XOSFyWTH+WzpY7szud8w==
X-CSE-MsgGUID: BPvuIPPmRlOxQNQ51FXsYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202211086"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:08:06 -0800
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
Subject: [PATCH v6 17/27] hw/intc/apic: Remove APICCommonState::legacy_instance_id field
Date: Thu,  8 Jan 2026 11:30:41 +0800
Message-Id: <20260108033051.777361-18-zhao1.liu@intel.com>
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

The APICCommonState::legacy_instance_id boolean was only set
in the pc_compat_2_6[] array, via the 'legacy-instance-id=on'
property. We removed all machines using that array, lets remove
that property, simplifying apic_common_realize().

Because instance_id is initialized as initial_apic_id, we can
not register vmstate_apic_common directly via dc->vmsd.

Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/intc/apic_common.c           | 5 -----
 include/hw/i386/apic_internal.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 4e9e30899457..bf4abc21d7bb 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -276,9 +276,6 @@ static void apic_common_realize(DeviceState *dev, Error **errp)
         info->enable_tpr_reporting(s, true);
     }
 
-    if (s->legacy_instance_id) {
-        instance_id = VMSTATE_INSTANCE_ID_ANY;
-    }
     vmstate_register_with_alias_id(NULL, instance_id, &vmstate_apic_common,
                                    s, -1, 0, NULL);
 
@@ -395,8 +392,6 @@ static const Property apic_properties_common[] = {
     DEFINE_PROP_UINT8("version", APICCommonState, version, 0x14),
     DEFINE_PROP_BIT("vapic", APICCommonState, vapic_control, VAPIC_ENABLE_BIT,
                     true),
-    DEFINE_PROP_BOOL("legacy-instance-id", APICCommonState, legacy_instance_id,
-                     false),
 };
 
 static void apic_common_get_id(Object *obj, Visitor *v, const char *name,
diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_internal.h
index 4a62fdceb4ea..0cb06bbc76c9 100644
--- a/include/hw/i386/apic_internal.h
+++ b/include/hw/i386/apic_internal.h
@@ -187,7 +187,6 @@ struct APICCommonState {
     uint32_t vapic_control;
     DeviceState *vapic;
     hwaddr vapic_paddr; /* note: persistence via kvmvapic */
-    bool legacy_instance_id;
     uint32_t extended_log_dest;
 };
 
-- 
2.34.1


