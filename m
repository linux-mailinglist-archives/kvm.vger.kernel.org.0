Return-Path: <kvm+bounces-60486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DB3BEFD5A
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA5B3BC0C5
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDEA2E9ECE;
	Mon, 20 Oct 2025 08:12:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CF12E9748
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760947930; cv=none; b=bQeOJdFe8/iAb758Wv4iEcmJThNK0PTRV1SkkT3yD8W4BcDXGMz/cpbkbCQLdusECTNNl+pS+11kj5tNOSQNLn3+n6oa5mIjoDNzq+0ljX/8pVW6J7lNNUJBQZR274EpvAX3H77WewPLoBcCSZtyRWWH8tUdrlfQop18ciCC+IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760947930; c=relaxed/simple;
	bh=6c348SA5+Gf+FnPAqqxvgi/Gt69sFLPdnhclt7qyrgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sb2vImGRokf9ZCeb2A2M7x3oDVDlbgwZXOPrddZvX69V/haq3GY2KI9GxjlpqCXtZ3d3z7XKc452Mxqoth60eesgTk+yGMwIxTV1yIK3W+hORTT+4uVQxPW5Illl2Am9iFSN6j16N8lo4HJ1MuowSRXM5u0zCDJIvPH4HZcJlvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxP9PT7vVoADUYAA--.50893S3;
	Mon, 20 Oct 2025 16:12:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxZOTQ7vVohSf4AA--.18451S3;
	Mon, 20 Oct 2025 16:12:03 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Song Gao <gaosong@loongson.cn>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [RFC 1/2] linux-headers: Update to Linux v6.18-rc2
Date: Mon, 20 Oct 2025 16:11:58 +0800
Message-Id: <20251020081159.2370512-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251020081159.2370512-1-maobibo@loongson.cn>
References: <20251020081159.2370512-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxZOTQ7vVohSf4AA--.18451S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Update headers to retrieve the latest KVM caps for LoongArch.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 include/standard-headers/linux/ethtool.h      |  1 +
 include/standard-headers/linux/fuse.h         | 22 ++++++++++--
 .../linux/input-event-codes.h                 |  1 +
 include/standard-headers/linux/input.h        | 22 +++++++++++-
 include/standard-headers/linux/pci_regs.h     | 10 ++++++
 include/standard-headers/linux/virtio_ids.h   |  1 +
 linux-headers/asm-loongarch/kvm.h             |  1 +
 linux-headers/asm-riscv/kvm.h                 | 23 ++++++++++++-
 linux-headers/asm-riscv/ptrace.h              |  4 +--
 linux-headers/asm-x86/kvm.h                   | 34 +++++++++++++++++++
 linux-headers/asm-x86/unistd_64.h             |  1 +
 linux-headers/asm-x86/unistd_x32.h            |  1 +
 linux-headers/linux/kvm.h                     |  3 ++
 linux-headers/linux/psp-sev.h                 | 10 +++++-
 linux-headers/linux/stddef.h                  |  1 -
 linux-headers/linux/vduse.h                   |  2 +-
 linux-headers/linux/vhost.h                   |  4 +--
 17 files changed, 130 insertions(+), 11 deletions(-)

diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index eb80314028..dc24512d28 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -2380,6 +2380,7 @@ enum {
 #define	RXH_L4_B_0_1	(1 << 6) /* src port in case of TCP/UDP/SCTP */
 #define	RXH_L4_B_2_3	(1 << 7) /* dst port in case of TCP/UDP/SCTP */
 #define	RXH_GTP_TEID	(1 << 8) /* teid in case of GTP */
+#define	RXH_IP6_FL	(1 << 9) /* IPv6 flow label */
 #define	RXH_DISCARD	(1 << 31)
 
 #define	RX_CLS_FLOW_DISC	0xffffffffffffffffULL
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index d8b2fd67e1..abf3a78858 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -235,6 +235,11 @@
  *
  *  7.44
  *  - add FUSE_NOTIFY_INC_EPOCH
+ *
+ *  7.45
+ *  - add FUSE_COPY_FILE_RANGE_64
+ *  - add struct fuse_copy_file_range_out
+ *  - add FUSE_NOTIFY_PRUNE
  */
 
 #ifndef _LINUX_FUSE_H
@@ -266,7 +271,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 44
+#define FUSE_KERNEL_MINOR_VERSION 45
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -653,6 +658,7 @@ enum fuse_opcode {
 	FUSE_SYNCFS		= 50,
 	FUSE_TMPFILE		= 51,
 	FUSE_STATX		= 52,
+	FUSE_COPY_FILE_RANGE_64	= 53,
 
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
@@ -671,7 +677,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_DELETE = 6,
 	FUSE_NOTIFY_RESEND = 7,
 	FUSE_NOTIFY_INC_EPOCH = 8,
-	FUSE_NOTIFY_CODE_MAX,
+	FUSE_NOTIFY_PRUNE = 9,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
@@ -1110,6 +1116,12 @@ struct fuse_notify_retrieve_in {
 	uint64_t	dummy4;
 };
 
+struct fuse_notify_prune_out {
+	uint32_t	count;
+	uint32_t	padding;
+	uint64_t	spare;
+};
+
 struct fuse_backing_map {
 	int32_t		fd;
 	uint32_t	flags;
@@ -1122,6 +1134,7 @@ struct fuse_backing_map {
 #define FUSE_DEV_IOC_BACKING_OPEN	_IOW(FUSE_DEV_IOC_MAGIC, 1, \
 					     struct fuse_backing_map)
 #define FUSE_DEV_IOC_BACKING_CLOSE	_IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
+#define FUSE_DEV_IOC_SYNC_INIT		_IO(FUSE_DEV_IOC_MAGIC, 3)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
@@ -1144,6 +1157,11 @@ struct fuse_copy_file_range_in {
 	uint64_t	flags;
 };
 
+/* For FUSE_COPY_FILE_RANGE_64 */
+struct fuse_copy_file_range_out {
+	uint64_t	bytes_copied;
+};
+
 #define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
 #define FUSE_SETUPMAPPING_FLAG_READ (1ull << 1)
 struct fuse_setupmapping_in {
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index 00dc9caac9..c914ccd723 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -27,6 +27,7 @@
 #define INPUT_PROP_TOPBUTTONPAD		0x04	/* softbuttons at top of pad */
 #define INPUT_PROP_POINTING_STICK	0x05	/* is a pointing stick */
 #define INPUT_PROP_ACCELEROMETER	0x06	/* has accelerometer */
+#define INPUT_PROP_HAPTIC_TOUCHPAD	0x07	/* is a haptic touchpad */
 
 #define INPUT_PROP_MAX			0x1f
 #define INPUT_PROP_CNT			(INPUT_PROP_MAX + 1)
diff --git a/include/standard-headers/linux/input.h b/include/standard-headers/linux/input.h
index d4512c20b5..9aff211dd5 100644
--- a/include/standard-headers/linux/input.h
+++ b/include/standard-headers/linux/input.h
@@ -426,6 +426,24 @@ struct ff_rumble_effect {
 	uint16_t weak_magnitude;
 };
 
+/**
+ * struct ff_haptic_effect
+ * @hid_usage: hid_usage according to Haptics page (WAVEFORM_CLICK, etc.)
+ * @vendor_id: the waveform vendor ID if hid_usage is in the vendor-defined range
+ * @vendor_waveform_page: the vendor waveform page if hid_usage is in the vendor-defined range
+ * @intensity: strength of the effect as percentage
+ * @repeat_count: number of times to retrigger effect
+ * @retrigger_period: time before effect is retriggered (in ms)
+ */
+struct ff_haptic_effect {
+	uint16_t hid_usage;
+	uint16_t vendor_id;
+	uint8_t  vendor_waveform_page;
+	uint16_t intensity;
+	uint16_t repeat_count;
+	uint16_t retrigger_period;
+};
+
 /**
  * struct ff_effect - defines force feedback effect
  * @type: type of the effect (FF_CONSTANT, FF_PERIODIC, FF_RAMP, FF_SPRING,
@@ -462,6 +480,7 @@ struct ff_effect {
 		struct ff_periodic_effect periodic;
 		struct ff_condition_effect condition[2]; /* One for each axis */
 		struct ff_rumble_effect rumble;
+		struct ff_haptic_effect haptic;
 	} u;
 };
 
@@ -469,6 +488,7 @@ struct ff_effect {
  * Force feedback effect types
  */
 
+#define FF_HAPTIC		0x4f
 #define FF_RUMBLE	0x50
 #define FF_PERIODIC	0x51
 #define FF_CONSTANT	0x52
@@ -478,7 +498,7 @@ struct ff_effect {
 #define FF_INERTIA	0x56
 #define FF_RAMP		0x57
 
-#define FF_EFFECT_MIN	FF_RUMBLE
+#define FF_EFFECT_MIN	FF_HAPTIC
 #define FF_EFFECT_MAX	FF_RAMP
 
 /*
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index f5b17745de..07e06aafec 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -207,6 +207,9 @@
 
 /* Capability lists */
 
+#define PCI_CAP_ID_MASK		0x00ff	/* Capability ID mask */
+#define PCI_CAP_LIST_NEXT_MASK	0xff00	/* Next Capability Pointer mask */
+
 #define PCI_CAP_LIST_ID		0	/* Capability ID */
 #define  PCI_CAP_ID_PM		0x01	/* Power Management */
 #define  PCI_CAP_ID_AGP		0x02	/* Accelerated Graphics Port */
@@ -776,6 +779,12 @@
 #define  PCI_ERR_UNC_MCBTLP	0x00800000	/* MC blocked TLP */
 #define  PCI_ERR_UNC_ATOMEG	0x01000000	/* Atomic egress blocked */
 #define  PCI_ERR_UNC_TLPPRE	0x02000000	/* TLP prefix blocked */
+#define  PCI_ERR_UNC_POISON_BLK	0x04000000	/* Poisoned TLP Egress Blocked */
+#define  PCI_ERR_UNC_DMWR_BLK	0x08000000	/* DMWr Request Egress Blocked */
+#define  PCI_ERR_UNC_IDE_CHECK	0x10000000	/* IDE Check Failed */
+#define  PCI_ERR_UNC_MISR_IDE	0x20000000	/* Misrouted IDE TLP */
+#define  PCI_ERR_UNC_PCRC_CHECK	0x40000000	/* PCRC Check Failed */
+#define  PCI_ERR_UNC_XLAT_BLK	0x80000000	/* TLP Translation Egress Blocked */
 #define PCI_ERR_UNCOR_MASK	0x08	/* Uncorrectable Error Mask */
 	/* Same bits as above */
 #define PCI_ERR_UNCOR_SEVER	0x0c	/* Uncorrectable Error Severity */
@@ -798,6 +807,7 @@
 #define  PCI_ERR_CAP_ECRC_CHKC		0x00000080 /* ECRC Check Capable */
 #define  PCI_ERR_CAP_ECRC_CHKE		0x00000100 /* ECRC Check Enable */
 #define  PCI_ERR_CAP_PREFIX_LOG_PRESENT	0x00000800 /* TLP Prefix Log Present */
+#define  PCI_ERR_CAP_COMP_TIME_LOG	0x00001000 /* Completion Timeout Prefix/Header Log Capable */
 #define  PCI_ERR_CAP_TLP_LOG_FLIT	0x00040000 /* TLP was logged in Flit Mode */
 #define  PCI_ERR_CAP_TLP_LOG_SIZE	0x00f80000 /* Logged TLP Size (only in Flit mode) */
 #define PCI_ERR_HEADER_LOG	0x1c	/* Header Log Register (16 bytes) */
diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
index 7aa2eb7662..6c12db16fa 100644
--- a/include/standard-headers/linux/virtio_ids.h
+++ b/include/standard-headers/linux/virtio_ids.h
@@ -68,6 +68,7 @@
 #define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
 #define VIRTIO_ID_BT			40 /* virtio bluetooth */
 #define VIRTIO_ID_GPIO			41 /* virtio gpio */
+#define VIRTIO_ID_SPI			45 /* virtio spi */
 
 /*
  * Virtio Transitional IDs
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index 5f354f5c68..57ba1a563b 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -103,6 +103,7 @@ struct kvm_fpu {
 #define  KVM_LOONGARCH_VM_FEAT_PMU		5
 #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
 #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
+#define  KVM_LOONGARCH_VM_FEAT_PTW		8
 
 /* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index ef27d4289d..759a4852c0 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -9,7 +9,7 @@
 #ifndef __LINUX_KVM_RISCV_H
 #define __LINUX_KVM_RISCV_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 #include <asm/bitsperlong.h>
@@ -56,6 +56,7 @@ struct kvm_riscv_config {
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
 	unsigned long satp_mode;
+	unsigned long zicbop_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -185,6 +186,10 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICCRSE,
 	KVM_RISCV_ISA_EXT_ZAAMO,
 	KVM_RISCV_ISA_EXT_ZALRSC,
+	KVM_RISCV_ISA_EXT_ZICBOP,
+	KVM_RISCV_ISA_EXT_ZFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFWMA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -205,6 +210,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_SUSP,
+	KVM_RISCV_SBI_EXT_FWFT,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
@@ -214,6 +220,18 @@ struct kvm_riscv_sbi_sta {
 	unsigned long shmem_hi;
 };
 
+struct kvm_riscv_sbi_fwft_feature {
+	unsigned long enable;
+	unsigned long flags;
+	unsigned long value;
+};
+
+/* SBI FWFT extension registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_sbi_fwft {
+	struct kvm_riscv_sbi_fwft_feature misaligned_deleg;
+	struct kvm_riscv_sbi_fwft_feature pointer_masking;
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -297,6 +315,9 @@ struct kvm_riscv_sbi_sta {
 #define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_SBI_STA_REG(name)		\
 		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_SBI_FWFT		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_FWFT_REG(name)	\
+		(offsetof(struct kvm_riscv_sbi_fwft, name) / sizeof(unsigned long))
 
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
diff --git a/linux-headers/asm-riscv/ptrace.h b/linux-headers/asm-riscv/ptrace.h
index 1e3166caca..a3f8211ede 100644
--- a/linux-headers/asm-riscv/ptrace.h
+++ b/linux-headers/asm-riscv/ptrace.h
@@ -6,7 +6,7 @@
 #ifndef _ASM_RISCV_PTRACE_H
 #define _ASM_RISCV_PTRACE_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -127,6 +127,6 @@ struct __riscv_v_regset_state {
  */
 #define RISCV_MAX_VLENB (8192)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_RISCV_PTRACE_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index f0c1a730d9..3bb38f6c3a 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -35,6 +35,11 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
+
+#define HV_VECTOR 28
+#define VC_VECTOR 29
+#define SX_VECTOR 30
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
@@ -409,6 +414,35 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_KVM		3
+
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
+({										\
+	__u64 type_size = (__u64)type << 32;					\
+										\
+	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ID(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_KVM, index)
+
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index 2f55bebb81..26c258d1a6 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -337,6 +337,7 @@
 #define __NR_io_pgetevents 333
 #define __NR_rseq 334
 #define __NR_uretprobe 335
+#define __NR_uprobe 336
 #define __NR_pidfd_send_signal 424
 #define __NR_io_uring_setup 425
 #define __NR_io_uring_enter 426
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 8cc8673f15..65c2aed946 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -290,6 +290,7 @@
 #define __NR_io_pgetevents (__X32_SYSCALL_BIT + 333)
 #define __NR_rseq (__X32_SYSCALL_BIT + 334)
 #define __NR_uretprobe (__X32_SYSCALL_BIT + 335)
+#define __NR_uprobe (__X32_SYSCALL_BIT + 336)
 #define __NR_pidfd_send_signal (__X32_SYSCALL_BIT + 424)
 #define __NR_io_uring_setup (__X32_SYSCALL_BIT + 425)
 #define __NR_io_uring_enter (__X32_SYSCALL_BIT + 426)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index be704965d8..4ea28ef7ca 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -954,6 +954,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_GUEST_MEMFD_FLAGS 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1590,6 +1591,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/linux-headers/linux/psp-sev.h b/linux-headers/linux/psp-sev.h
index 113c4ceb78..c525125ea8 100644
--- a/linux-headers/linux/psp-sev.h
+++ b/linux-headers/linux/psp-sev.h
@@ -185,6 +185,10 @@ struct sev_user_data_get_id2 {
  * @mask_chip_id: whether chip id is present in attestation reports or not
  * @mask_chip_key: whether attestation reports are signed or not
  * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @feature_info: whether SNP_FEATURE_INFO command is available
+ * @rapl_dis: whether RAPL is disabled
+ * @ciphertext_hiding_cap: whether platform has ciphertext hiding capability
+ * @ciphertext_hiding_en: whether ciphertext hiding is enabled
  * @rsvd1: reserved
  * @guest_count: the number of guest currently managed by the firmware
  * @current_tcb_version: current TCB version
@@ -200,7 +204,11 @@ struct sev_user_data_snp_status {
 	__u32 mask_chip_id:1;		/* Out */
 	__u32 mask_chip_key:1;		/* Out */
 	__u32 vlek_en:1;		/* Out */
-	__u32 rsvd1:29;
+	__u32 feature_info:1;		/* Out */
+	__u32 rapl_dis:1;		/* Out */
+	__u32 ciphertext_hiding_cap:1;	/* Out */
+	__u32 ciphertext_hiding_en:1;	/* Out */
+	__u32 rsvd1:25;
 	__u32 guest_count;		/* Out */
 	__u64 current_tcb_version;	/* Out */
 	__u64 reported_tcb_version;	/* Out */
diff --git a/linux-headers/linux/stddef.h b/linux-headers/linux/stddef.h
index e1fcfcf3b3..48ee4438e0 100644
--- a/linux-headers/linux/stddef.h
+++ b/linux-headers/linux/stddef.h
@@ -3,7 +3,6 @@
 #define _LINUX_STDDEF_H
 
 
-
 #ifndef __always_inline
 #define __always_inline __inline__
 #endif
diff --git a/linux-headers/linux/vduse.h b/linux-headers/linux/vduse.h
index f46269af34..da6ac89af1 100644
--- a/linux-headers/linux/vduse.h
+++ b/linux-headers/linux/vduse.h
@@ -237,7 +237,7 @@ struct vduse_iova_umem {
  * struct vduse_iova_info - information of one IOVA region
  * @start: start of the IOVA region
  * @last: last of the IOVA region
- * @capability: capability of the IOVA regsion
+ * @capability: capability of the IOVA region
  * @reserved: for future use, needs to be initialized to zero
  *
  * Structure used by VDUSE_IOTLB_GET_INFO ioctl to get information of
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index 283348b64a..c57674a6aa 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -260,7 +260,7 @@
  * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
  *   - Vhost will create vhost workers as kernel threads.
  */
-#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
+#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
 
 /**
  * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost device.
@@ -268,6 +268,6 @@
  *
  * @return: An 8-bit value indicating the current thread mode.
  */
-#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
+#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
 
 #endif
-- 
2.39.3


