Return-Path: <kvm+bounces-67318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB73D00C6C
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 04:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 684EA301A721
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 03:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB1B27F727;
	Thu,  8 Jan 2026 03:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CkAr+URW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A58277013
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 03:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767841567; cv=none; b=O6DCUOcVZFhSE6jAyFI6sgJYtM3BRHp8otoRn+QrU78frtCrlm1dW4uc9TRx1hbK/93BivkvFWcWuFVJ7HuaurkLzmww08lZrjeGtih71igha9EnrA0+v2kGAosHq+Y5YBNmrAUVA8VUMnugapaNF7ZmaAveF0mjCUZLv0ruAjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767841567; c=relaxed/simple;
	bh=g0OHFULtAj6oRf6AOpPXpYaPkE5/0w/dZzDNjkoFLZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EFfbFoXAGJlkKrxR2rEuDxumcyegix0UHdYC0HGzDaeVlmA6IQlyrXZ6mL2GtB8xjco/cMfxawp8VcUW/ugVjW+n8QIN5Sh2/RXt5EwGbW8zZyO7Hs6dLEKRmvn8jQfelFCe+wibF670zUdgMxuC845pi8vKREbmRpdUtj4ZEjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CkAr+URW; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767841566; x=1799377566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0OHFULtAj6oRf6AOpPXpYaPkE5/0w/dZzDNjkoFLZw=;
  b=CkAr+URWrDNctbO+zVcWMvRl1s5Kde1+dASr07UvT8jv18RSGhjLS3j3
   pe3OwI5McvZNE42mmYMpzmpRKCAC2LLITDQgnb6787wxR+fkYgY8i6e/A
   uBZai96GJakM6a6qJMtXxeNYvLf3ZJUEXcw0hYIYfwcHTHGt7Lo6AEacq
   6J8+SB3XtdYREDoqA92JOOFWL53ubHT3lrze1AkjIWbMtKkyqxbOT7TF6
   9nMRQZeyZH5h8ZwDvw2dJBsP2joETNx1XmIgXg22SCJ5euwH1jvdC+jNl
   a8En/Y0NDhzjZM1Z4+aZLxAvLX3B44h/E1jsYg3c3lgIGq8AwWGknl5Qa
   Q==;
