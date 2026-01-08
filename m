Return-Path: <kvm+bounces-67438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3941BD054BA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:01:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 877A2306CCD3
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7B52EC57F;
	Thu,  8 Jan 2026 17:59:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D501C2EC55D;
	Thu,  8 Jan 2026 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895142; cv=none; b=PLfaeA/TLdaUi9mRKI569ONmHqvAlcm9f1i5FTwBMhkCqREEqKGuiQRmc2jk2Oh179qTtZ/Fl7D9Oxt/pzuBkRgEYG6mYx3JLxSAQBc9E9hR7VL1pW0lj/2XhY0K2vq1adqprHTIYyhqYEZVqVVu+AkqqX92h7FFMFlDYYLIkUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895142; c=relaxed/simple;
	bh=g7Ulyl2A8Q+/ifOMpEC3aqgyynaSR7k8ilkWbwL0UUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcTP+eLivyfpC6SErpqE7RlM5QpX2zGlX5c5A3TREGdDTsHvfbAs8VZZfjZPNPf/wv+TcYffNz9LeK+Q0tS12QCM2pEVhYKS+NLwtLCGqaajViTTqJTQqvdhNbejfPOTGhcw/F+uriq+0DBbqVL9AbBqEz+30NFBGMFiiVdiOZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D58331515;
	Thu,  8 Jan 2026 09:58:48 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B8B873F5A1;
	Thu,  8 Jan 2026 09:58:52 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	maz@kernel.org,
	will@kernel.org,
	oupton@kernel.org,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	linux-kernel@vger.kernel.org,
	alexandru.elisei@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 03/15] update headers: Linux v6.18
Date: Thu,  8 Jan 2026 17:57:41 +0000
Message-ID: <20260108175753.1292097-4-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108175753.1292097-1-suzuki.poulose@arm.com>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update our headers fron linux-v6.18

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/asm/kvm.h    |  23 ++++++--
 include/linux/kvm.h        |  36 ++++++++++++
 include/linux/psci.h       |  52 +++++++++++++++++
 include/linux/virtio_ids.h |   1 +
 include/linux/virtio_net.h |  49 +++++++++++++++-
 include/linux/virtio_pci.h |   1 +
 powerpc/include/asm/kvm.h  |  13 -----
 riscv/include/asm/kvm.h    |  26 ++++++++-
 x86/include/asm/kvm.h      | 115 +++++++++++++++++++++++++++++++++++++
 9 files changed, 297 insertions(+), 19 deletions(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index 568bf858..ed5f3892 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -105,6 +105,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
+#define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -371,6 +372,7 @@ enum {
 #endif
 };
 
