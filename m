Return-Path: <kvm+bounces-18156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F1D8CF90F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3263B22331
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918E117C8D;
	Mon, 27 May 2024 06:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="FTWOe9ZW"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466B17BBE
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791288; cv=none; b=YZpI0hrDT6P+bNWQhyOUUOjaH3RClKdXIr/HrXSgd++FZQcAb/eP0UfsRqDnDdFHk1Pk64NlcqsVNQa1ELU4EyJK6H+qbdmhG4bVJsUkE4EAZV31PKoQpO4dAW9/PNWRUnp37PjnnSAB76xvwPh7EHSgsAO1jzp416GqcdBVsgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791288; c=relaxed/simple;
	bh=GXpJTrI/SnbZtYPTn5MjQyrieM+btFWCYfzeiZ/JpXY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OvPHeBq0eaefDz/f0FVirOWM0d88Je1eBd3qZKuDFvosuIyDrIcQKYzqmQKzZ4fywnIh461KabDEi8uH/dQC6BYD2u8vowL03nMWLsLkLcruKX77JbcQv+/EoH9u3sccGwiEBgJV5XAi4TwOTrTKX9zihwR3/EAILlH3IJy9Ohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=FTWOe9ZW; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1716791283; bh=GXpJTrI/SnbZtYPTn5MjQyrieM+btFWCYfzeiZ/JpXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FTWOe9ZWgUa4BNQbwvoOT2i3A0Zt8AIldcxkE5/gMbB5PGUMSqhtar/210vj8iRvY
	 b/OeOP1XS7pKP5DMLSdhl93e90tBahYCNi+A5qDQrCaSMa7L9zrLpBOrENIopmT69f
	 4OCWwGUv5HreFkAmfALnaEg+79odnuNfebhoi4C0=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Date: Mon, 27 May 2024 08:27:48 +0200
Subject: [PATCH v8 2/8] linux-headers: update to 6.10-rc1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240527-pvpanic-shutdown-v8-2-5a28ec02558b@t-8ch.de>
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
In-Reply-To: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, 
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1716791282; l=20868;
 i=thomas@t-8ch.de; s=20221212; h=from:subject:message-id;
 bh=GXpJTrI/SnbZtYPTn5MjQyrieM+btFWCYfzeiZ/JpXY=;
 b=0gRU4qzEeZELFHw4LUUh00p77Rigdvv83010JxJ0eYHrACu/2CLihlVT2h/FhIo1SmC1UUSM6
 y+zaQU1086OAEpje1oStgRA0XgGrUEJX0QMsW8kC3D/8WgwkXWJa7jx
X-Developer-Key: i=thomas@t-8ch.de; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
---
 include/standard-headers/linux/ethtool.h    |  55 +++++++++++
 include/standard-headers/linux/pci_regs.h   |   6 ++
 include/standard-headers/linux/pvpanic.h    |   7 +-
 include/standard-headers/linux/virtio_bt.h  |   1 -
 include/standard-headers/linux/virtio_mem.h |   2 +
 include/standard-headers/linux/virtio_net.h | 143 ++++++++++++++++++++++++++++
 linux-headers/asm-generic/unistd.h          |   5 +-
 linux-headers/asm-loongarch/kvm.h           |   4 +
 linux-headers/asm-mips/unistd_n32.h         |   1 +
 linux-headers/asm-mips/unistd_n64.h         |   1 +
 linux-headers/asm-mips/unistd_o32.h         |   1 +
 linux-headers/asm-powerpc/unistd_32.h       |   1 +
 linux-headers/asm-powerpc/unistd_64.h       |   1 +
 linux-headers/asm-riscv/kvm.h               |   1 +
 linux-headers/asm-s390/unistd_32.h          |   1 +
 linux-headers/asm-s390/unistd_64.h          |   1 +
 linux-headers/asm-x86/kvm.h                 |   4 +-
 linux-headers/asm-x86/unistd_32.h           |   1 +
 linux-headers/asm-x86/unistd_64.h           |   1 +
 linux-headers/asm-x86/unistd_x32.h          |   2 +
 linux-headers/linux/kvm.h                   |   4 +-
 linux-headers/linux/stddef.h                |   8 ++
 linux-headers/linux/vhost.h                 |  15 +--
 23 files changed, 252 insertions(+), 14 deletions(-)

diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 01503784d26f..b0b4b68410f1 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -752,6 +752,61 @@ enum ethtool_module_power_mode {
 	ETHTOOL_MODULE_POWER_MODE_HIGH,
 };
 
