Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C04BD91FF
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 15:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405318AbfJPNHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 09:07:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41022 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405314AbfJPNHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 09:07:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id t10so11251813plr.8
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 06:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wZh677+pLYfT7Nth5oMeUYsjvXgYmTkpkEHZHSrS44o=;
        b=BWbwZrVBsSsukjhMAItwCHkL1v1Qz8t+u2h56Q23Uo+22G3BAg02AjTaLmW1UzLfz6
         YlW+a7vzXUzOUYgaDznRdn4ECZK/ru3erAteHzKI+roFLAnl9e1TsjgXCtLUUMDLI7FZ
         BhBAaGz09JQM4OCO2MlelMRn9rbshD2gg60A7xx+W45QWvTUKr2kOTA0VclziafaJLv6
         EeyFfyuOyXqeJOh1Nnr7jR+ulGlvxTfFepPexUT0AUBP4ElzwSggivmiYIUZa5dU44QG
         7z6bHkvZ9Hf8Le+pxl0LuGnnq6k6nmB2zngAs7H4/Xg7pNB6f9fAFUqbc2wpdd+7sSKF
         x6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wZh677+pLYfT7Nth5oMeUYsjvXgYmTkpkEHZHSrS44o=;
        b=l953mNMJ6ysRjruX85uwSSA+yH++6Lr3F+ODii8MBnzSymvn69gNjRC44JmlHUJ/0w
         mc//ENzarZzn50ZMF62V/sxmh8vO2p+opZ6eiErtq5inbUKyrdJZ5I5i8rAQhB4BbcUG
         dkA+N7vcIAC5TS7NmM6pjBSud8Pc5c+F5oDl3sMNCq7uTRQRn6alkmsUm6Lt6R3L2rlZ
         7FsRETMhGZ9QzJ8kCP8jq9d9qNBo+PgkDouh0lb7ggXV6NRSjpeJpZgHF6fUpqgqkWBk
         NDH8lx3apWhSr1u5JsM5nGkoYGTb8Ovzdoi5gCwJQEIGwMPQH9Isn04xnRzhQcWD8jNe
         zw6A==
X-Gm-Message-State: APjAAAWMiTqO5dv6btfydkkWAGJj/bJQfyscYUPvc+zJh/g0JOGI4mLJ
        AxtW6DLaIAt/D7kp+uhbqO4=
X-Google-Smtp-Source: APXvYqzoAJDe6Zk0KdLrhXUfsQHY0RnhOOCn8IgZLMDBrX0JwcLElHcLNUg6nhhvJ1qXlT2OEaH40g==
X-Received: by 2002:a17:902:7b87:: with SMTP id w7mr40967934pll.110.1571231257686;
        Wed, 16 Oct 2019 06:07:37 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.39])
        by smtp.googlemail.com with ESMTPSA id s97sm2792296pjc.4.2019.10.16.06.07.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Oct 2019 06:07:37 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     mst@redhat.com, cohuck@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        rkagan@virtuozzo.com, vkuznets@redhat.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH V3 1/2] linux headers: update against Linux 5.4-rc2