+/* Vendor hyper call function numbers 0-63 */
 #define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
 
 enum {
@@ -381,6 +383,17 @@ enum {
 #endif
 };
 
+/* Vendor hyper call function numbers 64-127 */
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_2		KVM_REG_ARM_FW_FEAT_BMAP_REG(3)
+
+enum {
+	KVM_REG_ARM_VENDOR_HYP_BIT_DISCOVER_IMPL_VER	= 0,
+	KVM_REG_ARM_VENDOR_HYP_BIT_DISCOVER_IMPL_CPUS	= 1,
+#ifdef __KERNEL__
+	KVM_REG_ARM_VENDOR_HYP_BMAP_2_BIT_COUNT,
+#endif
+};
+
 /* Device Control API on vm fd */
 #define KVM_ARM_VM_SMCCC_CTRL		0
 #define   KVM_ARM_VM_SMCCC_FILTER	0
@@ -403,6 +416,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
+#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
@@ -417,10 +431,11 @@ enum {
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
-#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
-#define   KVM_ARM_VCPU_PMU_V3_INIT	1
-#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
-#define   KVM_ARM_VCPU_PMU_V3_SET_PMU	3
+#define   KVM_ARM_VCPU_PMU_V3_IRQ		0
+#define   KVM_ARM_VCPU_PMU_V3_INIT		1
+#define   KVM_ARM_VCPU_PMU_V3_FILTER		2
+#define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
+#define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 45e6d8fc..52f6000a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX              40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -375,6 +376,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
 			__u32 ndata;
 			union {
@@ -446,6 +448,31 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX */
+		struct {
+			__u64 flags;
+			__u64 nr;
+			union {
+				struct {
+					__u64 ret;
+					__u64 data[5];
+				} unknown;
+				struct {
+					__u64 ret;
+					__u64 gpa;
+					__u64 size;
+				} get_quote;
+				struct {
+					__u64 ret;
+					__u64 leaf;
+					__u64 r11, r12, r13, r14;
+				} get_tdvmcall_info;
+				struct {
+					__u64 ret;
+					__u64 vector;
+				} setup_event_notify;
+			};
+		} tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -617,6 +644,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
@@ -929,6 +957,12 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_ARM_EL2 240
+#define KVM_CAP_ARM_EL2_E2H0 241
+#define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_GUEST_MEMFD_FLAGS 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1565,6 +1599,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/include/linux/psci.h b/include/linux/psci.h
index 310d83e0..81759ff3 100644
--- a/include/linux/psci.h
+++ b/include/linux/psci.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * ARM Power State and Coordination Interface (PSCI) header
  *
@@ -46,6 +47,30 @@
 #define PSCI_0_2_FN64_MIGRATE			PSCI_0_2_FN64(5)
 #define PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU	PSCI_0_2_FN64(7)
 
+#define PSCI_1_0_FN_PSCI_FEATURES		PSCI_0_2_FN(10)
+#define PSCI_1_0_FN_CPU_FREEZE			PSCI_0_2_FN(11)
+#define PSCI_1_0_FN_CPU_DEFAULT_SUSPEND		PSCI_0_2_FN(12)
+#define PSCI_1_0_FN_NODE_HW_STATE		PSCI_0_2_FN(13)
+#define PSCI_1_0_FN_SYSTEM_SUSPEND		PSCI_0_2_FN(14)
+#define PSCI_1_0_FN_SET_SUSPEND_MODE		PSCI_0_2_FN(15)
+#define PSCI_1_0_FN_STAT_RESIDENCY		PSCI_0_2_FN(16)
+#define PSCI_1_0_FN_STAT_COUNT			PSCI_0_2_FN(17)
+
+#define PSCI_1_1_FN_SYSTEM_RESET2		PSCI_0_2_FN(18)
+#define PSCI_1_1_FN_MEM_PROTECT			PSCI_0_2_FN(19)
+#define PSCI_1_1_FN_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN(20)
+#define PSCI_1_3_FN_SYSTEM_OFF2			PSCI_0_2_FN(21)
+
+#define PSCI_1_0_FN64_CPU_DEFAULT_SUSPEND	PSCI_0_2_FN64(12)
+#define PSCI_1_0_FN64_NODE_HW_STATE		PSCI_0_2_FN64(13)
+#define PSCI_1_0_FN64_SYSTEM_SUSPEND		PSCI_0_2_FN64(14)
+#define PSCI_1_0_FN64_STAT_RESIDENCY		PSCI_0_2_FN64(16)
+#define PSCI_1_0_FN64_STAT_COUNT		PSCI_0_2_FN64(17)
+
+#define PSCI_1_1_FN64_SYSTEM_RESET2		PSCI_0_2_FN64(18)
+#define PSCI_1_1_FN64_MEM_PROTECT_CHECK_RANGE	PSCI_0_2_FN64(20)
+#define PSCI_1_3_FN64_SYSTEM_OFF2		PSCI_0_2_FN64(21)
+
 /* PSCI v0.2 power state encoding for CPU_SUSPEND function */
 #define PSCI_0_2_POWER_STATE_ID_MASK		0xffff
 #define PSCI_0_2_POWER_STATE_ID_SHIFT		0
@@ -56,6 +81,13 @@
 #define PSCI_0_2_POWER_STATE_AFFL_MASK		\
 				(0x3 << PSCI_0_2_POWER_STATE_AFFL_SHIFT)
 
+/* PSCI extended power state encoding for CPU_SUSPEND function */
+#define PSCI_1_0_EXT_POWER_STATE_ID_MASK	0xfffffff
+#define PSCI_1_0_EXT_POWER_STATE_ID_SHIFT	0
+#define PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT	30
+#define PSCI_1_0_EXT_POWER_STATE_TYPE_MASK	\
+				(0x1 << PSCI_1_0_EXT_POWER_STATE_TYPE_SHIFT)
+
 /* PSCI v0.2 affinity level state returned by AFFINITY_INFO */
 #define PSCI_0_2_AFFINITY_LEVEL_ON		0
 #define PSCI_0_2_AFFINITY_LEVEL_OFF		1
@@ -66,6 +98,13 @@
 #define PSCI_0_2_TOS_UP_NO_MIGRATE		1
 #define PSCI_0_2_TOS_MP				2
 
+/* PSCI v1.1 reset type encoding for SYSTEM_RESET2 */
+#define PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET	0
+#define PSCI_1_1_RESET_TYPE_VENDOR_START	0x80000000U
+
+/* PSCI v1.3 hibernate type for SYSTEM_OFF2 */
+#define PSCI_1_3_OFF_TYPE_HIBERNATE_OFF		BIT(0)
+
 /* PSCI version decoding (independent of PSCI version) */
 #define PSCI_VERSION_MAJOR_SHIFT		16
 #define PSCI_VERSION_MINOR_MASK			\
@@ -75,6 +114,18 @@
 		(((ver) & PSCI_VERSION_MAJOR_MASK) >> PSCI_VERSION_MAJOR_SHIFT)
 #define PSCI_VERSION_MINOR(ver)			\
 		((ver) & PSCI_VERSION_MINOR_MASK)
+#define PSCI_VERSION(maj, min)						\
+	((((maj) << PSCI_VERSION_MAJOR_SHIFT) & PSCI_VERSION_MAJOR_MASK) | \
+	 ((min) & PSCI_VERSION_MINOR_MASK))
+
+/* PSCI features decoding (>=1.0) */
+#define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT	1
+#define PSCI_1_0_FEATURES_CPU_SUSPEND_PF_MASK	\
+			(0x1 << PSCI_1_0_FEATURES_CPU_SUSPEND_PF_SHIFT)
+
+#define PSCI_1_0_OS_INITIATED			BIT(0)
+#define PSCI_1_0_SUSPEND_MODE_PC		0
+#define PSCI_1_0_SUSPEND_MODE_OSI		1
 
 /* PSCI return values (inclusive of all PSCI versions) */
 #define PSCI_RET_SUCCESS			0
@@ -86,5 +137,6 @@
 #define PSCI_RET_INTERNAL_FAILURE		-6
 #define PSCI_RET_NOT_PRESENT			-7
 #define PSCI_RET_DISABLED			-8
+#define PSCI_RET_INVALID_ADDRESS		-9
 
 #endif /* _UAPI_LINUX_PSCI_H */
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 7aa2eb76..6c12db16 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -68,6 +68,7 @@
 #define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
 #define VIRTIO_ID_BT			40 /* virtio bluetooth */
 #define VIRTIO_ID_GPIO			41 /* virtio gpio */
+#define VIRTIO_ID_SPI			45 /* virtio spi */
 
 /*
  * Virtio Transitional IDs
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index ac917471..1db45b01 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -70,6 +70,28 @@
 					 * with the same MAC.
 					 */
 #define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO 65 /* Driver can receive
+					      * GSO-over-UDP-tunnel packets
+					      */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM 66 /* Driver handles
+						   * GSO-over-UDP-tunnel
+						   * packets with partial csum
+						   * for the outer header
+						   */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO 67 /* Device can receive
+					     * GSO-over-UDP-tunnel packets
+					     */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM 68 /* Device handles
+						  * GSO-over-UDP-tunnel
+						  * packets with partial csum
+						  * for the outer header
+						  */
+
+/* Offloads bits corresponding to VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO{,_CSUM}
+ * features
+ */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED	46
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED	47
 
 #ifndef VIRTIO_NET_NO_LEGACY
 #define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
@@ -131,12 +153,17 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
 #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
 #define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
+#define VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM 8	/* UDP tunnel csum offload */
 	__u8 flags;
 #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
 #define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 0x20 /* UDPv4 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6 0x40 /* UDPv6 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL (VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 | \
+				       VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6)
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
@@ -166,7 +193,8 @@ struct virtio_net_hdr_v1 {
 
 struct virtio_net_hdr_v1_hash {
 	struct virtio_net_hdr_v1 hdr;
-	__le32 hash_value;
+	__le16 hash_value_lo;
+	__le16 hash_value_hi;
 #define VIRTIO_NET_HASH_REPORT_NONE            0
 #define VIRTIO_NET_HASH_REPORT_IPv4            1
 #define VIRTIO_NET_HASH_REPORT_TCPv4           2
@@ -181,6 +209,12 @@ struct virtio_net_hdr_v1_hash {
 	__le16 padding;
 };
 
+struct virtio_net_hdr_v1_hash_tunnel {
+	struct virtio_net_hdr_v1_hash hash_hdr;
+	__le16 outer_th_offset;
+	__le16 inner_nh_offset;
+};
+
 #ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
  * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
@@ -327,6 +361,19 @@ struct virtio_net_rss_config {
 	__u8 hash_key_data[/* hash_key_length */];
 };
 
+struct virtio_net_rss_config_hdr {
+	__le32 hash_types;
+	__le16 indirection_table_mask;
+	__le16 unclassified_queue;
+	__le16 indirection_table[/* 1 + indirection_table_mask */];
+};
+
+struct virtio_net_rss_config_trailer {
+	__le16 max_tx_vq;
+	__u8 hash_key_length;
+	__u8 hash_key_data[/* hash_key_length */];
+};
+
  #define VIRTIO_NET_CTRL_MQ_RSS_CONFIG          1
 
 /*
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index 8549d457..c691ac21 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -246,6 +246,7 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_ADMIN_CMD_LIST_USE	0x1
 
 /* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SELF	0x0
 #define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
 
 /* Transitional device admin command. */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index eaeda001..077c5437 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
  * Copyright IBM Corp. 2007
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index f06bc5ef..759a4852 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -9,7 +9,7 @@
 #ifndef __LINUX_KVM_RISCV_H
 #define __LINUX_KVM_RISCV_H
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 #include <asm/bitsperlong.h>
@@ -18,6 +18,7 @@
 #define __KVM_HAVE_IRQ_LINE
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_INTERRUPT_SET	-1U
 #define KVM_INTERRUPT_UNSET	-2U
@@ -55,6 +56,7 @@ struct kvm_riscv_config {
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
 	unsigned long satp_mode;
+	unsigned long zicbop_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -182,6 +184,12 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVVPTC,
 	KVM_RISCV_ISA_EXT_ZABHA,
 	KVM_RISCV_ISA_EXT_ZICCRSE,
+	KVM_RISCV_ISA_EXT_ZAAMO,
+	KVM_RISCV_ISA_EXT_ZALRSC,
+	KVM_RISCV_ISA_EXT_ZICBOP,
+	KVM_RISCV_ISA_EXT_ZFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFWMA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -202,6 +210,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_SUSP,
+	KVM_RISCV_SBI_EXT_FWFT,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
@@ -211,6 +220,18 @@ struct kvm_riscv_sbi_sta {
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
@@ -294,6 +315,9 @@ struct kvm_riscv_sbi_sta {
 #define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_SBI_STA_REG(name)		\
 		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_SBI_FWFT		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_FWFT_REG(name)	\
+		(offsetof(struct kvm_riscv_sbi_fwft, name) / sizeof(unsigned long))
 
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 9e75da97..d420c9c0 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
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
@@ -411,6 +416,35 @@ struct kvm_xcrs {
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
@@ -441,6 +475,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
+#define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
@@ -559,6 +594,9 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
 
+#define KVM_XEN_MSR_MIN_INDEX			0x40000000u
+#define KVM_XEN_MSR_MAX_INDEX			0x4fffffffu
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
@@ -841,6 +879,7 @@ struct kvm_sev_snp_launch_start {
 };
 
 /* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_PAGE_TYPE_INVALID		0x0
 #define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
 #define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
 #define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
@@ -927,4 +966,80 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SNP_VM		4
 #define KVM_X86_TDX_VM		5
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+	KVM_TDX_GET_CPUID,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 */
+	__u64 hw_error;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 supported_attrs;
+	__u64 supported_xfam;
+
+	__u64 kernel_tdvmcallinfo_1_r11;
+	__u64 user_tdvmcallinfo_1_r11;
+	__u64 kernel_tdvmcallinfo_1_r12;
+	__u64 user_tdvmcallinfo_1_r12;
+
+	__u64 reserved[250];
+
+	/* Configurable CPUID bits for userspace */
+	struct kvm_cpuid2 cpuid;
+};
+
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 xfam;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha384 digest */
+
+	/* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
+	__u64 reserved[12];
+
+	/*
+	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+	 * KVM_SET_CPUID2.
+	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
+	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+	 * module doesn't virtualize.
+	 */
+	struct kvm_cpuid2 cpuid;
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION   _BITULL(0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.43.0


