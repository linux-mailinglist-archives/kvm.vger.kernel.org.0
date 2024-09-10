Return-Path: <kvm+bounces-26261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B310973782
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BC53B2736A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BB5191F82;
	Tue, 10 Sep 2024 12:36:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28E818E76F
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725971787; cv=none; b=Bz+/tXyLZEpjhJMgCy3DhcQ3ClQ9Qzntkucb4kvWYDho3Q1W1qxMF25D/InJFdLiin7/rPr4Wl55Pbs/2RgPKM3YOboiVEBkTUVuYjHqWkkvdnaoLarJguj/6f55ERfBKMKqRhRs5VBkpNQLxzFMtPELGrsaE+GqmwDijNeZtlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725971787; c=relaxed/simple;
	bh=gt47L2/1sVzeqKcmzd/Rk+RpmgTdVGiIBt3nBws+vjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MpI0SS9nBF36WZp6dqSga22hyRcQ1TjMNnZLv7gLXWf1FrJ2N4iVkeT/bn8jRAUrg4q1sAmy5zRRylkPZP52hOhvthl+/qf1iwpTi9ZynA2y6vgOjUvGE1o4JM2zF9fIIzZu6c36ReS2fGrVyiewhxArqAThNVbDt0lsJW+z1cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxC+pFPeBmabkDAA--.8774S3;
	Tue, 10 Sep 2024 20:36:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMBx+cVCPeBmXGoDAA--.15753S3;
	Tue, 10 Sep 2024 20:36:20 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	kvm@vger.kernel.org,
	Bibo Mao <maobibo@loongson.cn>
Subject: [RFC PATCH V2 1/5] include: Add macro definitions needed for interrupt controller kvm emulation
Date: Tue, 10 Sep 2024 20:18:28 +0800
Message-Id: <2182eb694629ee3f2859e441b8076d62d3606ee2.1725969898.git.lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1725969898.git.lixianglai@loongson.cn>
References: <cover.1725969898.git.lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMBx+cVCPeBmXGoDAA--.15753S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add macro definitions needed for interrupt controller kvm emulation.

Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Song Gao <gaosong@loongson.cn>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>

 include/hw/intc/loongarch_extioi.h    | 38 ++++++++++++++++--
 include/hw/intc/loongarch_ipi.h       | 15 +++++++
 include/hw/intc/loongarch_pch_pic.h   | 58 +++++++++++++++++++++++++--
 include/hw/intc/loongson_ipi.h        |  1 -
 include/hw/intc/loongson_ipi_common.h |  2 +
 include/hw/loongarch/virt.h           | 15 +++++++
 linux-headers/asm-loongarch/kvm.h     | 18 +++++++++
 linux-headers/linux/kvm.h             |  6 +++
 8 files changed, 146 insertions(+), 7 deletions(-)

diff --git a/include/hw/intc/loongarch_extioi.h b/include/hw/intc/loongarch_extioi.h
index 626a37dfa1..97f6aa4d60 100644
--- a/include/hw/intc/loongarch_extioi.h
+++ b/include/hw/intc/loongarch_extioi.h
@@ -15,7 +15,7 @@
 #define EXTIOI_IRQS                (256)
 #define EXTIOI_IRQS_BITMAP_SIZE    (256 / 8)
 /* irq from EXTIOI is routed to no more than 4 cpus */
-#define EXTIOI_CPUS                (4)
+#define EXTIOI_CPUS                (256)
 /* map to ipnum per 32 irqs */
 #define EXTIOI_IRQS_IPMAP_SIZE     (256 / 32)
 #define EXTIOI_IRQS_COREMAP_SIZE   256
@@ -36,7 +36,7 @@
 #define EXTIOI_ISR_START             (0x700 - APIC_OFFSET)
 #define EXTIOI_ISR_END               (0x720 - APIC_OFFSET)
 #define EXTIOI_COREISR_START         (0x800 - APIC_OFFSET)
-#define EXTIOI_COREISR_END           (0xB20 - APIC_OFFSET)
+#define EXTIOI_COREISR_END           (0x820 - APIC_OFFSET)
 #define EXTIOI_COREMAP_START         (0xC00 - APIC_OFFSET)
 #define EXTIOI_COREMAP_END           (0xD00 - APIC_OFFSET)
 #define EXTIOI_SIZE                  0x800
