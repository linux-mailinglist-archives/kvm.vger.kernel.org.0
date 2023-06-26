Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82E73D7FD
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 08:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjFZGud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 02:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFZGub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 02:50:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5DEE4C
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 23:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687762188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/BQYQtN3VbWMwr3hdUAz6460NfGMHaYQQTnVCrZDbJs=;
        b=ZD98Jqz+X+3fNDd2vhnURa4AhohhlHqTxc1VABQY9z1CfEaFgGzML4Y6ZUzDs+XXQ0WBbZ
        sQlgpX/qMkg02UrhAyghq/XXDitcxhJ3nliG1e7KokD2VnTyOCC3So6yJdOpFdUmijzIDE
        CHBwOhf1AFjwurn2Gkjk8xlzMtJj6oU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-SDuf4AXTOxuTVvbSA_8NSA-1; Mon, 26 Jun 2023 02:49:43 -0400
X-MC-Unique: SDuf4AXTOxuTVvbSA_8NSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FF4C104458C;
        Mon, 26 Jun 2023 06:49:43 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DF28200B677;
        Mon, 26 Jun 2023 06:49:43 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     oliver.upton@linux.dev, salil.mehta@huawei.com,
        james.morse@arm.com, gshan@redhat.com,
        Shaoqin Huang <shahuang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 1/5] linux-headers: Update to v6.4-rc7
Date:   Mon, 26 Jun 2023 02:49:05 -0400
Message-Id: <20230626064910.1787255-2-shahuang@redhat.com>
In-Reply-To: <20230626064910.1787255-1-shahuang@redhat.com>
References: <20230626064910.1787255-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update to commit 45a3e24f65e9 ("Linux 6.4-rc7").

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 include/standard-headers/linux/const.h        |  2 +-
 include/standard-headers/linux/virtio_blk.h   | 18 +++----
 .../standard-headers/linux/virtio_config.h    |  6 +++
 include/standard-headers/linux/virtio_net.h   |  1 +
 linux-headers/asm-arm64/kvm.h                 | 33 ++++++++++++
 linux-headers/asm-riscv/kvm.h                 | 53 ++++++++++++++++++-
 linux-headers/asm-riscv/unistd.h              |  9 ++++
 linux-headers/asm-s390/unistd_32.h            |  1 +
 linux-headers/asm-s390/unistd_64.h            |  1 +
 linux-headers/asm-x86/kvm.h                   |  3 ++
 linux-headers/linux/const.h                   |  2 +-
 linux-headers/linux/kvm.h                     | 12 +++--
 linux-headers/linux/psp-sev.h                 |  7 +++
 linux-headers/linux/userfaultfd.h             | 17 +++++-
 14 files changed, 149 insertions(+), 16 deletions(-)

diff --git a/include/standard-headers/linux/const.h b/include/standard-headers/linux/const.h
index 5e48987251..1eb84b5087 100644
--- a/include/standard-headers/linux/const.h
+++ b/include/standard-headers/linux/const.h
@@ -28,7 +28,7 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
 #define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
