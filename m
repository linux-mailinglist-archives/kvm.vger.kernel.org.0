Return-Path: <kvm+bounces-1621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D526C7EA8AD
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 03:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22B571F23AA2
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 02:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27F58487;
	Tue, 14 Nov 2023 02:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E81A7497
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 02:07:32 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 785DBD43
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 18:07:27 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8DxRvFT1lJltsw5AA--.48248S3;
	Tue, 14 Nov 2023 10:07:15 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx_y9M1lJl9mtBAA--.12237S2;
	Tue, 14 Nov 2023 10:07:09 +0800 (CST)
From: Tianrui Zhao <zhaotianrui@loongson.cn>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	mst@redhat.com
Cc: maobibo@loongson.cn,
	zhaotianrui@loongson.cn,
	lixianglai@loongson.cn,
	gaosong@loongson.cn
Subject: [PATCH] linux-headers: Synchronize linux headers from linux v6.7.0-rc1
Date: Tue, 14 Nov 2023 09:54:12 +0800
Message-Id: <20231114015412.53135-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dx_y9M1lJl9mtBAA--.12237S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Use the scripts/update-linux-headers.sh to synchronize linux
headers from linux v6.7.0-rc1. We mainly want to add the
loongarch linux headers and then add the loongarch kvm support
based on it.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 include/standard-headers/drm/drm_fourcc.h     |   2 +
 include/standard-headers/linux/pci_regs.h     |  24 ++-
 include/standard-headers/linux/vhost_types.h  |   7 +
 .../standard-headers/linux/virtio_config.h    |   5 +
 linux-headers/asm-arm64/kvm.h                 |  32 ++++
 linux-headers/asm-generic/unistd.h            |  14 +-
 linux-headers/asm-loongarch/bitsperlong.h     |   1 +
 linux-headers/asm-loongarch/kvm.h             | 108 +++++++++++
 linux-headers/asm-loongarch/mman.h            |   1 +
 linux-headers/asm-loongarch/unistd.h          |   5 +
 linux-headers/asm-mips/unistd_n32.h           |   4 +
 linux-headers/asm-mips/unistd_n64.h           |   4 +
 linux-headers/asm-mips/unistd_o32.h           |   4 +
 linux-headers/asm-powerpc/unistd_32.h         |   4 +
 linux-headers/asm-powerpc/unistd_64.h         |   4 +
 linux-headers/asm-riscv/kvm.h                 |  12 ++
 linux-headers/asm-s390/unistd_32.h            |   4 +
 linux-headers/asm-s390/unistd_64.h            |   4 +
 linux-headers/asm-x86/unistd_32.h             |   4 +
 linux-headers/asm-x86/unistd_64.h             |   3 +
 linux-headers/asm-x86/unistd_x32.h            |   3 +
 linux-headers/linux/iommufd.h                 | 180 +++++++++++++++++-
 linux-headers/linux/kvm.h                     |  11 ++
 linux-headers/linux/psp-sev.h                 |   1 +
 linux-headers/linux/stddef.h                  |   7 +
 linux-headers/linux/userfaultfd.h             |   9 +-
 linux-headers/linux/vfio.h                    |  47 +++--
 linux-headers/linux/vhost.h                   |   8 +
 28 files changed, 486 insertions(+), 26 deletions(-)
 create mode 100644 linux-headers/asm-loongarch/bitsperlong.h
 create mode 100644 linux-headers/asm-loongarch/kvm.h
 create mode 100644 linux-headers/asm-loongarch/mman.h
 create mode 100644 linux-headers/asm-loongarch/unistd.h

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index 72279f4d25..3afb70160f 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -322,6 +322,8 @@ extern "C" {
  * index 1 = Cr:Cb plane, [39:0] Cr1:Cb1:Cr0:Cb0 little endian
  */
 #define DRM_FORMAT_NV15		fourcc_code('N', 'V', '1', '5') /* 2x2 subsampled Cr:Cb plane */
+#define DRM_FORMAT_NV20		fourcc_code('N', 'V', '2', '0') /* 2x1 subsampled Cr:Cb plane */
+#define DRM_FORMAT_NV30		fourcc_code('N', 'V', '3', '0') /* non-subsampled Cr:Cb plane */
 
 /*
  * 2 plane YCbCr MSB aligned
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index e5f558d964..a39193213f 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -80,6 +80,7 @@
 #define  PCI_HEADER_TYPE_NORMAL		0
 #define  PCI_HEADER_TYPE_BRIDGE		1
 #define  PCI_HEADER_TYPE_CARDBUS	2
+#define  PCI_HEADER_TYPE_MFD		0x80	/* Multi-Function Device (possible) */
 
 #define PCI_BIST		0x0f	/* 8 bits */
 #define  PCI_BIST_CODE_MASK	0x0f	/* Return result */
@@ -637,6 +638,7 @@
 #define PCI_EXP_RTCAP		0x1e	/* Root Capabilities */
 #define  PCI_EXP_RTCAP_CRSVIS	0x0001	/* CRS Software Visibility capability */
 #define PCI_EXP_RTSTA		0x20	/* Root Status */
+#define  PCI_EXP_RTSTA_PME_RQ_ID 0x0000ffff /* PME Requester ID */
 #define  PCI_EXP_RTSTA_PME	0x00010000 /* PME status */
 #define  PCI_EXP_RTSTA_PENDING	0x00020000 /* PME pending */
 /*
@@ -930,12 +932,13 @@
 
 /* Process Address Space ID */
 #define PCI_PASID_CAP		0x04    /* PASID feature register */
-#define  PCI_PASID_CAP_EXEC	0x02	/* Exec permissions Supported */
-#define  PCI_PASID_CAP_PRIV	0x04	/* Privilege Mode Supported */
+#define  PCI_PASID_CAP_EXEC	0x0002	/* Exec permissions Supported */
+#define  PCI_PASID_CAP_PRIV	0x0004	/* Privilege Mode Supported */
+#define  PCI_PASID_CAP_WIDTH	0x1f00
 #define PCI_PASID_CTRL		0x06    /* PASID control register */
-#define  PCI_PASID_CTRL_ENABLE	0x01	/* Enable bit */
-#define  PCI_PASID_CTRL_EXEC	0x02	/* Exec permissions Enable */
-#define  PCI_PASID_CTRL_PRIV	0x04	/* Privilege Mode Enable */
+#define  PCI_PASID_CTRL_ENABLE	0x0001	/* Enable bit */
+#define  PCI_PASID_CTRL_EXEC	0x0002	/* Exec permissions Enable */
+#define  PCI_PASID_CTRL_PRIV	0x0004	/* Privilege Mode Enable */
 #define PCI_EXT_CAP_PASID_SIZEOF	8
 
 /* Single Root I/O Virtualization */
@@ -975,6 +978,8 @@
 #define  PCI_LTR_VALUE_MASK	0x000003ff
 #define  PCI_LTR_SCALE_MASK	0x00001c00
 #define  PCI_LTR_SCALE_SHIFT	10
+#define  PCI_LTR_NOSNOOP_VALUE	0x03ff0000 /* Max No-Snoop Latency Value */
+#define  PCI_LTR_NOSNOOP_SCALE	0x1c000000 /* Scale for Max Value */
 #define PCI_EXT_CAP_LTR_SIZEOF	8
 
 /* Access Control Service */
@@ -1042,9 +1047,16 @@
 #define PCI_EXP_DPC_STATUS		0x08	/* DPC Status */
 #define  PCI_EXP_DPC_STATUS_TRIGGER	    0x0001 /* Trigger Status */
 #define  PCI_EXP_DPC_STATUS_TRIGGER_RSN	    0x0006 /* Trigger Reason */
+#define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_UNCOR  0x0000 /* Uncorrectable error */
+#define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_NFE    0x0002 /* Rcvd ERR_NONFATAL */
+#define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_FE     0x0004 /* Rcvd ERR_FATAL */
+#define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_IN_EXT 0x0006 /* Reason in Trig Reason Extension field */
 #define  PCI_EXP_DPC_STATUS_INTERRUPT	    0x0008 /* Interrupt Status */
 #define  PCI_EXP_DPC_RP_BUSY		    0x0010 /* Root Port Busy */
 #define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_EXT 0x0060 /* Trig Reason Extension */
+#define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_RP_PIO		0x0000	/* RP PIO error */
+#define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_SW_TRIGGER	0x0020	/* DPC SW Trigger bit */
+#define  PCI_EXP_DPC_RP_PIO_FEP		    0x1f00 /* RP PIO First Err Ptr */
 
 #define PCI_EXP_DPC_SOURCE_ID		 0x0A	/* DPC Source Identifier */
 
@@ -1088,6 +1100,8 @@
 #define  PCI_L1SS_CTL1_LTR_L12_TH_VALUE	0x03ff0000  /* LTR_L1.2_THRESHOLD_Value */
 #define  PCI_L1SS_CTL1_LTR_L12_TH_SCALE	0xe0000000  /* LTR_L1.2_THRESHOLD_Scale */
 #define PCI_L1SS_CTL2		0x0c	/* Control 2 Register */
+#define  PCI_L1SS_CTL2_T_PWR_ON_SCALE	0x00000003  /* T_POWER_ON Scale */
+#define  PCI_L1SS_CTL2_T_PWR_ON_VALUE	0x000000f8  /* T_POWER_ON Value */
 
 /* Designated Vendor-Specific (DVSEC, PCI_EXT_CAP_ID_DVSEC) */
 #define PCI_DVSEC_HEADER1		0x4 /* Designated Vendor-Specific Header1 */
diff --git a/include/standard-headers/linux/vhost_types.h b/include/standard-headers/linux/vhost_types.h
index 5ad07e134a..fd54044936 100644
--- a/include/standard-headers/linux/vhost_types.h
+++ b/include/standard-headers/linux/vhost_types.h
@@ -185,5 +185,12 @@ struct vhost_vdpa_iova_range {
  * DRIVER_OK
  */
 #define VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK  0x6
+/* Device may expose the virtqueue's descriptor area, driver area and
+ * device area to a different group for ASID binding than where its
+ * buffers may reside. Requires VHOST_BACKEND_F_IOTLB_ASID.
+ */
+#define VHOST_BACKEND_F_DESC_ASID    0x7
+/* IOTLB don't flush memory mapping across device reset */
+#define VHOST_BACKEND_F_IOTLB_PERSIST  0x8
 
 #endif
diff --git a/include/standard-headers/linux/virtio_config.h b/include/standard-headers/linux/virtio_config.h
index 8a7d0dc8b0..bfd1ca643e 100644
--- a/include/standard-headers/linux/virtio_config.h
+++ b/include/standard-headers/linux/virtio_config.h
@@ -103,6 +103,11 @@
  */
 #define VIRTIO_F_NOTIFICATION_DATA	38
 
+/* This feature indicates that the driver uses the data provided by the device
+ * as a virtqueue identifier in available buffer notifications.
+ */
+#define VIRTIO_F_NOTIF_CONFIG_DATA	39
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 38e5957526..c59ea55cd8 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -491,6 +491,38 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/*
+ * Get feature ID registers userspace writable mask.
+ *
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all currently known R/O registers that indicate
+ * anything useful feature wise, including the ID registers.
+ *
+ * If we ever need to introduce a new range, it will be described as
+ * such in the range field.
+ */
+#define KVM_ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define KVM_ARM_FEATURE_ID_RANGE	0
+#define KVM_ARM_FEATURE_ID_RANGE_SIZE	(3 * 8 * 8)
+
+struct reg_mask_range {
+	__u64 addr;		/* Pointer to mask array */
+	__u32 range;		/* Requested range */
+	__u32 reserved[13];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index abe087c53b..756b013fb8 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -71,7 +71,7 @@ __SYSCALL(__NR_fremovexattr, sys_fremovexattr)
 #define __NR_getcwd 17
 __SYSCALL(__NR_getcwd, sys_getcwd)
 #define __NR_lookup_dcookie 18
-__SC_COMP(__NR_lookup_dcookie, sys_lookup_dcookie, compat_sys_lookup_dcookie)
+__SYSCALL(__NR_lookup_dcookie, sys_ni_syscall)
 #define __NR_eventfd2 19
 __SYSCALL(__NR_eventfd2, sys_eventfd2)
 #define __NR_epoll_create1 20
@@ -816,15 +816,21 @@ __SYSCALL(__NR_process_mrelease, sys_process_mrelease)
 __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
 #define __NR_set_mempolicy_home_node 450
 __SYSCALL(__NR_set_mempolicy_home_node, sys_set_mempolicy_home_node)
-
 #define __NR_cachestat 451
 __SYSCALL(__NR_cachestat, sys_cachestat)
-
 #define __NR_fchmodat2 452
 __SYSCALL(__NR_fchmodat2, sys_fchmodat2)
+#define __NR_map_shadow_stack 453
+__SYSCALL(__NR_map_shadow_stack, sys_map_shadow_stack)
+#define __NR_futex_wake 454
+__SYSCALL(__NR_futex_wake, sys_futex_wake)
+#define __NR_futex_wait 455
+__SYSCALL(__NR_futex_wait, sys_futex_wait)
+#define __NR_futex_requeue 456
+__SYSCALL(__NR_futex_requeue, sys_futex_requeue)
 
 #undef __NR_syscalls
-#define __NR_syscalls 453
+#define __NR_syscalls 457
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-loongarch/bitsperlong.h b/linux-headers/asm-loongarch/bitsperlong.h
new file mode 100644
index 0000000000..6dc0bb0c13
--- /dev/null
+++ b/linux-headers/asm-loongarch/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
new file mode 100644
index 0000000000..c6ad2ee610
--- /dev/null
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#ifndef __UAPI_ASM_LOONGARCH_KVM_H
+#define __UAPI_ASM_LOONGARCH_KVM_H
+
+#include <linux/types.h>
+
+/*
+ * KVM LoongArch specific structures and definitions.
+ *
+ * Some parts derived from the x86 version of this file.
+ */
+
+#define __KVM_HAVE_READONLY_MEM
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET	1
+#define KVM_DIRTY_LOG_PAGE_OFFSET	64
+
+/*
+ * for KVM_GET_REGS and KVM_SET_REGS
+ */
+struct kvm_regs {
+	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
+	__u64 gpr[32];
+	__u64 pc;
+};
+
+/*
+ * for KVM_GET_FPU and KVM_SET_FPU
+ */
+struct kvm_fpu {
+	__u32 fcsr;
+	__u64 fcc;    /* 8x8 */
+	struct kvm_fpureg {
+		__u64 val64[4];
+	} fpr[32];
+};
+
+/*
+ * For LoongArch, we use KVM_SET_ONE_REG and KVM_GET_ONE_REG to access various
+ * registers.  The id field is broken down as follows:
+ *
+ *  bits[63..52] - As per linux/kvm.h
+ *  bits[51..32] - Must be zero.
+ *  bits[31..16] - Register set.
+ *
+ * Register set = 0: GP registers from kvm_regs (see definitions below).
+ *
+ * Register set = 1: CSR registers.
+ *
+ * Register set = 2: KVM specific registers (see definitions below).
+ *
+ * Register set = 3: FPU / SIMD registers (see definitions below).
+ *
+ * Other sets registers may be added in the future.  Each set would
+ * have its own identifier in bits[31..16].
+ */
+
+#define KVM_REG_LOONGARCH_GPR		(KVM_REG_LOONGARCH | 0x00000ULL)
+#define KVM_REG_LOONGARCH_CSR		(KVM_REG_LOONGARCH | 0x10000ULL)
+#define KVM_REG_LOONGARCH_KVM		(KVM_REG_LOONGARCH | 0x20000ULL)
+#define KVM_REG_LOONGARCH_FPSIMD	(KVM_REG_LOONGARCH | 0x30000ULL)
+#define KVM_REG_LOONGARCH_CPUCFG	(KVM_REG_LOONGARCH | 0x40000ULL)
+#define KVM_REG_LOONGARCH_MASK		(KVM_REG_LOONGARCH | 0x70000ULL)
+#define KVM_CSR_IDX_MASK		0x7fff
+#define KVM_CPUCFG_IDX_MASK		0x7fff
+
+/*
+ * KVM_REG_LOONGARCH_KVM - KVM specific control registers.
+ */
+
+#define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 1)
+#define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 2)
+
+#define LOONGARCH_REG_SHIFT		3
+#define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
+#define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
+#define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
+
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
+/* definition of registers in kvm_run */
+struct kvm_sync_regs {
+};
+
+/* dummy definition */
+struct kvm_sregs {
+};
+
+struct kvm_iocsr_entry {
+	__u32 addr;
+	__u32 pad;
+	__u64 data;
+};
+
+#define KVM_NR_IRQCHIPS		1
+#define KVM_IRQCHIP_NUM_PINS	64
+#define KVM_MAX_CORES		256
+
+#endif /* __UAPI_ASM_LOONGARCH_KVM_H */
diff --git a/linux-headers/asm-loongarch/mman.h b/linux-headers/asm-loongarch/mman.h
new file mode 100644
index 0000000000..8eebf89f5a
--- /dev/null
+++ b/linux-headers/asm-loongarch/mman.h
@@ -0,0 +1 @@
+#include <asm-generic/mman.h>
diff --git a/linux-headers/asm-loongarch/unistd.h b/linux-headers/asm-loongarch/unistd.h
new file mode 100644
index 0000000000..fcb668984f
--- /dev/null
+++ b/linux-headers/asm-loongarch/unistd.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_SYS_CLONE3
+
+#include <asm-generic/unistd.h>
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 46d8500654..994b6f008f 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -381,5 +381,9 @@
 #define __NR_set_mempolicy_home_node (__NR_Linux + 450)
 #define __NR_cachestat (__NR_Linux + 451)
 #define __NR_fchmodat2 (__NR_Linux + 452)
+#define __NR_map_shadow_stack (__NR_Linux + 453)
+#define __NR_futex_wake (__NR_Linux + 454)
+#define __NR_futex_wait (__NR_Linux + 455)
+#define __NR_futex_requeue (__NR_Linux + 456)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index c2f7ac673b..41dcf5877a 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -357,5 +357,9 @@
 #define __NR_set_mempolicy_home_node (__NR_Linux + 450)
 #define __NR_cachestat (__NR_Linux + 451)
 #define __NR_fchmodat2 (__NR_Linux + 452)
+#define __NR_map_shadow_stack (__NR_Linux + 453)
+#define __NR_futex_wake (__NR_Linux + 454)
+#define __NR_futex_wait (__NR_Linux + 455)
+#define __NR_futex_requeue (__NR_Linux + 456)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 757c68f2ad..ae9d334d96 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -427,5 +427,9 @@
 #define __NR_set_mempolicy_home_node (__NR_Linux + 450)
 #define __NR_cachestat (__NR_Linux + 451)
 #define __NR_fchmodat2 (__NR_Linux + 452)
+#define __NR_map_shadow_stack (__NR_Linux + 453)
+#define __NR_futex_wake (__NR_Linux + 454)
+#define __NR_futex_wait (__NR_Linux + 455)
+#define __NR_futex_requeue (__NR_Linux + 456)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 8ef94bbac1..b9b23d66d7 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -434,6 +434,10 @@
 #define __NR_set_mempolicy_home_node 450
 #define __NR_cachestat 451
 #define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index 0e7ee43e88..cbb4b3e8f7 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -406,6 +406,10 @@
 #define __NR_set_mempolicy_home_node 450
 #define __NR_cachestat 451
 #define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index 992c5e4071..60d3b21dea 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -80,6 +80,7 @@ struct kvm_riscv_csr {
 	unsigned long sip;
 	unsigned long satp;
 	unsigned long scounteren;
+	unsigned long senvcfg;
 };
 
 /* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -93,6 +94,11 @@ struct kvm_riscv_aia_csr {
 	unsigned long iprio2h;
 };
 
+/* Smstateen CSR for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_smstateen_csr {
+	unsigned long sstateen0;
+};
+
 /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_timer {
 	__u64 frequency;
@@ -131,6 +137,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICSR,
 	KVM_RISCV_ISA_EXT_ZIFENCEI,
 	KVM_RISCV_ISA_EXT_ZIHPM,
+	KVM_RISCV_ISA_EXT_SMSTATEEN,
+	KVM_RISCV_ISA_EXT_ZICOND,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -148,6 +156,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_PMU,
 	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
@@ -178,10 +187,13 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_SMSTATEEN	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
 #define KVM_REG_RISCV_CSR_AIA_REG(name)	\
 	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_CSR_SMSTATEEN_REG(name)  \
+	(offsetof(struct kvm_riscv_smstateen_csr, name) / sizeof(unsigned long))
 
 /* Timer registers are mapped as type 4 */
 #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index 716fa368ca..c093e6d5f9 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -425,5 +425,9 @@
 #define __NR_set_mempolicy_home_node 450
 #define __NR_cachestat 451
 #define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index b2a11b1d13..114c0569a4 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -373,5 +373,9 @@
 #define __NR_set_mempolicy_home_node 450
 #define __NR_cachestat 451
 #define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index d749ad1c24..329649c377 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -443,6 +443,10 @@
 #define __NR_set_mempolicy_home_node 450
 #define __NR_cachestat 451
 #define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index cea67282eb..4583606ce6 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -366,6 +366,9 @@
 #define __NR_cachestat 451
 #define __NR_fchmodat2 452
 #define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 5b2e79bf4c..146d74d8e4 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -318,6 +318,9 @@
 #define __NR_set_mempolicy_home_node (__X32_SYSCALL_BIT + 450)
 #define __NR_cachestat (__X32_SYSCALL_BIT + 451)
 #define __NR_fchmodat2 (__X32_SYSCALL_BIT + 452)
+#define __NR_futex_wake (__X32_SYSCALL_BIT + 454)
+#define __NR_futex_wait (__X32_SYSCALL_BIT + 455)
+#define __NR_futex_requeue (__X32_SYSCALL_BIT + 456)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
index 218bf7ac98..806d98d09c 100644
--- a/linux-headers/linux/iommufd.h
+++ b/linux-headers/linux/iommufd.h
@@ -47,6 +47,8 @@ enum {
 	IOMMUFD_CMD_VFIO_IOAS,
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_GET_HW_INFO,
+	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP,
 };
 
 /**
@@ -347,20 +349,86 @@ struct iommu_vfio_ioas {
 };
 #define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
 
+/**
+ * enum iommufd_hwpt_alloc_flags - Flags for HWPT allocation
+ * @IOMMU_HWPT_ALLOC_NEST_PARENT: If set, allocate a HWPT that can serve as
+ *                                the parent HWPT in a nesting configuration.
+ * @IOMMU_HWPT_ALLOC_DIRTY_TRACKING: Dirty tracking support for device IOMMU is
+ *                                   enforced on device attachment
+ */
+enum iommufd_hwpt_alloc_flags {
+	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
+	IOMMU_HWPT_ALLOC_DIRTY_TRACKING = 1 << 1,
+};
+
+/**
+ * enum iommu_hwpt_vtd_s1_flags - Intel VT-d stage-1 page table
+ *                                entry attributes
+ * @IOMMU_VTD_S1_SRE: Supervisor request
+ * @IOMMU_VTD_S1_EAFE: Extended access enable
+ * @IOMMU_VTD_S1_WPE: Write protect enable
+ */
+enum iommu_hwpt_vtd_s1_flags {
+	IOMMU_VTD_S1_SRE = 1 << 0,
+	IOMMU_VTD_S1_EAFE = 1 << 1,
+	IOMMU_VTD_S1_WPE = 1 << 2,
+};
+
+/**
+ * struct iommu_hwpt_vtd_s1 - Intel VT-d stage-1 page table
+ *                            info (IOMMU_HWPT_DATA_VTD_S1)
+ * @flags: Combination of enum iommu_hwpt_vtd_s1_flags
+ * @pgtbl_addr: The base address of the stage-1 page table.
+ * @addr_width: The address width of the stage-1 page table
+ * @__reserved: Must be 0
+ */
+struct iommu_hwpt_vtd_s1 {
+	__aligned_u64 flags;
+	__aligned_u64 pgtbl_addr;
+	__u32 addr_width;
+	__u32 __reserved;
+};
+
+/**
+ * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
+ * @IOMMU_HWPT_DATA_NONE: no data
+ * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
+ */
+enum iommu_hwpt_data_type {
+	IOMMU_HWPT_DATA_NONE,
+	IOMMU_HWPT_DATA_VTD_S1,
+};
+
 /**
  * struct iommu_hwpt_alloc - ioctl(IOMMU_HWPT_ALLOC)
  * @size: sizeof(struct iommu_hwpt_alloc)
- * @flags: Must be 0
+ * @flags: Combination of enum iommufd_hwpt_alloc_flags
  * @dev_id: The device to allocate this HWPT for
- * @pt_id: The IOAS to connect this HWPT to
+ * @pt_id: The IOAS or HWPT to connect this HWPT to
  * @out_hwpt_id: The ID of the new HWPT
  * @__reserved: Must be 0
+ * @data_type: One of enum iommu_hwpt_data_type
+ * @data_len: Length of the type specific data
+ * @data_uptr: User pointer to the type specific data
  *
  * Explicitly allocate a hardware page table object. This is the same object
  * type that is returned by iommufd_device_attach() and represents the
  * underlying iommu driver's iommu_domain kernel object.
  *
- * A HWPT will be created with the IOVA mappings from the given IOAS.
+ * A kernel-managed HWPT will be created with the mappings from the given
+ * IOAS via the @pt_id. The @data_type for this allocation must be set to
+ * IOMMU_HWPT_DATA_NONE. The HWPT can be allocated as a parent HWPT for a
+ * nesting configuration by passing IOMMU_HWPT_ALLOC_NEST_PARENT via @flags.
+ *
+ * A user-managed nested HWPT will be created from a given parent HWPT via
+ * @pt_id, in which the parent HWPT must be allocated previously via the
+ * same ioctl from a given IOAS (@pt_id). In this case, the @data_type
+ * must be set to a pre-defined type corresponding to an I/O page table
+ * type supported by the underlying IOMMU hardware.
+ *
+ * If the @data_type is set to IOMMU_HWPT_DATA_NONE, @data_len and
+ * @data_uptr should be zero. Otherwise, both @data_len and @data_uptr
+ * must be given.
  */
 struct iommu_hwpt_alloc {
 	__u32 size;
@@ -369,13 +437,26 @@ struct iommu_hwpt_alloc {
 	__u32 pt_id;
 	__u32 out_hwpt_id;
 	__u32 __reserved;
+	__u32 data_type;
+	__u32 data_len;
+	__aligned_u64 data_uptr;
 };
 #define IOMMU_HWPT_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_ALLOC)
 
+/**
+ * enum iommu_hw_info_vtd_flags - Flags for VT-d hw_info
+ * @IOMMU_HW_INFO_VTD_ERRATA_772415_SPR17: If set, disallow read-only mappings
+ *                                         on a nested_parent domain.
+ *                                         https://www.intel.com/content/www/us/en/content-details/772415/content-details.html
+ */
+enum iommu_hw_info_vtd_flags {
+	IOMMU_HW_INFO_VTD_ERRATA_772415_SPR17 = 1 << 0,
+};
+
 /**
  * struct iommu_hw_info_vtd - Intel VT-d hardware information
  *
- * @flags: Must be 0
+ * @flags: Combination of enum iommu_hw_info_vtd_flags
  * @__reserved: Must be 0
  *
  * @cap_reg: Value of Intel VT-d capability register defined in VT-d spec
@@ -404,6 +485,20 @@ enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_INTEL_VTD,
 };
 
+/**
+ * enum iommufd_hw_capabilities
+ * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
+ *                               If available, it means the following APIs
+ *                               are supported:
+ *
+ *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
+ *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
+ *
+ */
+enum iommufd_hw_capabilities {
+	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
+};
+
 /**
  * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
  * @size: sizeof(struct iommu_hw_info)
@@ -415,6 +510,8 @@ enum iommu_hw_info_type {
  *             the iommu type specific hardware information data
  * @out_data_type: Output the iommu hardware info type as defined in the enum
  *                 iommu_hw_info_type.
+ * @out_capabilities: Output the generic iommu capability info type as defined
+ *                    in the enum iommu_hw_capabilities.
  * @__reserved: Must be 0
  *
  * Query an iommu type specific hardware information data from an iommu behind
@@ -439,6 +536,81 @@ struct iommu_hw_info {
 	__aligned_u64 data_uptr;
 	__u32 out_data_type;
 	__u32 __reserved;
+	__aligned_u64 out_capabilities;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
+
+/*
+ * enum iommufd_hwpt_set_dirty_tracking_flags - Flags for steering dirty
+ *                                              tracking
+ * @IOMMU_HWPT_DIRTY_TRACKING_ENABLE: Enable dirty tracking
+ */
+enum iommufd_hwpt_set_dirty_tracking_flags {
+	IOMMU_HWPT_DIRTY_TRACKING_ENABLE = 1,
+};
+
+/**
+ * struct iommu_hwpt_set_dirty_tracking - ioctl(IOMMU_HWPT_SET_DIRTY_TRACKING)
+ * @size: sizeof(struct iommu_hwpt_set_dirty_tracking)
+ * @flags: Combination of enum iommufd_hwpt_set_dirty_tracking_flags
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain
+ * @__reserved: Must be 0
+ *
+ * Toggle dirty tracking on an HW pagetable.
+ */
+struct iommu_hwpt_set_dirty_tracking {
+	__u32 size;
+	__u32 flags;
+	__u32 hwpt_id;
+	__u32 __reserved;
+};
+#define IOMMU_HWPT_SET_DIRTY_TRACKING _IO(IOMMUFD_TYPE, \
+					  IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING)
+
+/**
+ * enum iommufd_hwpt_get_dirty_bitmap_flags - Flags for getting dirty bits
+ * @IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR: Just read the PTEs without clearing
+ *                                        any dirty bits metadata. This flag
+ *                                        can be passed in the expectation
+ *                                        where the next operation is an unmap
+ *                                        of the same IOVA range.
+ *
+ */
+enum iommufd_hwpt_get_dirty_bitmap_flags {
+	IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR = 1,
+};
+
+/**
+ * struct iommu_hwpt_get_dirty_bitmap - ioctl(IOMMU_HWPT_GET_DIRTY_BITMAP)
+ * @size: sizeof(struct iommu_hwpt_get_dirty_bitmap)
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain
+ * @flags: Combination of enum iommufd_hwpt_get_dirty_bitmap_flags
+ * @__reserved: Must be 0
+ * @iova: base IOVA of the bitmap first bit
+ * @length: IOVA range size
+ * @page_size: page size granularity of each bit in the bitmap
+ * @data: bitmap where to set the dirty bits. The bitmap bits each
+ *        represent a page_size which you deviate from an arbitrary iova.
+ *
+ * Checking a given IOVA is dirty:
+ *
+ *  data[(iova / page_size) / 64] & (1ULL << ((iova / page_size) % 64))
+ *
+ * Walk the IOMMU pagetables for a given IOVA range to return a bitmap
+ * with the dirty IOVAs. In doing so it will also by default clear any
+ * dirty bit metadata set in the IOPTE.
+ */
+struct iommu_hwpt_get_dirty_bitmap {
+	__u32 size;
+	__u32 hwpt_id;
+	__u32 flags;
+	__u32 __reserved;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 data;
+};
+#define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
+					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)
+
 #endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 0d74ee999a..549fea3a97 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_LOONGARCH_IOCSR  38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -336,6 +337,13 @@ struct kvm_run {
 			__u32 len;
 			__u8  is_write;
 		} mmio;