+/**
+ * enum ethtool_pse_types - Types of PSE controller.
+ * @ETHTOOL_PSE_UNKNOWN: Type of PSE controller is unknown
+ * @ETHTOOL_PSE_PODL: PSE controller which support PoDL
+ * @ETHTOOL_PSE_C33: PSE controller which support Clause 33 (PoE)
+ */
+enum ethtool_pse_types {
+	ETHTOOL_PSE_UNKNOWN =	1 << 0,
+	ETHTOOL_PSE_PODL =	1 << 1,
+	ETHTOOL_PSE_C33 =	1 << 2,
+};
+
+/**
+ * enum ethtool_c33_pse_admin_state - operational state of the PoDL PSE
+ *	functions. IEEE 802.3-2022 30.9.1.1.2 aPSEAdminState
+ * @ETHTOOL_C33_PSE_ADMIN_STATE_UNKNOWN: state of PSE functions is unknown
+ * @ETHTOOL_C33_PSE_ADMIN_STATE_DISABLED: PSE functions are disabled
+ * @ETHTOOL_C33_PSE_ADMIN_STATE_ENABLED: PSE functions are enabled
+ */
+enum ethtool_c33_pse_admin_state {
+	ETHTOOL_C33_PSE_ADMIN_STATE_UNKNOWN = 1,
+	ETHTOOL_C33_PSE_ADMIN_STATE_DISABLED,
+	ETHTOOL_C33_PSE_ADMIN_STATE_ENABLED,
+};
+
+/**
+ * enum ethtool_c33_pse_pw_d_status - power detection status of the PSE.
+ *	IEEE 802.3-2022 30.9.1.1.3 aPoDLPSEPowerDetectionStatus:
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_UNKNOWN: PSE status is unknown
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_DISABLED: The enumeration "disabled"
+ *	indicates that the PSE State diagram is in the state DISABLED.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_SEARCHING: The enumeration "searching"
+ *	indicates the PSE State diagram is in a state other than those
+ *	listed.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_DELIVERING: The enumeration
+ *	"deliveringPower" indicates that the PSE State diagram is in the
+ *	state POWER_ON.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_TEST: The enumeration "test" indicates that
+ *	the PSE State diagram is in the state TEST_MODE.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_FAULT: The enumeration "fault" indicates that
+ *	the PSE State diagram is in the state TEST_ERROR.
+ * @ETHTOOL_C33_PSE_PW_D_STATUS_OTHERFAULT: The enumeration "otherFault"
+ *	indicates that the PSE State diagram is in the state IDLE due to
+ *	the variable error_condition = true.
+ */
+enum ethtool_c33_pse_pw_d_status {
+	ETHTOOL_C33_PSE_PW_D_STATUS_UNKNOWN = 1,
+	ETHTOOL_C33_PSE_PW_D_STATUS_DISABLED,
+	ETHTOOL_C33_PSE_PW_D_STATUS_SEARCHING,
+	ETHTOOL_C33_PSE_PW_D_STATUS_DELIVERING,
+	ETHTOOL_C33_PSE_PW_D_STATUS_TEST,
+	ETHTOOL_C33_PSE_PW_D_STATUS_FAULT,
+	ETHTOOL_C33_PSE_PW_D_STATUS_OTHERFAULT,
+};
+
 /**
  * enum ethtool_podl_pse_admin_state - operational state of the PoDL PSE
  *	functions. IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index a39193213ff2..94c00996e633 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -1144,8 +1144,14 @@
 #define PCI_DOE_DATA_OBJECT_HEADER_2_LENGTH		0x0003ffff
 
 #define PCI_DOE_DATA_OBJECT_DISC_REQ_3_INDEX		0x000000ff
+#define PCI_DOE_DATA_OBJECT_DISC_REQ_3_VER		0x0000ff00
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_VID		0x0000ffff
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_PROTOCOL		0x00ff0000
 #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_NEXT_INDEX	0xff000000
 
+/* Compute Express Link (CXL r3.1, sec 8.1.5) */
+#define PCI_DVSEC_CXL_PORT				3
+#define PCI_DVSEC_CXL_PORT_CTL				0x0c
+#define PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR		0x00000001
+
 #endif /* LINUX_PCI_REGS_H */
diff --git a/include/standard-headers/linux/pvpanic.h b/include/standard-headers/linux/pvpanic.h
index 54b7485390d3..b1150944316f 100644
--- a/include/standard-headers/linux/pvpanic.h
+++ b/include/standard-headers/linux/pvpanic.h
@@ -3,7 +3,10 @@
 #ifndef __PVPANIC_H__
 #define __PVPANIC_H__
 