diff --git a/include/standard-headers/linux/virtio_blk.h b/include/standard-headers/linux/virtio_blk.h
index 7155b1a470..d7be3cf5e4 100644
--- a/include/standard-headers/linux/virtio_blk.h
+++ b/include/standard-headers/linux/virtio_blk.h
@@ -138,11 +138,11 @@ struct virtio_blk_config {
 
 	/* Zoned block device characteristics (if VIRTIO_BLK_F_ZONED) */
 	struct virtio_blk_zoned_characteristics {
-		uint32_t zone_sectors;
-		uint32_t max_open_zones;
-		uint32_t max_active_zones;
-		uint32_t max_append_sectors;
-		uint32_t write_granularity;
+		__virtio32 zone_sectors;
+		__virtio32 max_open_zones;
+		__virtio32 max_active_zones;
+		__virtio32 max_append_sectors;
+		__virtio32 write_granularity;
 		uint8_t model;
 		uint8_t unused2[3];
 	} zoned;
@@ -239,11 +239,11 @@ struct virtio_blk_outhdr {
  */
 struct virtio_blk_zone_descriptor {
 	/* Zone capacity */
-	uint64_t z_cap;
+	__virtio64 z_cap;
 	/* The starting sector of the zone */
-	uint64_t z_start;
+	__virtio64 z_start;
 	/* Zone write pointer position in sectors */
-	uint64_t z_wp;
+	__virtio64 z_wp;
 	/* Zone type */
 	uint8_t z_type;
 	/* Zone state */
@@ -252,7 +252,7 @@ struct virtio_blk_zone_descriptor {
 };
 
 struct virtio_blk_zone_report {
-	uint64_t nr_zones;
+	__virtio64 nr_zones;
 	uint8_t reserved[56];
 	struct virtio_blk_zone_descriptor zones[];
 };
diff --git a/include/standard-headers/linux/virtio_config.h b/include/standard-headers/linux/virtio_config.h
index 965ee6ae23..8a7d0dc8b0 100644
--- a/include/standard-headers/linux/virtio_config.h
+++ b/include/standard-headers/linux/virtio_config.h
@@ -97,6 +97,12 @@
  */
 #define VIRTIO_F_SR_IOV			37
 
+/*
+ * This feature indicates that the driver passes extra data (besides
+ * identifying the virtqueue) in its device notifications.
+ */
+#define VIRTIO_F_NOTIFICATION_DATA	38
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
diff --git a/include/standard-headers/linux/virtio_net.h b/include/standard-headers/linux/virtio_net.h
index c0e797067a..2325485f2c 100644
--- a/include/standard-headers/linux/virtio_net.h
+++ b/include/standard-headers/linux/virtio_net.h
@@ -61,6 +61,7 @@
 #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
 #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
+#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
 #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index d7e7bb885e..38e5957526 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -198,6 +198,15 @@ struct kvm_arm_copy_mte_tags {
 	__u64 reserved[2];
 };
 
+/*
+ * Counter/Timer offset structure. Describe the virtual/physical offset.
+ * To be used with KVM_ARM_SET_COUNTER_OFFSET.
+ */
+struct kvm_arm_counter_offset {
+	__u64 counter_offset;
+	__u64 reserved;
+};
+
 #define KVM_ARM_TAGS_TO_GUEST		0
 #define KVM_ARM_TAGS_FROM_GUEST		1
 
@@ -363,6 +372,10 @@ enum {
 	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
 };
 
+/* Device Control API on vm fd */
+#define KVM_ARM_VM_SMCCC_CTRL		0
+#define   KVM_ARM_VM_SMCCC_FILTER	0
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
@@ -402,6 +415,8 @@ enum {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define   KVM_ARM_VCPU_TIMER_IRQ_HVTIMER	2
+#define   KVM_ARM_VCPU_TIMER_IRQ_HPTIMER	3
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
@@ -458,6 +473,24 @@ enum {
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
+enum kvm_smccc_filter_action {
+	KVM_SMCCC_FILTER_HANDLE = 0,
+	KVM_SMCCC_FILTER_DENY,
+	KVM_SMCCC_FILTER_FWD_TO_USER,
+
+};
+
+struct kvm_smccc_filter {
+	__u32 base;
+	__u32 nr_functions;
+	__u8 action;
+	__u8 pad[15];
+};
+
+/* arm64-specific KVM_EXIT_HYPERCALL flags */
+#define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
+#define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index 92af6f3f05..f92790c948 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -12,6 +12,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <asm/bitsperlong.h>
 #include <asm/ptrace.h>
 
 #define __KVM_HAVE_READONLY_MEM
@@ -52,6 +53,7 @@ struct kvm_riscv_config {
 	unsigned long mvendorid;
 	unsigned long marchid;
 	unsigned long mimpid;
+	unsigned long zicboz_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -64,7 +66,7 @@ struct kvm_riscv_core {
 #define KVM_RISCV_MODE_S	1
 #define KVM_RISCV_MODE_U	0
 
-/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_csr {
 	unsigned long sstatus;
 	unsigned long sie;
@@ -78,6 +80,17 @@ struct kvm_riscv_csr {
 	unsigned long scounteren;
 };
 
+/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_aia_csr {
+	unsigned long siselect;
+	unsigned long iprio1;
+	unsigned long iprio2;
+	unsigned long sieh;
+	unsigned long siph;
+	unsigned long iprio1h;
+	unsigned long iprio2h;
+};
+
 /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_timer {
 	__u64 frequency;
@@ -105,9 +118,29 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
+	KVM_RISCV_ISA_EXT_ZICBOZ,
+	KVM_RISCV_ISA_EXT_ZBB,
+	KVM_RISCV_ISA_EXT_SSAIA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
+/*
+ * SBI extension IDs specific to KVM. This is not the same as the SBI
+ * extension IDs defined by the RISC-V SBI specification.
+ */
+enum KVM_RISCV_SBI_EXT_ID {
+	KVM_RISCV_SBI_EXT_V01 = 0,
+	KVM_RISCV_SBI_EXT_TIME,
+	KVM_RISCV_SBI_EXT_IPI,
+	KVM_RISCV_SBI_EXT_RFENCE,
+	KVM_RISCV_SBI_EXT_SRST,
+	KVM_RISCV_SBI_EXT_HSM,
+	KVM_RISCV_SBI_EXT_PMU,
+	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
+	KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_RISCV_SBI_EXT_MAX,
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -118,6 +151,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
+#define KVM_REG_RISCV_SUBTYPE_MASK	0x0000000000FF0000
+#define KVM_REG_RISCV_SUBTYPE_SHIFT	16
 
 /* Config registers are mapped as type 1 */
 #define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -131,8 +166,12 @@ enum KVM_RISCV_ISA_EXT_ID {
 
 /* Control and status registers are mapped as type 3 */
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_CSR_AIA_REG(name)	\
+	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
 
 /* Timer registers are mapped as type 4 */
 #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -152,6 +191,18 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* ISA Extension registers are mapped as type 7 */
 #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
 
+/* SBI extension registers are mapped as type 8 */
+#define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_SINGLE	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_EN	(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_DIS	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_REG(__ext_id)	\
+		((__ext_id) / __BITS_PER_LONG)
+#define KVM_REG_RISCV_SBI_MULTI_MASK(__ext_id)	\
+		(1UL << ((__ext_id) % __BITS_PER_LONG))
+#define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
+		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/linux-headers/asm-riscv/unistd.h b/linux-headers/asm-riscv/unistd.h
index 73d7cdd2ec..950ab3fd44 100644
--- a/linux-headers/asm-riscv/unistd.h
+++ b/linux-headers/asm-riscv/unistd.h
@@ -43,3 +43,12 @@
 #define __NR_riscv_flush_icache (__NR_arch_specific_syscall + 15)
 #endif
 __SYSCALL(__NR_riscv_flush_icache, sys_riscv_flush_icache)
+
+/*
+ * Allows userspace to query the kernel for CPU architecture and
+ * microarchitecture details across a given set of CPUs.
+ */
+#ifndef __NR_riscv_hwprobe
+#define __NR_riscv_hwprobe (__NR_arch_specific_syscall + 14)
+#endif
+__SYSCALL(__NR_riscv_hwprobe, sys_riscv_hwprobe)
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index 8e644d65f5..800f3adb20 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -419,6 +419,7 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
 #define __NR_process_mrelease 448
 #define __NR_futex_waitv 449
 #define __NR_set_mempolicy_home_node 450
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 51da542fec..399a605901 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -367,6 +367,7 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
 #define __NR_process_mrelease 448
 #define __NR_futex_waitv 449
 #define __NR_set_mempolicy_home_node 450
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 2937e7bf69..2b3a8f7bd2 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -557,4 +557,7 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+/* x86-specific KVM_EXIT_HYPERCALL flags. */
+#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/const.h b/linux-headers/linux/const.h
index 5e48987251..1eb84b5087 100644
--- a/linux-headers/linux/const.h
+++ b/linux-headers/linux/const.h
@@ -28,7 +28,7 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
 #define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 599de3c6e3..65b145b317 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -341,8 +341,11 @@ struct kvm_run {
 			__u64 nr;
 			__u64 args[6];
 			__u64 ret;
-			__u32 longmode;
-			__u32 pad;
+
+			union {
+				__u32 longmode;
+				__u64 flags;
+			};
 		} hypercall;
 		/* KVM_EXIT_TPR_ACCESS */
 		struct {
@@ -1182,6 +1185,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_COUNTER_OFFSET 227
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1449,7 +1453,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
-#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)  /* deprecated */
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
@@ -1541,6 +1545,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
+/* Available with KVM_CAP_COUNTER_OFFSET */
+#define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
diff --git a/linux-headers/linux/psp-sev.h b/linux-headers/linux/psp-sev.h
index 51d8b3940e..12ccb70099 100644
--- a/linux-headers/linux/psp-sev.h
+++ b/linux-headers/linux/psp-sev.h
@@ -36,6 +36,13 @@ enum {
  * SEV Firmware status code
  */
 typedef enum {
+	/*
+	 * This error code is not in the SEV spec. Its purpose is to convey that
+	 * there was an error that prevented the SEV firmware from being called.
+	 * The SEV API error codes are 16 bits, so the -1 value will not overlap
+	 * with possible values from the specification.
+	 */
+	SEV_RET_NO_FW_CALL = -1,
 	SEV_RET_SUCCESS = 0,
 	SEV_RET_INVALID_PLATFORM_STATE,
 	SEV_RET_INVALID_GUEST_STATE,
diff --git a/linux-headers/linux/userfaultfd.h b/linux-headers/linux/userfaultfd.h
index ba5d0df52f..14e402263a 100644
--- a/linux-headers/linux/userfaultfd.h
+++ b/linux-headers/linux/userfaultfd.h
@@ -38,7 +38,8 @@
 			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
 			   UFFD_FEATURE_MINOR_SHMEM |		\
 			   UFFD_FEATURE_EXACT_ADDRESS |		\
-			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM)
+			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM |	\
+			   UFFD_FEATURE_WP_UNPOPULATED)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -203,6 +204,12 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_WP_HUGETLBFS_SHMEM indicates that userfaultfd
 	 * write-protection mode is supported on both shmem and hugetlbfs.
+	 *
+	 * UFFD_FEATURE_WP_UNPOPULATED indicates that userfaultfd
+	 * write-protection mode will always apply to unpopulated pages
+	 * (i.e. empty ptes).  This will be the default behavior for shmem
+	 * & hugetlbfs, so this flag only affects anonymous memory behavior
+	 * when userfault write-protection mode is registered.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -217,6 +224,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
 #define UFFD_FEATURE_EXACT_ADDRESS		(1<<11)
 #define UFFD_FEATURE_WP_HUGETLBFS_SHMEM		(1<<12)
+#define UFFD_FEATURE_WP_UNPOPULATED		(1<<13)
 	__u64 features;
 
 	__u64 ioctls;
@@ -297,6 +305,13 @@ struct uffdio_writeprotect {
 struct uffdio_continue {
 	struct uffdio_range range;
 #define UFFDIO_CONTINUE_MODE_DONTWAKE		((__u64)1<<0)
+	/*
+	 * UFFDIO_CONTINUE_MODE_WP will map the page write protected on
+	 * the fly.  UFFDIO_CONTINUE_MODE_WP is available only if the
+	 * write protected ioctl is implemented for the range
+	 * according to the uffdio_register.ioctls.
+	 */
+#define UFFDIO_CONTINUE_MODE_WP			((__u64)1<<1)
 	__u64 mode;
 
 	/*
-- 
2.39.1