Date:   Wed, 16 Oct 2019 21:07:24 +0800
Message-Id: <20191016130725.5045-2-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
References: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/standard-headers/asm-x86/bootparam.h |  2 +
 include/standard-headers/asm-x86/kvm_para.h  |  1 +
 include/standard-headers/linux/ethtool.h     | 24 ++++++++++
 include/standard-headers/linux/pci_regs.h    | 19 +++++++-
 include/standard-headers/linux/virtio_ids.h  |  2 +
 include/standard-headers/linux/virtio_pmem.h |  6 +--
 linux-headers/asm-arm/kvm.h                  | 16 ++++++-
 linux-headers/asm-arm/unistd-common.h        |  2 +
 linux-headers/asm-arm64/kvm.h                | 21 +++++++-
 linux-headers/asm-generic/mman-common.h      | 18 ++++---
 linux-headers/asm-generic/mman.h             | 10 ++--
 linux-headers/asm-generic/unistd.h           | 10 +++-
 linux-headers/asm-mips/mman.h                |  3 ++
 linux-headers/asm-mips/unistd_n32.h          |  2 +
 linux-headers/asm-mips/unistd_n64.h          |  2 +
 linux-headers/asm-mips/unistd_o32.h          |  2 +
 linux-headers/asm-powerpc/mman.h             |  6 +--
 linux-headers/asm-powerpc/unistd_32.h        |  2 +
 linux-headers/asm-powerpc/unistd_64.h        |  2 +
 linux-headers/asm-s390/kvm.h                 |  6 +++
 linux-headers/asm-s390/unistd_32.h           |  2 +
 linux-headers/asm-s390/unistd_64.h           |  2 +
 linux-headers/asm-x86/kvm.h                  | 28 ++++++++---
 linux-headers/asm-x86/unistd.h               |  2 +-
 linux-headers/asm-x86/unistd_32.h            |  2 +
 linux-headers/asm-x86/unistd_64.h            |  2 +
 linux-headers/asm-x86/unistd_x32.h           |  2 +
 linux-headers/linux/kvm.h                    | 12 ++++-
 linux-headers/linux/psp-sev.h                |  5 +-
 linux-headers/linux/vfio.h                   | 71 ++++++++++++++++++++--------
 30 files changed, 225 insertions(+), 59 deletions(-)

diff --git a/include/standard-headers/asm-x86/bootparam.h b/include/standard-headers/asm-x86/bootparam.h
index 67d4f0119f..a6f7cf535e 100644
--- a/include/standard-headers/asm-x86/bootparam.h
+++ b/include/standard-headers/asm-x86/bootparam.h
@@ -29,6 +29,8 @@
 #define XLF_EFI_HANDOVER_32		(1<<2)
 #define XLF_EFI_HANDOVER_64		(1<<3)
 #define XLF_EFI_KEXEC			(1<<4)
+#define XLF_5LEVEL			(1<<5)
+#define XLF_5LEVEL_ENABLED		(1<<6)
 
 
 #endif /* _ASM_X86_BOOTPARAM_H */
diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index e1715143fd..90604a8fb7 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
+#define KVM_FEATURE_PV_SCHED_YIELD	13
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 9b9919a8f6..4ff422b635 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -259,10 +259,32 @@ struct ethtool_tunable {
 #define ETHTOOL_PHY_FAST_LINK_DOWN_ON	0
 #define ETHTOOL_PHY_FAST_LINK_DOWN_OFF	0xff
 
+/* Energy Detect Power Down (EDPD) is a feature supported by some PHYs, where
+ * the PHY's RX & TX blocks are put into a low-power mode when there is no
+ * link detected (typically cable is un-plugged). For RX, only a minimal
+ * link-detection is available, and for TX the PHY wakes up to send link pulses
+ * to avoid any lock-ups in case the peer PHY may also be running in EDPD mode.
+ *
+ * Some PHYs may support configuration of the wake-up interval for TX pulses,
+ * and some PHYs may support only disabling TX pulses entirely. For the latter
+ * a special value is required (ETHTOOL_PHY_EDPD_NO_TX) so that this can be
+ * configured from userspace (should the user want it).
+ *
+ * The interval units for TX wake-up are in milliseconds, since this should
+ * cover a reasonable range of intervals:
+ *  - from 1 millisecond, which does not sound like much of a power-saver
+ *  - to ~65 seconds which is quite a lot to wait for a link to come up when
+ *    plugging a cable
+ */
+#define ETHTOOL_PHY_EDPD_DFLT_TX_MSECS		0xffff
+#define ETHTOOL_PHY_EDPD_NO_TX			0xfffe
+#define ETHTOOL_PHY_EDPD_DISABLE		0
+
 enum phy_tunable_id {
 	ETHTOOL_PHY_ID_UNSPEC,
 	ETHTOOL_PHY_DOWNSHIFT,
 	ETHTOOL_PHY_FAST_LINK_DOWN,
+	ETHTOOL_PHY_EDPD,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
 	 * phy_tunable_strings[] in net/core/ethtool.c
@@ -1483,6 +1505,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT = 64,
 	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT	 = 65,
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
+	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
+	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index 27164769d1..29d6e93fd1 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -528,6 +528,7 @@
 #define  PCI_EXP_LNKCAP_SLS_5_0GB 0x00000002 /* LNKCAP2 SLS Vector bit 1 */
 #define  PCI_EXP_LNKCAP_SLS_8_0GB 0x00000003 /* LNKCAP2 SLS Vector bit 2 */
 #define  PCI_EXP_LNKCAP_SLS_16_0GB 0x00000004 /* LNKCAP2 SLS Vector bit 3 */
+#define  PCI_EXP_LNKCAP_SLS_32_0GB 0x00000005 /* LNKCAP2 SLS Vector bit 4 */
 #define  PCI_EXP_LNKCAP_MLW	0x000003f0 /* Maximum Link Width */
 #define  PCI_EXP_LNKCAP_ASPMS	0x00000c00 /* ASPM Support */
 #define  PCI_EXP_LNKCAP_L0SEL	0x00007000 /* L0s Exit Latency */
@@ -556,6 +557,7 @@
 #define  PCI_EXP_LNKSTA_CLS_5_0GB 0x0002 /* Current Link Speed 5.0GT/s */
 #define  PCI_EXP_LNKSTA_CLS_8_0GB 0x0003 /* Current Link Speed 8.0GT/s */
 #define  PCI_EXP_LNKSTA_CLS_16_0GB 0x0004 /* Current Link Speed 16.0GT/s */
+#define  PCI_EXP_LNKSTA_CLS_32_0GB 0x0005 /* Current Link Speed 32.0GT/s */
 #define  PCI_EXP_LNKSTA_NLW	0x03f0	/* Negotiated Link Width */
 #define  PCI_EXP_LNKSTA_NLW_X1	0x0010	/* Current Link Width x1 */
 #define  PCI_EXP_LNKSTA_NLW_X2	0x0020	/* Current Link Width x2 */
@@ -589,6 +591,7 @@
 #define  PCI_EXP_SLTCTL_CCIE	0x0010	/* Command Completed Interrupt Enable */
 #define  PCI_EXP_SLTCTL_HPIE	0x0020	/* Hot-Plug Interrupt Enable */
 #define  PCI_EXP_SLTCTL_AIC	0x00c0	/* Attention Indicator Control */
+#define  PCI_EXP_SLTCTL_ATTN_IND_SHIFT 6      /* Attention Indicator shift */
 #define  PCI_EXP_SLTCTL_ATTN_IND_ON    0x0040 /* Attention Indicator on */
 #define  PCI_EXP_SLTCTL_ATTN_IND_BLINK 0x0080 /* Attention Indicator blinking */
 #define  PCI_EXP_SLTCTL_ATTN_IND_OFF   0x00c0 /* Attention Indicator off */
@@ -661,6 +664,7 @@
 #define  PCI_EXP_LNKCAP2_SLS_5_0GB	0x00000004 /* Supported Speed 5GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_8_0GB	0x00000008 /* Supported Speed 8GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_16_0GB	0x00000010 /* Supported Speed 16GT/s */
+#define  PCI_EXP_LNKCAP2_SLS_32_0GB	0x00000020 /* Supported Speed 32GT/s */
 #define  PCI_EXP_LNKCAP2_CROSSLINK	0x00000100 /* Crosslink supported */
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
 #define  PCI_EXP_LNKCTL2_TLS		0x000f
@@ -668,6 +672,7 @@
 #define  PCI_EXP_LNKCTL2_TLS_5_0GT	0x0002 /* Supported Speed 5GT/s */
 #define  PCI_EXP_LNKCTL2_TLS_8_0GT	0x0003 /* Supported Speed 8GT/s */
 #define  PCI_EXP_LNKCTL2_TLS_16_0GT	0x0004 /* Supported Speed 16GT/s */
+#define  PCI_EXP_LNKCTL2_TLS_32_0GT	0x0005 /* Supported Speed 32GT/s */
 #define PCI_EXP_LNKSTA2		50	/* Link Status 2 */
 #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	52	/* v2 endpoints with link end here */
 #define PCI_EXP_SLTCAP2		52	/* Slot Capabilities 2 */
@@ -709,7 +714,9 @@
 #define PCI_EXT_CAP_ID_DPC	0x1D	/* Downstream Port Containment */
 #define PCI_EXT_CAP_ID_L1SS	0x1E	/* L1 PM Substates */
 #define PCI_EXT_CAP_ID_PTM	0x1F	/* Precision Time Measurement */
-#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_PTM
+#define PCI_EXT_CAP_ID_DLF	0x25	/* Data Link Feature */
+#define PCI_EXT_CAP_ID_PL_16GT	0x26	/* Physical Layer 16.0 GT/s */
+#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_PL_16GT
 
 #define PCI_EXT_CAP_DSN_SIZEOF	12
 #define PCI_EXT_CAP_MCAST_ENDPOINT_SIZEOF 40
@@ -1049,4 +1056,14 @@
 #define  PCI_L1SS_CTL1_LTR_L12_TH_SCALE	0xe0000000  /* LTR_L1.2_THRESHOLD_Scale */
 #define PCI_L1SS_CTL2		0x0c	/* Control 2 Register */
 
+/* Data Link Feature */
+#define PCI_DLF_CAP		0x04	/* Capabilities Register */
+#define  PCI_DLF_EXCHANGE_ENABLE	0x80000000  /* Data Link Feature Exchange Enable */
+
+/* Physical Layer 16.0 GT/s */
+#define PCI_PL_16GT_LE_CTRL	0x20	/* Lane Equalization Control Register */
+#define  PCI_PL_16GT_LE_CTRL_DSP_TX_PRESET_MASK		0x0000000F
+#define  PCI_PL_16GT_LE_CTRL_USP_TX_PRESET_MASK		0x000000F0
+#define  PCI_PL_16GT_LE_CTRL_USP_TX_PRESET_SHIFT	4
+
 #endif /* LINUX_PCI_REGS_H */
diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
index 32b2f94d1f..585e07b273 100644
--- a/include/standard-headers/linux/virtio_ids.h
+++ b/include/standard-headers/linux/virtio_ids.h
@@ -43,6 +43,8 @@
 #define VIRTIO_ID_INPUT        18 /* virtio input */
 #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
 #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
+#define VIRTIO_ID_IOMMU        23 /* virtio IOMMU */
+#define VIRTIO_ID_FS           26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM         27 /* virtio pmem */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/standard-headers/linux/virtio_pmem.h b/include/standard-headers/linux/virtio_pmem.h
index 7e3d43b121..fc029de798 100644
--- a/include/standard-headers/linux/virtio_pmem.h
+++ b/include/standard-headers/linux/virtio_pmem.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause */
 /*
  * Definitions for virtio-pmem devices.
  *
@@ -7,8 +7,8 @@
  * Author(s): Pankaj Gupta <pagupta@redhat.com>
  */
 
-#ifndef _UAPI_LINUX_VIRTIO_PMEM_H
-#define _UAPI_LINUX_VIRTIO_PMEM_H
+#ifndef _LINUX_VIRTIO_PMEM_H
+#define _LINUX_VIRTIO_PMEM_H
 
 #include "standard-headers/linux/types.h"
 #include "standard-headers/linux/virtio_ids.h"
diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
index e1f8b74558..9d379d3372 100644
--- a/linux-headers/asm-arm/kvm.h
+++ b/linux-headers/asm-arm/kvm.h
@@ -214,6 +214,18 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
+	/* Higher values mean better protection. */
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
+	/* Higher values mean better protection. */
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL		2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	(1U << 4)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
@@ -254,8 +266,10 @@ struct kvm_vcpu_events {
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/linux-headers/asm-arm/unistd-common.h b/linux-headers/asm-arm/unistd-common.h
index 27a9b6da27..eb5d361b11 100644
--- a/linux-headers/asm-arm/unistd-common.h
+++ b/linux-headers/asm-arm/unistd-common.h
@@ -388,5 +388,7 @@
 #define __NR_fsconfig (__NR_SYSCALL_BASE + 431)
 #define __NR_fsmount (__NR_SYSCALL_BASE + 432)
 #define __NR_fspick (__NR_SYSCALL_BASE + 433)
+#define __NR_pidfd_open (__NR_SYSCALL_BASE + 434)
+#define __NR_clone3 (__NR_SYSCALL_BASE + 435)
 
 #endif /* _ASM_ARM_UNISTD_COMMON_H */
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 2431ec35a9..0ce6e49f3a 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -229,6 +229,16 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 					 KVM_REG_ARM_FW | ((r) & 0xffff))
 #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL		2
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
@@ -260,6 +270,13 @@ struct kvm_vcpu_events {
 	 KVM_REG_SIZE_U256 |						\
 	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
 
+/*
+ * Register values for KVM_REG_ARM64_SVE_ZREG(), KVM_REG_ARM64_SVE_PREG() and
+ * KVM_REG_ARM64_SVE_FFR() are represented in memory in an endianness-
+ * invariant layout which differs from the layout used for the FPSIMD
+ * V-registers on big-endian systems: see sigcontext.h for more explanation.
+ */
+
 #define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
 #define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
 
@@ -308,8 +325,10 @@ struct kvm_vcpu_events {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/linux-headers/asm-generic/mman-common.h b/linux-headers/asm-generic/mman-common.h
index abd238d0f7..c160a5354e 100644
--- a/linux-headers/asm-generic/mman-common.h
+++ b/linux-headers/asm-generic/mman-common.h
@@ -19,15 +19,18 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
-#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
-# define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be uninitialized */
-#else
-# define MAP_UNINITIALIZED 0x0		/* Don't support this flag */
-#endif
 
-/* 0x0100 - 0x80000 flags are defined in asm-generic/mman.h */
+/* 0x0100 - 0x4000 flags are defined in asm-generic/mman.h */
+#define MAP_POPULATE		0x008000	/* populate (prefault) pagetables */
+#define MAP_NONBLOCK		0x010000	/* do not block on IO */
+#define MAP_STACK		0x020000	/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB		0x040000	/* create a huge page mapping */
+#define MAP_SYNC		0x080000 /* perform synchronous page faults for the mapping */
 #define MAP_FIXED_NOREPLACE	0x100000	/* MAP_FIXED which doesn't unmap underlying mapping */
 
+#define MAP_UNINITIALIZED 0x4000000	/* For anonymous mmap, memory could be
+					 * uninitialized */
+
 /*
  * Flags for mlock
  */
@@ -64,6 +67,9 @@
 #define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
 #define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
 
+#define MADV_COLD	20		/* deactivate these pages */
+#define MADV_PAGEOUT	21		/* reclaim these pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/linux-headers/asm-generic/mman.h b/linux-headers/asm-generic/mman.h
index 653687d977..57e8195d0b 100644
--- a/linux-headers/asm-generic/mman.h
+++ b/linux-headers/asm-generic/mman.h
@@ -9,13 +9,11 @@
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_LOCKED	0x2000		/* pages are locked */
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
-#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
-#define MAP_SYNC	0x80000		/* perform synchronous page faults for the mapping */
 
-/* Bits [26:31] are reserved, see mman-common.h for MAP_HUGETLB usage */
+/*
+ * Bits [26:31] are reserved, see asm-generic/hugetlb_encode.h
+ * for MAP_HUGETLB usage
+ */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index a87904daf1..1fc8faa6e9 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -569,7 +569,7 @@ __SYSCALL(__NR_semget, sys_semget)
 __SC_COMP(__NR_semctl, sys_semctl, compat_sys_semctl)
 #if defined(__ARCH_WANT_TIME32_SYSCALLS) || __BITS_PER_LONG != 32
 #define __NR_semtimedop 192
-__SC_COMP(__NR_semtimedop, sys_semtimedop, sys_semtimedop_time32)
+__SC_3264(__NR_semtimedop, sys_semtimedop_time32, sys_semtimedop)
 #endif
 #define __NR_semop 193
 __SYSCALL(__NR_semop, sys_semop)
@@ -844,9 +844,15 @@ __SYSCALL(__NR_fsconfig, sys_fsconfig)
 __SYSCALL(__NR_fsmount, sys_fsmount)
 #define __NR_fspick 433
 __SYSCALL(__NR_fspick, sys_fspick)
+#define __NR_pidfd_open 434
+__SYSCALL(__NR_pidfd_open, sys_pidfd_open)
+#ifdef __ARCH_WANT_SYS_CLONE3
+#define __NR_clone3 435
+__SYSCALL(__NR_clone3, sys_clone3)
+#endif
 
 #undef __NR_syscalls
-#define __NR_syscalls 434
+#define __NR_syscalls 436
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/mman.h b/linux-headers/asm-mips/mman.h
index c2b40969eb..57dc2ac4f8 100644
--- a/linux-headers/asm-mips/mman.h
+++ b/linux-headers/asm-mips/mman.h
@@ -95,6 +95,9 @@
 #define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
 #define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
 
+#define MADV_COLD	20		/* deactivate these pages */
+#define MADV_PAGEOUT	21		/* reclaim these pages */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index fb988de900..659d5c9ade 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -363,6 +363,8 @@
 #define __NR_fsconfig	(__NR_Linux + 431)
 #define __NR_fsmount	(__NR_Linux + 432)
 #define __NR_fspick	(__NR_Linux + 433)
+#define __NR_pidfd_open	(__NR_Linux + 434)
+#define __NR_clone3	(__NR_Linux + 435)
 
 
 #endif /* _ASM_MIPS_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 17359163c9..4b6310a05c 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -339,6 +339,8 @@
 #define __NR_fsconfig	(__NR_Linux + 431)
 #define __NR_fsmount	(__NR_Linux + 432)
 #define __NR_fspick	(__NR_Linux + 433)
+#define __NR_pidfd_open	(__NR_Linux + 434)
+#define __NR_clone3	(__NR_Linux + 435)
 
 
 #endif /* _ASM_MIPS_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 83c8d8fb83..4ce7b4e288 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -409,6 +409,8 @@
 #define __NR_fsconfig	(__NR_Linux + 431)
 #define __NR_fsmount	(__NR_Linux + 432)
 #define __NR_fspick	(__NR_Linux + 433)
+#define __NR_pidfd_open	(__NR_Linux + 434)
+#define __NR_clone3	(__NR_Linux + 435)
 
 
 #endif /* _ASM_MIPS_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/mman.h b/linux-headers/asm-powerpc/mman.h
index 1c2b3fca05..8db7c2a3be 100644
--- a/linux-headers/asm-powerpc/mman.h
+++ b/linux-headers/asm-powerpc/mman.h
@@ -21,15 +21,11 @@
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 
+
 #define MCL_CURRENT     0x2000          /* lock all currently mapped pages */
 #define MCL_FUTURE      0x4000          /* lock all additions to address space */
 #define MCL_ONFAULT	0x8000		/* lock all pages that are faulted in */
 
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
-#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
-
 /* Override any generic PKEY permission defines */
 #define PKEY_DISABLE_EXECUTE   0x4
 #undef PKEY_ACCESS_MASK
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 04cb2d3e61..5584cc1b4f 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -416,6 +416,8 @@
 #define __NR_fsconfig	431
 #define __NR_fsmount	432
 #define __NR_fspick	433
+#define __NR_pidfd_open	434
+#define __NR_clone3	435
 
 
 #endif /* _ASM_POWERPC_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index b1e6921490..251bcff77e 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -388,6 +388,8 @@
 #define __NR_fsconfig	431
 #define __NR_fsmount	432
 #define __NR_fspick	433
+#define __NR_pidfd_open	434
+#define __NR_clone3	435
 
 
 #endif /* _ASM_POWERPC_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index 03ab5968c7..0138ccb0d8 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -231,6 +231,12 @@ struct kvm_guest_debug_arch {
 #define KVM_SYNC_GSCB   (1UL << 9)
 #define KVM_SYNC_BPBC   (1UL << 10)
 #define KVM_SYNC_ETOKEN (1UL << 11)
+
+#define KVM_SYNC_S390_VALID_FIELDS \
+	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
+	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
+	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
+
 /* length and alignment of the sdnx as a power of two */
 #define SDNXC 8
 #define SDNXL (1UL << SDNXC)
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index 941853f3e9..7cce3ee296 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -406,5 +406,7 @@
 #define __NR_fsconfig 431
 #define __NR_fsmount 432
 #define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 90271d7f82..2371ff1e7a 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -354,5 +354,7 @@
 #define __NR_fsconfig 431
 #define __NR_fsmount 432
 #define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 6e7dd792e4..503d3f42da 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -378,23 +378,24 @@ struct kvm_sync_regs {
 	struct kvm_vcpu_events events;
 };
 
-#define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
-#define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
-#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
-#define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
+#define KVM_X86_QUIRK_LINT0_REENABLED	   (1 << 0)
+#define KVM_X86_QUIRK_CD_NW_CLEARED	   (1 << 1)
+#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
+#define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
+#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1
+#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 
-#define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
-
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
+#define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -432,4 +433,17 @@ struct kvm_nested_state {
 	} data;
 };
 
+/* for KVM_CAP_PMU_EVENT_FILTER */
+struct kvm_pmu_event_filter {
+	__u32 action;
+	__u32 nevents;
+	__u32 fixed_counter_bitmap;
+	__u32 flags;
+	__u32 pad[4];
+	__u64 events[0];
+};
+
+#define KVM_PMU_EVENT_ALLOW 0
+#define KVM_PMU_EVENT_DENY 1
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/asm-x86/unistd.h b/linux-headers/asm-x86/unistd.h
index c04f638154..498d1515c6 100644
--- a/linux-headers/asm-x86/unistd.h
+++ b/linux-headers/asm-x86/unistd.h
@@ -3,7 +3,7 @@
 #define _ASM_X86_UNISTD_H
 
 /* x32 syscall flag bit */
-#define __X32_SYSCALL_BIT	0x40000000
+#define __X32_SYSCALL_BIT	0x40000000UL
 
 # ifdef __i386__
 #  include <asm/unistd_32.h>
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 57bb48854c..e8ebec1cdc 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -424,5 +424,7 @@
 #define __NR_fsconfig 431
 #define __NR_fsmount 432
 #define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
 
 #endif /* _ASM_X86_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index fe6aa0688a..a2f863d549 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -346,5 +346,7 @@
 #define __NR_fsconfig 431
 #define __NR_fsmount 432
 #define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
 
 #endif /* _ASM_X86_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 09cca49ba7..4cdc67d848 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -299,6 +299,8 @@
 #define __NR_fsconfig (__X32_SYSCALL_BIT + 431)
 #define __NR_fsmount (__X32_SYSCALL_BIT + 432)
 #define __NR_fspick (__X32_SYSCALL_BIT + 433)
+#define __NR_pidfd_open (__X32_SYSCALL_BIT + 434)
+#define __NR_clone3 (__X32_SYSCALL_BIT + 435)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 18892d6541..3d9b18f7f8 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -116,7 +116,7 @@ struct kvm_irq_level {
 	 * ACPI gsi notion of irq.
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
-	 * For ARM: See Documentation/virtual/kvm/api.txt
+	 * For ARM: See Documentation/virt/kvm/api.txt
 	 */
 	union {
 		__u32 irq;
@@ -243,6 +243,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -995,6 +997,9 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1085,7 +1090,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emulation.  See Documentation/virtual/kvm/api.txt.
+ * emulation.  See Documentation/virt/kvm/api.txt.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
@@ -1141,6 +1146,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1329,6 +1335,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
 /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
+/* Available with KVM_CAP_PMU_EVENT_FILTER */
+#define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
diff --git a/linux-headers/linux/psp-sev.h b/linux-headers/linux/psp-sev.h
index 36bbe17d8f..34c39690c0 100644
--- a/linux-headers/linux/psp-sev.h
+++ b/linux-headers/linux/psp-sev.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
 /*
  * Userspace interface for AMD Secure Encrypted Virtualization (SEV)
  * platform management commands.
@@ -7,10 +8,6 @@
  * Author: Brijesh Singh <brijesh.singh@amd.com>
  *
  * SEV API specification is available at: https://developer.amd.com/sev/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __PSP_SEV_USER_H__
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 24f505199f..fb10370d29 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -295,15 +295,38 @@ struct vfio_region_info_cap_type {
 	__u32 subtype;	/* type specific */
 };
 
+/*
+ * List of region types, global per bus driver.
+ * If you introduce a new type, please add it here.
+ */
+
+/* PCI region type containing a PCI vendor part */
 #define VFIO_REGION_TYPE_PCI_VENDOR_TYPE	(1 << 31)
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
+#define VFIO_REGION_TYPE_GFX                    (1)
+#define VFIO_REGION_TYPE_CCW			(2)
+
+/* sub-types for VFIO_REGION_TYPE_PCI_* */
 
-/* 8086 Vendor sub-types */
+/* 8086 vendor PCI sub-types */
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION	(1)
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
 
-#define VFIO_REGION_TYPE_GFX                    (1)
+/* 10de vendor PCI sub-types */
+/*
+ * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
+ */
+#define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
+
+/* 1014 vendor PCI sub-types */
+/*
+ * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
+ * to do TLB invalidation on a GPU.
+ */
+#define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
+
+/* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
 /**
@@ -353,25 +376,9 @@ struct vfio_region_gfx_edid {
 #define VFIO_DEVICE_GFX_LINK_STATE_DOWN  2
 };
 
-#define VFIO_REGION_TYPE_CCW			(2)
-/* ccw sub-types */
+/* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
 
-/*
- * 10de vendor sub-type
- *
- * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
- */
-#define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
-
-/*
- * 1014 vendor sub-type
- *
- * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
- * to do TLB invalidation on a GPU.
- */
-#define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
-
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
  * which allows direct access to non-MSIX registers which happened to be within
@@ -714,7 +721,31 @@ struct vfio_iommu_type1_info {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
-	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
+#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
+	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
+	__u32   cap_offset;	/* Offset within info struct of first cap */
+};
+
+/*
+ * The IOVA capability allows to report the valid IOVA range(s)
+ * excluding any non-relaxable reserved regions exposed by
+ * devices attached to the container. Any DMA map attempt
+ * outside the valid iova range will return error.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE  1
+
+struct vfio_iova_range {
+	__u64	start;
+	__u64	end;
+};
+
+struct vfio_iommu_type1_info_cap_iova_range {
+	struct	vfio_info_cap_header header;
+	__u32	nr_iovas;
+	__u32	reserved;
+	struct	vfio_iova_range iova_ranges[];
 };
 
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
-- 
2.14.5