@@ -64,7 +64,8 @@ typedef struct ExtIOICore {
     qemu_irq parent_irq[LS3A_INTC_IP];
 } ExtIOICore;
 
-#define TYPE_LOONGARCH_EXTIOI "loongarch.extioi"
+#define TYPE_LOONGARCH_EXTIOI        "loongarch-extioi"
+#define TYPE_KVM_LOONGARCH_EXTIOI    "loongarch-kvm-extioi"
 OBJECT_DECLARE_SIMPLE_TYPE(LoongArchExtIOI, LOONGARCH_EXTIOI)
 struct LoongArchExtIOI {
     SysBusDevice parent_obj;
@@ -86,4 +87,35 @@ struct LoongArchExtIOI {
     MemoryRegion extioi_system_mem;
     MemoryRegion virt_extend;
 };
+
+struct KVMLoongArchExtIOI {
+    SysBusDevice parent_obj;
+    uint32_t num_cpu;
+    uint32_t features;
+    uint32_t status;
+
+    /* hardware state */
+    uint32_t nodetype[EXTIOI_IRQS_NODETYPE_COUNT / 2];
+    uint32_t bounce[EXTIOI_IRQS_GROUP_COUNT];
+    uint32_t isr[EXTIOI_IRQS / 32];
+    uint32_t coreisr[EXTIOI_CPUS][EXTIOI_IRQS_GROUP_COUNT];
+    uint32_t enable[EXTIOI_IRQS / 32];
+    uint32_t ipmap[EXTIOI_IRQS_IPMAP_SIZE / 4];
+    uint32_t coremap[EXTIOI_IRQS / 4];
+    uint8_t  sw_coremap[EXTIOI_IRQS];
+};
+typedef struct KVMLoongArchExtIOI KVMLoongArchExtIOI;
+DECLARE_INSTANCE_CHECKER(KVMLoongArchExtIOI, KVM_LOONGARCH_EXTIOI,
+                         TYPE_KVM_LOONGARCH_EXTIOI)
+
+struct KVMLoongArchExtIOIClass {
+    SysBusDeviceClass parent_class;
+    DeviceRealize parent_realize;
+
+    bool is_created;
+    int dev_fd;
+};
+typedef struct KVMLoongArchExtIOIClass KVMLoongArchExtIOIClass;
+DECLARE_CLASS_CHECKERS(KVMLoongArchExtIOIClass, KVM_LOONGARCH_EXTIOI,
+                       TYPE_KVM_LOONGARCH_EXTIOI)
 #endif /* LOONGARCH_EXTIOI_H */
diff --git a/include/hw/intc/loongarch_ipi.h b/include/hw/intc/loongarch_ipi.h
index 276b3040a3..64ebbdcba6 100644
--- a/include/hw/intc/loongarch_ipi.h
+++ b/include/hw/intc/loongarch_ipi.h
@@ -22,4 +22,19 @@ struct LoongarchIPIClass {
     LoongsonIPICommonClass parent_class;
 };
 
+#define TYPE_KVM_LOONGARCH_IPI  "kvm_loongarch_ipi"
+
+OBJECT_DECLARE_TYPE(KVMLoongarchIPIState,
+                    KVMLoongArchIPIClass, KVM_LOONGARCH_IPI)
+
+struct KVMLoongarchIPIState {
+    LoongsonIPICommonState parent_obj;
+    int dev_fd;
+};
+
+struct KVMLoongArchIPIClass {
+   LoongsonIPICommonClass parent_class;
+   DeviceRealize parent_realize;
+    DeviceUnrealize parent_unrealize;
+};
 #endif
diff --git a/include/hw/intc/loongarch_pch_pic.h b/include/hw/intc/loongarch_pch_pic.h
index d5437e88f2..bbde9e6de9 100644
--- a/include/hw/intc/loongarch_pch_pic.h
+++ b/include/hw/intc/loongarch_pch_pic.h
@@ -5,9 +5,13 @@
  * Copyright (c) 2021 Loongson Technology Corporation Limited
  */
 
+#ifndef LOONGARCH_PCH_PIC_H
+#define LOONGARCH_PCH_PIC_H
+
 #include "hw/sysbus.h"
 
-#define TYPE_LOONGARCH_PCH_PIC "loongarch_pch_pic"
+#define TYPE_LOONGARCH_PCH_PIC          "loongarch_pch_pic"
+#define TYPE_KVM_LOONGARCH_PCH_PIC      "loongarch_kvm_pch_pic"
 #define PCH_PIC_NAME(name) TYPE_LOONGARCH_PCH_PIC#name
 OBJECT_DECLARE_SIMPLE_TYPE(LoongArchPCHPIC, LOONGARCH_PCH_PIC)
 
@@ -28,15 +32,26 @@ OBJECT_DECLARE_SIMPLE_TYPE(LoongArchPCHPIC, LOONGARCH_PCH_PIC)
 #define PCH_PIC_AUTO_CTRL0_HI           0xc4
 #define PCH_PIC_AUTO_CTRL1_LO           0xe0
 #define PCH_PIC_AUTO_CTRL1_HI           0xe4
-#define PCH_PIC_ROUTE_ENTRY_OFFSET      0x100
+#define PCH_PIC_ROUTE_ENTRY_START       0x100
 #define PCH_PIC_ROUTE_ENTRY_END         0x13f
-#define PCH_PIC_HTMSI_VEC_OFFSET        0x200
+#define PCH_PIC_HTMSI_VEC_START         0x200
 #define PCH_PIC_HTMSI_VEC_END           0x23f
 #define PCH_PIC_INT_STATUS_LO           0x3a0
 #define PCH_PIC_INT_STATUS_HI           0x3a4
 #define PCH_PIC_INT_POL_LO              0x3e0
 #define PCH_PIC_INT_POL_HI              0x3e4
 
+#define PCH_PIC_INT_ID_START            PCH_PIC_INT_ID_LO
+#define PCH_PIC_MASK_START              PCH_PIC_INT_MASK_LO
+#define PCH_PIC_HTMSI_EN_START          PCH_PIC_HTMSI_EN_LO
+#define PCH_PIC_EDGE_START              PCH_PIC_INT_EDGE_LO
+#define PCH_PIC_CLEAR_START             PCH_PIC_INT_CLEAR_LO
+#define PCH_PIC_AUTO_CTRL0_START        PCH_PIC_AUTO_CTRL0_LO
+#define PCH_PIC_AUTO_CTRL1_START        PCH_PIC_AUTO_CTRL1_LO
+#define PCH_PIC_INT_IRR_START           0x380
+#define PCH_PIC_INT_ISR_START           PCH_PIC_INT_STATUS_LO
+#define PCH_PIC_POLARITY_START          PCH_PIC_INT_POL_LO
+
 #define STATUS_LO_START                 0
 #define STATUS_HI_START                 0x4
 #define POL_LO_START                    0x40
@@ -67,3 +82,40 @@ struct LoongArchPCHPIC {
     MemoryRegion iomem8;
     unsigned int irq_num;
 };
+
+struct KVMLoongArchPCHPIC {
+    SysBusDevice parent_obj;
+    uint64_t int_mask; /*0x020 interrupt mask register*/
+    uint64_t htmsi_en; /*0x040 1=msi*/
+    uint64_t intedge; /*0x060 edge=1 level  =0*/
+    uint64_t intclr; /*0x080 for clean edge int,set 1 clean,set 0 is noused*/
+    uint64_t auto_crtl0; /*0x0c0*/
+    uint64_t auto_crtl1; /*0x0e0*/
+    uint64_t last_intirr;    /* edge detection */
+    uint64_t intirr; /* 0x380 interrupt request register */
+    uint64_t intisr; /* 0x3a0 interrupt service register */
+    /*
+     * 0x3e0 interrupt level polarity selection
+     * register 0 for high level trigger
+     */
+    uint64_t int_polarity;
+
+    uint8_t route_entry[64]; /*0x100 - 0x138*/
+    uint8_t htmsi_vector[64]; /*0x200 - 0x238*/
+};
+typedef struct KVMLoongArchPCHPIC KVMLoongArchPCHPIC;
+DECLARE_INSTANCE_CHECKER(KVMLoongArchPCHPIC, KVM_LOONGARCH_PCH_PIC,
+                         TYPE_KVM_LOONGARCH_PCH_PIC)
+
+struct KVMLoongArchPCHPICClass {
+    SysBusDeviceClass parent_class;
+    DeviceRealize parent_realize;
+
+    bool is_created;
+    int dev_fd;
+};
+typedef struct KVMLoongArchPCHPICClass KVMLoongArchPCHPICClass;
+DECLARE_CLASS_CHECKERS(KVMLoongArchPCHPICClass, KVM_LOONGARCH_PCH_PIC,
+                       TYPE_KVM_LOONGARCH_PCH_PIC)
+
+#endif /* LOONGARCH_PCH_PIC_H */
diff --git a/include/hw/intc/loongson_ipi.h b/include/hw/intc/loongson_ipi.h
index 4e517cc8dc..57e0d94e2b 100644
--- a/include/hw/intc/loongson_ipi.h
+++ b/include/hw/intc/loongson_ipi.h
@@ -27,5 +27,4 @@ struct LoongsonIPIState {
 
     MemoryRegion *ipi_mmio_mem;
 };
-
 #endif
diff --git a/include/hw/intc/loongson_ipi_common.h b/include/hw/intc/loongson_ipi_common.h
index df9d9c5168..adba8ffd49 100644
--- a/include/hw/intc/loongson_ipi_common.h
+++ b/include/hw/intc/loongson_ipi_common.h
@@ -45,6 +45,8 @@ struct LoongsonIPICommonClass {
     DeviceUnrealize parent_unrealize;
     AddressSpace *(*get_iocsr_as)(CPUState *cpu);
     CPUState *(*cpu_by_arch_id)(int64_t id);
+    void (*pre_save)(LoongsonIPICommonState *s);
+    void (*post_load)(LoongsonIPICommonState *s, int version_id);
 };
 
 MemTxResult loongson_ipi_core_readl(void *opaque, hwaddr addr, uint64_t *data,
diff --git a/include/hw/loongarch/virt.h b/include/hw/loongarch/virt.h
index c373e48f27..c1769fc20c 100644
--- a/include/hw/loongarch/virt.h
+++ b/include/hw/loongarch/virt.h
@@ -36,6 +36,21 @@
 
 #define FDT_BASE                0x100000
 
+/* KVM_IRQ_LINE irq field index values */
+#define KVM_LOONGARCH_IRQ_TYPE_SHIFT            24
+#define KVM_LOONGARCH_IRQ_TYPE_MASK             0xff
+#define KVM_LOONGARCH_IRQ_VCPU_SHIFT            16
+#define KVM_LOONGARCH_IRQ_VCPU_MASK             0xff
+#define KVM_LOONGARCH_IRQ_NUM_SHIFT             0
+#define KVM_LOONGARCH_IRQ_NUM_MASK              0xffff
+
+/* irq_type field */
+#define KVM_LOONGARCH_IRQ_TYPE_CPU_IP           0
+#define KVM_LOONGARCH_IRQ_TYPE_CPU_IO           1
+#define KVM_LOONGARCH_IRQ_TYPE_HT               2
+#define KVM_LOONGARCH_IRQ_TYPE_MSI              3
+#define KVM_LOONGARCH_IRQ_TYPE_IOAPIC           4
+
 struct LoongArchVirtMachineState {
     /*< private >*/
     MachineState parent_obj;
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index f9abef3823..e102d500a3 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -108,4 +108,22 @@ struct kvm_iocsr_entry {
 #define KVM_IRQCHIP_NUM_PINS	64
 #define KVM_MAX_CORES		256
 
+#define KVM_DEV_LOONGARCH_IPI_GRP_REGS		        0x40000001
+
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS	        0x40000002
+
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS	        0x40000003
+#define KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU   	0x0
+#define KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE   	0x1
+#define KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE   	0x2
+
+#define KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL	        0x40000004
+#define KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU   	0x0
+#define KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE 	0x1
+#define KVM_DEV_LOONGARCH_EXTIOI_CTRL_LOAD_FINISHED   	0x3
+
+#define KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS	        0x40000005
+#define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
+#define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
+
 #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index c93876ca0b..cd2aed735c 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1138,6 +1138,12 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_RISCV_AIA,
 #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
+	KVM_DEV_TYPE_LOONGARCH_PCH_PIC,
+#define KVM_DEV_TYPE_LOONGARCH_PCH_PIC  KVM_DEV_TYPE_LOONGARCH_PCH_PIC
+	KVM_DEV_TYPE_LOONGARCH_IPI,
+#define KVM_DEV_TYPE_LOONGARCH_IPI      KVM_DEV_TYPE_LOONGARCH_IPI
+	KVM_DEV_TYPE_LOONGARCH_EXTIOI,
+#define KVM_DEV_TYPE_LOONGARCH_EXTIOI   KVM_DEV_TYPE_LOONGARCH_EXTIOI
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.39.1


