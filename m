Return-Path: <kvm+bounces-65128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 791CCC9C157
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:05:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACF143A5568
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD0927CCF0;
	Tue,  2 Dec 2025 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdEOh+ti"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7768B274641
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691486; cv=none; b=g2iCOtz3GYG4889Kk3rLRzHWNdkiVSRmU65lOiWBDR/bgEiXUfonCOIptisBrP7kQxbEeLKIhqjpxheo+t4BcVLp6mbgcRXcUQjhOUutNdQ73f3MnhHUm4zW1bYSKGeB/xvERZUmGt/DyiZJYCrPca8/7fUvqJgYcyJHgCXzRTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691486; c=relaxed/simple;
	bh=jdwdoPeiuj5hgaguwFsIEjMplMYC2DfLFUQwIPwyNfQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYLcGvdD3L8YSaqYya7RGbSoFtSqnbcqZ1kYvSyscDmRJg2rH0uk84FYDN/rbNWkhDpDMKGn26584LFMYJYpQyNPpR3x8UfEniw9xbDhmPk2a8IX6B4XE630q8NBBEKYjxDp4I26Vy0v29hmYP/7xPzpOKpyJJ41GskmkKUse1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdEOh+ti; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691485; x=1796227485;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jdwdoPeiuj5hgaguwFsIEjMplMYC2DfLFUQwIPwyNfQ=;
  b=YdEOh+tiB6Rp+0WrOhZQqIKj8jQTeCwijR1GdyVJY84UqNhmrAPUeO72
   Az4QRjx0R2Bg7NhzyTGH/c0Qj0mK3m4fvi+FsJzSZX/FdF1DBnbswJmaj
   wZ/GmqDJIKwJ9Px7TphqIssGb6MMiuL75fzIz22MYuwr89carRriVGte+
   Cry7jJdlc4P6df/ejmnIGYX/Nr9fGyu6kWzR2vUM0SZVBd5Kp55HGRbji
   4SfggjCY1/pGYdp9dhC1efKOsXmAANs4WiS3GZ7rIVPpZ8RiyrT/VXwKk
   FvtfU1LOOQJ+Ks52TjsUU8+huhuCQWDAWra/iGP+Sxyg8HX077gBMiVU3
   A==;
X-CSE-ConnectionGUID: M3mFMXmZQ4OQZ1HdzMMl/w==
X-CSE-MsgGUID: Xx4eySVhR1aZ0IKLzap5Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="92142333"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="92142333"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:04:44 -0800
X-CSE-ConnectionGUID: b36O1wgTS/66Ky57K3ojJA==
X-CSE-MsgGUID: vKHMIdluRr2f6g0L0b8d7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199536986"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 02 Dec 2025 08:04:35 -0800
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
Subject: [PATCH v5 04/28] hw/i386/pc: Remove PCMachineClass::legacy_cpu_hotplug field
Date: Wed,  3 Dec 2025 00:28:11 +0800
Message-Id: <20251202162835.3227894-5-zhao1.liu@intel.com>
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

Now all PC & Q35 machiens are using modern hotplug from the beginning,
and all legacy_cpu_hotplug flags keep false during runtime.

So it's safe to remove legacy_cpu_hotplug flags and related properties,
with unused gpe_cpu field.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v4:
 * Referring Igor's v5 [*], drop gpe_cpu field and does not only remove
   build_legacy_cpu_hotplug_aml(), but instead remove the entire
   cpu_hotplug.c file in a separate patch.

[*]: https://lore.kernel.org/qemu-devel/20251031142825.179239-1-imammedo@redhat.com/
---
 hw/acpi/ich9.c          | 40 ++++------------------------------------
 hw/acpi/piix4.c         | 40 ++++------------------------------------
 hw/i386/acpi-build.c    |  4 +---
 include/hw/acpi/ich9.h  |  2 --
 include/hw/acpi/piix4.h |  2 --
 include/hw/i386/pc.h    |  3 ---
 6 files changed, 9 insertions(+), 82 deletions(-)