+		/* KVM_EXIT_LOONGARCH_IOCSR */
+		struct {
+			__u64 phys_addr;
+			__u8  data[8];
+			__u32 len;
+			__u8  is_write;
+		} iocsr_io;
 		/* KVM_EXIT_HYPERCALL */
 		struct {
 			__u64 nr;
@@ -1188,6 +1196,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1358,6 +1367,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
 #define KVM_REG_RISCV		0x8000000000000000ULL
+#define KVM_REG_LOONGARCH	0x9000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1558,6 +1568,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
diff --git a/linux-headers/linux/psp-sev.h b/linux-headers/linux/psp-sev.h
index 12ccb70099..bcb21339ee 100644
--- a/linux-headers/linux/psp-sev.h
+++ b/linux-headers/linux/psp-sev.h
@@ -68,6 +68,7 @@ typedef enum {
 	SEV_RET_INVALID_PARAM,
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
+	SEV_RET_INVALID_KEY = 0x27,
 	SEV_RET_MAX,
 } sev_ret_code;
 
diff --git a/linux-headers/linux/stddef.h b/linux-headers/linux/stddef.h
index 9bb07083ac..b3d4a9c170 100644
--- a/linux-headers/linux/stddef.h
+++ b/linux-headers/linux/stddef.h
@@ -29,6 +29,11 @@
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
 
+#ifdef __cplusplus
+/* sizeof(struct{}) is 1 in C++, not 0, can't use C version of the macro. */
+#define __DECLARE_FLEX_ARRAY(T, member)	\
+	T member[0]
+#else
 /**
  * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
  *
@@ -49,3 +54,5 @@
 #ifndef __counted_by
 #define __counted_by(m)
 #endif
+
+#endif /* _LINUX_STDDEF_H */
diff --git a/linux-headers/linux/userfaultfd.h b/linux-headers/linux/userfaultfd.h
index 59978fbaae..953c75feda 100644
--- a/linux-headers/linux/userfaultfd.h
+++ b/linux-headers/linux/userfaultfd.h
@@ -40,7 +40,8 @@
 			   UFFD_FEATURE_EXACT_ADDRESS |		\
 			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM |	\
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
-			   UFFD_FEATURE_POISON)
+			   UFFD_FEATURE_POISON |		\
+			   UFFD_FEATURE_WP_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -216,6 +217,11 @@ struct uffdio_api {
 	 * (i.e. empty ptes).  This will be the default behavior for shmem
 	 * & hugetlbfs, so this flag only affects anonymous memory behavior
 	 * when userfault write-protection mode is registered.
+	 *
+	 * UFFD_FEATURE_WP_ASYNC indicates that userfaultfd write-protection
+	 * asynchronous mode is supported in which the write fault is
+	 * automatically resolved and write-protection is un-set.
+	 * It implies UFFD_FEATURE_WP_UNPOPULATED.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -232,6 +238,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_HUGETLBFS_SHMEM		(1<<12)
 #define UFFD_FEATURE_WP_UNPOPULATED		(1<<13)
 #define UFFD_FEATURE_POISON			(1<<14)
+#define UFFD_FEATURE_WP_ASYNC			(1<<15)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index acf72b4999..8e175ece31 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -277,8 +277,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_FLAG_CAPS	(1 << 3) /* Info supports caps */
 	__u32	index;		/* Region index */
 	__u32	cap_offset;	/* Offset within info struct of first cap */
-	__u64	size;		/* Region size (bytes) */
-	__u64	offset;		/* Region offset from start of device fd */
+	__aligned_u64	size;	/* Region size (bytes) */
+	__aligned_u64	offset;	/* Region offset from start of device fd */
 };
 #define VFIO_DEVICE_GET_REGION_INFO	_IO(VFIO_TYPE, VFIO_BASE + 8)
 