X-CSE-ConnectionGUID: QiW7AvdGT5yldJgxGCZ1qg==
X-CSE-MsgGUID: /EargpwfS/uFp1RbcKBxXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91876974"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="91876974"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 19:06:06 -0800
X-CSE-ConnectionGUID: 4/AJYUC6RAaelqoaTr42sA==
X-CSE-MsgGUID: /FZ5nvgnTEWLVDV0vL9z7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="202210572"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2026 19:05:55 -0800
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
Subject: [PATCH v6 03/27] pc: Start with modern CPU hotplug interface by default
Date: Thu,  8 Jan 2026 11:30:27 +0800
Message-Id: <20260108033051.777361-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108033051.777361-1-zhao1.liu@intel.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For compatibility reasons PC/Q35 will start with legacy CPU hotplug
interface by default but with new CPU hotplug AML code since 2.7
machine type (in commit 679dd1a957df ("pc: use new CPU hotplug interface
since 2.7 machine type")). In that way, legacy firmware that doesn't use
QEMU generated ACPI tables was able to continue using legacy CPU hotplug
interface.

While later machine types, with firmware supporting QEMU provided ACPI
tables, generate new CPU hotplug AML, which will switch to new CPU
hotplug interface when guest OS executes its _INI method on ACPI tables
loading.

Since 2.6 machine type is now gone, and consider that the legacy BIOS
(based on QEMU ACPI prior to v2.7) should be no longer in use, previous
compatibility requirements are no longer necessary. So initialize
'modern' hotplug directly from the very beginning for PC/Q35 machines
with cpu_hotplug_hw_init(), and drop _INIT method.

Additionally, remove the checks and settings around cpu_hotplug_legacy
in cpuhp VMState (for piix4 & ich9), to eliminate the risk of
segmentation faults, as gpe_cpu no longer has the opportunity to be
initialized. This is safe because all hotplug now start with the modern
way, and it's impossible to switch to legacy way at runtime (even the
"cpu-hotplug-legacy" properties does not allow it either).

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Acked-by: Igor Mammedov <imammedo@redhat.com>
---
Changes since v4:
 * New patch split off from Igor's v5 [*].

[*]: https://lore.kernel.org/qemu-devel/20251031142825.179239-1-imammedo@redhat.com/
---
 hw/acpi/cpu.c                  | 10 ----------
 hw/acpi/ich9.c                 | 22 +++-------------------
 hw/acpi/piix4.c                | 21 +++------------------
 hw/i386/acpi-build.c           |  2 +-
 hw/loongarch/virt-acpi-build.c |  1 -
 include/hw/acpi/cpu.h          |  1 -
 6 files changed, 7 insertions(+), 50 deletions(-)

diff --git a/hw/acpi/cpu.c b/hw/acpi/cpu.c
index 6f1ae79edbf3..d63ca83c1bcd 100644
--- a/hw/acpi/cpu.c
+++ b/hw/acpi/cpu.c
@@ -408,16 +408,6 @@ void build_cpus_aml(Aml *table, MachineState *machine, CPUHotplugFeatures opts,
         aml_append(field, aml_reserved_field(4 * 8));
         aml_append(field, aml_named_field(CPU_DATA, 32));
         aml_append(cpu_ctrl_dev, field);
-
-        if (opts.has_legacy_cphp) {
-            method = aml_method("_INI", 0, AML_SERIALIZED);
-            /* switch off legacy CPU hotplug HW and use new one,
-             * on reboot system is in new mode and writing 0
-             * in CPU_SELECTOR selects BSP, which is NOP at
-             * the time _INI is called */
-            aml_append(method, aml_store(zero, aml_name(CPU_SELECTOR)));
-            aml_append(cpu_ctrl_dev, method);
-        }
     }
     aml_append(sb_scope, cpu_ctrl_dev);
 
diff --git a/hw/acpi/ich9.c b/hw/acpi/ich9.c
index 2b3b493c014b..54590129c695 100644
--- a/hw/acpi/ich9.c
+++ b/hw/acpi/ich9.c
@@ -183,26 +183,10 @@ static const VMStateDescription vmstate_tco_io_state = {
     }
 };
 