-#define PVPANIC_PANICKED	(1 << 0)
-#define PVPANIC_CRASH_LOADED	(1 << 1)
+#include "standard-headers/linux/const.h"
+
+#define PVPANIC_PANICKED	_BITUL(0)
+#define PVPANIC_CRASH_LOADED	_BITUL(1)
+#define PVPANIC_SHUTDOWN	_BITUL(2)
 
 #endif /* __PVPANIC_H__ */
diff --git a/include/standard-headers/linux/virtio_bt.h b/include/standard-headers/linux/virtio_bt.h
index a11ecc3f92df..6f0dee7e326a 100644
--- a/include/standard-headers/linux/virtio_bt.h
+++ b/include/standard-headers/linux/virtio_bt.h
@@ -13,7 +13,6 @@
 
 enum virtio_bt_config_type {
 	VIRTIO_BT_CONFIG_TYPE_PRIMARY	= 0,
-	VIRTIO_BT_CONFIG_TYPE_AMP	= 1,
 };
 
 enum virtio_bt_config_vendor {
diff --git a/include/standard-headers/linux/virtio_mem.h b/include/standard-headers/linux/virtio_mem.h
index 18c74c527c8a..6bfa41bd8b6e 100644
--- a/include/standard-headers/linux/virtio_mem.h
+++ b/include/standard-headers/linux/virtio_mem.h
@@ -90,6 +90,8 @@
 #define VIRTIO_MEM_F_ACPI_PXM		0
 /* unplugged memory must not be accessed */
 #define VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE	1
+/* plugged memory will remain plugged when suspending+resuming */
+#define VIRTIO_MEM_F_PERSISTENT_SUSPEND		2
 
 
 /* --- virtio-mem: guest -> host requests --- */
diff --git a/include/standard-headers/linux/virtio_net.h b/include/standard-headers/linux/virtio_net.h
index 0f8841774238..fc594fe5fcbe 100644
--- a/include/standard-headers/linux/virtio_net.h
+++ b/include/standard-headers/linux/virtio_net.h
@@ -56,6 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+#define VIRTIO_NET_F_DEVICE_STATS 50	/* Device can provide device-level statistics. */
 #define VIRTIO_NET_F_VQ_NOTF_COAL 52	/* Device supports virtqueue notification coalescing */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
 #define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
@@ -406,4 +407,146 @@ struct  virtio_net_ctrl_coal_vq {
 	struct virtio_net_ctrl_coal coal;
 };
 
+/*
+ * Device Statistics
+ */
+#define VIRTIO_NET_CTRL_STATS         8
+#define VIRTIO_NET_CTRL_STATS_QUERY   0
+#define VIRTIO_NET_CTRL_STATS_GET     1
+
+struct virtio_net_stats_capabilities {
+
+#define VIRTIO_NET_STATS_TYPE_CVQ       (1ULL << 32)
+
+#define VIRTIO_NET_STATS_TYPE_RX_BASIC  (1ULL << 0)
+#define VIRTIO_NET_STATS_TYPE_RX_CSUM   (1ULL << 1)
+#define VIRTIO_NET_STATS_TYPE_RX_GSO    (1ULL << 2)
+#define VIRTIO_NET_STATS_TYPE_RX_SPEED  (1ULL << 3)
+
+#define VIRTIO_NET_STATS_TYPE_TX_BASIC  (1ULL << 16)
+#define VIRTIO_NET_STATS_TYPE_TX_CSUM   (1ULL << 17)
+#define VIRTIO_NET_STATS_TYPE_TX_GSO    (1ULL << 18)
+#define VIRTIO_NET_STATS_TYPE_TX_SPEED  (1ULL << 19)
+
+	uint64_t supported_stats_types[1];
+};
+
+struct virtio_net_ctrl_queue_stats {
+	struct {
+		uint16_t vq_index;
+		uint16_t reserved[3];
+		uint64_t types_bitmap[1];
+	} stats[1];
+};
+
+struct virtio_net_stats_reply_hdr {
+#define VIRTIO_NET_STATS_TYPE_REPLY_CVQ       32
+
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_BASIC  0
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_CSUM   1
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_GSO    2
+#define VIRTIO_NET_STATS_TYPE_REPLY_RX_SPEED  3
+
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_BASIC  16
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_CSUM   17
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_GSO    18
+#define VIRTIO_NET_STATS_TYPE_REPLY_TX_SPEED  19
+	uint8_t type;
+	uint8_t reserved;
+	uint16_t vq_index;
+	uint16_t reserved1;
+	uint16_t size;
+};
+
+struct virtio_net_stats_cvq {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t command_num;
+	uint64_t ok_num;
+};
+
+struct virtio_net_stats_rx_basic {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t rx_notifications;
+
+	uint64_t rx_packets;
+	uint64_t rx_bytes;
+
+	uint64_t rx_interrupts;
+
+	uint64_t rx_drops;
+	uint64_t rx_drop_overruns;
+};
+
+struct virtio_net_stats_tx_basic {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t tx_notifications;
+
+	uint64_t tx_packets;
+	uint64_t tx_bytes;
+
+	uint64_t tx_interrupts;
+
+	uint64_t tx_drops;
+	uint64_t tx_drop_malformed;
+};
+
+struct virtio_net_stats_rx_csum {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t rx_csum_valid;
+	uint64_t rx_needs_csum;
+	uint64_t rx_csum_none;
+	uint64_t rx_csum_bad;
+};
+
+struct virtio_net_stats_tx_csum {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t tx_csum_none;
+	uint64_t tx_needs_csum;
+};
+
+struct virtio_net_stats_rx_gso {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t rx_gso_packets;
+	uint64_t rx_gso_bytes;
+	uint64_t rx_gso_packets_coalesced;
+	uint64_t rx_gso_bytes_coalesced;
+};
+
+struct virtio_net_stats_tx_gso {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	uint64_t tx_gso_packets;
+	uint64_t tx_gso_bytes;
+	uint64_t tx_gso_segments;
+	uint64_t tx_gso_segments_bytes;
+	uint64_t tx_gso_packets_noseg;
+	uint64_t tx_gso_bytes_noseg;
+};
+
+struct virtio_net_stats_rx_speed {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	/* rx_{packets,bytes}_allowance_exceeded are too long. So rename to
+	 * short name.
+	 */
+	uint64_t rx_ratelimit_packets;
+	uint64_t rx_ratelimit_bytes;
+};
+
+struct virtio_net_stats_tx_speed {
+	struct virtio_net_stats_reply_hdr hdr;
+
+	/* tx_{packets,bytes}_allowance_exceeded are too long. So rename to
+	 * short name.
+	 */
+	uint64_t tx_ratelimit_packets;
+	uint64_t tx_ratelimit_bytes;
+};
+
 #endif /* _LINUX_VIRTIO_NET_H */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 75f00965ab15..d983c48a3b6a 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -842,8 +842,11 @@ __SYSCALL(__NR_lsm_set_self_attr, sys_lsm_set_self_attr)
 #define __NR_lsm_list_modules 461
 __SYSCALL(__NR_lsm_list_modules, sys_lsm_list_modules)
 
+#define __NR_mseal 462
+__SYSCALL(__NR_mseal, sys_mseal)
+
 #undef __NR_syscalls
-#define __NR_syscalls 462
+#define __NR_syscalls 463
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index 109785922cf9..f9abef382317 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -17,6 +17,8 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
+
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  */
@@ -72,6 +74,8 @@ struct kvm_fpu {
 
 #define KVM_REG_LOONGARCH_COUNTER	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 1)
 #define KVM_REG_LOONGARCH_VCPU_RESET	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 2)
+/* Debugging: Special instruction for software breakpoint */
+#define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index ce2e050a9ba4..fc93b3be3091 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -390,5 +390,6 @@
 #define __NR_lsm_get_self_attr (__NR_Linux + 459)
 #define __NR_lsm_set_self_attr (__NR_Linux + 460)
 #define __NR_lsm_list_modules (__NR_Linux + 461)
+#define __NR_mseal (__NR_Linux + 462)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 5bfb3733ffdf..e72a3eb2c937 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -366,5 +366,6 @@
 #define __NR_lsm_get_self_attr (__NR_Linux + 459)
 #define __NR_lsm_set_self_attr (__NR_Linux + 460)
 #define __NR_lsm_list_modules (__NR_Linux + 461)
+#define __NR_mseal (__NR_Linux + 462)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 02eaecd020ec..b86eb0786c76 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -436,5 +436,6 @@
 #define __NR_lsm_get_self_attr (__NR_Linux + 459)
 #define __NR_lsm_set_self_attr (__NR_Linux + 460)
 #define __NR_lsm_list_modules (__NR_Linux + 461)
+#define __NR_mseal (__NR_Linux + 462)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index bbab08d6ec26..28627b6546f2 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -443,6 +443,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index af34cde70f20..1fc42a830046 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -415,6 +415,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index b1c503c2959c..e878e7cc3978 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -167,6 +167,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
+	KVM_RISCV_ISA_EXT_SSCOFPMF,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index a3ece69d8241..7706c21b87e2 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -434,5 +434,6 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 8c5fd93495ce..62082d592d35 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -382,5 +382,6 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 31c95c2dfe4c..b4e2e8d220e2 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -709,7 +709,9 @@ struct kvm_sev_cmd {
 struct kvm_sev_init {
 	__u64 vmsa_features;
 	__u32 flags;
-	__u32 pad[9];
+	__u16 ghcb_version;
+	__u16 pad1;
+	__u32 pad2[8];
 };
 
 struct kvm_sev_launch_start {
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 5c9c329e9390..fb7b8b169bfa 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -452,6 +452,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index d9aab7ae87d8..da439afee1cf 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -374,6 +374,7 @@
 #define __NR_lsm_get_self_attr 459
 #define __NR_lsm_set_self_attr 460
 #define __NR_lsm_list_modules 461
+#define __NR_mseal 462
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 63cdd1ee43df..4fcb607c724b 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -318,6 +318,7 @@
 #define __NR_set_mempolicy_home_node (__X32_SYSCALL_BIT + 450)
 #define __NR_cachestat (__X32_SYSCALL_BIT + 451)
 #define __NR_fchmodat2 (__X32_SYSCALL_BIT + 452)
+#define __NR_map_shadow_stack (__X32_SYSCALL_BIT + 453)
 #define __NR_futex_wake (__X32_SYSCALL_BIT + 454)
 #define __NR_futex_wait (__X32_SYSCALL_BIT + 455)
 #define __NR_futex_requeue (__X32_SYSCALL_BIT + 456)
@@ -326,6 +327,7 @@
 #define __NR_lsm_get_self_attr (__X32_SYSCALL_BIT + 459)
 #define __NR_lsm_set_self_attr (__X32_SYSCALL_BIT + 460)
 #define __NR_lsm_list_modules (__X32_SYSCALL_BIT + 461)
+#define __NR_mseal (__X32_SYSCALL_BIT + 462)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 038731cdef26..c93876ca0ba9 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1217,9 +1217,9 @@ struct kvm_vfio_spapr_tce {
 /* Available with KVM_CAP_SPAPR_RESIZE_HPT */
 #define KVM_PPC_RESIZE_HPT_PREPARE _IOR(KVMIO, 0xad, struct kvm_ppc_resize_hpt)
 #define KVM_PPC_RESIZE_HPT_COMMIT  _IOR(KVMIO, 0xae, struct kvm_ppc_resize_hpt)
-/* Available with KVM_CAP_PPC_RADIX_MMU or KVM_CAP_PPC_HASH_MMU_V3 */
+/* Available with KVM_CAP_PPC_MMU_RADIX or KVM_CAP_PPC_MMU_HASH_V3 */
 #define KVM_PPC_CONFIGURE_V3_MMU  _IOW(KVMIO,  0xaf, struct kvm_ppc_mmuv3_cfg)
-/* Available with KVM_CAP_PPC_RADIX_MMU */
+/* Available with KVM_CAP_PPC_MMU_RADIX */
 #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
 /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
diff --git a/linux-headers/linux/stddef.h b/linux-headers/linux/stddef.h
index bf9749dd1422..96aa341942b0 100644
--- a/linux-headers/linux/stddef.h
+++ b/linux-headers/linux/stddef.h
@@ -55,4 +55,12 @@
 #define __counted_by(m)
 #endif
 
+#ifndef __counted_by_le
+#define __counted_by_le(m)
+#endif
+
+#ifndef __counted_by_be
+#define __counted_by_be(m)
+#endif
+
 #endif /* _LINUX_STDDEF_H */
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index bea697390613..b95dd84eef2d 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -179,12 +179,6 @@
 /* Get the config size */
 #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
 
-/* Get the count of all virtqueues */
-#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
-
-/* Get the number of virtqueue groups. */
-#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
-
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 
@@ -228,10 +222,17 @@
 #define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
 					      struct vhost_vring_state)
 
+
+/* Get the count of all virtqueues */
+#define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
+
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
+
 /* Get the queue size of a specific virtqueue.
  * userspace set the vring index in vhost_vring_state.index
  * kernel set the queue size in vhost_vring_state.num
  */
-#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x80,	\
+#define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
 #endif

-- 
2.45.1