@@ -294,8 +294,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_CAP_SPARSE_MMAP	1
 
 struct vfio_region_sparse_mmap_area {
-	__u64	offset;	/* Offset of mmap'able area within region */
-	__u64	size;	/* Size of mmap'able area */
+	__aligned_u64	offset;	/* Offset of mmap'able area within region */
+	__aligned_u64	size;	/* Size of mmap'able area */
 };
 
 struct vfio_region_info_cap_sparse_mmap {
@@ -450,9 +450,9 @@ struct vfio_device_migration_info {
 					     VFIO_DEVICE_STATE_V1_RESUMING)
 
 	__u32 reserved;
-	__u64 pending_bytes;
-	__u64 data_offset;
-	__u64 data_size;
+	__aligned_u64 pending_bytes;
+	__aligned_u64 data_offset;
+	__aligned_u64 data_size;
 };
 
 /*
@@ -476,7 +476,7 @@ struct vfio_device_migration_info {
 
 struct vfio_region_info_cap_nvlink2_ssatgt {
 	struct vfio_info_cap_header header;
-	__u64 tgt;
+	__aligned_u64 tgt;
 };
 
 /*
@@ -816,7 +816,7 @@ struct vfio_device_gfx_plane_info {
 	__u32 drm_plane_type;	/* type of plane: DRM_PLANE_TYPE_* */
 	/* out */
 	__u32 drm_format;	/* drm format of plane */