-static bool vmstate_test_use_cpuhp(void *opaque)
-{
-    ICH9LPCPMRegs *s = opaque;
-    return !s->cpu_hotplug_legacy;
-}
-
-static int vmstate_cpuhp_pre_load(void *opaque)
-{
-    ICH9LPCPMRegs *s = opaque;
-    Object *obj = OBJECT(s->gpe_cpu.device);
-    object_property_set_bool(obj, "cpu-hotplug-legacy", false, &error_abort);
-    return 0;
-}
-
 static const VMStateDescription vmstate_cpuhp_state = {
     .name = "ich9_pm/cpuhp",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = vmstate_test_use_cpuhp,
-    .pre_load = vmstate_cpuhp_pre_load,
     .fields = (const VMStateField[]) {
         VMSTATE_CPU_HOTPLUG(cpuhp_state, ICH9LPCPMRegs),
         VMSTATE_END_OF_LIST()
@@ -338,8 +322,8 @@ void ich9_pm_init(PCIDevice *lpc_pci, ICH9LPCPMRegs *pm, qemu_irq sci_irq)
     pm->powerdown_notifier.notify = pm_powerdown_req;
     qemu_register_powerdown_notifier(&pm->powerdown_notifier);
 
-    legacy_acpi_cpu_hotplug_init(pci_address_space_io(lpc_pci),
-        OBJECT(lpc_pci), &pm->gpe_cpu, ICH9_CPU_HOTPLUG_IO_BASE);
+    cpu_hotplug_hw_init(pci_address_space_io(lpc_pci),
+        OBJECT(lpc_pci), &pm->cpuhp_state, ICH9_CPU_HOTPLUG_IO_BASE);
 
     acpi_memory_hotplug_init(pci_address_space_io(lpc_pci), OBJECT(lpc_pci),
                              &pm->acpi_memory_hotplug,
@@ -419,7 +403,7 @@ void ich9_pm_add_properties(Object *obj, ICH9LPCPMRegs *pm)
 {
     static const uint32_t gpe0_len = ICH9_PMIO_GPE0_LEN;
     pm->acpi_memory_hotplug.is_enabled = true;
-    pm->cpu_hotplug_legacy = true;
+    pm->cpu_hotplug_legacy = false;
     pm->disable_s3 = 0;
     pm->disable_s4 = 0;
     pm->s4_val = 2;
diff --git a/hw/acpi/piix4.c b/hw/acpi/piix4.c
index 19d4d4be9329..0eda692084d3 100644
--- a/hw/acpi/piix4.c
+++ b/hw/acpi/piix4.c
@@ -195,25 +195,10 @@ static const VMStateDescription vmstate_memhp_state = {
     }
 };
 
-static bool vmstate_test_use_cpuhp(void *opaque)
-{
-    PIIX4PMState *s = opaque;
-    return !s->cpu_hotplug_legacy;
-}
-
-static int vmstate_cpuhp_pre_load(void *opaque)
-{
-    Object *obj = OBJECT(opaque);
-    object_property_set_bool(obj, "cpu-hotplug-legacy", false, &error_abort);
-    return 0;
-}
-
 static const VMStateDescription vmstate_cpuhp_state = {
     .name = "piix4_pm/cpuhp",
     .version_id = 1,
     .minimum_version_id = 1,
-    .needed = vmstate_test_use_cpuhp,
-    .pre_load = vmstate_cpuhp_pre_load,
     .fields = (const VMStateField[]) {
         VMSTATE_CPU_HOTPLUG(cpuhp_state, PIIX4PMState),
         VMSTATE_END_OF_LIST()
@@ -573,12 +558,12 @@ static void piix4_acpi_system_hot_add_init(MemoryRegion *parent,
         qbus_set_hotplug_handler(BUS(pci_get_bus(PCI_DEVICE(s))), OBJECT(s));
     }
 
-    s->cpu_hotplug_legacy = true;
+    s->cpu_hotplug_legacy = false;
     object_property_add_bool(OBJECT(s), "cpu-hotplug-legacy",
                              piix4_get_cpu_hotplug_legacy,
                              piix4_set_cpu_hotplug_legacy);
-    legacy_acpi_cpu_hotplug_init(parent, OBJECT(s), &s->gpe_cpu,
-                                 PIIX4_CPU_HOTPLUG_IO_BASE);
+    cpu_hotplug_hw_init(parent, OBJECT(s), &s->cpuhp_state,
+                        PIIX4_CPU_HOTPLUG_IO_BASE);
 
     if (s->acpi_memory_hotplug.is_enabled) {
         acpi_memory_hotplug_init(parent, OBJECT(s), &s->acpi_memory_hotplug,
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index 9446a9f862ca..23147ddc25e7 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -964,7 +964,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
         build_legacy_cpu_hotplug_aml(dsdt, machine, pm->cpu_hp_io_base);
     } else {
         CPUHotplugFeatures opts = {
-            .acpi_1_compatible = true, .has_legacy_cphp = true,
+            .acpi_1_compatible = true,
             .smi_path = pm->smi_on_cpuhp ? "\\_SB.PCI0.SMI0.SMIC" : NULL,
             .fw_unplugs_cpu = pm->smi_on_cpu_unplug,
         };
diff --git a/hw/loongarch/virt-acpi-build.c b/hw/loongarch/virt-acpi-build.c
index 8ff9ebdcd9ed..beed6dcb8f89 100644
--- a/hw/loongarch/virt-acpi-build.c
+++ b/hw/loongarch/virt-acpi-build.c
@@ -369,7 +369,6 @@ build_la_ged_aml(Aml *dsdt, MachineState *machine)
 
     if (event & ACPI_GED_CPU_HOTPLUG_EVT) {
         opts.acpi_1_compatible = false;
-        opts.has_legacy_cphp = false;
         opts.fw_unplugs_cpu = false;
         opts.smi_path = NULL;
 
diff --git a/include/hw/acpi/cpu.h b/include/hw/acpi/cpu.h
index 557219d2c638..2809dd8a911e 100644
--- a/include/hw/acpi/cpu.h
+++ b/include/hw/acpi/cpu.h
@@ -54,7 +54,6 @@ void cpu_hotplug_hw_init(MemoryRegion *as, Object *owner,
 
 typedef struct CPUHotplugFeatures {
     bool acpi_1_compatible;
-    bool has_legacy_cphp;
     bool fw_unplugs_cpu;
     const char *smi_path;
 } CPUHotplugFeatures;
-- 
2.34.1