diff --git a/hw/acpi/ich9.c b/hw/acpi/ich9.c
index 54590129c695..f254f3879716 100644
--- a/hw/acpi/ich9.c
+++ b/hw/acpi/ich9.c
@@ -339,26 +339,6 @@ static void ich9_pm_get_gpe0_blk(Object *obj, Visitor *v, const char *name,
     visit_type_uint32(v, name, &value, errp);
 }
 
-static bool ich9_pm_get_cpu_hotplug_legacy(Object *obj, Error **errp)
-{
-    ICH9LPCState *s = ICH9_LPC_DEVICE(obj);
-
-    return s->pm.cpu_hotplug_legacy;
-}
-
-static void ich9_pm_set_cpu_hotplug_legacy(Object *obj, bool value,
-                                           Error **errp)
-{
-    ICH9LPCState *s = ICH9_LPC_DEVICE(obj);
-
-    assert(!value);
-    if (s->pm.cpu_hotplug_legacy && value == false) {
-        acpi_switch_to_modern_cphp(&s->pm.gpe_cpu, &s->pm.cpuhp_state,
-                                   ICH9_CPU_HOTPLUG_IO_BASE);
-    }
-    s->pm.cpu_hotplug_legacy = value;
-}
-
 static bool ich9_pm_get_enable_tco(Object *obj, Error **errp)
 {
     ICH9LPCState *s = ICH9_LPC_DEVICE(obj);
@@ -403,7 +383,6 @@ void ich9_pm_add_properties(Object *obj, ICH9LPCPMRegs *pm)
 {
     static const uint32_t gpe0_len = ICH9_PMIO_GPE0_LEN;
     pm->acpi_memory_hotplug.is_enabled = true;
-    pm->cpu_hotplug_legacy = false;
     pm->disable_s3 = 0;
     pm->disable_s4 = 0;
     pm->s4_val = 2;
@@ -422,9 +401,6 @@ void ich9_pm_add_properties(Object *obj, ICH9LPCPMRegs *pm)
                         NULL, NULL, pm);
     object_property_add_uint32_ptr(obj, ACPI_PM_PROP_GPE0_BLK_LEN,
                                    &gpe0_len, OBJ_PROP_FLAG_READ);
-    object_property_add_bool(obj, "cpu-hotplug-legacy",
-                             ich9_pm_get_cpu_hotplug_legacy,
-                             ich9_pm_set_cpu_hotplug_legacy);
     object_property_add_uint8_ptr(obj, ACPI_PM_PROP_S3_DISABLED,
                                   &pm->disable_s3, OBJ_PROP_FLAG_READWRITE);
     object_property_add_uint8_ptr(obj, ACPI_PM_PROP_S4_DISABLED,
@@ -477,11 +453,7 @@ void ich9_pm_device_plug_cb(HotplugHandler *hotplug_dev, DeviceState *dev,
                                 dev, errp);
         }
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
-        if (lpc->pm.cpu_hotplug_legacy) {
-            legacy_acpi_cpu_plug_cb(hotplug_dev, &lpc->pm.gpe_cpu, dev, errp);
-        } else {
-            acpi_cpu_plug_cb(hotplug_dev, &lpc->pm.cpuhp_state, dev, errp);
-        }
+        acpi_cpu_plug_cb(hotplug_dev, &lpc->pm.cpuhp_state, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_DEVICE)) {
         acpi_pcihp_device_plug_cb(hotplug_dev, &lpc->pm.acpi_pci_hotplug,
                                   dev, errp);
@@ -500,8 +472,7 @@ void ich9_pm_device_unplug_request_cb(HotplugHandler *hotplug_dev,
         acpi_memory_unplug_request_cb(hotplug_dev,
                                       &lpc->pm.acpi_memory_hotplug, dev,
                                       errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU) &&
-               !lpc->pm.cpu_hotplug_legacy) {
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         uint64_t negotiated = lpc->smi_negotiated_features;
 
         if (negotiated & BIT_ULL(ICH9_LPC_SMI_F_BROADCAST_BIT) &&
@@ -533,8 +504,7 @@ void ich9_pm_device_unplug_cb(HotplugHandler *hotplug_dev, DeviceState *dev,
 
     if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM)) {
         acpi_memory_unplug_cb(&lpc->pm.acpi_memory_hotplug, dev, errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU) &&
-               !lpc->pm.cpu_hotplug_legacy) {
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         acpi_cpu_unplug_cb(&lpc->pm.cpuhp_state, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_DEVICE)) {
         acpi_pcihp_device_unplug_cb(hotplug_dev, &lpc->pm.acpi_pci_hotplug,
@@ -556,7 +526,5 @@ void ich9_pm_ospm_status(AcpiDeviceIf *adev, ACPIOSTInfoList ***list)
     ICH9LPCState *s = ICH9_LPC_DEVICE(adev);
 
     acpi_memory_ospm_status(&s->pm.acpi_memory_hotplug, list);
-    if (!s->pm.cpu_hotplug_legacy) {
-        acpi_cpu_ospm_status(&s->pm.cpuhp_state, list);
-    }
+    acpi_cpu_ospm_status(&s->pm.cpuhp_state, list);
 }
diff --git a/hw/acpi/piix4.c b/hw/acpi/piix4.c
index a7a29b0d09a9..6ad5f1d1c19d 100644
--- a/hw/acpi/piix4.c
+++ b/hw/acpi/piix4.c
@@ -336,11 +336,7 @@ static void piix4_device_plug_cb(HotplugHandler *hotplug_dev,
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_DEVICE)) {
         acpi_pcihp_device_plug_cb(hotplug_dev, &s->acpi_pci_hotplug, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
-        if (s->cpu_hotplug_legacy) {
-            legacy_acpi_cpu_plug_cb(hotplug_dev, &s->gpe_cpu, dev, errp);
-        } else {
-            acpi_cpu_plug_cb(hotplug_dev, &s->cpuhp_state, dev, errp);
-        }
+        acpi_cpu_plug_cb(hotplug_dev, &s->cpuhp_state, dev, errp);
     } else {
         g_assert_not_reached();
     }
@@ -358,8 +354,7 @@ static void piix4_device_unplug_request_cb(HotplugHandler *hotplug_dev,
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_DEVICE)) {
         acpi_pcihp_device_unplug_request_cb(hotplug_dev, &s->acpi_pci_hotplug,
                                             dev, errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU) &&
-               !s->cpu_hotplug_legacy) {
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         acpi_cpu_unplug_request_cb(hotplug_dev, &s->cpuhp_state, dev, errp);
     } else {
         error_setg(errp, "acpi: device unplug request for not supported device"
@@ -378,8 +373,7 @@ static void piix4_device_unplug_cb(HotplugHandler *hotplug_dev,
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_DEVICE)) {
         acpi_pcihp_device_unplug_cb(hotplug_dev, &s->acpi_pci_hotplug, dev,
                                     errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU) &&
-               !s->cpu_hotplug_legacy) {
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         acpi_cpu_unplug_cb(&s->cpuhp_state, dev, errp);
     } else {
         error_setg(errp, "acpi: device unplug for not supported device"
@@ -523,26 +517,6 @@ static const MemoryRegionOps piix4_gpe_ops = {
     .endianness = DEVICE_LITTLE_ENDIAN,
 };
 
-
-static bool piix4_get_cpu_hotplug_legacy(Object *obj, Error **errp)
-{
-    PIIX4PMState *s = PIIX4_PM(obj);
-
-    return s->cpu_hotplug_legacy;
-}
-
-static void piix4_set_cpu_hotplug_legacy(Object *obj, bool value, Error **errp)
-{
-    PIIX4PMState *s = PIIX4_PM(obj);
-
-    assert(!value);
-    if (s->cpu_hotplug_legacy && value == false) {
-        acpi_switch_to_modern_cphp(&s->gpe_cpu, &s->cpuhp_state,
-                                   PIIX4_CPU_HOTPLUG_IO_BASE);
-    }
-    s->cpu_hotplug_legacy = value;
-}
-
 static void piix4_acpi_system_hot_add_init(MemoryRegion *parent,
                                            PCIBus *bus, PIIX4PMState *s)
 {
@@ -558,10 +532,6 @@ static void piix4_acpi_system_hot_add_init(MemoryRegion *parent,
         qbus_set_hotplug_handler(BUS(pci_get_bus(PCI_DEVICE(s))), OBJECT(s));
     }
 
-    s->cpu_hotplug_legacy = false;
-    object_property_add_bool(OBJECT(s), "cpu-hotplug-legacy",
-                             piix4_get_cpu_hotplug_legacy,
-                             piix4_set_cpu_hotplug_legacy);
     cpu_hotplug_hw_init(parent, OBJECT(s), &s->cpuhp_state,
                         PIIX4_CPU_HOTPLUG_IO_BASE);
 
@@ -576,9 +546,7 @@ static void piix4_ospm_status(AcpiDeviceIf *adev, ACPIOSTInfoList ***list)
     PIIX4PMState *s = PIIX4_PM(adev);
 
     acpi_memory_ospm_status(&s->acpi_memory_hotplug, list);
-    if (!s->cpu_hotplug_legacy) {
-        acpi_cpu_ospm_status(&s->cpuhp_state, list);
-    }
+    acpi_cpu_ospm_status(&s->cpuhp_state, list);
 }
 
 static void piix4_send_gpe(AcpiDeviceIf *adev, AcpiEventStatusBits ev)
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 23147ddc25e7..bf7ed2e50837 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -960,9 +960,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
     }
     aml_append(dsdt, scope);
 
-    if (pcmc->legacy_cpu_hotplug) {
-        build_legacy_cpu_hotplug_aml(dsdt, machine, pm->cpu_hp_io_base);
-    } else {
+    {
         CPUHotplugFeatures opts = {
             .acpi_1_compatible = true,
             .smi_path = pm->smi_on_cpuhp ? "\\_SB.PCI0.SMI0.SMIC" : NULL,
diff --git a/include/hw/acpi/ich9.h b/include/hw/acpi/ich9.h
index 245fe08dc245..6a21472eb32e 100644
--- a/include/hw/acpi/ich9.h
+++ b/include/hw/acpi/ich9.h
@@ -53,8 +53,6 @@ typedef struct ICH9LPCPMRegs {
     uint32_t pm_io_base;
     Notifier powerdown_notifier;
 
-    bool cpu_hotplug_legacy;
-    AcpiCpuHotplug gpe_cpu;
     CPUHotplugState cpuhp_state;
 
     bool keep_pci_slot_hpc;
diff --git a/include/hw/acpi/piix4.h b/include/hw/acpi/piix4.h
index eb1c122d8069..e075f0cbeaf1 100644
--- a/include/hw/acpi/piix4.h
+++ b/include/hw/acpi/piix4.h
@@ -63,8 +63,6 @@ struct PIIX4PMState {
     uint8_t disable_s4;
     uint8_t s4_val;
 
-    bool cpu_hotplug_legacy;
-    AcpiCpuHotplug gpe_cpu;
     CPUHotplugState cpuhp_state;
 
     MemHotplugState acpi_memory_hotplug;
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index e83157ab358f..698e3fb84af0 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -110,9 +110,6 @@ struct PCMachineClass {
     bool enforce_amd_1tb_hole;
     bool isa_bios_alias;
 
-    /* generate legacy CPU hotplug AML */
-    bool legacy_cpu_hotplug;
-
     /* use PVH to load kernels that support this feature */
     bool pvh_enabled;
 
-- 
2.34.1