-	__u64 drm_format_mod;   /* tiled mode */
+	__aligned_u64 drm_format_mod;   /* tiled mode */
 	__u32 width;	/* width of plane */
 	__u32 height;	/* height of plane */
 	__u32 stride;	/* stride of plane */
@@ -829,6 +829,7 @@ struct vfio_device_gfx_plane_info {
 		__u32 region_index;	/* region index */
 		__u32 dmabuf_id;	/* dma-buf id */
 	};
+	__u32 reserved;
 };
 
 #define VFIO_DEVICE_QUERY_GFX_PLANE _IO(VFIO_TYPE, VFIO_BASE + 14)
@@ -863,9 +864,10 @@ struct vfio_device_ioeventfd {
 #define VFIO_DEVICE_IOEVENTFD_32	(1 << 2) /* 4-byte write */
 #define VFIO_DEVICE_IOEVENTFD_64	(1 << 3) /* 8-byte write */
 #define VFIO_DEVICE_IOEVENTFD_SIZE_MASK	(0xf)
-	__u64	offset;			/* device fd offset of write */
-	__u64	data;			/* data to be written */
+	__aligned_u64	offset;		/* device fd offset of write */
+	__aligned_u64	data;		/* data to be written */
 	__s32	fd;			/* -1 for de-assignment */
+	__u32	reserved;
 };
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
@@ -1434,6 +1436,27 @@ struct vfio_device_feature_mig_data_size {
 
 #define VFIO_DEVICE_FEATURE_MIG_DATA_SIZE 9
 
+/**
+ * Upon VFIO_DEVICE_FEATURE_SET, set or clear the BUS mastering for the device
+ * based on the operation specified in op flag.
+ *
+ * The functionality is incorporated for devices that needs bus master control,
+ * but the in-band device interface lacks the support. Consequently, it is not
+ * applicable to PCI devices, as bus master control for PCI devices is managed
+ * in-band through the configuration space. At present, this feature is supported
+ * only for CDX devices.
+ * When the device's BUS MASTER setting is configured as CLEAR, it will result in
+ * blocking all incoming DMA requests from the device. On the other hand, configuring
+ * the device's BUS MASTER setting as SET (enable) will grant the device the
+ * capability to perform DMA to the host memory.
+ */
+struct vfio_device_feature_bus_master {
+	__u32 op;
+#define		VFIO_DEVICE_FEATURE_CLEAR_MASTER	0	/* Clear Bus Master */
+#define		VFIO_DEVICE_FEATURE_SET_MASTER		1	/* Set Bus Master */
+};
+#define VFIO_DEVICE_FEATURE_BUS_MASTER 10
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
@@ -1449,7 +1472,7 @@ struct vfio_iommu_type1_info {
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
 #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
-	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
+	__aligned_u64	iova_pgsizes;		/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
 	__u32   pad;
 };
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index f5c48b61ab..649560c685 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -219,4 +219,12 @@
  */
 #define VHOST_VDPA_RESUME		_IO(VHOST_VIRTIO, 0x7E)
 
+/* Get the group for the descriptor table including driver & device areas
+ * of a virtqueue: read index, write group in num.
+ * The virtqueue index is stored in the index field of vhost_vring_state.
+ * The group ID of the descriptor table for this specific virtqueue
+ * is returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.39.1


